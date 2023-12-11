package kalman.mem

import chisel3._

class L1Request extends Bundle {
  val addr = UInt(64.W)
  val data = UInt(64.W)
  // TODO: propagate coreDataBytes here...
  val mask = UInt(8.W)
  val write = Bool()
}
