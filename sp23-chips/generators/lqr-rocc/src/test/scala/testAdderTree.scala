package lqrRoCC

import chisel3._
import chisel3.util._
import chiseltest._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import org.scalatest.freespec.AnyFreeSpec

class adderTreeTest extends AnyFreeSpec with ChiselScalatestTester {

  "Basic Testcase" in {
    test(new floatAddTree(32, 4)).withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation)) { c =>
        c.io.vec(0).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec(1).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec(2).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec(3).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.out.expect("b11000011010001011101110000101001".asUInt(32.W)) // -197.86


      
      

    }
  }

  "Basic-ii Testcase" in {
    test(new floatAddTree(32, 16)).withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation)) { c =>
        c.io.vec(0).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec(1).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec(2).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec(3).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.vec(4).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec(5).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec(6).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec(7).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.vec(8).poke("b11000010110010100011001100110011".asUInt(32.W)) //-101.1 **
        c.io.vec(9).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec(10).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec(11).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.vec(12).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec(13).poke("b01000011101111111100110011001101".asUInt(32.W)) //383.6 **
        c.io.vec(14).poke("b01000010101011101011110101110001".asUInt(32.W)) //87.37 **
        c.io.vec(15).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.out.expect("b11000011111111111000100011110110".asUInt(32.W))// sum is  -197.86 * 4 -100 + 380 + 0.37 =-511.07


      
      

    }
  }
}
