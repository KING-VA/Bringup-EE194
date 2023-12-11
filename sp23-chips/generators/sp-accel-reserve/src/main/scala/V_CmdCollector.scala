package spaccel_reserve

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class CMDCollector()(implicit p: Parameters) extends Module {


  val io = IO(new Bundle { 
    val rocc = Flipped(Decoupled(new RoCCCommand))
    val resp = Decoupled(new RoCCResponse)

    val accel_in_progress = Output(Bool())
    val cmd_to_spload_bundle = Decoupled(new Cmd_to_Spload_Bundle)
  })

  //setting the correct resp signal, the accelerate doesn't write anything
  //back to CPU
  io.resp.valid := false.B
  io.resp.bits  := DontCare


  //Status register 3 zeros when init
  val cmd_status_reg = RegInit( VecInit(Seq.fill(3) (false.B) ) )

  //Info registers for all the ptrs
  val sp_ptr_reg     = RegInit(0.U(64.W))
  val sp_size_reg    = RegInit(0.U(8.W))
  val d_ptr_reg      = RegInit(0.U(64.W))
  val out_ptr_reg    = RegInit(0.U(64.W))


  //Collect instructions into register
  io.rocc.ready := true.B     //(always ready for cmd, assume CPU issue at correct time)
  when(io.rocc.valid){

      when(io.rocc.bits.inst.funct === 0.U){
        cmd_status_reg(0) := true.B
        sp_ptr_reg        := io.rocc.bits.rs1
        sp_size_reg       := io.rocc.bits.rs2
      }
      when(io.rocc.bits.inst.funct === 1.U){
        cmd_status_reg(1) := true.B
        d_ptr_reg         := io.rocc.bits.rs1
      }
      when(io.rocc.bits.inst.funct === 2.U){
        cmd_status_reg(2) := true.B
        out_ptr_reg       := io.rocc.bits.rs1
      }
  }

  //Passing Data to next stage (SP_load) of pipeline 
  io.cmd_to_spload_bundle.bits.sp_ptr   := sp_ptr_reg
  io.cmd_to_spload_bundle.bits.sp_size  := sp_size_reg
  io.cmd_to_spload_bundle.bits.d_ptr    := d_ptr_reg
  io.cmd_to_spload_bundle.bits.out_ptr  := out_ptr_reg

  io.cmd_to_spload_bundle.valid := false.B
  //valid when all true
  // and More IMPROTANTLY!, output accel_in_progress

  io.accel_in_progress := false.B
  when( cmd_status_reg.reduce(_&&_) ){
    io.cmd_to_spload_bundle.valid := true.B
    io.accel_in_progress := true.B
  }

  // reset internal reg state

  when(io.cmd_to_spload_bundle.fire){

    cmd_status_reg.foreach{ r =>
      r := false.B
    }

  }


}



  