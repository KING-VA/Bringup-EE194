/*
This module takes a RoCC command to fetch a SINGLE Sparse Row that could be spread over multiple 64b chunks.
It translates this into multiple memory requests for fetching 64b chunks.
It also marks start row chunks and end row chunks so the decoder can figure out whether a weight is the first or the last in the row.

spSize denotes the number of entries for the row => this could be an estimate of sparsity.

We assume 
    1. each chunk is 64b
*/

package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class SpLCinputBundle extends Bundle {
    val spPtr = UInt(64.W)
    val spSize = UInt(8.W)
    val is_virtual_addr = Bool()
}

class SpLCoutputBundle extends Bundle {
    val memPtr = UInt(64.W)
    val startRowChunk = Bool()
    val endRowChunk = Bool()
    val is_virtual_addr = Bool()
}

// Todo: implement the LUTSwitch that controls "val valuesPerLine = WireInit(8.U(64.W))"."

// class LUTControllerCmd extends Bundle {
//     val useLUT = Bool()
// }

class AccelSparseLoadController()(implicit p: Parameters) extends Module {

  //FSM


  val io = IO(new Bundle { 
    val inputBundle = Flipped(DecoupledIO(new SparseLoadControllerCmd()))
    val outputBundle = DecoupledIO(new SparseLoadControllerMemControllerInterface())
    val LUTSwitch = Flipped(DecoupledIO(new LUTControllerCmd))
    val busy = Output(Bool())
    // TODO: 
   
  })

io.outputBundle.bits.startRowChunk := false.B
io.outputBundle.bits.memPtr := 0.U
io.outputBundle.bits.endRowChunk  := false.B
io.outputBundle.bits.is_virtual_addr := false.B

io.LUTSwitch.ready := true.B

  // TODO: LOGIC
	
val ctr = RegInit(0.U(64.W))


val valuesPerLine = RegInit(8.U(64.W)) // was val valuesPerLine = RegInit(8.U(64.W))

    when(io.LUTSwitch.fire) {
        when(io.LUTSwitch.bits.switch === 1.U){valuesPerLine := 16.U}.
        elsewhen(io.LUTSwitch.bits.switch === 0.U) {valuesPerLine := 8.U}
    }

  val spPtr = RegInit(0.U(64.W))
  val spSize = RegInit(0.U(8.W))

  val use_virtual = RegInit(false.B)

  io.busy := ctr =/= 0.U

  io.inputBundle.ready := ctr === 0.U   

  io.outputBundle.valid := ctr =/= 0.U

  when(io.LUTSwitch.fire){
    when(io.LUTSwitch.bits.switch === 1.U){valuesPerLine := 16.U}.
    elsewhen(io.LUTSwitch.bits.switch === 0.U) {valuesPerLine := 8.U}
  }.otherwise {



  when (ctr === 0.U) {
      when(io.inputBundle.fire) {
          ctr := ctr + 1.U
          spPtr := io.inputBundle.bits.spPtr
          spSize := io.inputBundle.bits.spSize
          use_virtual := io.inputBundle.bits.is_virtual_addr
      }
  }.otherwise {

      when (ctr === 1.U) {
          io.outputBundle.bits.startRowChunk := true.B
      }.otherwise{
          io.outputBundle.bits.startRowChunk := false.B
      }
      
      when (ctr * valuesPerLine >= 2.U * spSize) {
          io.outputBundle.bits.endRowChunk := true.B
      }.otherwise{
          io.outputBundle.bits.endRowChunk := false.B
      }

      io.outputBundle.bits.memPtr := spPtr + (ctr - 1.U) * 8.U
      io.outputBundle.bits.is_virtual_addr := use_virtual

      when(io.outputBundle.fire) {
          when (ctr * valuesPerLine >= 2.U * spSize) {
              ctr := 0.U
          }.otherwise {
              ctr := ctr + 1.U
          }
      }
  }
}

}




/** comment here:

/*
This module takes a RoCC command to fetch a SINGLE Sparse Row that could be spread over multiple 64b chunks.
It translates this into multiple memory requests for fetching 64b chunks.
It also marks start row chunks and end row chunks so the decoder can figure out whether a weight is the first or the last in the row.

spSize denotes the number of entries for the row => this could be an estimate of sparsity.

We assume 
    1. each chunk is 64b
*/

package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class SpLCinputBundle extends Bundle {
    val spPtr = UInt(64.W)
    val spSize = UInt(8.W)
}

class SpLCoutputBundle extends Bundle {
    val memPtr = UInt(64.W)
    val startRowChunk = Bool()
    val endRowChunk = Bool()
}

// Todo: implement the LUTSwitch that controls "val valuesPerLine = WireInit(8.U(64.W))"."

// class LUTControllerCmd extends Bundle {
//     val useLUT = Bool()
// }

class AccelSparseLoadController()(implicit p: Parameters) extends Module {

  //FSM


  val io = IO(new Bundle { 
    val inputBundle = Flipped(DecoupledIO(new SpLCinputBundle))
    val outputBundle = DecoupledIO(new SpLCoutputBundle)
    val LUTSwitch = Flipped(DecoupledIO(new LUTControllerCmd))
    val busy = Output(Bool())
    // TODO: 
   
  })

io.outputBundle.bits.startRowChunk := false.B
io.outputBundle.bits.memPtr := 0.U
io.outputBundle.bits.endRowChunk  := false.B

io.LUTSwitch.ready := true.B

  // TODO: LOGIC
	
val ctr = RegInit(0.U(64.W))

  // val valuesPerLine = WireInit(16.U(64.W)) // val valuesPerLine = WireInit(8.U(64.W))
val valuesPerLine = RegInit(16.U(64.W)) // was val valuesPerLine = RegInit(8.U(64.W))

    when(io.LUTSwitch.fire) {
        when(io.LUTSwitch.bits.switch === 1.U){valuesPerLine := 16.U}.
        elsewhen(io.LUTSwitch.bits.switch === 0.U) {valuesPerLine := 8.U}
    }

  val spPtr = RegInit(0.U(64.W))
  val spSize = RegInit(0.U(8.W))

  io.busy := ctr =/= 0.U

  io.inputBundle.ready := ctr === 0.U   

  io.outputBundle.valid := ctr =/= 0.U

  when (ctr === 0.U) {
      when(io.inputBundle.fire) {
          ctr := ctr + 1.U
          spPtr := io.inputBundle.bits.spPtr
          spSize := io.inputBundle.bits.spSize
      }
  }.otherwise {

      when (ctr === 1.U) {
          io.outputBundle.bits.startRowChunk := true.B
      }.otherwise{
          io.outputBundle.bits.startRowChunk := false.B
      }
      
      when (ctr * valuesPerLine >= 2.U * spSize) {
          io.outputBundle.bits.endRowChunk := true.B
      }.otherwise{
          io.outputBundle.bits.endRowChunk := false.B
      }

      io.outputBundle.bits.memPtr := spPtr + (ctr - 1.U) * 8.U

      when(io.outputBundle.fire) {
          when (ctr * valuesPerLine >= 2.U * spSize) {
              ctr := 0.U
          }.otherwise {
              ctr := ctr + 1.U
          }
      }
  }

}

**/
