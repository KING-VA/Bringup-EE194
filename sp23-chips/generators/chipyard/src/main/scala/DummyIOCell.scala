
package chipyard

import chisel3._
import chisel3.util._
import chisel3.experimental.{Analog, IO}
import freechips.rocketchip.config.{Config, Field}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem._
import sifive.blocks.devices.gpio._
import sifive.blocks.devices.pwm._
import sifive.blocks.devices.pinctrl._
//import constellation.{UserVirtualChannelParams}
import barstools.iocell.chisel._
import chipyard.iobinders._
import sifive.blocks.devices.spi._
import testchipip._

import chipyard.harness._
import chipyard.config.{I2CChipIO}
import sifive.blocks.devices.i2c._
// In IO Bundle for Dummy Cell
class DummyInIOCellBundle extends DigitalInIOCellBundle {
  // Bypass ports
  val pad_cell  = Analog(1.W)// Pad/bump signal (off-chip)
  val i_cell    = Input(Bool()) //Input(Bool())
  val ie_cell   = Output(Bool())
}

// Out IO Bundle for Dummy Cell
class DummyOutIOCellBundle extends DigitalOutIOCellBundle {
  // Bypass ports
  val pad_cell  = Analog(1.W) // Input(Bool()) // Pad/bump signal (off-chip)
  val o_cell    = Output(Bool())
  val oe_cell   = Output(Bool())
}

// GPIO Bundle for Dummy Cell
class DummyGPIOCellBundle extends DigitalGPIOCellBundle {
  // Bypass ports
  val pad_cell  = Analog(1.W) // Pad/bump signal (off-chip)
  val i_cell    = Input(Bool())
  val o_cell    = Output(Bool())
  val oe_cell   = Output(Bool())
  val ie_cell   = Output(Bool())
}

// Can only extend a single class (need to extende BlackBox and DigitalGPIOCell)
abstract class DummyGPIOCellBlackBox extends BlackBox with HasBlackBoxResource {
  addResource("vsrc/DummyGPIO.v")
}

// Define GPIOCell
class DummyInIOCell extends DummyGPIOCellBlackBox with DigitalInIOCell {
  val io = IO(new DummyInIOCellBundle)
}
// Define GPIOCell
class DummyOutIOCell extends DummyGPIOCellBlackBox with DigitalOutIOCell {
  val io = IO(new DummyOutIOCellBundle)
}
// Define GPIOCell
class DummyGPIOCell extends DummyGPIOCellBlackBox with DigitalGPIOCell {
  val io = IO(new DummyGPIOCellBundle)
}

case class DummyIOCellParams() extends IOCellTypeParams {
  def analog() = Module(new GenericAnalogIOCell)
  def gpio()   = Module(new DummyGPIOCell)
  def input()  = Module(new DummyInIOCell)
  def output() = Module(new DummyOutIOCell)
}

// Add to top level
class CanHaveDummyIOCells extends Config((site, here, up) => {
  case IOCellKey => DummyIOCellParams()
})


// Index to config dictionary to access parameters and instances
case object DummyIOCellKey extends Field[IOCellTypeParams]

// IO Binders
class WithDummyGPIOCells extends OverrideIOBinder({
  (system: HasPeripheryGPIOModuleImp) => {
    val (ports2d, cells2d) = system.gpio.zipWithIndex.map({ case (gpio, i) =>
      gpio.pins.zipWithIndex.map({ case (pin, j) =>
        val g = IO(Analog(1.W)).suggestName(s"gpio_${i}_${j}")
        val iocell = system.p(IOCellKey).gpio().suggestName(s"iocell_gpio_${i}_${j}")

        iocell.io.o := pin.o.oval
        iocell.io.oe := pin.o.oe
        iocell.io.ie := pin.o.ie
        pin.i.ival := iocell.io.i
        iocell.io.pad <> g

        GPIOPins.gpioPins += (s"iocell_gpio_${i}_${j}" -> pin)

        (g, iocell)
        }).unzip
      }).unzip
    val ports: Seq[Analog] = ports2d.flatten
    (ports, cells2d.flatten)
  }
})


class BareSPIChipIO(val csWidth: Int = 1) extends Bundle {
  val sck = Output(Bool())
  val cs = Vec(csWidth, Output(Bool()))
  val mosi = Output(Bool())
  val miso = Input(Bool())
}

// Regular SPI IOBinder
class WithDummyBareSPIIOCells extends OverrideIOBinder({
  (system: HasPeripherySPIModuleImp) => {
  val (ports: Seq[BareSPIChipIO], cells2d) = system.spi.zipWithIndex.map({ case (s, i) =>
    val name = s"spi_${i + 1}" // note this might cause collisions if we add more SPI flash
    val port = IO(new BareSPIChipIO(s.c.csWidth)).suggestName(name)
    val iocellBase = s"iocell_${name}"

    // SCK and CS are unidirectional outputs
    val sckIOs = IOCell.generateFromSignal(s.sck, port.sck, Some(s"${iocellBase}_sck"), system.p(IOCellKey), IOCell.toAsyncReset)
    val csIOs = IOCell.generateFromSignal(s.cs, port.cs, Some(s"${iocellBase}_cs"), system.p(IOCellKey), IOCell.toAsyncReset)

    // Limit to 2 pins
    val dqIOs = s.dq.take(2).zip(Seq(port.mosi, port.miso)).zipWithIndex.map { case ((pin, ana), j) =>
      GPIOPins.spiPorts += (s"${iocellBase}_dq_${j}" -> pin)

      // Create cells but do not connect them
      if (j == 0) {
        val mosiIOCell = system.p(IOCellKey).output().suggestName(s"${iocellBase}_mosi")
        // Make connection to top level port
        mosiIOCell.io.o := pin.o
        mosiIOCell.io.oe := true.B
        ana := mosiIOCell.io.pad.asBool
        mosiIOCell
      } else {
        val misoIOCell = system.p(IOCellKey).input().suggestName(s"${iocellBase}_miso")

        // Make connection to top level port
        pin.i := misoIOCell.io.i
        misoIOCell.io.ie := true.B
        misoIOCell.io.pad := ana.asBool
        misoIOCell
      }
    }

    (port, dqIOs ++ csIOs ++ sckIOs)

    }).unzip
    (ports, cells2d.flatten)
  }
})

// Quad SPI IOBinder
class WithDummySPIIOCells extends OverrideIOBinder({
  (system: HasPeripherySPIFlashModuleImp) => {
    val (ports: Seq[SPIChipIO], cells2d) = system.qspi.zipWithIndex.map({ case (s, i) =>
      val name = s"qspi_${i}"
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
        // iocell.io.ie := true.B
        iocell.io.ie := pin.ie
        pin.i := iocell.io.i
        iocell.io.pad <> ana


        GPIOPins.spiPorts += (s"${iocellBase}_dq_${j}" -> pin)
        iocell
      }

      (port, dqIOs ++ csIOs ++ sckIOs)
    }).unzip
    (ports, cells2d.flatten)
  }
})

// Harness Binders to Dont Touch SPI
class WithDontTouchSPI extends OverrideHarnessBinder({
	  (system: HasPeripherySPIModuleImp, th: HasHarnessSignalReferences, ports: Seq[BareSPIChipIO]) => {
			ports.foreach({ p => {
	 			p.miso := 1.B
				dontTouch(p.sck)
	 			dontTouch(p.cs)
	 			dontTouch(p.mosi)
	 			dontTouch(p.miso)
	 			dontTouch(p)
			}})
		}
})


class WithDummyI2CIOCells extends OverrideIOBinder({
  (system: HasPeripheryI2CModuleImp) => {
    val (ports: Seq[I2CChipIO], cells2d) = system.i2c.zipWithIndex.map({ case (s, i) =>
      val name = s"i2c_${i}"
      val port = IO(new I2CChipIO()).suggestName(name)
      val iocellBase = s"iocell_${name}"

			// SDA and SCL are both
      val i2cIOs = Seq(s.sda, s.scl).zip(Seq(port.sda, port.scl)).zip(Seq("sda", "scl")).map { case ((pin, ana), pinName) =>
        val iocell = system.p(IOCellKey).gpio().suggestName(s"${iocellBase}_${pinName}")
        iocell.io.o := pin.out
        iocell.io.oe := pin.oe  // Intech22 GPIO should be configure ass open drain pull up
        iocell.io.ie := true.B
        pin.in := iocell.io.i
        iocell.io.pad <> ana


        GPIOPins.i2cPorts += (s"${iocellBase}_${pinName}" -> pin)

        iocell
      }
      (port, i2cIOs)
    }).unzip
    (ports, cells2d.flatten)
	}
})


// Harness Binders to Dont Touch SPI
class WithDontTouchI2C extends OverrideHarnessBinder({
	  (system: HasPeripheryI2CModuleImp, th: HasHarnessSignalReferences, ports: Seq[I2CChipIO]) => {
			ports.foreach({ p => {
				dontTouch(p.scl)
	 			dontTouch(p.sda)
				}})
		}
})



class WithDummyPWMIOCells extends OverrideIOBinder({
  (system: HasPeripheryPWMModuleImp) => {
    val (ports: Seq[PWMPortIO], cells2d) = system.pwm.zipWithIndex.map({ case (s, i) =>
      val name = s"pwm_${i}"
      val port = IO(new PWMPortIO(s.c)).suggestName(name)
      val iocellBase = s"iocell_${name}"

			// SDA and SCL are both
      val pwmIOs = s.gpio.zip(port.gpio).zipWithIndex.map { case ((pin, ana), j) =>
        val iocell = system.p(IOCellKey).output().suggestName(s"${iocellBase}_pwm_${j}")

        // Make connection to top level port
        iocell.io.o := pin
        iocell.io.oe := true.B
        ana := iocell.io.pad.asBool

        GPIOPins.pwmPorts += (s"${iocellBase}_pwm_${j}" -> pin)
        iocell
      }
      (port, pwmIOs)
    }).unzip
    (ports, cells2d.flatten)
	}
})
