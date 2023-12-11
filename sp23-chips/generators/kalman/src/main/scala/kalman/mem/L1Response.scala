package kalman.mem

import chisel3._

class L1Response extends Bundle {
  val addr = UInt(64.W)
  val data = UInt(64.W)
}