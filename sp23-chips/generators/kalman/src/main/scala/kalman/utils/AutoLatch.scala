package kalman.utils

import chisel3._
import chisel3.util.{Decoupled, DecoupledIO, ReadyValidIO, Valid}

class AutoLatchIO[T <: Data](gen: T) extends Bundle {
  val in = Flipped(Decoupled(gen))
  val out = Decoupled(gen)
}

class AutoLatch[T <: Data](gen: T) extends Module {
  val io = IO(new AutoLatchIO(gen))
  val reg = Reg(gen)

  io.out.valid := io.in.valid
  io.in.ready := io.out.ready
  io.out.bits := reg
  when(io.in.valid) {
    reg := io.in.bits
    io.out.bits := io.in.bits
  }
}

object AutoLatch {
  def apply[T <: Data](in: ReadyValidIO[T]): DecoupledIO[T] = {
    val buffer = Module(new AutoLatch(chiselTypeOf(in.bits)))
    buffer.io.in.bits := in.bits
    buffer.io.in.valid := in.valid
    buffer.io.out
  }
}
