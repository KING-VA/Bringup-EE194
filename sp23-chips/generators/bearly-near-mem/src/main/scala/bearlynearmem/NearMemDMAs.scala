package bearlynearmem

import chipsalliance.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy.{ClockCrossingType, LazyModule, SimpleLazyModule}
import freechips.rocketchip.tilelink.{TLBusWrapper, TLFragmenter}

class NearMemDMAs(
                   configs: Seq[NearMemDMAConfig],
                   masterBus: TLBusWrapper,
                   ctrlBus: TLBusWrapper,
                   ctrlCrossing: ClockCrossingType,
                 )(implicit p: Parameters) extends SimpleLazyModule {

  // TODO: this module must be placed in the same clock domain as [[masterBus]];
  //  is there a better way to express this?

  configs.zipWithIndex.foreach { case (config, i) =>
    val nearMemDMA = LazyModule(new NearMemDMA(config)(p))
    nearMemDMA.suggestName(s"nearMemDMA_$i")
    masterBus.coupleFrom("near-mem-dma") {
      _ :=* nearMemDMA.masterNode
    }
    ctrlBus.coupleTo("near-mem-dma") {
      // TODO: should the fragmenter be moved out of the coupler (into this module)?
      nearMemDMA.controlXing(ctrlCrossing) := TLFragmenter(ctrlBus) := _
    }
  }
}
