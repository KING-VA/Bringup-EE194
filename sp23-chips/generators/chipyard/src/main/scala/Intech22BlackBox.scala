package chipyard

import chisel3._
import chisel3.util._
import chisel3.experimental.{IntParam, BaseModule}
import freechips.rocketchip.amba.axi4._
import freechips.rocketchip.subsystem.BaseSubsystem
import freechips.rocketchip.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper.{HasRegMap, RegField}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.UIntIsOneOf
import chisel3.experimental.{Analog, IO}

// Generic bundle for Intech22 slices
class SliceIO(width : Int) extends Bundle {
  val dq              = Input(Vec(width, Bool()))
  val drv0            = Input(Vec(width, Bool()))
  val drv1            = Input(Vec(width, Bool()))
  val drv2            = Input(Vec(width, Bool()))
  val enabq           = Input(Vec(width, Bool()))
  val enq             = Input(Vec(width, Bool()))
  val pd              = Input(Vec(width, Bool()))
  val ppen            = Input(Vec(width, Bool()))
  val prg_slew        = Input(Vec(width, Bool()))
  val puq             = Input(Vec(width, Bool()))
  val pwrup_pull_en   = Input(Vec(width, Bool()))
  val pwrupzhl        = Input(Vec(width, Bool()))
  val outi            = Output(Vec(width, Bool()))
  val pad             = Vec(width, Analog(1.W))
}

// All slices inherit; used to add slice to single list
trait Intech22Slice {
  val io : SliceIO
}

// Used to indicated removed slice in cases where sequence represents row of slices
class slice_placeholder extends Module with Intech22Slice {
  val io = IO(new SliceIO(1))
  io.outi := DontCare
}

// Wrapper for west slices
class hl_west_io_wrapper extends BlackBox with HasBlackBoxResource with Intech22Slice {
  val io = IO(new SliceIO(4))
  addResource("/vsrc/hl_west_io_wrapper.v")
}

// Wrapper for south slices
class hl_south_io_wrapper extends BlackBox with HasBlackBoxResource with Intech22Slice {
  val io = IO(new SliceIO(8))
  addResource("/vsrc/hl_south_io_wrapper.v")
}

// Wrapper for corner slices
class hl_corner_io_wrapper extends BlackBox with HasBlackBoxResource with Intech22Slice {
  val io = IO(new SliceIO(10))
  addResource("/vsrc/hl_corner_io_wrapper.v")
}
