package lqrRoCC

import chisel3._
import chisel3.util._
import chiseltest._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import org.scalatest.freespec.AnyFreeSpec

class dotTest extends AnyFreeSpec with ChiselScalatestTester {

  "Basic Testcase dot" in {
    test(new dotCompute(32, 4)).withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation)) { c =>
        c.io.vec1(0).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec1(1).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec1(2).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec1(3).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36


        c.io.vec2(0).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(1).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec2(2).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(3).poke("b00000000000000000000000000000000".asUInt(32.W)) //0

        c.io.out.expect("b00000000000000000000000000000000".asUInt(32.W)) // dot compute should take 1 cycle, thus not ready here

        c.clock.step(1)

        //c.io.out.expect("b11000010101000110000111101011100".asUInt(32.W)) // -81.53

        c.clock.step(3)
    }
  }


  "Basic Testcase dot ii" in {
    test(new dotCompute(32, 16)).withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation)) { c =>
        c.io.vec1(0).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec1(1).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec1(2).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec1(3).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.vec1(4).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec1(5).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec1(6).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec1(7).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.vec1(8).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec1(9).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec1(10).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec1(11).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36

        c.io.vec1(12).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec1(13).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec1(14).poke("b01000010101011100000000000000000".asUInt(32.W)) //87
        c.io.vec1(15).poke("b11000011100011111010111000010100".asUInt(32.W)) //-287.36


        c.io.vec2(0).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(1).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec2(2).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(3).poke("b00000000000000000000000000000000".asUInt(32.W)) //0
        
        c.io.vec2(4).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(5).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec2(6).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(7).poke("b00000000000000000000000000000000".asUInt(32.W)) //0

        c.io.vec2(8).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(9).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec2(10).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(11).poke("b00000000000000000000000000000000".asUInt(32.W)) //0

        c.io.vec2(12).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(13).poke("b01000000011001100110011001100110".asUInt(32.W)) //3.6
        c.io.vec2(14).poke("b10111111100011001100110011001101".asUInt(32.W)) //-1.1
        c.io.vec2(15).poke("b00111111100000000000000000000000".asUInt(32.W)) //1 ***


        c.io.out.expect("b00000000000000000000000000000000".asUInt(32.W)) // dot compute should take 1 cycle, thus not ready here

        c.clock.step(1)

        c.io.out.expect("b11000100000110010101111010111000".asUInt(32.W)) // -81.53*4-287.36 = -613.48

        c.clock.step(3)
    }
  }
}