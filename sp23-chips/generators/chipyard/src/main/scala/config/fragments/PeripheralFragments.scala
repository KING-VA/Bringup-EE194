package chipyard.config

import scala.util.matching.Regex
import chisel3._
import chisel3.util.{log2Up}
import chisel3.experimental.{Analog, IO}

import freechips.rocketchip.config.{Config}
import freechips.rocketchip.devices.tilelink.{BootROMLocated}
import freechips.rocketchip.devices.debug.{Debug, ExportDebug, DebugModuleKey, DMI, JtagDTMKey, JtagDTMConfig}
import freechips.rocketchip.diplomacy.{AsynchronousCrossing}
import freechips.rocketchip.stage.phases.TargetDirKey
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.tile.{XLen}

import sifive.blocks.devices.gpio._
import sifive.blocks.devices.uart._
import sifive.blocks.devices.spi._
import sifive.blocks.devices.i2c._
import sifive.blocks.devices.pwm._

import testchipip._

import chipyard.{ExtTLMem}
import chipyard.iobinders.{OverrideIOBinder, IOCellKey}

import barstools.iocell.chisel._


// Set the bootrom to the Chipyard bootrom
class WithBootROM extends Config((site, here, up) => {
  case BootROMLocated(x) => up(BootROMLocated(x), site).map( p => p.copy(
    hang = 0x10000,
    contentFileName = s"${site(TargetDirKey)}/bootrom.rv${site(XLen)}.img"
    ))
})

// DOC include start: gpio config fragment
class WithGPIO(address: BigInt = 0x10010000, width: Int = 4) extends Config ((site, here, up) => {
  case PeripheryGPIOKey => up(PeripheryGPIOKey) ++ Seq(
    GPIOParams(address = address, width = width, includeIOF = false))
})
// DOC include end: gpio config fragment

class WithUARTOverride(address: BigInt = 0x10020000, baudrate: BigInt = 115200) extends Config ((site, here, up) => {
  case PeripheryUARTKey => Seq(
    UARTParams(address = address, nTxEntries = 256, nRxEntries = 256, initBaudRate = baudrate))
})

class WithUART(address: BigInt = 0x10020000, baudrate: BigInt = 115200) extends Config ((site, here, up) => {
  case PeripheryUARTKey => up(PeripheryUARTKey) ++ Seq(
    UARTParams(address = address, nTxEntries = 256, nRxEntries = 256, initBaudRate = baudrate))
})

class WithNoUART extends Config((site, here, up) => {
  case PeripheryUARTKey => Nil
})

class WithUARTFIFOEntries(txEntries: Int, rxEntries: Int) extends Config((site, here, up) => {
  case PeripheryUARTKey => up(PeripheryUARTKey).map(_.copy(nTxEntries = txEntries, nRxEntries = rxEntries))
})

class WithSPIFlash(address: BigInt = 0x10030000, fAddress: BigInt = 0x20000000, size: BigInt = 0x10000000) extends Config((site, here, up) => {
  // Note: the default size matches freedom with the addresses below
  case PeripherySPIFlashKey => up(PeripherySPIFlashKey) ++ Seq(
    SPIFlashParams(rAddress = address, fAddress = fAddress, fSize = size))
})

class WithSPI(address: BigInt = 0x10031000) extends Config((site, here, up) => {
  case PeripherySPIKey => up(PeripherySPIKey) ++ Seq(
    SPIParams(rAddress = address))
})

class WithI2C(address: BigInt = 0x10040000) extends Config((site, here, up) => {
  case PeripheryI2CKey => up(PeripheryI2CKey) ++ Seq(
    I2CParams(address = address, controlXType = AsynchronousCrossing(), intXType = AsynchronousCrossing())
  )
})

class WithPWM(address: BigInt = 0x10060000, channels: Int = 4, cmpWidth: Int = 16) extends Config((site, here, up) => {
  case PeripheryPWMKey => up(PeripheryPWMKey) ++ Seq(
    PWMParams(address = address, size = 0x1000, regBytes = 4, ncmp = channels, cmpWidth = cmpWidth))
})

class WithDMIDTM extends Config((site, here, up) => {
  case ExportDebug => up(ExportDebug, site).copy(protocols = Set(DMI))
})

class WithJTAGDTMKey(partNum: Int = 0x000, manufId: Int = 0x489) extends Config((site, here, up) => {
  case JtagDTMKey => new JtagDTMConfig (
    idcodeVersion = 2,
    idcodePartNum = partNum,
    idcodeManufId = manufId,
    debugIdleCycles = 5)
})

class WithNoDebug extends Config((site, here, up) => {
  case DebugModuleKey => None
})

class WithTLSerialLocation(masterWhere: TLBusWrapperLocation, slaveWhere: TLBusWrapperLocation) extends Config((site, here, up) => {
  case SerialTLAttachKey => up(SerialTLAttachKey, site).copy(masterWhere = masterWhere, slaveWhere = slaveWhere)
})

class WithTLBackingMemory extends Config((site, here, up) => {
  case ExtMem => None // disable AXI backing memory
  case ExtTLMem => up(ExtMem, site) // enable TL backing memory
})

class WithSerialTLBackingMemory extends Config((site, here, up) => {
  case ExtMem => None
  case SerialTLKey => up(SerialTLKey, site).map { k => k.copy(
    memParams = {
      val memPortParams = up(ExtMem, site).get
      require(memPortParams.nMemoryChannels == 1)
      memPortParams.master
    },
    isMemoryDevice = true
  )}
})

class WithNoSerialTL extends Config((site, here, up) => {
  case SerialTLKey => None // remove serialized tl port
})

class WithExtMemIdBits(n: Int) extends Config((site, here, up) => {
    case ExtMem => up(ExtMem, site).map(x => x.copy(master = x.master.copy(idBits = n)))
})

//TODO: Implement the Intel SPI Cells in Intech22Fragments and use those instead
class BareSPIChipIO(val csWidth: Int = 1) extends Bundle {
  val sck = Output(Bool())
  val cs = Vec(csWidth, Output(Bool()))
  val mosi = Output(Bool())
  val miso = Input(Bool())
}

class WithBareSPIIOCells extends OverrideIOBinder({
  (system: HasPeripherySPIModuleImp) => {
    val (ports: Seq[BareSPIChipIO], cells2d) = system.spi.zipWithIndex.map({ case (s, i) =>
      val name = s"spi_${i + 1}" // note this might cause collisions if we add more SPI flash
      val port = IO(new BareSPIChipIO(s.c.csWidth)).suggestName(name)
      val iocellBase = s"iocell_${name}"

      // SCK and CS are unidirectional outputs
      val sckIOs = IOCell.generateFromSignal(s.sck, port.sck, Some(s"${iocellBase}_sck"), system.p(IOCellKey), IOCell.toAsyncReset)
      val csIOs = IOCell.generateFromSignal(s.cs, port.cs, Some(s"${iocellBase}_cs"), system.p(IOCellKey), IOCell.toAsyncReset)

/*
      val mosiIOs = IOCell.generateFromSignal(s.dq[0], port.mosi, Some(s"${iocellBase}_mosi"), system.p(IOCellKey), IOCell.toAsyncReset)
      val misoIOs = IOCell.generateFromSignal(s.dq[1], port.mosi, Some(s"${iocellBase}_mosi"), system.p(IOCellKey), IOCell.toAsyncReset)
*/

			println("ORANGE")
      // Limit to 2 pins
      val dqIOs = s.dq.take(2).zip(Seq(port.mosi, port.miso)).zipWithIndex.map { case ((pin, ana), j) =>
        if (j == 0) {
          val mosiIOCell = system.p(IOCellKey).output().suggestName(s"${iocellBase}_mosi")
          mosiIOCell.io.o := pin.o
          mosiIOCell.io.oe := true.B
          ana := mosiIOCell.io.pad.asBool

          mosiIOCell
        } else {
          val misoIOCell = system.p(IOCellKey).input().suggestName(s"${iocellBase}_miso")
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

class I2CChipIO extends Bundle {
  val sda = Analog(1.W)
  val scl = Analog(1.W)
}

//TODO: Implement the Intel I2C Cells in Intech22Fragments and use those instead
class WithI2CIOCells extends OverrideIOBinder({
  (system: HasPeripheryI2CModuleImp) => {
    val (ports: Seq[I2CChipIO], cells2d) = system.i2c.zipWithIndex.map({ case (s, i) =>
      val name = s"i2c_${i}"
      val port = IO(new I2CChipIO()).suggestName(name)
      val iocellBase = s"iocell_${name}"

      // SDA and SCL are both bidirectional
      val i2cIOs = Seq(s.sda, s.scl).zip(Seq(port.sda, port.scl)).zip(Seq("sda", "scl")).map { case ((pin, ana), pinName) =>
        val iocell = system.p(IOCellKey).gpio().suggestName(s"${iocellBase}_${pinName}")
        iocell.io.o := pin.out
        iocell.io.oe := pin.oe
        iocell.io.ie := true.B
        pin.in := iocell.io.i
        iocell.io.pad <> ana
        iocell
      }
      (port, i2cIOs)
    }).unzip
    (ports, cells2d.flatten)
  }
})



