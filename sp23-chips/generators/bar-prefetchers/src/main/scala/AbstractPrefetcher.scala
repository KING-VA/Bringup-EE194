package prefetchers

import chisel3._
import chisel3.util._
import chisel3.experimental.{IO}
import freechips.rocketchip.config.{Field, Parameters}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.util._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem.{CacheBlockBytes}

trait CanInstantiatePrefetcher {
  def desc: String
  def instantiate()(implicit p: Parameters): AbstractPrefetcher
}

class Snoop(implicit val p: Parameters) extends Bundle {
  val blockBytes = p(CacheBlockBytes)

  val write = Bool()
  val address = UInt()
  def block = address >> log2Up(blockBytes)
  def block_address = block << log2Up(blockBytes)
}

class SnoopPC(implicit val p: Parameters) extends Bundle {
  val pc_0 = UInt(10.W) //10 bits
  val pc_1 = UInt(10.W) //10 bits
  val pc_valid_0 = Bool()
  val pc_valid_1 = Bool()
  val branch_taken_0 = Bool()
  val branch_taken_1 = Bool()
}

class Prefetch(implicit val p: Parameters) extends Bundle {
  val blockBytes = p(CacheBlockBytes)

  val write = Bool()
  val address = UInt()
  def block = address >> log2Up(blockBytes)
  def block_address = block << log2Up(blockBytes)
}

class PrefetcherIO(implicit p: Parameters) extends Bundle {
  val snoop = Input(Valid(new Snoop))
  val pc = Input(new SnoopPC)
  val flush = Input(Bool())
  val request = Decoupled(new Prefetch)
  val hit = Output(Bool())
}

abstract class AbstractPrefetcher(implicit p: Parameters) extends Module {
  val io = IO(new PrefetcherIO)

  io.request.valid := false.B
  io.request.bits := DontCare
  io.request.bits.address := 0.U(1.W)
  io.hit := false.B
}

case class NullPrefetcherParams() extends CanInstantiatePrefetcher {
  def desc() = "Null Prefetcher"
  def instantiate()(implicit p: Parameters) = Module(new NullPrefetcher()(p))
}

class NullPrefetcher(implicit p: Parameters) extends AbstractPrefetcher()(p)

