package kalman

import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tile._

/**
  * Config fragment for Chipyard to initialize a Kalman RoCC accelerator.
  */
class WithKalmanFilter
    extends Config((site, here, up) => { case BuildRoCC =>
      up(BuildRoCC) ++ Seq((p: Parameters) => {
        val accel = LazyModule(new KalmanAccelerator(OpcodeSet.custom1)(p))
        accel
      })
    })

