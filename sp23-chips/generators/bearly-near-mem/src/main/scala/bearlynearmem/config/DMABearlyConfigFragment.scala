package bearlynearmem.config

import chipsalliance.rocketchip.config.{Config, Parameters}

class DMABearlyConfigFragment extends Config(Parameters.empty ++
  new bearlynearmem.WithNearMemDMA(0x8803000) ++
  new bearlynearmem.WithNearMemDMA(0x8802000) ++
  new bearlynearmem.WithNearMemDMA(0x8801000) ++
  new bearlynearmem.WithNearMemDMA(0x8800000) ++
  Parameters.empty
)
