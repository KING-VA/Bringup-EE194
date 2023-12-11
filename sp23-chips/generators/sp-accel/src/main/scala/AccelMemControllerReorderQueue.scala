package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class AccelMemControllerReorderQueue()(implicit p: Parameters) extends Module {
  
  val io = IO(new Bundle { 
    val req = Decoupled(UInt(2.W))
    val resp = Flipped(Valid(new MemControllerInFlightQueueBundle()))
    val deq = Decoupled(new MemControllerInFlightQueueBundle())
    val empty = Output(Bool())
  })

  val entries = RegInit(0.U.asTypeOf(Vec(4, Valid(new MemControllerInFlightQueueBundle()))))
  val req_ptr = RegInit(0.U(3.W))
  val deq_ptr = RegInit(0.U(3.W))

  val full = Wire(Bool())
  full := (req_ptr(1, 0) === deq_ptr(1, 0)) && (req_ptr(2) =/= deq_ptr(2))
  io.req.valid := !full
  io.req.bits := req_ptr(1, 0)
  when (io.req.fire()) {
    req_ptr := req_ptr + 1.U
  }

  io.deq.valid := entries(deq_ptr(1, 0)).valid
  io.deq.bits := entries(deq_ptr(1, 0)).bits
  when (io.deq.fire()) {
    entries(deq_ptr(1, 0)).valid := false.B
    deq_ptr := deq_ptr + 1.U
  }
  io.empty := req_ptr === deq_ptr

  when (io.resp.valid) {
    entries(io.resp.bits.entry_id).valid := true.B
    entries(io.resp.bits.entry_id).bits := io.resp.bits
  }
}