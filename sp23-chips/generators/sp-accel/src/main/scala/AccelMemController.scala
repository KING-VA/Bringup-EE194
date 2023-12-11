package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class MemControllerArbiterBundle extends Bundle {
  val data = UInt(64.W)
  val start = Bool()
  val last = Bool()
  val write_offset = UInt(8.W)
}



class AccelMemController()(implicit p: Parameters) extends LazyModule 
{

  val write_node = TLClientNode(Seq(TLMasterPortParameters.v1(Seq(TLMasterParameters.v1(name="SPL2WriteNode", sourceId = IdRange(0, 32))))))
  val read_node  = TLClientNode(Seq(TLMasterPortParameters.v1(Seq(TLMasterParameters.v1(name="SPL2ReadNode",  sourceId = IdRange(0, 4))))))

  val node = TLIdentityNode()
  node := write_node
  node := read_node

  lazy val module = new AccelMemControllerImpl
  class AccelMemControllerImpl extends LazyModuleImp(this) {


  val io = IO(new Bundle { 
    val sparse = Flipped(Decoupled(new SparseLoadControllerMemControllerInterface))
    val dense = Flipped(Decoupled(new DenseRowControllerMemControllerInterface))
    val sparse_decoder = Decoupled(new MemControllerSparseDecoderInterface)
	  val mem_controller_accumulator = Decoupled(new MemControllerAccumulatorInterface)
	  val accumulator_mem_controller = Flipped(Decoupled(new AccumulatorMemControllerInterface))
    val mem = new HellaCacheIO
    val cmd = Flipped(Decoupled(new MemControllerCmd()))
    val busy = Output(Bool())
    val sparse_decoder_credit = Input(Bool())
    val accumulator_credit = Input(Bool())

    val ptw_virtual_accum = Decoupled(new MemControllerPTWVirtualInterface)
    val ptw_physical_accum = Flipped(Decoupled(new MemControllerPTWPhysicalInterface))
    val ptw_virtual_dense = Decoupled(new MemControllerPTWVirtualInterface)
    val ptw_physical_dense = Flipped(Decoupled(new MemControllerPTWPhysicalInterface))
  })

  io.mem.req.bits.size := 3.U
  io.mem.req.bits.no_alloc := 0.U
  io.mem.s1_data.mask := Cat(Fill(32, 1.U(1.W)))
  io.mem.req.bits.no_xcpt := 0.U
  io.mem.req.bits.mask := Cat(Fill(32, 1.U(1.W)))
  io.mem.s1_kill := 0.U
  io.mem.req.bits.phys := 0.U
  io.mem.req.bits.dprv := 0.U
  io.mem.s1_data.data := 0.U
  io.mem.s2_kill := 0.U
  io.mem.keep_clock_enabled := 1.U
  io.mem.req.bits.signed := 0.U
	io.mem.req.bits.dv := DontCare

  
  val reorder_queue = Module(new AccelMemControllerReorderQueue()).io
  val output_row_ptr = RegInit(0.U(64.W))

  // switch for using PTW if using virtual addresses
  val use_virtual_dense = RegInit(false.B)
  use_virtual_dense := io.dense.bits.is_virtual_addr
  val use_virtual_out = RegInit(false.B)
  
  io.cmd.ready := true.B
  when (io.cmd.ready && io.cmd.valid) {
  	output_row_ptr := io.cmd.bits.output_row_pointer
    use_virtual_out := io.cmd.bits.is_virtual_addr
  }

  // L1 section Read - Sparse
  
  io.mem.req.valid := io.sparse.valid && reorder_queue.req.valid
  io.sparse.ready := io.mem.req.ready && reorder_queue.req.valid
  reorder_queue.req.ready := io.mem.req.ready && io.sparse.valid

  io.mem.req.bits.tag := Cat(reorder_queue.req.bits, 0.U(2.W), io.sparse.bits.startRowChunk, io.sparse.bits.endRowChunk)
  io.mem.req.bits.cmd := 0.U
  io.mem.req.bits.addr := io.sparse.bits.memPtr
  io.mem.req.bits.data := DontCare


  reorder_queue.resp.valid := io.mem.resp.valid
  reorder_queue.resp.bits.entry_id := io.mem.resp.bits.tag(5, 4)
  reorder_queue.resp.bits.data := io.mem.resp.bits.data
  reorder_queue.resp.bits.client_id := io.mem.resp.bits.tag(3, 2)
  reorder_queue.resp.bits.start := io.mem.resp.bits.tag(1)
  reorder_queue.resp.bits.last := io.mem.resp.bits.tag(0)

  io.sparse_decoder.valid := reorder_queue.deq.valid && (reorder_queue.deq.bits.client_id === 0.U)
  io.sparse_decoder.bits.spRow := reorder_queue.deq.bits.data
  io.sparse_decoder.bits.startRowChunk := reorder_queue.deq.bits.start
  io.sparse_decoder.bits.endRowChunk := reorder_queue.deq.bits.last

  reorder_queue.deq.ready := io.sparse_decoder.ready

  



  //Important Constant for L2 operation
  val BURST_BLOCK = 16




  // Creating TL node for L2 operations 
  val (tl_out_write, edgesOut_write) = write_node.out(0)
  val l2_write_inflight = RegInit(false.B)

  io.accumulator_mem_controller.ready := tl_out_write.a.ready
  //
  //
  //    L2 Write
  //
  //

  tl_out_write.a.valid := false.B 

  // PTW translation
  when (io.accumulator_mem_controller.valid && io.ptw_virtual_accum.ready && use_virtual_out) {
    io.ptw_virtual_accum.valid := true.B
    io.ptw_virtual_accum.bits.virtual_addr := output_row_ptr
  }
  val accum_write_cond = Wire(Bool())
  accum_write_cond := Mux(use_virtual_out, io.ptw_physical_accum.valid, io.accumulator_mem_controller.valid)
  io.ptw_physical_accum.ready := true.B

  // The L2 Write Section
  val unique_write_source_id = RegInit(0.U(8.W))
  val block_wrote = RegInit(0.U(8.W))

  when (accum_write_cond) {
      tl_out_write.a.valid := true.B
      tl_out_write.a.bits := edgesOut_write.Put(
        fromSource = unique_write_source_id,
        // based on whether use virtual mem for out, choose the corresponding address
        toAddress = Mux(use_virtual_out, io.ptw_physical_accum.bits.physical_addr + (io.accumulator_mem_controller.bits.offset << 3), 
                    output_row_ptr + (io.accumulator_mem_controller.bits.offset << 3)),
        lgSize = 3.U,
        data = io.accumulator_mem_controller.bits.output_row_data
      )._2
      dontTouch(tl_out_write.a)
    }

  //Setting busy when L2 write succcessfully fires
  when (tl_out_write.a.fire) {
    l2_write_inflight := true.B
    unique_write_source_id := unique_write_source_id + 1.U
  }

  tl_out_write.d.ready := true.B  // always ready to receive info for write
  when(tl_out_write.d.fire) {
    when(block_wrote === (BURST_BLOCK-1).U){
      l2_write_inflight := false.B
      block_wrote := 0.U
      unique_write_source_id := 0.U
    }.otherwise{
      block_wrote := block_wrote + 1.U
    }
  }
  dontTouch(tl_out_write.d)
  
  //
  //
  //    L2 Read
  //
  //
  
  val (tl_out_read, edgesOut_read) = read_node.out(0)
  val l2_read_inflight = RegInit(false.B)
  val burst_second_cache_line = RegInit(false.B)
  val saved_dense_addr =  RegInit(0.U(32.W))
  val block_recv = RegInit(0.U(8.W))     
  val dense_fire_counter = RegInit(BURST_BLOCK.U(8.W))

  //This is a tricky logic, we want to deq data from dense loader
  //for the (0-BURST_BLOCKth) block, yet we are only requesting addr of the 0th block, but for 512 bits
  //so as long as we are not waiting for the last block to complete, we should deq from denser loader

  val bursting_now = Wire(Bool())
  val not_reading_l2 = Wire(Bool())
  bursting_now := l2_read_inflight && (dense_fire_counter > 0.U)
  not_reading_l2 := ((block_recv === 0.U) && tl_out_read.a.ready && !l2_read_inflight)

  io.dense.ready := bursting_now || not_reading_l2

    // PTW translation
  when (io.dense.valid && io.ptw_virtual_dense.ready && use_virtual_dense) {
    io.ptw_virtual_dense.valid := true.B
    io.ptw_virtual_dense.bits.virtual_addr := io.dense.bits.dense_row_pointer
  }
  val dense_read_cond = Wire(Bool())
  dense_read_cond := Mux(use_virtual_dense, io.ptw_physical_dense.valid, io.dense.valid)
  io.ptw_physical_dense.ready := true.B


  //given a 512 bits operation, maximumally deque from dense loader 8 times
  when (io.dense.fire){
    when (dense_fire_counter > 0.U) {
      dense_fire_counter := dense_fire_counter - 1.U
    }
    when(dense_fire_counter === BURST_BLOCK.U){
      saved_dense_addr := Mux(use_virtual_dense, io.ptw_physical_dense.bits.physical_addr, io.dense.bits.dense_row_pointer) //Save the beginning address for later burst uses
    }
  }


  tl_out_read.a.valid := false.B 

  // Burst the first cache line, the 0-7th Block
  when (!l2_read_inflight && dense_read_cond && block_recv === 0.U){
    tl_out_read.a.valid := true.B
    tl_out_read.a.bits := edgesOut_read.Get(
        fromSource = 0.U,
        // TODO: need to check translated physical address is indexed properly
        toAddress = Mux(use_virtual_dense, Cat(io.ptw_physical_dense.bits.physical_addr(31,6), 0.U(6.W)),
                                           Cat(io.dense.bits.dense_row_pointer(31,6), 0.U(6.W))),
        // 512 bits == 64 bytes == 2**6
        lgSize = 6.U
    )._2
  }

  // Burst the 8-15th Block, we must use the saved dense addr, in case io.dense.bits changes 
  when (burst_second_cache_line){
    tl_out_read.a.valid := true.B
    tl_out_read.a.bits := edgesOut_read.Get(
        fromSource = 1.U,
        toAddress = Cat(saved_dense_addr(31,6)+1.U, 0.U(6.W)),
        // 512 bits == 64 bytes == 2**6
        lgSize = 6.U
    )._2
  }

  //Setting busy when L2 read successfuly fire (in this case, source_id == 0 fires)
  when(tl_out_read.a.fire){
    l2_read_inflight := true.B

    when(tl_out_read.a.bits.source === 0.U){
      burst_second_cache_line := true.B
    }
    when(tl_out_read.a.bits.source === 1.U){
      burst_second_cache_line := false.B
    }

  }

  //only read enq data from L2 when accumulator is ready
  tl_out_read.d.ready := io.mem_controller_accumulator.ready
  io.mem_controller_accumulator.valid := tl_out_read.d.valid
  io.mem_controller_accumulator.bits.dense_row_data := tl_out_read.d.bits.data
  io.mem_controller_accumulator.bits.data_index := 0.U //for debugging purpose

  when (tl_out_read.d.fire) {

    // channel just fire, and we already have received 7 block, reading 16 blocks from L2 is done
    when(block_recv === (BURST_BLOCK-1).U) {
      dense_fire_counter := BURST_BLOCK.U
      block_recv := 0.U
      l2_read_inflight := false.B
    }.otherwise{
      block_recv := block_recv + 1.U
    }

    // providing the correct index to accumulator
    io.mem_controller_accumulator.bits.data_index := (tl_out_read.d.bits.source << 3.U) + block_recv(2,0)

  }

  dontTouch(l2_read_inflight)

  
  io.busy := !reorder_queue.empty || l2_write_inflight || l2_read_inflight
  

 }


}
