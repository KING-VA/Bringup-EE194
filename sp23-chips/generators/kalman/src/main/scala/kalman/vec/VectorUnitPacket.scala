package kalman.vec

import chisel3._
import chisel3.util._
import kalman.KalmanOp

class VectorUnitPacket()(implicit c: VectorConfig) extends Bundle {
  /** the address to load from or store to */
  val addr = UInt(64.W)

  /** first vector register operand */
  val v0 = UInt((log2Ceil(c.numVectors) + 1).W)

  /** second vector register operand */
  val v1 = UInt((log2Ceil(c.numVectors) + 1).W)

  /** operation to do */
  val op = KalmanOp()
}
