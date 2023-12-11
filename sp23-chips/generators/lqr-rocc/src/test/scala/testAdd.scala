package lqrRoCC

import chisel3._
import chisel3.util._
import chiseltest._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import org.scalatest.freespec.AnyFreeSpec

class addTest extends AnyFreeSpec with ChiselScalatestTester {

  "Basic Testcase" in {
    test(new floatAdd()).withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation)) { c =>
      val in0_poke = "b11000000001000111101011100001010".asUInt(32.W) // -2.56
      val in1_poke = "b11000001000011100110011001100110".asUInt(32.W) // -8.9
      val out_poke = "b11000001001101110101110000101001".asUInt(32.W) // -11.46
      c.io.in0.poke(in0_poke)
      c.io.in1.poke(in1_poke)
      //step(1)
      //c.io.out.expect(out_poke)
      
      println("T1: " + c.io.in0.peek().litValue)
      println("T1:" + c.io.in1.peek().litValue)
      println("T1:" + c.io.out.peek().litValue)
      println("T1-truth:" + out_poke)
      

      val in0_poke2 = "b01000000100101010111000010100100".asUInt(32.W) // 4.67
      val in1_poke2 = "b11000001000011001100110011001101".asUInt(32.W) // -8.8
      val out_poke2 = "b11000000100001000010100011110110".asUInt(32.W) // -4.13
      c.io.in0.poke(in0_poke2)
      c.io.in1.poke(in1_poke2)
      //step(1)
      c.io.out.expect(out_poke2)
      
      println("T2:" + c.io.in0.peek().litValue)
      println("T2:" + c.io.in1.peek().litValue)
      println("T2:" + c.io.out.peek().litValue)
      println("T2-truth:" + out_poke2)

    }
  }
}
