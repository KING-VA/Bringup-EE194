package kalman.vec

import chisel3._
import chisel3.util.Decoupled
import hardfloat.DivSqrtRecFN_small

class VectorDividerPacket(implicit c: VectorConfig) extends Bundle {
  val inputs = Vec(2, Vec(c.numItems, UInt(c.encodedItemSize.W)))
  val sqrt = Bool()
}

class VectorDivider(implicit c: VectorConfig) extends Module {
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(new VectorDividerPacket()))
    val out = Decoupled(Vec(c.numItems, UInt(c.encodedItemSize.W)))
  })

  val out = io.out.bits
  val packet = io.in.bits
  val ready = Wire(Vec(c.numItems, Bool()))
  val valid = Wire(Vec(c.numItems, Bool()))

  (packet.inputs(0) lazyZip packet.inputs(1) lazyZip out lazyZip (valid lazyZip ready)).foreach({ case (a, b, o, (v, r)) =>
    val divider = Module(new DivSqrtRecFN_small(c.expWidth, c.sigWidth, 0))

    divider.io.sqrtOp := packet.sqrt
    divider.io.a := a
    divider.io.b := b
    divider.io.roundingMode := hardfloat.consts.round_max
    divider.io.detectTininess := false.B
    divider.io.inValid := io.in.valid

    o := divider.io.out
    r := divider.io.inReady
    v := Mux(packet.sqrt, divider.io.outValid_sqrt, divider.io.outValid_div)
  })

  io.out.valid := valid.reduceTree { (a, b) => a && b }
  io.in.ready := ready.reduceTree{ (a, b) => a && b }
}
