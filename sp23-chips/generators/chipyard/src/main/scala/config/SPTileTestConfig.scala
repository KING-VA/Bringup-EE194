package chipyard
import freechips.rocketchip.config.{Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem._
//import constellation.{UserVirtualChannelParams}
// The chip config for the all-digital chip
class SPTileTestDigitalChipConfig extends Config(
  // BEGIN: Common adjustments (probably don't need to change these)
  new chipyard.config.WithNPMPs(0) ++                                                   // Remove all PMP features from cores
  new chipyard.config.WithL2TLBs(0) ++
  new chipyard.config.WithMultiRoCC ++
  // END: Common adjustments
  // BEGIN: Rocket SpecializedTile settings
  new freechips.rocketchip.subsystem.WithAsynchronousRocketTiles(depth=8, sync=3) ++
  new chipyard.config.WithMultiRoCCFromBuildRoCC(0, 1, 2, 3) ++
  new spaccel.WithSparseAccel ++
  new freechips.rocketchip.subsystem.WithL1ICacheSets(64) ++
  new freechips.rocketchip.subsystem.WithL1ICacheWays(1) ++
  new freechips.rocketchip.subsystem.WithL1DCacheSets(64) ++
  new freechips.rocketchip.subsystem.WithL1DCacheWays(1) ++
  new freechips.rocketchip.subsystem.WithNBigCores(4) ++                                // 4 Rocket core
  // END: Rocket SpecializedTile settings
  new chipyard.config.AbstractConfig)
