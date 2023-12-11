package prefetchers

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.should.Matchers
import freechips.rocketchip.config.{Field, Parameters}

class BOPTest extends AnyFlatSpec with ChiselScalatestTester with Matchers {
  behavior of "BOPTester"

  it should "BOPTest" in {
    test(new BOPrefetcher(new SingleBOPrefetcherParams())(Parameters.empty)).withAnnotations(Seq(VerilatorBackendAnnotation, WriteFstAnnotation)) { bop =>
      //populate RR table & train scoreboard
      for (i <- 0 until 120) {
        bop.io.snoop.valid.poke(true.B)
        bop.io.snoop.bits.write.poke(false.B)
        bop.io.snoop.bits.address.poke((i * 12).U)
        // println(bop.match_in_rr.peek().litValue);
        bop.clock.step(1)    // advance the clock
      }

      bop.io.snoop.valid.poke(false.B)

      // printf(cf"Score Table = ${bop.score_table.peek().litValue}%x")
      // for (i <- 0 until 52) {
      //   println(bop.score_table(i).peek().litValue)
      // }

      bop.io.request.ready.poke(true.B)
      bop.clock.step(30)// advance the clock
      bop.io.request.ready.poke(false.B)

      bop.io.snoop.valid.poke(true.B)
      bop.io.snoop.bits.write.poke(false.B)
      bop.io.snoop.bits.address.poke((180*12).U)   //set test input

      bop.clock.step(1)    // advance the clock
      bop.io.snoop.valid.poke(false.B)
      bop.io.request.ready.poke(true.B)
      bop.io.request.valid.expect(true.B)
      bop.io.request.bits.write.expect(false.B)
      println(bop.io.request.bits.address.peek().litValue) //print actual output
      bop.io.request.bits.address.expect((181*12).U) //check output

      bop.clock.step(100)    // advance the clock
      
			println("Done")
    }
  }
}
