package chipyard
import freechips.rocketchip.config.{Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem._

class KalmanConfig extends Config(
  new kalman.WithKalmanFilter ++
    new freechips.rocketchip.subsystem.WithNBigCores(1) ++
    new freechips.rocketchip.subsystem.WithL1ICacheSets(64) ++
    new freechips.rocketchip.subsystem.WithL1ICacheWays(1) ++
    new freechips.rocketchip.subsystem.WithL1DCacheSets(64) ++
    new freechips.rocketchip.subsystem.WithL1DCacheWays(4) ++

    new freechips.rocketchip.subsystem.WithNBanks(4) ++
    new freechips.rocketchip.subsystem.WithInclusiveCache(nWays=8, capacityKB=512) ++

    new chipyard.config.AbstractConfig
)

