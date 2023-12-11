package chipyard.iobinders

import chisel3._
import chisel3.experimental.{Analog, IO, DataMirror}

import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.devices.debug._
import freechips.rocketchip.jtag.{JTAGIO}
import freechips.rocketchip.subsystem._
import freechips.rocketchip.system.{SimAXIMem}
import freechips.rocketchip.amba.axi4.{AXI4Bundle, AXI4SlaveNode, AXI4MasterNode, AXI4EdgeParameters}
import freechips.rocketchip.util._
import freechips.rocketchip.prci._
import freechips.rocketchip.groundtest.{GroundTestSubsystemModuleImp, GroundTestSubsystem}

import sifive.blocks.devices.gpio._
import sifive.blocks.devices.uart._
import sifive.blocks.devices.spi._
import sifive.blocks.devices.pwm._
import sifive.blocks.devices.i2c._
import sifive.blocks.devices.pinctrl._
import tracegen.{TraceGenSystemModuleImp}

import barstools.iocell.chisel._

import testchipip._
import icenet.{CanHavePeripheryIceNIC, SimNetwork, NicLoopback, NICKey, NICIOvonly}

import chipyard.clocking.{HasChipyardPRCI, DividerOnlyClockGenerator, ClockSelector, ClockDivider, IntelRingPll, IntelRingPllCtrl, IntelClockRecieverCtrl, IntelClockReciever}
import scala.reflect.{ClassTag}


object IOBinderTypes {
  type IOBinderTuple = (Seq[Data], Seq[IOCell])
  type IOBinderFunction = (Boolean, => Any) => ModuleValue[IOBinderTuple]
}
import IOBinderTypes._

// System for instantiating binders based
// on the scala type of the Target (_not_ its IO). This avoids needing to
// duplicate harnesses (essentially test harnesses) for each target.

// IOBinders is map between string representations of traits to the desired
// IO connection behavior for tops matching that trait. We use strings to enable
// composition and overriding of IOBinders, much like how normal Keys in the config
// system are used/ At elaboration, the testharness traverses this set of functions,
// and functions which match the type of the DigitalTop are evaluated.

// You can add your own binder by adding a new (key, fn) pair, typically by using
// the OverrideIOBinder or ComposeIOBinder macros
case object IOBinders extends Field[Map[String, Seq[IOBinderFunction]]](
  Map[String, Seq[IOBinderFunction]]().withDefaultValue(Nil)
)

object GPIOPins {
	val gpioPins = scala.collection.mutable.Map.empty[String, EnhancedPin]
	val spiPorts = scala.collection.mutable.Map.empty[String, SPIDataIO]
	val i2cPorts = scala.collection.mutable.Map.empty[String, I2CPin]
  val pwmPorts = scala.collection.mutable.Map.empty[String, Bool]
}



abstract trait HasIOBinders { this: LazyModule =>
  val lazySystem: LazyModule
  private val iobinders = p(IOBinders)
  // Note: IOBinders cannot rely on the implicit clock/reset, as they may be called from the
  // context of a LazyRawModuleImp
  private val lzy = iobinders.map({ case (s,fns) => s -> fns.map(f => f(true, lazySystem)) })
  private val imp = iobinders.map({ case (s,fns) => s -> fns.map(f => f(false, lazySystem.module)) })

  private lazy val lzyFlattened: Map[String, IOBinderTuple] = lzy.map({
    case (s,ms) => s -> (ms.map(_._1).flatten, ms.map(_._2).flatten)
  })
  private lazy val impFlattened: Map[String, IOBinderTuple] = imp.map({
    case (s,ms) => s -> (ms.map(_._1).flatten, ms.map(_._2).flatten)
  })

  // A publicly accessible list of IO cells (useful for a floorplanning tool, for example)
  val iocells = InModuleBody { (lzyFlattened.values ++ impFlattened.values).unzip._2.flatten.toBuffer }

  // A mapping between stringified DigitalSystem traits and their corresponding ChipTop ports
  val portMap = InModuleBody { iobinders.keys.map(k => k -> (lzyFlattened(k)._1 ++ impFlattened(k)._1)).toMap }

  // A mapping between stringified DigitalSystem traits and their corresponding ChipTop iocells
  val iocellMap = InModuleBody { iobinders.keys.map(k => k -> (lzyFlattened(k)._2 ++ impFlattened(k)._2)).toMap }


}

// Note: The parameters instance is accessible only through LazyModule
// or LazyModuleImpLike. The self-type requirement in traits like
// CanHaveMasterAXI4MemPort is insufficient to make it accessible to the IOBinder
// As a result, IOBinders only work on Modules which inherit LazyModule or
// or LazyModuleImpLike
object GetSystemParameters {
  def apply(s: Any): Parameters = {
    s match {
      case s: LazyModule => s.p
      case s: LazyModuleImpLike => s.p
      case _ => throw new Exception(s"Trying to get Parameters from a system that is not LazyModule or LazyModuleImpLike")
    }
  }
}

class IOBinder[T](composer: Seq[IOBinderFunction] => Seq[IOBinderFunction])(implicit tag: ClassTag[T]) extends Config((site, here, up) => {
  case IOBinders => up(IOBinders, site) + (tag.runtimeClass.toString -> composer(up(IOBinders, site)(tag.runtimeClass.toString)))
})

class ConcreteIOBinder[T](composes: Boolean, fn: T => IOBinderTuple)(implicit tag: ClassTag[T]) extends IOBinder[T](
  up => (if (composes) up else Nil) ++ Seq(((_, t) => { InModuleBody {
    t match {
      case system: T => fn(system)
      case _ => (Nil, Nil)
    }
  }}): IOBinderFunction)
)

class LazyIOBinder[T](composes: Boolean, fn: T => ModuleValue[IOBinderTuple])(implicit tag: ClassTag[T]) extends IOBinder[T](
  up => (if (composes) up else Nil) ++ Seq(((isLazy, t) => {
    val empty = new ModuleValue[IOBinderTuple] {
      def getWrappedValue: IOBinderTuple = (Nil, Nil)
    }
    if (isLazy) {
      t match {
        case system: T => fn(system)
        case _ => empty
      }
    } else {
      empty
    }
  }): IOBinderFunction)
)

// The "Override" binders override any previous IOBinders (lazy or concrete) defined on the same trait.
// The "Compose" binders do not override previously defined IOBinders on the same trait
// The default IOBinders evaluate only in the concrete "ModuleImp" phase of elaboration
// The "Lazy" IOBinders evaluate in the LazyModule phase, but can also generate hardware through InModuleBody

class OverrideIOBinder[T](fn: T => IOBinderTuple)(implicit tag: ClassTag[T]) extends ConcreteIOBinder[T](false, fn)
class ComposeIOBinder[T](fn: T => IOBinderTuple)(implicit tag: ClassTag[T]) extends ConcreteIOBinder[T](true, fn)

class OverrideLazyIOBinder[T](fn: T => ModuleValue[IOBinderTuple])(implicit tag: ClassTag[T]) extends LazyIOBinder[T](false, fn)
class ComposeLazyIOBinder[T](fn: T => ModuleValue[IOBinderTuple])(implicit tag: ClassTag[T]) extends LazyIOBinder[T](true, fn)


case object IOCellKey extends Field[IOCellTypeParams](GenericIOCellParams())


class WithGPIOCells extends OverrideIOBinder({
  (system: HasPeripheryGPIOModuleImp) => {
    val (ports2d, cells2d) = system.gpio.zipWithIndex.map({ case (gpio, i) =>
      gpio.pins.zipWithIndex.map({ case (pin, j) =>
        val g = IO(Analog(1.W)).suggestName(s"gpio_${i}_${j}")
        // GET RID OF IOCELL
        val iocell = system.p(IOCellKey).gpio().suggestName(s"iocell_gpio_${i}_${j}")

				iocell.io.o := pin.o.oval
        iocell.io.oe := pin.o.oe
        iocell.io.ie := pin.o.ie
        // PINS REFER TO IO OF THE SYSTEM
        pin.i.ival := iocell.io.i
        // INSTEAD OF CONNECTING IT TO AN IO CELL, RETURN THE PIN OBJ OR AS A BUNDLE
        // (PINS, IOCELL) -> (PINS, EMPTY ARRAY)
        iocell.io.pad <> g

        GPIOPins.gpioPins += (s"iocell_gpio_${i}_${j}" -> pin)
				(g, iocell)
      }).unzip
    }).unzip
    val ports: Seq[Analog] = ports2d.flatten
    (ports, cells2d.flatten)
  }
})

// DOC include start: WithUARTIOCells
class WithUARTIOCells extends OverrideIOBinder({
  (system: HasPeripheryUARTModuleImp) => {
    val (ports: Seq[UARTPortIO], cells2d) = system.uart.zipWithIndex.map({ case (u, i) =>
      val (port, ios) = IOCell.generateIOFromSignal(u, s"uart_${i}", system.p(IOCellKey), abstractResetAsAsync = true)
      (port, ios)
    }).unzip
    // RETURN A REFERENCE TO THE WIRE INSTEAD OF PORTS
    (ports, cells2d.flatten)
  }
})
// DOC include end: WithUARTIOCells

class WithSPIIOCells extends OverrideIOBinder({
  (system: HasPeripherySPIFlashModuleImp) => {
    val (ports: Seq[SPIChipIO], cells2d) = system.qspi.zipWithIndex.map({ case (s, i) =>
      val name = s"spi_${i}"
      val port = IO(new SPIChipIO(s.c.csWidth)).suggestName(name)
      val iocellBase = s"iocell_${name}"

      // SCK and CS are unidirectional outputs
      val sckIOs = IOCell.generateFromSignal(s.sck, port.sck, Some(s"${iocellBase}_sck"), system.p(IOCellKey), IOCell.toAsyncReset)
      val csIOs = IOCell.generateFromSignal(s.cs, port.cs, Some(s"${iocellBase}_cs"), system.p(IOCellKey), IOCell.toAsyncReset)

      // DQ are bidirectional, so then need special treatment
      val dqIOs = s.dq.zip(port.dq).zipWithIndex.map { case ((pin, ana), j) =>
        val iocell = system.p(IOCellKey).gpio().suggestName(s"${iocellBase}_dq_${j}")
        iocell.io.o := pin.o
        iocell.io.oe := pin.oe
        iocell.io.ie := true.B
        pin.i := iocell.io.i
        iocell.io.pad <> ana
        iocell
      }

      (port, dqIOs ++ csIOs ++ sckIOs)
    }).unzip
    (ports, cells2d.flatten)
  }
})

class WithExtInterruptIOCells extends OverrideIOBinder({
  (system: HasExtInterruptsModuleImp) => {
    if (system.outer.nExtInterrupts > 0) {
      val (port: UInt, cells) = IOCell.generateIOFromSignal(system.interrupts, "ext_interrupts", system.p(IOCellKey), abstractResetAsAsync = true)
      (Seq(port), cells)
    } else {
      (Nil, Nil)
    }
  }
})

// Rocketchip's JTAGIO exposes the oe signal, which doesn't go off-chip
class JTAGChipIO extends Bundle {
  val TCK = Input(Clock())
  val TMS = Input(Bool())
  val TDI = Input(Bool())
  val TDO = Output(Bool())
}

class WithDebugIOCells extends OverrideLazyIOBinder({
  (system: HasPeripheryDebug) => {
    implicit val p = GetSystemParameters(system)
    val tlbus = system.asInstanceOf[BaseSubsystem].locateTLBusWrapper(p(ExportDebug).slaveWhere)
    val clockSinkNode = system.debugOpt.map(_ => ClockSinkNode(Seq(ClockSinkParameters())))
    clockSinkNode.map(_ := tlbus.fixedClockNode)
    def clockBundle = clockSinkNode.get.in.head._1


    InModuleBody { system.asInstanceOf[BaseSubsystem].module match { case system: HasPeripheryDebugModuleImp => {
      system.debug.map({ debug =>
        // We never use the PSDIO, so tie it off on-chip
        system.psd.psd.foreach { _ <> 0.U.asTypeOf(new PSDTestMode) }
        system.resetctrl.map { rcio => rcio.hartIsInReset.map { _ := clockBundle.reset.asBool } }
        system.debug.map { d =>
          // Tie off extTrigger
          d.extTrigger.foreach { t =>
            t.in.req := false.B
            t.out.ack := t.out.req
          }
          // Tie off disableDebug
          d.disableDebug.foreach { d => d := false.B }
          // Drive JTAG on-chip IOs
          d.systemjtag.map { j =>
            j.reset := ResetCatchAndSync(j.jtag.TCK, clockBundle.reset.asBool)
            j.mfr_id := p(JtagDTMKey).idcodeManufId.U(11.W)
            j.part_number := p(JtagDTMKey).idcodePartNum.U(16.W)
            j.version := p(JtagDTMKey).idcodeVersion.U(4.W)
          }
        }
        Debug.connectDebugClockAndReset(Some(debug), clockBundle.clock)

        // Add IOCells for the DMI/JTAG/APB ports
        val dmiTuple = debug.clockeddmi.map { d =>
          IOCell.generateIOFromSignal(d, "dmi", p(IOCellKey), abstractResetAsAsync = true)
        }

        val jtagTuple = debug.systemjtag.map { j =>
          val jtag_wire = Wire(new JTAGChipIO)
          j.jtag.TCK := jtag_wire.TCK
          j.jtag.TMS := jtag_wire.TMS
          j.jtag.TDI := jtag_wire.TDI
          jtag_wire.TDO := j.jtag.TDO.data
          IOCell.generateIOFromSignal(jtag_wire, "jtag", p(IOCellKey), abstractResetAsAsync = true)
        }

        val apbTuple = debug.apb.map { a =>
          IOCell.generateIOFromSignal(a, "apb", p(IOCellKey), abstractResetAsAsync = true)
        }

        val allTuples = (dmiTuple ++ jtagTuple ++ apbTuple).toSeq
        (allTuples.map(_._1).toSeq, allTuples.flatMap(_._2).toSeq)
      }).getOrElse((Nil, Nil))
    }}}
  }
})

class WithSerialTLIOCells extends OverrideIOBinder({
  (system: CanHavePeripheryTLSerial) => system.serial_tl.map({ s =>
    val sys = system.asInstanceOf[BaseSubsystem]
    val (port, cells) = IOCell.generateIOFromSignal(s.getWrappedValue, "serial_tl", sys.p(IOCellKey), abstractResetAsAsync = true)
    (Seq(port), cells)
  }).getOrElse((Nil, Nil))
})

class WithAXI4MemPunchthrough extends OverrideLazyIOBinder({
  (system: CanHaveMasterAXI4MemPort) => {
    implicit val p: Parameters = GetSystemParameters(system)
    val clockSinkNode = p(ExtMem).map(_ => ClockSinkNode(Seq(ClockSinkParameters())))
    clockSinkNode.map(_ := system.asInstanceOf[HasTileLinkLocations].locateTLBusWrapper(MBUS).fixedClockNode)
    def clockBundle = clockSinkNode.get.in.head._1

    InModuleBody {
      val ports: Seq[ClockedAndResetIO[AXI4Bundle]] = system.mem_axi4.zipWithIndex.map({ case (m, i) =>
        val p = IO(new ClockedAndResetIO(DataMirror.internal.chiselTypeClone[AXI4Bundle](m))).suggestName(s"axi4_mem_${i}")
        p.bits <> m
        p.clock := clockBundle.clock
        p.reset := clockBundle.reset
        p
      }).toSeq
      (ports, Nil)
    }
  }
})

class WithAXI4MMIOPunchthrough extends OverrideLazyIOBinder({
  (system: CanHaveMasterAXI4MMIOPort) => {
    implicit val p: Parameters = GetSystemParameters(system)
    val clockSinkNode = p(ExtBus).map(_ => ClockSinkNode(Seq(ClockSinkParameters())))
    clockSinkNode.map(_ := system.asInstanceOf[HasTileLinkLocations].locateTLBusWrapper(SBUS).fixedClockNode)
    def clockBundle = clockSinkNode.get.in.head._1

    InModuleBody {
      val ports: Seq[ClockedAndResetIO[AXI4Bundle]] = system.mmio_axi4.zipWithIndex.map({ case (m, i) =>
        val p = IO(new ClockedAndResetIO(DataMirror.internal.chiselTypeClone[AXI4Bundle](m))).suggestName(s"axi4_mmio_${i}")
        p.bits <> m
        p.clock := clockBundle.clock
        p.reset := clockBundle.reset
        p
      }).toSeq
      (ports, Nil)
    }
  }
})

class WithL2FBusAXI4Punchthrough extends OverrideLazyIOBinder({
  (system: CanHaveSlaveAXI4Port) => {
    implicit val p: Parameters = GetSystemParameters(system)
    val clockSinkNode = p(ExtIn).map(_ => ClockSinkNode(Seq(ClockSinkParameters())))
    clockSinkNode.map(_ := system.asInstanceOf[BaseSubsystem].fbus.fixedClockNode)
    def clockBundle = clockSinkNode.get.in.head._1

    InModuleBody {
      val ports: Seq[ClockedIO[AXI4Bundle]] = system.l2_frontend_bus_axi4.zipWithIndex.map({ case (m, i) =>
        val p = IO(new ClockedIO(Flipped(DataMirror.internal.chiselTypeClone[AXI4Bundle](m)))).suggestName(s"axi4_fbus_${i}")
        m <> p.bits
        p.clock := clockBundle.clock
        p
      }).toSeq
      (ports, Nil)
    }
  }
})

class WithBlockDeviceIOPunchthrough extends OverrideIOBinder({
  (system: CanHavePeripheryBlockDevice) => {
    val ports: Seq[ClockedIO[BlockDeviceIO]] = system.bdev.map({ bdev =>
      val p = IO(new ClockedIO(new BlockDeviceIO()(GetSystemParameters(system)))).suggestName("blockdev")
      p <> bdev
      p
    }).toSeq
    (ports, Nil)
  }
})

class WithNICIOPunchthrough extends OverrideIOBinder({
  (system: CanHavePeripheryIceNIC) => {
    val ports: Seq[ClockedIO[NICIOvonly]] = system.icenicOpt.map({ n =>
      val p = IO(new ClockedIO(new NICIOvonly)).suggestName("nic")
      p <> n
      p
    }).toSeq
    (ports, Nil)
  }
})

class WithTraceGenSuccessPunchthrough extends OverrideIOBinder({
  (system: TraceGenSystemModuleImp) => {
    val success: Bool = IO(Output(Bool())).suggestName("success")
    success := system.success
    (Seq(success), Nil)
  }
})

class WithTraceIOPunchthrough extends OverrideIOBinder({
  (system: CanHaveTraceIOModuleImp) => {
    val ports: Option[TraceOutputTop] = system.traceIO.map { t =>
      val trace = IO(DataMirror.internal.chiselTypeClone[TraceOutputTop](t)).suggestName("trace")
      trace <> t
      trace
    }
    (ports.toSeq, Nil)
  }
})

class WithCustomBootPin extends OverrideIOBinder({
  (system: CanHavePeripheryCustomBootPin) => system.custom_boot_pin.map({ p =>
    val sys = system.asInstanceOf[BaseSubsystem]
    val (port, cells) = IOCell.generateIOFromSignal(p.getWrappedValue, "custom_boot", sys.p(IOCellKey), abstractResetAsAsync = true)
    (Seq(port), cells)
  }).getOrElse((Nil, Nil))
})

class WithDontTouchPorts extends OverrideIOBinder({
  (system: DontTouch) => system.dontTouchPorts(); (Nil, Nil)
})

class ClockWithFreq(val freqMHz: Double) extends Bundle {
  val clock = Clock()
}

class WithDividerOnlyClockGenerator extends OverrideLazyIOBinder({
  (system: HasChipyardPRCI) => {
    // Connect the implicit clock
    implicit val p = GetSystemParameters(system)
    val implicitClockSinkNode = ClockSinkNode(Seq(ClockSinkParameters(name = Some("implicit_clock"))))
    system.connectImplicitClockSinkNode(implicitClockSinkNode)
    InModuleBody {
      val implicit_clock = implicitClockSinkNode.in.head._1.clock
      val implicit_reset = implicitClockSinkNode.in.head._1.reset
      system.asInstanceOf[BaseSubsystem].module match { case l: LazyModuleImp => {
        l.clock := implicit_clock
        l.reset := implicit_reset
      }}
    }

    // Connect all other requested clocks
    val referenceClockSource = ClockSourceNode(Seq(ClockSourceParameters()))
    val dividerOnlyClockGen = LazyModule(new DividerOnlyClockGenerator("buildTopClockGenerator"))

    (system.allClockGroupsNode
      := dividerOnlyClockGen.node
      := referenceClockSource)

    InModuleBody {
      val clock_wire = Wire(Input(new ClockWithFreq(dividerOnlyClockGen.module.referenceFreq)))
      // val reset_wire = Wire(Input(AsyncReset()))
      val resetn_wire = Wire(Input(AsyncReset()))
      val reset_wire = Wire(AsyncReset())
      reset_wire := (!resetn_wire.asBool).asAsyncReset
      val (clock_io, clockIOCell) = IOCell.generateIOFromSignal(clock_wire, "clock", p(IOCellKey))
      val (reset_io, resetIOCell) = IOCell.generateIOFromSignal(resetn_wire, "reset", p(IOCellKey))

      referenceClockSource.out.unzip._1.map { o =>
        o.clock := clock_wire.clock
        o.reset := reset_wire
      }

      (Seq(clock_io, reset_io), clockIOCell ++ resetIOCell)
    }
  }
})

// TODO: Add PPL in
class WithDividerAndPLLClockGenerator extends OverrideLazyIOBinder({
  (system: HasChipyardPRCI) => {
    // Connect the implicit clock
    implicit val p = GetSystemParameters(system)
    val implicitClockSinkNode = ClockSinkNode(Seq(ClockSinkParameters(name = Some("implicit_clock"))))
    system.connectImplicitClockSinkNode(implicitClockSinkNode)
    InModuleBody {
      val implicit_clock = implicitClockSinkNode.in.head._1.clock
      val implicit_reset = implicitClockSinkNode.in.head._1.reset
      system.asInstanceOf[BaseSubsystem].module match { case l: LazyModuleImp => {
        l.clock := implicit_clock
        l.reset := implicit_reset
      }}
    }

    // Connect all other requested clocks
    val tlbus = system.asInstanceOf[BaseSubsystem].locateTLBusWrapper(CBUS)

    val pllClockSource = ClockSourceNode(Seq(ClockSourceParameters(name=Some("pll-clock-source")))) //creates the clock node for the PLL, NOT the PPL module
    val pllClockSource_div0 = ClockSourceNode(Seq(ClockSourceParameters(name=Some("pll-clock-source-div0"))))
    val pllClockSource_div1 = ClockSourceNode(Seq(ClockSourceParameters(name=Some("pll-clock-source-div1"))))

    val pllctrl = LazyModule(new IntelRingPllCtrl(0x10004000, tlbus))
    val pllctrlClockSink = ClockSinkNode(Seq(ClockSinkParameters()))
    pllctrlClockSink := tlbus.fixedClockNode

    val clockDivider = LazyModule(new ClockDivider(0x10003000, tlbus))
    val clockSelector = LazyModule(new ClockSelector(0x10002000, tlbus))

    val referenceClockSource = ClockSourceNode(Seq(ClockSourceParameters()))

    (system.allClockGroupsNode
      := clockDivider.clockNode
      := clockSelector.clockNode)

    (clockSelector.clockNode := referenceClockSource)
    (clockSelector.clockNode := pllClockSource)
    (clockSelector.clockNode := pllClockSource_div0)
    (clockSelector.clockNode := pllClockSource_div1)

    InModuleBody {

      val clock_wire = Wire(Input(Clock()))
      val pll_clkref = Wire(Input(Clock()))
      val lock_wire = Wire(Output(UInt(1.W)))
      val resetn_wire = Wire(Input(AsyncReset()))
      val reset_wire = Wire(AsyncReset())
      reset_wire := (!resetn_wire.asBool).asAsyncReset
      val clock_debug_wire = Wire(Output(Clock()))


      val (clock_io, clockIOCell) = IOCell.generateIOFromSignal(clock_wire, "clock", p(IOCellKey))
      val (pllclkref_io, pllIOCell) = IOCell.generateIOFromSignal(pll_clkref, "pll_in", p(IOCellKey))
      val (reset_io, resetIOCell) = IOCell.generateIOFromSignal(resetn_wire, "reset", p(IOCellKey))
      val (clock_debug_io, clockDebugIOCell) = IOCell.generateIOFromSignal(clock_debug_wire, "clock_debug", p(IOCellKey))
      val (lock_io, lockIOCell) = IOCell.generateIOFromSignal(lock_wire, "lock", p(IOCellKey))

      // TODO: instantiate and conenct PLL module
      val ringpll = withReset(reset_wire) {Module(new IntelRingPll)}

      ringpll.io.clkref            := pll_clkref
      ringpll.io.fz_tight_loopb    := pllctrl.module.io.fz_tight_loopb  
      ringpll.io.fz_lockforce      := pllctrl.module.io.fz_lockforce 
      ringpll.io.fz_lockcnt        := pllctrl.module.io.fz_lockcnt 
      ringpll.io.fz_lockthresh     := pllctrl.module.io.fz_lockthresh
      ringpll.io.fz_pfd_pw         := pllctrl.module.io.fz_pfd_pw 
      ringpll.io.fz_dca_ctrl       := pllctrl.module.io.fz_dca_ctrl
      ringpll.io.fz_dca_cb         := pllctrl.module.io.fz_dca_cb 
      ringpll.io.fz_irefgen        := pllctrl.module.io.fz_irefgen 
      ringpll.io.fz_startup        := pllctrl.module.io.fz_startup 
      ringpll.io.fz_cp1trim        := pllctrl.module.io.fz_cp1trim 
      ringpll.io.fz_cp2trim        := pllctrl.module.io.fz_cp2trim 
      ringpll.io.fz_nopfdpwrgate   := pllctrl.module.io.fz_nopfdpwrgate 
      ringpll.io.fz_pfddly         := pllctrl.module.io.fz_pfddly 
      ringpll.io.fz_cpnbias        := pllctrl.module.io.fz_cpnbias 
      ringpll.io.fz_vcotrim        := pllctrl.module.io.fz_vcotrim 
      ringpll.io.fz_skadj          := pllctrl.module.io.fz_skadj 
      ringpll.io.fz_vcosel         := pllctrl.module.io.fz_vcosel 
      ringpll.io.fz_spare          := pllctrl.module.io.fz_spare 
      ringpll.io.fz_ldo_faststart  := pllctrl.module.io.fz_ldo_faststart 
      ringpll.io.fz_ldo_bypass     := pllctrl.module.io.fz_ldo_bypass 
      ringpll.io.fz_ldo_vinvoltsel := pllctrl.module.io.fz_ldo_vinvoltsel 
      ringpll.io.fz_ldo_fbtrim     := pllctrl.module.io.fz_ldo_fbtrim 
      ringpll.io.fz_ldo_reftrim    := pllctrl.module.io.fz_ldo_reftrim 
      ringpll.io.powergood_vnn     := pllctrl.module.io.powergood_vnn    
      ringpll.io.pllen             := pllctrl.module.io.pllen 
      ringpll.io.bypass            := pllctrl.module.io.bypass  
      ringpll.io.ldo_enable        := pllctrl.module.io.ldo_enable  
      ringpll.io.fz_ldo_extrefsel  := pllctrl.module.io.fz_ldo_extrefsel  

      ringpll.io.ratio             := pllctrl.module.io.ratio 
      ringpll.io.fraction          := pllctrl.module.io.fraction
      ringpll.io.mdiv_ratio        := pllctrl.module.io.mdiv_ratio 
      ringpll.io.vcodiv_ratio      := pllctrl.module.io.vcodiv_ratio 
      ringpll.io.zdiv0_ratio       := pllctrl.module.io.zdiv0_ratio   
      ringpll.io.zdiv0_ratio_p5    := pllctrl.module.io.zdiv0_ratio_p5 
      ringpll.io.zdiv1_ratio       := pllctrl.module.io.zdiv1_ratio 
      ringpll.io.zdiv1_ratio_p5    := pllctrl.module.io.zdiv1_ratio_p5

      ringpll.io.ssc_frac_step       := pllctrl.module.io.ssc_frac_step
      ringpll.io.ssc_cyc_to_peak_m1  := pllctrl.module.io.ssc_cyc_to_peak_m1
      ringpll.io.ssc_en              := pllctrl.module.io.ssc_en
      ringpll.io.mash_order_plus_one := pllctrl.module.io.mash_order_plus_one

      ringpll.io.fz_lockstickyb       := pllctrl.module.io.fz_lockstickyb
      ringpll.io.fz_lpfclksel         := pllctrl.module.io.fz_lpfclksel
      ringpll.io.idvdisable_bi        := pllctrl.module.io.idvdisable_bi 
      ringpll.io.idvfreqai            := pllctrl.module.io.idvfreqai
      ringpll.io.idvfreqbi            := pllctrl.module.io.idvfreqbi
      ringpll.io.idvpulsei            := pllctrl.module.io.idvpulsei
      ringpll.io.idvtclki             := pllctrl.module.io.idvtclki
      ringpll.io.idvtctrli            := pllctrl.module.io.idvtctrli
      ringpll.io.idvtdi               := pllctrl.module.io.idvtdi
      ringpll.io.idvtresi             := pllctrl.module.io.idvtresi
      ringpll.io.idfx_fscan_sdi       := pllctrl.module.io.idfx_fscan_sdi
      ringpll.io.idfx_fscan_mode      := pllctrl.module.io.idfx_fscan_mode
      ringpll.io.idfx_fscan_shiften   := pllctrl.module.io.idfx_fscan_shiften
      ringpll.io.idfx_fscan_rstbypen  := pllctrl.module.io.idfx_fscan_rstbypen
      ringpll.io.idfx_fscan_byprstb   := pllctrl.module.io.idfx_fscan_byprstb
      ringpll.io.idfx_fscan_clkungate := pllctrl.module.io.idfx_fscan_clkungate
      ringpll.io.ldo_vref             := pllctrl.module.io.ldo_vref
      ringpll.io.tck                  := pllctrl.module.io.tck
      ringpll.io.tcapturedr 		      := pllctrl.module.io.tcapturedr
      ringpll.io.tdi                  := pllctrl.module.io.tdi
      ringpll.io.treg_en 		          := pllctrl.module.io.treg_en
      ringpll.io.trst_n 		          := pllctrl.module.io.trst_n
      ringpll.io.tshiftdr             := pllctrl.module.io.tshiftdr
      ringpll.io.tupdatedr            := pllctrl.module.io.tupdatedr
      ringpll.io.pllfwen_b            := pllctrl.module.io.pllfwen_b
      
      pllClockSource.out.unzip._1.map { o =>
        o.clock := ringpll.io.clkpll
        o.reset := reset_wire
      }

      pllClockSource_div0.out.unzip._1.map { o =>
        o.clock := ringpll.io.clkpll0
        o.reset := reset_wire
      }

      pllClockSource_div1.out.unzip._1.map { o =>
        o.clock := ringpll.io.clkpll1
        o.reset := reset_wire
      }

      referenceClockSource.out.unzip._1.map { o =>
        o.clock := clock_wire
        o.reset := reset_wire
      }

      pllctrl.module.clock       := pllctrlClockSink.in.head._1.clock
      pllctrl.module.reset       := pllctrlClockSink.in.head._1.reset
      clockSelector.module.clock := pllctrlClockSink.in.head._1.clock
      clockSelector.module.reset := pllctrlClockSink.in.head._1.reset
      clockDivider.module.clock  := pllctrlClockSink.in.head._1.clock
      clockDivider.module.reset  := pllctrlClockSink.in.head._1.reset

      clock_debug_wire := clockSelector.module.io.clk_debug
      lock_wire := ringpll.io.lock

      (Seq(clock_io, pllclkref_io, reset_io, clock_debug_io, lock_io), clockIOCell ++ pllIOCell ++ resetIOCell ++ clockDebugIOCell ++ lockIOCell)
    }
  }
})

