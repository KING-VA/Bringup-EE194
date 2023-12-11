/*
This module takes in a row with sparse matrix entries as follows:
7     4 3     0
[  idx |   w   ]

Currently, the module assumes chunks of 64b, comprising 8 entries of 8b each. 
It only works for full chunks, i.e., expects the sparse row to have num entries that's a multiple of 8.

It reads one chunk at a time, parses the sparse row, and sends a centroid, start, and last to the Virtualweight Ctr module.

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


class AccelLUT()(implicit p: Parameters) extends Module {
  val io = IO(new Bundle {      
    val inputBundle = Flipped(DecoupledIO(new MemControllerSparseDecoderInterface))
    val write = Flipped(DecoupledIO(new WriteLUTCmd))
    val readCmd = Flipped(DecoupledIO(new ReadLUTCmd))

    val outputBundleAcc1 = DecoupledIO(new LUTVirtualWeightControllerInterface) 
    val outputBundleAcc2 = DecoupledIO(new LUTVirtualWeightControllerInterface)
    val outputNoLUT = DecoupledIO(new LUTVirtualWeightControllerInterface)
    val readData = DecoupledIO(new ReadLUTData)
    val LUTSwitch = Flipped(DecoupledIO(new LUTControllerCmd))

  })
  
    val LUTEmpty = RegInit(true.B)
    val outputWeightUsed = RegInit(true.B)
    val useLUT = RegInit(0.U(1.W))  // was val useLUT = RegInit(0.U(1.W))

    
    io.outputNoLUT.valid := false.B
    io.outputNoLUT.bits := DontCare
    io.readCmd.ready := !LUTEmpty
    io.readData.bits := DontCare
    io.readData.valid := !LUTEmpty // true.B
    io.write.ready := true.B    // might be a source of error  
    io.outputBundleAcc1.valid := false.B
    io.outputBundleAcc2.valid := false.B
    io.outputBundleAcc1.bits := DontCare
    io.outputBundleAcc2.bits := DontCare

    io.LUTSwitch.ready := true.B 
    io.inputBundle.ready := outputWeightUsed && io.outputBundleAcc1.ready

    when(io.LUTSwitch.valid) {
      when(io.LUTSwitch.bits.switch === 1.U) {
        useLUT := 1.U 
      }.elsewhen(io.LUTSwitch.bits.switch=== 0.U ) {
        useLUT := 0.U 
      }
    }.otherwise {

  
    // LUT write
    val centroids1 = RegInit(VecInit(Seq.fill(8) {0.U(8.W)}))
    val centroids2 = RegInit(VecInit(Seq.fill(8) {0.U(8.W)}))

    when(io.write.valid) {
        for (i <- 0 until 8) {
            centroids1(i) := io.write.bits.data1(i*8+7, i*8) 
            centroids2(i) := io.write.bits.data2(i*8+7, i*8)
        }
        LUTEmpty := false.B
  }

    val dataTemp = WireInit(VecInit(Seq.fill(8) {0.U(8.W)}))
    
    // LUT read
    when (io.readData.fire) {
    for (i <- 0 until 8) {
      when(io.readCmd.bits.wantToRead === 1.U) {  //should put this in the spec
        dataTemp(i) := centroids1(i) 
      }.elsewhen(io.readCmd.bits.wantToRead === 2.U) {
        dataTemp(i) := centroids2(i)
      }
    }
    io.readData.bits.data := dataTemp.asUInt
  }

    when(useLUT === 1.U) {
      io.outputNoLUT.valid := false.B
      io.outputNoLUT.bits := DontCare

      val outputWeight1 = RegInit(VecInit(Seq.fill(8) {0.U(8.W)}))
      val outputWeight2 = RegInit(VecInit(Seq.fill(8) {0.U(8.W)}))
      val outputStart = RegInit(false.B)
      val outputEnd = RegInit(false.B)
      
      
      val weightIndex = WireInit(VecInit(Seq.fill(16) {0.U(4.W)}))
      weightIndex := (io.inputBundle.bits.spRow).asTypeOf(weightIndex)

  // weight is in the index: 0, 2, 4, 6; index is in the position: 1, 3, 5, 7;
      when(io.inputBundle.fire){

      for (i <- 0 until 4) {
          outputWeight1((i << 1) + 1) := Cat(0.U(4.W), weightIndex((i << 1) + 1))
          when(weightIndex(i << 1) < 8.U) {
          outputWeight1(i << 1) := centroids1(weightIndex(i << 1)) // io.LUT.bits.centroids1(i << 1) 
          }.elsewhen(weightIndex(i << 1) < 16.U) {
          outputWeight1(i << 1) := centroids2(weightIndex(i << 1)) // io.LUT.bits.centroids2(i << 1) 
          }.otherwise {
          outputWeight1(i << 1) := 0.U
          }
      }

      for (j <- 4 until 8) {
          outputWeight2(((j-4) << 1) + 1) := Cat(0.U(4.W), weightIndex((j << 1) + 1))
        when(weightIndex(j << 1) < 8.U) { 
          outputWeight2((j-4) << 1) := centroids1(weightIndex(j << 1)) // io.LUT.bits.centroids1(i << 1) 
          }.elsewhen(weightIndex(j << 1) < 16.U) {
          outputWeight2((j-4) << 1) := centroids2(weightIndex(j << 1)) // io.LUT.bits.centroids2(i << 1) 
          }.otherwise {
          outputWeight2((j-4) << 1) := 0.U
          }
      }
        outputWeightUsed := false.B
  }

    // I will have 1 more cycle for this because outputWeightUsed is a register. 
    when(!outputWeightUsed && !LUTEmpty) {  
        io.outputBundleAcc1.valid := true.B
        io.outputBundleAcc2.valid := true.B
    }.otherwise {
        io.outputBundleAcc1.valid := false.B
        io.outputBundleAcc2.valid := false.B
    }

    outputStart := io.inputBundle.bits.startRowChunk
    outputEnd := io.inputBundle.bits.endRowChunk

      when(io.outputBundleAcc1.fire && io.outputBundleAcc2.fire) {

        io.outputBundleAcc1.bits.centroids := Cat(outputWeight1.reverse)
        io.outputBundleAcc2.bits.centroids := Cat(outputWeight2.reverse)

        
        outputWeightUsed := true.B
        when (outputStart && outputEnd) {
          io.outputBundleAcc1.bits.startRowWeight := true.B
          io.outputBundleAcc1.bits.endRowWeight := false.B
          io.outputBundleAcc2.bits.startRowWeight := false.B
          io.outputBundleAcc2.bits.endRowWeight := true.B
        }.elsewhen(outputStart) {  // I assume that InputBundle are all multiples of 128
          io.outputBundleAcc1.bits.startRowWeight := true.B
          io.outputBundleAcc1.bits.endRowWeight := false.B
          io.outputBundleAcc2.bits.startRowWeight := false.B
          io.outputBundleAcc2.bits.endRowWeight := false.B
        }.elsewhen(outputEnd) {
          io.outputBundleAcc1.bits.startRowWeight := false.B
          io.outputBundleAcc1.bits.endRowWeight := false.B
          io.outputBundleAcc2.bits.startRowWeight := false.B
          io.outputBundleAcc2.bits.endRowWeight := true.B
        }.otherwise{
          io.outputBundleAcc1.bits.startRowWeight := false.B
          io.outputBundleAcc1.bits.endRowWeight := false.B
          io.outputBundleAcc2.bits.startRowWeight := false.B
          io.outputBundleAcc2.bits.endRowWeight := false.B
        }
    }
    }.otherwise{

        io.outputNoLUT.valid := io.inputBundle.valid
        
        when (io.outputNoLUT.fire) {
          io.outputNoLUT.bits.centroids := io.inputBundle.bits.spRow
          io.outputNoLUT.bits.endRowWeight := io.inputBundle.bits.endRowChunk
          io.outputNoLUT.bits.startRowWeight := io.inputBundle.bits.startRowChunk
        }

        io.outputBundleAcc1.valid := false.B
        io.outputBundleAcc1.bits := DontCare
        io.outputBundleAcc2.valid := false.B
        io.outputBundleAcc2.bits := DontCare
    }
}

}

