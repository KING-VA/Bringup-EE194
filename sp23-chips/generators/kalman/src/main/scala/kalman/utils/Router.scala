package kalman.utils

import chisel3._
import chisel3.util._

class RouterIO[T <: Data](gen: T, n: Int) extends Bundle {
  val in = Flipped(Decoupled(gen))
  val out = Vec(n, Decoupled(gen))
  val sel = Input(UInt(log2Ceil(n).W))
}

class Router[T <: Data](gen: T, n: Int) extends Module {
  val io = IO(new RouterIO(gen, n))

  for (i <- 0 until n) {
    io.out(i).noenq()
  }

  io.out(io.sel) <> io.in
}

object Router {
  def apply[T <: Data](in: ReadyValidIO[T], n: Int): RouterIO[T] = {
    val router = Module(new Router(chiselTypeOf(in.bits), n))
    router.io.in := in
    router.io
  }
}
