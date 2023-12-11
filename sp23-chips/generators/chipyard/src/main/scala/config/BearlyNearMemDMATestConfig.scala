package chipyard

import bearlynearmem.config.DMABearlyConfigFragment
import chipsalliance.rocketchip.config.{Config, Parameters}
import chipyard.config.AbstractConfig

class BearlyNearMemDMATestConfig extends Config(Parameters.empty ++
  new DMABearlyConfigFragment() ++

  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new AbstractConfig()
)
