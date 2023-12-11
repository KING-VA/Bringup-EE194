package prefetchers

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import chisel3.experimental.ChiselEnum
import freechips.rocketchip.config.{Field, Parameters}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem.{CacheBlockBytes}

case class SingleT2StridedPrefetcherParams(
  SIT_num_entries: Int = 8,
  prefetch_degree: Int = 4
) extends CanInstantiatePrefetcher {
  def desc() = "T2 Strided Prefetcher"
  def instantiate()(implicit p: Parameters) = Module(new SingleT2StridedPrefetcher(this)(p))
}

class SingleT2StridedPrefetcher(params: SingleT2StridedPrefetcherParams)(implicit p: Parameters) extends AbstractPrefetcher()(p) {

  val prefetch_degree_bits = log2Ceil(params.prefetch_degree)
  val SIT_entry_bits = log2Ceil(params.SIT_num_entries)
  val block_bits = log2Up(io.request.bits.blockBytes)

  //Loop hardware regs
  val target_pc = Reg(UInt(10.W))
  val loop_count = RegInit(0.U) //currently unused...
  val loop_pc = Reg(UInt(10.W))
  val set = RegInit(false.B)
  val flush_table = RegInit(false.B)

  val last_branch_pc = Reg(UInt(10.W))
  val last_branch_taken = RegInit(false.B) 

  // Only check against next valid pc
  when (io.pc.pc_valid_0 || io.pc.pc_valid_1) {
    //If both taken, pick PC1
    last_branch_pc := Mux(io.pc.branch_taken_1 && io.pc.pc_valid_1, io.pc.pc_1, io.pc.pc_0)
    last_branch_taken := (io.pc.pc_valid_0 && io.pc.branch_taken_0) || (io.pc.pc_valid_1 && io.pc.branch_taken_1)
  } .otherwise {
    last_branch_pc := last_branch_pc
    last_branch_taken := last_branch_taken
  }

  //Looping hardware
  //Identify one loop at a time
  when (io.pc.pc_valid_0 && last_branch_taken && (io.pc.pc_0 < last_branch_pc)) {
    when (!set && last_branch_pc === loop_pc) {
      set := true.B
    } .elsewhen (!(loop_pc === last_branch_pc) || 
                  (!set && 
                    (((io.pc.pc_0 > target_pc) && (io.pc.pc_0 < loop_pc)) 
                    || ((last_branch_pc > target_pc) && (last_branch_pc < loop_pc))))) {
      //Loop switch
      loop_pc := last_branch_pc
      target_pc := io.pc.pc_0
      set := false.B
      loop_count := 0.U
      flush_table := true.B
      // flush table at every loop switch
    }
  }

  when (set) {
      loop_count := loop_count + 1.U
  }
  

  //Stride Identifier Table
  val SIT = Reg(Vec(params.SIT_num_entries, Valid(new SIT_entry)))
  val SIT_exists_vec = RegInit(VecInit(Seq.fill(params.SIT_num_entries)(false.B)))
  val SIT_prefetch_vec = RegInit(VecInit(Seq.fill(params.SIT_num_entries)(false.B)))
  val SIT_exists_uint = SIT_exists_vec.asUInt()
  val SIT_prefetch_uint = SIT_prefetch_vec.asUInt()
  val head = RegInit(0.U(SIT_entry_bits.W))
  val new_entry_pc = Reg(UInt(10.W))
  val new_entry_addr = Reg(UInt())
  val new_entry_valid = RegInit(false.B)
  val last_prefetch_addr = Reg(UInt())
  val last_delta = Reg(UInt())
  val last_degree = Reg(UInt())
  val last_write = Reg(Bool())
  when (!io.flush && io.snoop.valid && set && (io.pc.pc_0 >= target_pc) && (io.pc.pc_0 <= loop_pc)) {
    for (i <- 0 until params.SIT_num_entries) {
      when (SIT(i).valid && SIT(i).bits.pc === io.pc.pc_0) {
        //FSM state changes
        when (SIT(i).bits.state =/= SIT_states.s_new && SIT(i).bits.state =/= SIT_states.s_s4 && SIT(i).bits.delta === io.snoop.bits.address - SIT(i).bits.last_addr) {
          when (SIT(i).bits.state === SIT_states.s_ready || SIT(i).bits.state === SIT_states.s_u1 || SIT(i).bits.state === SIT_states.s_u2 || SIT(i).bits.state === SIT_states.s_u3) {
            SIT(i).bits.state := SIT_states.s_s1
          }
          .elsewhen (SIT(i).bits.state === SIT_states.s_s1) {
            SIT(i).bits.state := SIT_states.s_s2
          }
          .elsewhen (SIT(i).bits.state === SIT_states.s_s2) {
            SIT(i).bits.state := SIT_states.s_s3
          }
          .elsewhen (SIT(i).bits.state === SIT_states.s_s3) {
            SIT(i).bits.state := SIT_states.s_s4
          }
        } .otherwise {
          when (SIT(i).bits.state === SIT_states.s_new) {
            SIT(i).bits.state := SIT_states.s_ready
          }
          .elsewhen (SIT(i).bits.state === SIT_states.s_ready || SIT(i).bits.state === SIT_states.s_s1 || SIT(i).bits.state === SIT_states.s_s2 || SIT(i).bits.state === SIT_states.s_s3) {
            SIT(i).bits.state := SIT_states.s_u1
          }
          .elsewhen (SIT(i).bits.state === SIT_states.s_u1) {
            SIT(i).bits.state := SIT_states.s_u2
          }
          .elsewhen (SIT(i).bits.state === SIT_states.s_u2) {
            SIT(i).bits.state := SIT_states.s_u3
          }
          .elsewhen (SIT(i).bits.state === SIT_states.s_u3) {
            SIT(i).bits.state := SIT_states.s_u4
            SIT(i).valid := false.B
          }
        }
        SIT(i).bits.delta := io.snoop.bits.address - SIT(i).bits.last_addr
        SIT(i).bits.last_addr := io.snoop.bits.address
        last_delta := SIT(i).bits.delta
        last_write := io.snoop.bits.write
        //When in "strided prefetch" state
        when(SIT(i).bits.state === SIT_states.s_s4) {
          when(!SIT(i).bits.strided_prefetch) {
            //Initialize last prefetch address
            when(SIT(i).bits.delta < io.request.bits.blockBytes.U) {
              //Record last snoop address when prefetch was sent out
              SIT(i).bits.last_prefetch_addr := io.snoop.bits.address
              //Prefetch next block
              last_prefetch_addr := io.snoop.bits.address + (1.U << block_bits)
              //Only send out 1 prefetch
              last_degree := 0.U
            } .otherwise {
              SIT(i).bits.last_prefetch_addr := io.snoop.bits.address + (SIT(i).bits.delta << prefetch_degree_bits)
              last_prefetch_addr := io.snoop.bits.address + (SIT(i).bits.delta << prefetch_degree_bits)
              //Send out multiple prefetches
              last_degree := params.prefetch_degree.U - 1.U
            }
            SIT_prefetch_vec(i) := true.B
            SIT(i).bits.strided_prefetch := true.B
          } .elsewhen(SIT(i).bits.delta < io.request.bits.blockBytes.U) {
            //when reached next block
            //Also this assumes positive stride
            when(io.snoop.bits.address - SIT(i).bits.last_prefetch_addr > io.request.bits.blockBytes.U) {
              last_prefetch_addr := io.snoop.bits.address + (1.U << block_bits.U)
              SIT_prefetch_vec(i) := true.B
            } .otherwise {
              SIT_prefetch_vec(i) := false.B
            }
            last_degree := 0.U
          } .otherwise {
            last_prefetch_addr := SIT(i).bits.last_prefetch_addr + SIT(i).bits.delta
            SIT(i).bits.last_prefetch_addr := SIT(i).bits.last_prefetch_addr + (SIT(i).bits.delta << prefetch_degree_bits)
            SIT_prefetch_vec(i) := true.B
            last_degree := params.prefetch_degree.U - 1.U
          }
        } .otherwise {
          SIT_prefetch_vec(i) := false.B
        }
        SIT_exists_vec(i) := true.B
      } .otherwise {
        SIT_exists_vec(i) := false.B
        SIT_prefetch_vec(i) := false.B
      }
    }
  }

  // No conflicts since set is false
  when (flush_table || io.flush) {
    for (i <- 0 until params.SIT_num_entries) {
      SIT(i).valid := false.B
      head := 0.U
    }
    flush_table := false.B
  }

  //If PC not in table, write into SIT on next cycle
  new_entry_valid := !io.flush && io.snoop.valid && set && (io.pc.pc_0 >= target_pc) && (io.pc.pc_0 <= loop_pc) //&& SIT_exists_uint === 0.U//&& !SIT.exists((entry: SIT_entry) => entry.pc === io.pc.pc_0).B //Is this legal?
  new_entry_addr := io.snoop.bits.address
  new_entry_pc := io.pc.pc_0
  when (head < (params.SIT_num_entries.U - 1.U) && new_entry_valid && SIT_exists_uint === 0.U) {
    SIT(head).valid := true.B
    SIT(head).bits.pc := new_entry_pc
    SIT(head).bits.last_addr := new_entry_addr
    SIT(head).bits.delta := 0.U
    SIT(head).bits.state := SIT_states.s_new
    SIT(head).bits.strided_prefetch := false.B
    head := head + 1.U
  }

  val prefetch_active = RegInit(false.B)
  val prefetch_count = RegInit(0.U(prefetch_degree_bits.W))
  val prefetch = Reg(Output(Flipped(Decoupled(new prefetch_req))))
  val prefetch_queue = Module(new Queue(new prefetch_req, entries=params.SIT_num_entries, flow=true))
  val curr_dist = RegInit(0.U(16.U)) //arbitrary width for now, just enough to cover most strides
  val reset_deq = RegInit(true.B) 
  //Dummy variable to connect queue output to
  val fake_prefetch = Reg(Input(Flipped(Decoupled(new prefetch_req))))

  //Connect queue to producer and consumer
  prefetch_queue.io.enq <> prefetch //has r, v and bits
  prefetch_queue.io.deq <> fake_prefetch

  //Pipelined to prevent logic issues
  // new_entry_valid => making sure SIT was checked last cycle
  when (new_entry_valid && SIT_prefetch_uint =/= 0.U) {
    //Initialize prefetch address and delta
    prefetch.bits.addr := last_prefetch_addr
    prefetch.bits.delta := last_delta
    prefetch.bits.degree := last_degree
    prefetch.bits.write := last_write
    prefetch.valid := true.B
    prefetch_active := true.B
  } .otherwise {
    prefetch.valid := false.B
  }

  io.request.valid := prefetch_active
  io.request.bits.address := prefetch_queue.io.deq.bits.addr + curr_dist
  io.request.bits.write := prefetch_queue.io.deq.bits.write

  //Send out queued requests
  when (io.request.fire()) {
    //Move to next address for front of queue
    when (prefetch_count === prefetch_queue.io.deq.bits.degree) {
      curr_dist := 0.U
      prefetch_count := 0.U
      prefetch_queue.io.deq.ready := true.B
      reset_deq := true.B
      prefetch_active := false.B
    } .otherwise {
      curr_dist := curr_dist + prefetch_queue.io.deq.bits.delta
      prefetch_active := true.B
      prefetch_count := prefetch_count + 1.U
    }
  }

  when (reset_deq) {
    //reset dequeue ready
    prefetch_queue.io.deq.ready := false.B
    reset_deq := false.B
  }

}

object SIT_states extends ChiselEnum {
  val s_new, s_ready, s_u1, s_u2, s_u3, s_u4, s_s1, s_s2, s_s3, s_s4 = Value
}

class SIT_entry extends Bundle {
  val pc = UInt()
  val last_addr = UInt()
  val delta = UInt()
  val last_prefetch_addr = UInt()
  val state = SIT_states()
  val strided_prefetch = Bool()
}

class prefetch_req(implicit p: Parameters) extends CoreBundle {
  val addr = UInt()
  val delta = UInt()
  val degree = UInt()
  val write = Bool()
}

