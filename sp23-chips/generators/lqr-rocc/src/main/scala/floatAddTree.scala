package lqrRoCC

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._


class floatAddTree(val data_w: Int = 32, val n: Int = 16, val expWidth: Int = 8, val sigWidth: Int = 24) extends Module {
  val io = IO(new Bundle {
    val vec = Input(Vec(n, UInt((data_w+1).W)))
    val out = Output(UInt(data_w.W))
  })


  def float_add(a :UInt, b: UInt): UInt = {
    val sum = Wire(UInt((data_w+1).W))
    val adder = Module(new floatAdd(data_w,8,24))
    adder.io.in0 := a
    adder.io.in1 := b
    sum := adder.io.out
    sum
  }

  // TOGGLE COMMENT/UNCOMMENT FOR CHISEL TEST
  //io.out := resultRec
  io.out := hardfloat.fNFromRecFN(expWidth, sigWidth, io.vec.reduceTree((x, y) => float_add(x, y)))


}
