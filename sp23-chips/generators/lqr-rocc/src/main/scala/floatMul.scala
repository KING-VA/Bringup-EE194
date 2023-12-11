package lqrRoCC

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._


class floatMul(val data_w: Int = 32, val expWidth: Int = 8, val sigWidth: Int = 24)
 extends Module {
  val io = IO(new Bundle {
    val in0 = Input(UInt(data_w.W))
    val in1 = Input(UInt(data_w.W))
    val out = Output(UInt((data_w+1).W))
  })
  val excep_reg = RegInit(0.U(5.W))

//class MulRecFN(expWidth: Int, sigWidth: Int) extends chisel3.RawModule 
//    val io = IO(new Bundle {
//         val a = Input(UInt((expWidth + sigWidth + 1).W))
//         val b = Input(UInt((expWidth + sigWidth + 1).W))
//         val roundingMode = Input(UInt(3.W))
//         val detectTininess = Input(Bool())
//         val out = Output(UInt((expWidth + sigWidth + 1).W))
//         val exceptionFlags = Output(UInt(5.W))
//     })
  val Mul = Module(new hardfloat.MulRecFN(8, 24)) // *** 24 or 24?
  // TOGGLE COMMENT/UNCOMMENT FOR CHISEL TEST
  //Mul.io.a := io.in0
  //Mul.io.b := io.in1
  // --- inspired from Kalman Team on Hardfloat ---
  Mul.io.a := hardfloat.recFNFromFN(expWidth, sigWidth, io.in0)
  Mul.io.b := hardfloat.recFNFromFN(expWidth, sigWidth, io.in1)
  Mul.io.roundingMode := hardfloat.consts.round_max
  Mul.io.detectTininess := false.B
  // TOGGLE COMMENT/UNCOMMENT FOR CHISEL TEST
  //io.out := hardfloat.fNFromRecFN(expWidth, sigWidth, Mul.io.out)

  io.out := Mul.io.out
  excep_reg := Mul.io.exceptionFlags
}
