package lqrRoCC

import chisel3._
import chisel3.util._
import chiseltest._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import org.scalatest.freespec.AnyFreeSpec

class mulTest extends AnyFreeSpec with ChiselScalatestTester {

  "Basic Testcase" in {
    test(new floatMul()).withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation)) { c =>
      
      val in0_poke = "b00111111100011001100110011001101".asUInt(32.W) // 1.1
      val in1_poke = "b01000000000011001100110011001101".asUInt(32.W) // 2.2
      val out_poke = "b01000000000110101110000101001000".asUInt(32.W) //2.42
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
      val out_poke2 = "b11000010001001000110001001001110".asUInt(32.W) // -41.096
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
