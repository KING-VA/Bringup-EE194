package kalman

import chisel3._
import freechips.rocketchip.tile._

/**
 * The RoCC accelerator shim, only gets loaded when Diplomacy is done figuring
 * out memory parameters. It is separate from KalmanTop so that KalmanTop can
 * be initialized without giving it all possible I/O that RoCC can take in (we
 * don't need all of it).
 *
 * @param outer the KalmanAccelerator initializing this
 */
class KalmanAcceleratorImp(outer: KalmanAccelerator)
  extends LazyRoCCModuleImp(outer) {
  // The actual Kalman filter logic.
  val top = Module(new KalmanTop())

  println(s"Added Kalman Accelerator")

  // Connect only the signals we need to the accelerator.
  io.cmd <> top.io.cmd
  io.resp <> top.io.resp
  io.busy <> top.io.busy
  io.mem <> top.io.mem
}
