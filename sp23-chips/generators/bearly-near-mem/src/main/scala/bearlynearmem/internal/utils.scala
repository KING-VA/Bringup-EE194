package bearlynearmem.internal

import chisel3._

private[internal] object utils {
  /**
    * Saturate a SInt to the target bit width
    * @param v input value
    * @param targetWidth width to saturate to
    * @return
    */
  def saturate(v: SInt, targetWidth: Int): SInt = {
    require(v.getWidth > targetWidth)
    val max = ((BigInt(1) << (targetWidth - 1)) - 1).S(v.getWidth.W)
    val min = (~((BigInt(1) << (targetWidth - 1)) - 1)).S(v.getWidth.W)
    val out = Wire(SInt(targetWidth.W))
    when(v > max) {
      out := max
    }.elsewhen(v < min) {
      out := min
    }.otherwise {
      out := v(targetWidth - 1, 0).asSInt
    }
    out
  }

  /**
    * Chop a value up into a vector of equally-sized chunks
    *
    * @param v input value
    * @param width width of each element of the output
    * @return
    */
  def chop(v: UInt, width: Int): Vec[UInt] = {
    require(v.getWidth % width == 0, "vector does not divide evenly")
    VecInit.tabulate(v.getWidth / width) { i =>
      val offset = i * width
      v(offset + width - 1, offset)
    }
  }
}
