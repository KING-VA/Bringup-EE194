package prefetchers

import chisel3._
import chisel3.util._
import freechips.rocketchip.config.{Field, Parameters}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.util._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem.{CacheBlockBytes}
import freechips.rocketchip.tile._

case class SingleBOPrefetcherParams(
    BADSCORE: Int = 10,
    ROUND_MAX: Int = 20,
    SCORE_MAX: Int = 20,
    RR_NUM_ENTRIES: Int = 16,
    ST_NUM_ENTRIES: Int = 26,     //DONT CHANGE: number of offsets (= number of score table entries)
    RR_TAG_SIZE: Int = 20,        //DONT CHANGE: 64-bit addresses, store entire address as tag
    RR_ENTRY_SIZE: Int = 20 + 1,  //DONT CHANGE: + 1 valid bit
    OFFSET_WIDTH: Int = 9         //DONT CHANGE: to accomondate larges offset = 256
) extends CanInstantiatePrefetcher {
    def desc() = "Single Best-Offset Prefetcher"
    def instantiate()(implicit p: Parameters) = Module(new BOPrefetcher(this)(p))
}

class BOPrefetcher(params: SingleBOPrefetcherParams)(implicit p: Parameters) extends AbstractPrefetcher()(p) {
    //Registers
    val best_offset = RegInit(1.U(params.OFFSET_WIDTH.W))
    val prefetcher_on = RegInit(false.B)
    val max_index = RegInit(0.U(log2Ceil(params.ST_NUM_ENTRIES).W))
    val rr_head = RegInit(0.U(log2Ceil(params.RR_NUM_ENTRIES).W))
    val snoop_valid = RegInit(false.B)
    val snoop_write = RegInit(false.B)
    //Wires
    val curr_addr = Wire(UInt(64.W))
    curr_addr := io.snoop.bits.address                              //input to prefetcher
    val max_score = Wire(UInt((log2Ceil(params.SCORE_MAX) + 1).W))
    val is_eolp = Wire(Bool())    //end of a learning phase

    // Instantiate Offset List, Score Table, Recent Requests Table, and Address Buffer
    val offset_list = VecInit(
      1.U(params.OFFSET_WIDTH.W), 2.U(params.OFFSET_WIDTH.W), 3.U(params.OFFSET_WIDTH.W), 4.U(params.OFFSET_WIDTH.W), 5.U(params.OFFSET_WIDTH.W), 6.U(params.OFFSET_WIDTH.W), 8.U(params.OFFSET_WIDTH.W),
      10.U(params.OFFSET_WIDTH.W), 16.U(params.OFFSET_WIDTH.W), 20.U(params.OFFSET_WIDTH.W), 24.U(params.OFFSET_WIDTH.W), 30.U(params.OFFSET_WIDTH.W), 32.U(params.OFFSET_WIDTH.W), 45.U(params.OFFSET_WIDTH.W),
      64.U(params.OFFSET_WIDTH.W), 72.U(params.OFFSET_WIDTH.W), 80.U(params.OFFSET_WIDTH.W), 100.U(params.OFFSET_WIDTH.W), 120.U(params.OFFSET_WIDTH.W), 128.U(params.OFFSET_WIDTH.W), 144.U(params.OFFSET_WIDTH.W),
      150.U(params.OFFSET_WIDTH.W), 180.U(params.OFFSET_WIDTH.W), 192.U(params.OFFSET_WIDTH.W), 250.U(params.OFFSET_WIDTH.W), 256.U(params.OFFSET_WIDTH.W)
    )
    val recent_requests = RegInit(VecInit(Seq.fill(params.RR_NUM_ENTRIES)(0.U(params.RR_ENTRY_SIZE.W))))
    val score_table = RegInit(VecInit(Seq.fill(params.ST_NUM_ENTRIES)(0.U((log2Ceil(params.SCORE_MAX) + 1).W))))

    //********* IO Start *********
    //Output queue
    val pref_out = Reg(Output(Decoupled(new prefetch_request)))
    val prefetch_queue = Module(new Queue(new prefetch_request, entries=8, flow=true))
    prefetch_queue.io.enq <> pref_out

    //Enqueue
    when (io.snoop.valid) {
      pref_out.bits.addr := io.snoop.bits.address + (best_offset << 2.U)
      pref_out.bits.write := io.snoop.bits.write
      pref_out.valid := prefetcher_on && recent_requests.contains(Cat((io.snoop.bits.address - (best_offset << 2.U))(21,2), 1.U(1.W)))
    } .otherwise {
      pref_out.valid := false.B
    }

    //Dequeue
    when (io.request.fire()) {
      prefetch_queue.io.deq.ready := true.B
    } .otherwise {
      prefetch_queue.io.deq.ready := false.B
    }

    //Ouput
    io.request.bits.address := prefetch_queue.io.deq.bits.addr
    io.request.bits.write := prefetch_queue.io.deq.bits.write
    io.request.valid := prefetch_queue.io.deq.valid
    
    //********* IO End *********
    
    // Write to RR table
    when (io.snoop.valid) {
      recent_requests(rr_head) := Cat(curr_addr(21,2), 1.U(1.W)) // set valid bit and write tag TODO
      rr_head := rr_head + 1.U
    }
    
    //********* Learning Algorithm Start *********
    val round_count = Counter(params.ROUND_MAX)  // Round Counter (there are ROUND_MAX rounds in a learning phase)

    val offset_match_bitmap = VecInit(Seq.fill(params.ST_NUM_ENTRIES)(0.U(1.W))) // bitmap(k) is true iff offset(k) has a match in RR table
    
    for (k <- 0 until params.ST_NUM_ENTRIES) {
      val curr_offset = offset_list(k) // d_*

      val rr_check_tag = curr_addr - (curr_offset << 2.U) // X - d_*
      
      offset_match_bitmap(k) := recent_requests.contains(Cat(rr_check_tag(21,2), 1.U(1.W))).asUInt //TODO
    }
    
    is_eolp := round_count.value === params.ROUND_MAX.U - 1.U || (score_table(max_index) === (params.SCORE_MAX - 1).U && offset_match_bitmap(max_index).asBool) // End of a learning phase
    max_score := score_table.reduceTree((a: UInt, b: UInt) => Mux(a >= b, a, b))
    
    when (io.snoop.valid) {
      round_count.inc() // increment round count every cycle

      when(is_eolp) { 
        for (i <- 0 until params.ST_NUM_ENTRIES) { // reset scores
          score_table(i) := 0.U
        }
        best_offset := offset_list(max_index) // set the new best offset
        prefetcher_on := score_table(max_index) > params.BADSCORE.U // condition to determine if prefetcher is on/off
      } .otherwise { // else increment score for whichever offset that has a match in RR
        for (i <- 0 until params.ST_NUM_ENTRIES) {
          score_table(i) := score_table(i) + offset_match_bitmap(i)
        }
      }

      max_index := score_table.indexWhere((x: UInt) => x === max_score)
    }
    //********* Learning Algorithm End *********
}
