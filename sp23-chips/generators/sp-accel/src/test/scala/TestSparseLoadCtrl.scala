package spaccel

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec 

class AccelSparseLoadControllerTest extends AnyFreeSpec with ChiselScalatestTester {
    "Testcase" in {
        test(new AccelSparseLoadController()) { c=>
            c.io.inputBundle.bits.spPtr.poke(0.U)
            c.io.inputBundle.bits.spSize.poke(12.U)
            c.io.inputBundle.valid.poke(true.B)
            c.clock.step(1)

            c.io.outputBundle.valid.expect(true.B)
            c.io.outputBundle.bits.memPtr.expect(0.U)
            c.io.outputBundle.bits.startRowChunk.expect(true.B)
            c.io.outputBundle.bits.endRowChunk.expect(false.B)
            c.io.outputBundle.ready.poke(true.B)
            c.clock.step(1)

            c.io.outputBundle.valid.expect(true.B)
            c.io.outputBundle.bits.memPtr.expect(64.U)
            c.io.outputBundle.bits.startRowChunk.expect(false.B)
            c.io.outputBundle.bits.endRowChunk.expect(false.B)
            c.io.outputBundle.ready.poke(true.B)
            c.clock.step(1)

            c.io.outputBundle.valid.expect(true.B)
            c.io.outputBundle.bits.memPtr.expect(64.U)
            c.io.outputBundle.bits.startRowChunk.expect(false.B)
            c.io.outputBundle.bits.endRowChunk.expect(true.B)
            c.io.outputBundle.ready.poke(true.B)
            c.clock.step(1)
            c.io.outputBundle.valid.expect(false.B)
        }
    }
}