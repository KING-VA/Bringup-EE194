package bearlynearmem

import freechips.rocketchip.config.{Config, Field}
import freechips.rocketchip.diplomacy.{AddressSet, AsynchronousCrossing, LazyModule}
import freechips.rocketchip.subsystem.BaseSubsystem

case class NearMemDMAConfig(addr: AddressSet)

case object NearMemDMAConfigKey extends Field[Seq[NearMemDMAConfig]](Nil)

trait CanHavePeripheryNearMemDMA {
  this: BaseSubsystem =>

  sbus {
    val nearMemDMAs = LazyModule(new NearMemDMAs(
      p(NearMemDMAConfigKey),
      masterBus = sbus,
      ctrlBus = pbus, ctrlCrossing = AsynchronousCrossing(),
    ))
  }
}

class WithNearMemDMA(base: BigInt) extends Config((site, here, up) => {
  case NearMemDMAConfigKey => up(NearMemDMAConfigKey) :+ NearMemDMAConfig(AddressSet(base, 0xfff))
})
