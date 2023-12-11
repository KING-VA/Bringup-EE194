package bearlynearmem

import bearlynearmem.internal.DMATile
import chipsalliance.rocketchip.config.Parameters
import chisel3._
import chisel3.experimental.ChiselEnum
import freechips.rocketchip.diplomacy.{HasClockDomainCrossing, LazyModule, LazyModuleImp, SimpleDevice}
import freechips.rocketchip.regmapper.{RegField, RegFieldDesc}
import freechips.rocketchip.subsystem.{CacheBlockBytes, PeripheryBusKey}
import freechips.rocketchip.tile.XLen
import freechips.rocketchip.tilelink.{TLClockDomainCrossing, TLInwardClockCrossingHelper, TLNameNode, TLOutwardNode, TLRegisterNode}

object NearMemDMA {
  private[bearlynearmem] case class Config(
                                            /** beatBytes of the control node */
                                            ctrlBeatBytes: Int,

                                            /** The operation size in bytes */
                                            opSize: Int,

                                            /** The size (in bits) of an address */
                                            addressSize: Int,
                                          )
}

class NearMemDMA(val k: NearMemDMAConfig)(implicit p: Parameters)
  extends LazyModule
  with HasClockDomainCrossing
  {
  // This module contains all of the logic that is different for each instance.
  // Everything that is shared (i.e. everything except the RegisterRouter) goes
  // in the DMATile module. This makes it so the DMATile module is identical
  // per instance, so it can be hierarchically PAR'd and reused.

  val device = new SimpleDevice("dma_device", Seq("sp23_bearly_tapeout,dma_device"))

  val config = NearMemDMA.Config(
    ctrlBeatBytes = p(PeripheryBusKey).beatBytes,
    opSize = p(CacheBlockBytes),
    addressSize = p(XLen),
  )

  private[bearlynearmem] val controlNode = TLRegisterNode(
    address = List(k.addr),
    device = device,
    beatBytes = config.ctrlBeatBytes)

  val controlXing: TLInwardClockCrossingHelper = this.crossIn(controlNode)

  private[bearlynearmem] val tile = LazyModule(new DMATile(config))

  val masterNode: TLOutwardNode = TLNameNode("master") :=* tile.masterNode

  override lazy val module = new NearMemDMAImp(this)
}

object Mode extends ChiselEnum {
  val copy = Value(0.U(4.W))
  val mac = Value(2.U(4.W))
}

class NearMemDMAImp(self: NearMemDMA) extends LazyModuleImp(self) {
  private val tile = self.tile

  // Leading Seq.empty placed to get IntelliJ's formatter to align things properly.
  // Trailing Seq.empty placed to ensure each "element" ends in ++ (to reduce merge conflicts)
  // The `: _*` applies to the whole expression.
  self.controlNode.regmap(Seq.empty ++
    Seq(
      0x00 -> Seq(
        RegField.r(1, tile.regIO.status.error, RegFieldDesc("error", "error?")),
        RegField.r(1, tile.regIO.status.completed, RegFieldDesc("completed", "completed?")),
        RegField.r(1, tile.regIO.status.inProgress, RegFieldDesc("inProgress", "inProgress?")),
        RegField.r(1, tile.regIO.status.errors.badMode, RegFieldDesc("errorBadMode", "is mode invalid?")),
        RegField.r(1, tile.regIO.status.errors.srcMisaligned, RegFieldDesc("errorSrcMisaligned", "is srcaddr misaligned?")),
        RegField.r(1, tile.regIO.status.errors.dstMisaligned, RegFieldDesc("errorDstMisaligned", "is destaddr misaligned?")),
        RegField.r(1, tile.regIO.status.errors.strideMisaligned, RegFieldDesc("errorStrideMisaligned", "is srcstride misaligned?")),
        RegField.r(1, tile.regIO.status.errors.countTooLarge, RegFieldDesc("errorCountTooLarge", "was count too large?")),
        RegField.r(1, tile.regIO.status.errors.readDenied, RegFieldDesc("errorReadDenied", "was a memory read denied?")),
        RegField.r(1, tile.regIO.status.errors.readCorrupt, RegFieldDesc("errorReadCorrupt", "was a memory read corrupt?")),
        RegField.r(1, tile.regIO.status.errors.writeDenied, RegFieldDesc("errorWriteDenied", "was a memory write denied?")),
      ),
      0x08 -> Seq(tile.regIO.modeRaw.regField(RegFieldDesc("mode", "operation mode"))),
      0x10 -> Seq(tile.regIO.srcAddr.regField(RegFieldDesc("srcaddr", "source address of operation"))),
      0x18 -> Seq(tile.regIO.destAddr.regField(RegFieldDesc("destaddr", "destination address of operation"))),
      0x20 -> Seq(tile.regIO.srcStride.regField(RegFieldDesc("srcstride", "stride of accesses"))),
      0x28 -> Seq(tile.regIO.count.regField(RegFieldDesc("count", "number of strides to copy"))),
    ) ++
    tile.regIO.operandRegister.zipWithIndex.map { case (reg, i) =>
      (0x40 + i * reg.getDataWidth / 8) -> Seq(reg.regField(RegFieldDesc(s"operand$i", s"operand register part $i")))
    } ++
    tile.regIO.destinationRegister.zipWithIndex.map { case (reg, i) =>
      (0x80 + i * reg.getWidth / 8) -> Seq(RegField.r(reg.getWidth, reg, RegFieldDesc(s"destVal$i", s"destination register part $i")))
    } ++
    Seq.empty: _*
  )
}

