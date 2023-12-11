package chipyard.clocking

import chisel3._
import chisel3.util._

import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.util._
import freechips.rocketchip.prci._
import freechips.rocketchip.util.ElaborationArtefacts

import testchipip._

object ResetStretcher {
  def apply(clock: Clock, reset: Reset, cycles: Int): Reset = {
    withClockAndReset(clock, reset) {
      val n = log2Ceil(cycles)
      val count = Module(new AsyncResetRegVec(w=n, init=0))
      val resetout = Module(new AsyncResetRegVec(w=1, init=1))
      count.io.en := resetout.io.q
      count.io.d := count.io.q + 1.U
      resetout.io.en := resetout.io.q
      resetout.io.d := count.io.q < (cycles-1).U

      resetout.io.q.asBool
    }
  }
}


case class ClockSelNode()(implicit valName: ValName)
  extends MixedNexusNode(ClockImp, ClockGroupImp)(
     dFn = { d =>  
         ClockGroupSourceParameters()
     },
     uFn = { u => 
         ClockSinkParameters()
     }
  )

class ClockSelector(address: BigInt, tlbus: TLBusWrapper)(implicit p: Parameters) extends LazyModule {
    val device = new SimpleDevice("clk-sel-ctrl", Nil)
    val tlNode = TLRegisterNode(Seq(AddressSet(address, 4096-1)), device, "reg/control", beatBytes=tlbus.beatBytes)
    tlbus.toVariableWidthSlave(Some("clk-sel-ctrl")) { tlNode := TLBuffer() }

    val clockNode = ClockSelNode()

    lazy val module = new Impl 
    class Impl extends LazyModuleImp(this) {
        val io = IO(new Bundle {
            val clk_debug = Output(Clock())
        })

        val asyncReset = clockNode.in.map(_._1).map(_.reset).toSeq(0)
        val clocks = clockNode.in.map(_._1).map(_.clock)

        val sel = withReset(asyncReset) { Module(new AsyncResetRegVec(w=3, init=0)) }

        val mux = withClock(false.B.asClock) { testchipip.ClockMutexMux(clocks) }
        mux.io.sel        := sel.io.q
        mux.io.resetAsync := asyncReset.asAsyncReset

        val (outClocks, _) = clockNode.out.head
        val (sinkNames, sinks) = outClocks.member.elements.toSeq.unzip

        sinks.foreach(sink => {
            sink.clock := mux.io.clockOut
            sink.reset := ResetStretcher(clocks(0), asyncReset, 200).asAsyncReset
        })

        // clock debug output
        val divBits = 12
        val debug_en  = withReset(asyncReset) { Module(new AsyncResetRegVec(w=1, init=1)) }
        val debug_sel = withReset(asyncReset) { Module(new AsyncResetRegVec(w=3, init=0)) }
        val debug_mux = withClock(false.B.asClock) { testchipip.ClockMutexMux(clocks) }
        val debug_div = withReset(asyncReset) { Module(new AsyncResetRegVec(w=divBits, init=1)) }
        debug_mux.io.sel        := debug_sel.io.q
        debug_mux.io.resetAsync := asyncReset.asAsyncReset

        val clk_temp = Wire(Clock())
        clk_temp := withClockAndReset(debug_mux.io.clockOut, asyncReset) {
            val divider = Module(new testchipip.ClockDivideOrPass(divBits, depth = 3, genClockGate = p(ClockGateImpl)))
            divider.io.divisor := debug_div.io.q
            divider.io.resetAsync := asyncReset
            divider.io.clockOut
        }

        io.clk_debug := ClockGate(clk_temp, debug_en.io.q.asBool)

        tlNode.regmap(
            0x00 -> Seq(RegField.rwReg(3, sel.io)),
            0x04 -> Seq(RegField.rwReg(1, debug_en.io)),
            0x08 -> Seq(RegField.rwReg(3, debug_sel.io)),
            0x0C -> Seq(RegField.rwReg(divBits, debug_div.io))
        )
    }
}
