/*
This module takes in a row with sparse matrix entries as follows:
15   8 7    0
[ idx |  w  ]

Currently, the module assumes chunks of 64b, comprising 4 entries of 16b each. 
It only works for full chunks, i.e., expects the sparse row to have num entries that's a multiple of 4.

It reads one chunk at a time, parses the sparse row, and 
    1. independently sends a weight, start, and last to the accumulator queue.
    2. independently sends an index to the dense load control queue.

It moves to the next chunk when both indices and weights for the current chunk have been written.
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

class SpDinputBundle extends Bundle {
    val spRow = UInt(64.W)
    val startRowChunk = Bool()
    val endRowChunk = Bool()
}

class SpDoutputBundleAcc extends Bundle {
    val weight = UInt(8.W)
    val startRowWeight = Bool()
    val endRowWeight = Bool()
}

class SpDoutputBundleDenseLoadCtrl extends Bundle {
    val idx = UInt(8.W)
}

class AccelSparseDecoder()(implicit p: Parameters) extends Module {

  //FSM


  val io = IO(new Bundle { 
    val inputBundle = Flipped(DecoupledIO(new SpDinputBundle()))
    val outputBundleAcc = DecoupledIO(new SpDoutputBundleAcc())
    val outputBundleDenseLoadCtrl = DecoupledIO(new SpDoutputBundleDenseLoadCtrl())
    val busy = Output(Bool())
    // TODO: 
   
  })
io.outputBundleAcc.bits.endRowWeight := false.B
io.outputBundleDenseLoadCtrl.bits.idx := 0.U
io.outputBundleAcc.bits.startRowWeight := false.B
io.outputBundleAcc.bits.weight := 0.U
  // TODO: LOGIC

   // val idle :: read :: red :: Nil = Enum (3)
	
	// val ctr = Reg(UInt(64.W), 0.U)
  val wCtr = RegInit(0.U(8.W))
  val idxCtr = RegInit(0.U(8.W))

  // val savedIdx = Reg(UInt(8.W), 0.U)

  val numElems = WireInit(4.U(8.W))
  val lineWidth = WireInit(64.U(8.W))

  val lineVec = RegInit(VecInit(Seq.fill(8) {0.U(8.W)}))
  val line = RegInit(0.U(64.W))
  val startRowChunk = RegInit(false.B)
  val endRowChunk = RegInit(false.B)

  io.busy := wCtr =/= 0.U || idxCtr =/= 0.U

  io.inputBundle.ready := wCtr === 0.U && idxCtr === 0.U  

  io.outputBundleAcc.valid := wCtr =/= 0.U 

  io.outputBundleDenseLoadCtrl.valid := idxCtr =/= 0.U

  when ((wCtr === 0.U) && (idxCtr === 0.U)) {
          when(io.inputBundle.fire()) {
          wCtr := wCtr + 1.U
          idxCtr := idxCtr + 1.U

          lineVec := (io.inputBundle.bits.spRow).asTypeOf(lineVec)
          startRowChunk := io.inputBundle.bits.startRowChunk
          endRowChunk := io.inputBundle.bits.endRowChunk
      }   
  }.otherwise {

      when (wCtr === 1.U) {
          io.outputBundleAcc.bits.startRowWeight := startRowChunk
      }.otherwise {
          io.outputBundleAcc.bits.startRowWeight := false.B
      }

      when (wCtr === numElems) {
          io.outputBundleAcc.bits.endRowWeight := endRowChunk
      }.otherwise {
          io.outputBundleAcc.bits.endRowWeight := false.B
      }

      
      
      when (idxCtr =/= 0.U) {
          io.outputBundleDenseLoadCtrl.bits.idx := lineVec(idxCtr*2.U - 1.U)
      }
      when (wCtr =/= 0.U) {
          io.outputBundleAcc.bits.weight := lineVec((wCtr-1.U)*2.U)
      }

      when (io.outputBundleAcc.fire()) {
          when (wCtr === numElems) {
              wCtr := 0.U
          }.otherwise {
              wCtr := wCtr + 1.U
          }
      }

      when (io.outputBundleDenseLoadCtrl.fire()) {
          when (idxCtr === numElems) {
              idxCtr := 0.U
          }.otherwise {
              idxCtr := idxCtr + 1.U
          } 
      }

  }
}