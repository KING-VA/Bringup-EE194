package kalman

import freechips.rocketchip.config._
import freechips.rocketchip.tile._

/**
 * The publicly exposed Kalman Accelerator RoCC accelerator fragment. It
 * lazily instantiates a KalmanAcceleratorImp once Diplomacy is done figuring
 * things out.
 *
 * @param opcodes possible opcodes to use
 * @param p
 */
class KalmanAccelerator(opcodes: OpcodeSet)(implicit p: Parameters)
  extends LazyRoCC(opcodes) {
  override lazy val module = new KalmanAcceleratorImp(this)
}
