package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class AccelDenseLoadController()(implicit p: Parameters) extends Module {

  //FSM


  val io = IO(new Bundle { 
    val cmd = Flipped(Decoupled(new DenseLoadControllerCmd()))
    val sparse_decoder = Flipped(Decoupled(new SparseDecoderDenseLoadControllerInterface()))
    val mem_controller = Decoupled(new DenseRowControllerMemControllerInterface())
    val busy = Output(Bool())
  })

  val ptr =  RegInit(0.U(64.W))
  // Number of lines the dense row spans
  val size =  RegInit(0.U(8.W))
  val ptr_valid = RegInit(false.B)
  val use_virtual = RegInit(false.B)

  val output_res = RegInit(0.U(64.W)) 

  io.cmd.ready := true.B

  when(io.cmd.ready && io.cmd.valid)
  {
    ptr := io.cmd.bits.dense_matrix_ptr
    size := io.cmd.bits.dense_row_size
    use_virtual := io.cmd.bits.is_virtual_addr
    ptr_valid := true.B
  }


  val current_idx = RegInit(0.U(8.W))

  val pipe0 = Module(new Queue(new SparseDecoderDenseLoadControllerInterface(), 1, true, false)).io

   pipe0.enq <> io.sparse_decoder

   io.sparse_decoder.ready := pipe0.enq.ready && ptr_valid

   pipe0.deq.ready := io.mem_controller.ready && (current_idx === (size - 1.U))
   io.mem_controller.valid := pipe0.deq.valid
   io.mem_controller.bits.dense_row_pointer := ptr + ((pipe0.deq.bits.idx * size) << 3) + (current_idx << 3)
   io.busy := pipe0.deq.valid

   when (io.mem_controller.fire()) {
      current_idx := current_idx + 1.U
   }
   when (pipe0.deq.fire()) {
      current_idx := 0.U
   }

   // pass along whether this command is using virtual address
   io.mem_controller.bits.is_virtual_addr := use_virtual
/*
  when(!ind_valid)
  {
    io.sparse_decoder.ready := true.B
    index := io.sparse_decoder.bits.idx
    ind_valid := true.B

  }

  when(ind_valid && !output_res_valid){ //todo fully pipeline later
    output_res := ptr+index*size
    output_res_valid := true.B
  }

  when(output_res_valid)
  {
    io.mem_controller.valid := true.B
    io.mem_controller.bits.dense_row_pointer := output_res
    
  }

  when(io.mem_controller.valid && io.mem_controller.ready && !ind_valid)
  {
    output_res_valid := false.B
  }

  when(!output_res_valid && !io.cmd.valid)
  {
    ind_valid := false.B
  }
*/  
  

 }