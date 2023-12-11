package gps23

import chisel3._
import chisel3.util._
import chisel3.experimental.{IntParam, BaseModule}
import freechips.rocketchip.amba.axi4._
import freechips.rocketchip.subsystem.BaseSubsystem
import freechips.rocketchip.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper.{HasRegMap, RegField}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.UIntIsOneOf

// This is an GCD MMIO example copied from generators/chipyard/src/main/scala/example/GCD.scala
// See chipyard doc 6.7 MMIO Peripherals for more explainations

// DOC include start: GPS params
case class GPSParams(
  address: BigInt = 0x1000,
  width: Int = 32,
  useAXI4: Boolean = false,
  useBlackBox: Boolean = true)
// DOC include end: GPS params

// DOC include start: GPS key
case object GPSKey extends Field[Option[GPSParams]](None)
// DOC include end: GPS key

class GPSIO(val w: Int) extends Bundle {
  val clock = Input(Clock())
  val reset = Input(Bool())
  val input_ready = Output(Bool())
  val input_valid = Input(Bool())
  val x = Input(UInt(w.W))
  val y = Input(UInt(w.W))
  val output_ready = Input(Bool())
  val output_valid = Output(Bool())
  val gcd = Output(UInt(w.W))
  val busy = Output(Bool())
}

trait GPSTopIO extends Bundle {
  val gps_busy = Output(Bool())
}

trait HasGPSIO extends BaseModule {
  val w: Int
  val io = IO(new GPSIO(w))
}

// DOC include start: GPS blackbox
class GPSMMIOBlackBox(val w: Int) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxResource
  with HasGPSIO
{
  addResource("/vsrc/GPSMMIOBlackBox.v")
}
// DOC include end: GCD blackbox

// DOC include start: GCD chisel
class GPSMMIOChiselModule(val w: Int) extends Module
  with HasGPSIO
{
  val s_idle :: s_run :: s_done :: Nil = Enum(3)

  val state = RegInit(s_idle)
  val tmp   = Reg(UInt(w.W))
  val gcd   = Reg(UInt(w.W))

  io.input_ready := state === s_idle
  io.output_valid := state === s_done
  io.gcd := gcd

  when (state === s_idle && io.input_valid) {
    state := s_run
  } .elsewhen (state === s_run && tmp === 0.U) {
    state := s_done
  } .elsewhen (state === s_done && io.output_ready) {
    state := s_idle
  }

  when (state === s_idle && io.input_valid) {
    gcd := io.x
    tmp := io.y
  } .elsewhen (state === s_run) {
    when (gcd > tmp) {
      gcd := gcd - tmp
    } .otherwise {
      tmp := tmp - gcd
    }
  }

  io.busy := state =/= s_idle
}
// DOC include end: GPS chisel

// DOC include start: GPS instance regmap

trait GPSModule extends HasRegMap {
  val io: GPSTopIO

  implicit val p: Parameters
  def params: GPSParams
  val clock: Clock
  val reset: Reset


  // How many clock cycles in a PWM cycle?
  val x = Reg(UInt(params.width.W))
  val y = Wire(new DecoupledIO(UInt(params.width.W)))
  val gcd = Wire(new DecoupledIO(UInt(params.width.W)))
  val status = Wire(UInt(2.W))

  val impl = if (params.useBlackBox) {
    Module(new GPSMMIOBlackBox(params.width))
  } else {
    Module(new GPSMMIOChiselModule(params.width))
  }

  impl.io.clock := clock
  impl.io.reset := reset.asBool

  impl.io.x := x
  impl.io.y := y.bits
  impl.io.input_valid := y.valid
  y.ready := impl.io.input_ready

  gcd.bits := impl.io.gcd
  gcd.valid := impl.io.output_valid
  impl.io.output_ready := gcd.ready

  status := Cat(impl.io.input_ready, impl.io.output_valid)
  io.gps_busy := impl.io.busy

  regmap(
    0x00 -> Seq(
      RegField.r(2, status)), // a read-only register capturing current status
    0x04 -> Seq(
      RegField.w(params.width, x)), // a plain, write-only register
    0x08 -> Seq(
      RegField.w(params.width, y)), // write-only, y.valid is set on write
    0x0C -> Seq(
      RegField.r(params.width, gcd))) // read-only, gcd.ready is set on read
}
// DOC include end: GPS instance regmap

// DOC include start: GPS router
class GPSTL(params: GPSParams, beatBytes: Int)(implicit p: Parameters)
  extends TLRegisterRouter(
    params.address, "gps", Seq("ucbbar,gps"),
    beatBytes = beatBytes)(
      new TLRegBundle(params, _) with GPSTopIO)(
      new TLRegModule(params, _, _) with GPSModule)

class GPSAXI4(params: GCDParams, beatBytes: Int)(implicit p: Parameters)
  extends AXI4RegisterRouter(
    params.address,
    beatBytes=beatBytes)(
      new AXI4RegBundle(params, _) with GPSTopIO)(
      new AXI4RegModule(params, _, _) with GPSModule)
// DOC include end: GPS router

// DOC include start: GPS lazy trait
trait CanHavePeripheryGPS { this: BaseSubsystem =>
  private val portName = "gps"

  // Only build if we are using the TL (nonAXI4) version
  val gps = p(GPSKey) match {
    case Some(params) => {
      if (params.useAXI4) {
        val gps = LazyModule(new GPSAXI4(params, pbus.beatBytes)(p))
        pbus.toSlave(Some(portName)) {
          gps.node :=
          AXI4Buffer () :=
          TLToAXI4 () :=
          // toVariableWidthSlave doesn't use holdFirstDeny, which TLToAXI4() needsx
          TLFragmenter(pbus.beatBytes, pbus.blockBytes, holdFirstDeny = true)
        }
        Some(gps)
      } else {
        val gps = LazyModule(new GPSTL(params, pbus.beatBytes)(p))
        pbus.toVariableWidthSlave(Some(portName)) { gps.node }
        Some(gps)
      }
    }
    case None => None
  }
}
// DOC include end: GPS lazy trait

// DOC include start: GPS imp trait
trait CanHavePeripheryGPSModuleImp extends LazyModuleImp {
  val outer: CanHavePeripheryGPS
  val gps_busy = outer.gps match {
    case Some(gps) => {
      val busy = IO(Output(Bool()))
      busy := gps.module.io.gps_busy
      Some(busy)
    }
    case None => None
  }
}

// DOC include end: GPS imp trait


// DOC include start: GPS config fragment
class WithGPS(useAXI4: Boolean = false, useBlackBox: Boolean = false) extends Config((site, here, up) => {
  case GPSKey => Some(GPSParams(useAXI4 = useAXI4, useBlackBox = useBlackBox))
})
// DOC include end: GPS config fragment
