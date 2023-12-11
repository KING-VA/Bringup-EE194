package kalman.vec

import chisel3._
import hardfloat.MulRecFN

class VectorMultiplier(implicit c: VectorConfig) extends Module {
  val io = IO(new Bundle {
    val in = Input(Vec(2, Vec(c.numItems, UInt(c.encodedItemSize.W))))
    val out = Output(Vec(c.numItems, UInt(c.encodedItemSize.W)))
  })

  def multiply(v1: Vec[UInt], v2: Vec[UInt])  = {
    require(v1.size == c.numItems)
    require(v2.size == c.numItems)
    require(v1(0).getWidth == c.encodedItemSize)
    require(v2(0).getWidth == c.encodedItemSize)
    io.in(0) := v1
    io.in(1) := v2
    io.out
  }

  (io.in(0) lazyZip io.in(1) lazyZip io.out).foreach((a, b, o) => {
    val multiplier = Module(new MulRecFN(c.expWidth, c.sigWidth))
    multiplier.io.a := a
    multiplier.io.b := b
    multiplier.io.roundingMode := hardfloat.consts.round_max
    multiplier.io.detectTininess := false.B
    o := multiplier.io.out
  })
}
