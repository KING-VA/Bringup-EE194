package lqrRoCC

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._

class dotCompute(val data_w: Int = 32, val n: Int = 16) extends Module {
  val io = IO(new Bundle {
    val vec1 =  Input(Vec(n,UInt(data_w.W)))
    val vec2 =  Input(Vec(n,UInt(data_w.W)))
    val out = Output(UInt(data_w.W))
  })

  // declare n multiplier
  val mul_vec_io = Array.fill(n)(Module(new floatMul(data_w,8,24)).io) 

  // declare n buffer reg - 1 cycle
  val mul_result_vec   = RegInit(VecInit(Seq.fill(n)(0.U((data_w+1).W))))
  for(i <- 0 until n) {
    mul_vec_io(i).in0 := io.vec1(i)
    mul_vec_io(i).in1 := io.vec2(i)
    mul_result_vec(i) := mul_vec_io(i).out
  }

  val tree_add_io = Module(new floatAddTree(data_w, n)).io
  tree_add_io.vec := mul_result_vec

  io.out := tree_add_io.out


}
