package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class AccelCmdDispatch()(implicit p: Parameters) extends Module {

  //FSM

  val io = IO(new Bundle { 
    val rocc = Flipped(Decoupled(new RoCCCommand))
    // io.rocc.bits.inst.funct
    // io.rocc.bits.rs1
    // io.rocc.bits.rs2
    // io.rocc.bits.inst.rd
    val resp = Decoupled(new RoCCResponse)
    val busy = Output(Bool())
    val sparse = Decoupled(new SparseLoadControllerCmd)
    val dense = Decoupled(new DenseLoadControllerCmd)
    val mem_controller = Decoupled(new MemControllerCmd)
    val accumulator = Decoupled(new AccumulatorCmd)
    val writeLUT = Decoupled(new WriteLUTCmd)
    val LUTCmd = Decoupled(new ReadLUTCmd)
    val LUTData = Flipped(Decoupled(new ReadLUTData))
    val LUTSwitch = Decoupled(new LUTControllerCmd)
    val LUTSwitchSpLoad = Decoupled(new LUTControllerCmd)
  })
  val pipe0 = Module(new Queue(new RoCCCommand, 1, true, false)).io
  io.busy := pipe0.deq.valid
  pipe0.enq <> io.rocc
  io.resp.valid := false.B
  io.resp.bits := DontCare
  io.LUTSwitch.valid := false.B
  io.LUTSwitch.bits := DontCare 

  io.LUTSwitchSpLoad.valid := false.B
  io.LUTSwitchSpLoad.bits := DontCare
  
  io.sparse.valid := false.B
  io.dense.valid := false.B
  io.accumulator.valid := false.B
  io.mem_controller.valid := false.B
  io.sparse.bits := DontCare
  io.dense.bits := DontCare
  io.accumulator.bits := DontCare
  io.mem_controller.bits := DontCare
  pipe0.deq.ready := false.B
  io.writeLUT.valid := false.B
  io.writeLUT.bits := DontCare
  pipe0.deq.ready := false.B

  io.LUTCmd.valid := false.B
  io.LUTCmd.bits := DontCare

  io.LUTData.ready := false.B
  when (pipe0.deq.bits.inst.funct === 0.U) {
    io.sparse.valid := pipe0.deq.valid
    io.sparse.bits.spPtr := pipe0.deq.bits.rs1
    io.sparse.bits.spSize := pipe0.deq.bits.rs2
    io.sparse.bits.is_virtual_addr := false.B
    pipe0.deq.ready := io.sparse.ready
  }
  .elsewhen (pipe0.deq.bits.inst.funct === 1.U) {
    io.dense.valid := pipe0.deq.valid && io.accumulator.ready
    io.dense.bits.dense_matrix_ptr := pipe0.deq.bits.rs1
    io.dense.bits.dense_row_size := pipe0.deq.bits.rs2
    io.dense.bits.is_virtual_addr := false.B
    io.accumulator.bits.dense_row_size := pipe0.deq.bits.rs2
    io.accumulator.valid := pipe0.deq.valid && io.dense.ready
    pipe0.deq.ready := io.dense.ready && io.accumulator.ready
  }
  .elsewhen (pipe0.deq.bits.inst.funct === 2.U) {
    io.mem_controller.valid := pipe0.deq.valid
    io.mem_controller.bits.output_row_pointer := pipe0.deq.bits.rs1
    io.mem_controller.bits.is_virtual_addr := false.B
    pipe0.deq.ready := io.mem_controller.ready
  }
     // for codebook features
  .elsewhen (pipe0.deq.bits.inst.funct === 3.U) {
     // below are the added instructions 
     // for Enabling LUT and index accumulation
     io.LUTSwitch.valid := pipe0.deq.valid
     io.LUTSwitch.bits.switch := pipe0.deq.bits.rs1
     io.LUTSwitchSpLoad.valid := pipe0.deq.valid
     io.LUTSwitchSpLoad.bits.switch := pipe0.deq.bits.rs1
     pipe0.deq.ready := io.LUTSwitchSpLoad.ready && io.LUTSwitch.ready
   }
   .elsewhen (pipe0.deq.bits.inst.funct === 4.U) {
    io.writeLUT.valid := pipe0.deq.valid
    io.writeLUT.bits.data1 := pipe0.deq.bits.rs1
    io.writeLUT.bits.data2 := pipe0.deq.bits.rs2
    pipe0.deq.ready := io.writeLUT.ready
  }
  .elsewhen (pipe0.deq.bits.inst.funct === 5.U) {
    pipe0.deq.ready := io.LUTCmd.ready   // this may be wrong.
    io.LUTCmd.valid := pipe0.deq.valid
    io.LUTCmd.bits.wantToRead := pipe0.deq.bits.rs1
    io.LUTData.ready := io.LUTCmd.fire //true.B
    io.resp.valid := false.B
    
    when(io.LUTData.fire) {
      io.resp.valid := true.B // io.LUTData.valid: do I need to make sure that it is on only when LUTData.valid is true?
      io.resp.bits.data := io.LUTData.bits.data
      io.resp.bits.rd := pipe0.deq.bits.inst.rd
    }
  }

  // when input funct 7 has top bit set to 1 => use virtual address for that instruction
  when (pipe0.deq.bits.inst.funct === 64.U) {
    io.sparse.valid := pipe0.deq.valid
    io.sparse.bits.spPtr := pipe0.deq.bits.rs1
    io.sparse.bits.spSize := pipe0.deq.bits.rs2
    io.sparse.bits.is_virtual_addr := true.B
    pipe0.deq.ready := io.sparse.ready
  }
  .elsewhen (pipe0.deq.bits.inst.funct === 65.U) {
    io.dense.valid := pipe0.deq.valid && io.accumulator.ready
    io.dense.bits.dense_matrix_ptr := pipe0.deq.bits.rs1
    io.dense.bits.dense_row_size := pipe0.deq.bits.rs2
    io.dense.bits.is_virtual_addr := true.B
    io.accumulator.bits.dense_row_size := pipe0.deq.bits.rs2
    io.accumulator.valid := pipe0.deq.valid && io.dense.ready
    pipe0.deq.ready := io.dense.ready && io.accumulator.ready
  }
  .elsewhen (pipe0.deq.bits.inst.funct === 66.U) {
    io.mem_controller.valid := pipe0.deq.valid
    io.mem_controller.bits.output_row_pointer := pipe0.deq.bits.rs1
    io.mem_controller.bits.is_virtual_addr := true.B
    pipe0.deq.ready := io.mem_controller.ready
  }
 }
