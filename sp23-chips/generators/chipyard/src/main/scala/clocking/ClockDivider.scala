package chipyard.clocking

import chisel3._
import chisel3.util._
// import chisel3.core.{IntParam, Reset}

import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.util._
import freechips.rocketchip.prci._
import freechips.rocketchip.util.ElaborationArtefacts

import testchipip._

class ClockDivider(address: BigInt, tlbus: TLBusWrapper)(implicit p: Parameters) extends LazyModule {
    val device = new SimpleDevice("clk-div-ctrl", Nil)
    val tlNode = TLRegisterNode(Seq(AddressSet(address, 4096-1)), device, "reg/control", beatBytes=tlbus.beatBytes)
    tlbus.toVariableWidthSlave(Some("clk-div-ctrl")) { tlNode := TLBuffer() }

    val clockNode = ClockGroupIdentityNode()

    lazy val module = new LazyModuleImp(this) {
        val sources = clockNode.in.head._1.member.data.toSeq
        val sinks = clockNode.out.head._1.member.elements.toSeq
        val nSinks = sinks.size
        val divBits = 5

        val regs = (0 until nSinks).map({i =>
            val sinkName = sinks(i)._1
            val asyncReset = sources(0).reset
            val reg = withReset(asyncReset) { Module(new AsyncResetRegVec(w=divBits, init=0)) }
            sinks(i)._2.clock := withClockAndReset(sources(i).clock, asyncReset) {
            val divider = Module(new testchipip.ClockDivideOrPass(divBits, depth = 3, genClockGate = p(ClockGateImpl)))
            divider.io.divisor := reg.io.q
            divider.io.resetAsync := asyncReset
            divider.io.clockOut
        }
            sinks(i)._2.reset := sources(i).reset
            reg
        })

        tlNode.regmap((0 until nSinks).map({i =>
          val sinkName = sinks(i)._1
          println(s"ClockDivSel for ${sinkName} regmapped at ${(address+i*4).toString(16)}")
          i*4 -> Seq(RegField.rwReg(divBits, regs(i).io))
        }): _*)
    }
}
