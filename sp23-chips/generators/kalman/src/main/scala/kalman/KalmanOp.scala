package kalman

import chisel3._
import chisel3.experimental.ChiselEnum

/**
 * What operation the Kalman filter accelerator should do, which corresponds
 * to the lower log2(enum size) bits of the `funct7` field in the instruction.
 */
object KalmanOp extends ChiselEnum {
  // Memory <-> Vector Operations
  /** vec[v0] = M[addr] */
  val ld_vector = Value(0x0.U)
  /** M[addr] = vec[v0] */
  val st_vector = Value(0x1.U)

  // Vector -> Register Operations
  /** R[rd] = vec[v0] dot vec[v1] */
  val dot_vector = Value(0x2.U)

  // Vector -> Vector Operations
  /** vec[vout] = vec[v0] + vec[v1] */
  val v_add = Value(0x3.U)
  /** vec[vout] = vec[v0] - vec[v1] */
  val v_sub = Value(0x4.U)
  /** vec[vout] = vec[v0] * vec[v1] (elementwise) */
  val v_mul = Value(0x5.U)

  /** vec[vout] = vec[v0] / vec[v1] (elementwise) */
  val v_div = Value(0x6.U)
  /** vec[vout] = sqrt(vec[v0]) */
  val v_sqrt = Value(0x7.U)

  /** vec[vout] = rs1 (repeated) */
  val v_fill = Value(0x8.U)

  /** vout = v0 */
  val v_set_out = Value(0x9.U)
  /** size = rs1 */
  val v_set_size = Value(0x10.U)
}
