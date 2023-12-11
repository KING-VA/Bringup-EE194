package bearlynearmem.internal

import chisel3._
import chisel3.util._
import freechips.rocketchip.regmapper.{RegField, RegFieldDesc, RegReadFn, RegWriteFn}

private[internal] class RegisterRWIO[T <: Data](gen: T) extends Bundle {
  val write = Flipped(Decoupled(gen))
  val read = Output(gen)

  def regWrite: RegWriteFn = RegWriteFn((valid, data) => {
    write.valid := valid
    write.bits := data.asTypeOf(gen)
    write.ready
  })

  def regRead: RegReadFn = RegReadFn(read.asUInt)

  def getDataWidth = gen.getWidth

  def regField(desc: RegFieldDesc): RegField = {
    RegField(gen.getWidth, regRead, regWrite, desc)
  }
}

private[internal] class RegisterRW[T <: Data](val init: T, name: String) {
  val reg: T = RegInit(init).suggestName(name)

  def io = new RegisterRWIO(chiselTypeOf(init))

  def connect(io: RegisterRWIO[T]): Unit = {
    io.write.deq()
    when(io.write.fire) {
      reg := io.write.bits
    }

    io.read := reg
  }
}
