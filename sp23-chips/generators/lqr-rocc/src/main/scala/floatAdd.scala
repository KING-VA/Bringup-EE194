package lqrRoCC

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._


class floatAdd(val data_w: Int = 32, val expWidth: Int = 8, val sigWidth: Int = 24) extends Module {
  val io = IO(new Bundle {
    val in0 = Input(UInt((data_w+1).W))
    val in1 = Input(UInt((data_w+1).W))
    val out = Output(UInt((data_w+1).W))
  })
  val excep_reg = RegInit(0.U(5.W))

  val final_reg = RegInit(0.U((data_w+1).W)) // added this reg try to cut critical path

// class MulAddRecFN(expWidth: Int, sigWidth: Int) extends chisel3.RawModule
// {
//     val io = IO(new Bundle {
//         val op = Bits(INPUT, 2)
//         val a = Bits(INPUT, expWidth + sigWidth + 1)
//         val b = Bits(INPUT, expWidth + sigWidth + 1)
//         val c = Bits(INPUT, expWidth + sigWidth + 1)
//         val roundingMode   = UInt(INPUT, 3)
//         val detectTininess = UInt(INPUT, 1)
//         val out = Bits(OUTPUT, expWidth + sigWidth + 1)
//         val exceptionFlags = Bits(OUTPUT, 5)
//     })

//val signProd = rawA.sign ^ rawB.sign ^ io.op(1)
//val doSubMags = signProd ^ rawC.sign ^ io.op(0)

  val Add = Module(new hardfloat.AddRecFN(expWidth, sigWidth))
  Add.io.a := io.in0
  Add.io.b := io.in1

  // TOGGLE COMMENT/UNCOMMENT FOR CHISEL TEST
  //Add.io.a := hardfloat.recFNFromFN(expWidth, sigWidth, io.in0)
  //Add.io.b := hardfloat.recFNFromFN(expWidth, sigWidth, io.in1)

  Add.io.roundingMode := hardfloat.consts.round_max
  Add.io.detectTininess := false.B
  Add.io.subOp := false.B

  
  //final_reg := hardfloat.fNFromRecFN(expWidth, sigWidth, Add.io.out)
  final_reg := Add.io.out
  io.out := final_reg
  excep_reg := Add.io.exceptionFlags
}
