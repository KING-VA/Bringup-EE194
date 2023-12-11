package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

// Todo: currently only work if 2 LUTInputs are read and use to compute at the same time. 
// 2. change the datacount to increase 1 at a time. 
// 3. should implement io.LUTSwitch.ready := false.B, afterwards; 
// 4. seems that LUTOption/option is not used. 

class AccelVirtualWeightControl()(implicit p: Parameters) extends Module {
    val io = IO(new Bundle {  
        val MemInput = Flipped(DecoupledIO(new LUTVirtualWeightControllerInterface))
        val LUTInput1 = Flipped(DecoupledIO(new LUTVirtualWeightControllerInterface))
        val LUTInput2 = Flipped(DecoupledIO(new LUTVirtualWeightControllerInterface))
        // val LUTOption = Flipped(DecoupledIO(new LUTControllerCmd))
        val outputBundle = DecoupledIO(new VirtualWeightControllerSparseDecoderInterface)
    })
    // val useLUT = RegInit(false.B) // added useLUT and LUTSwitch
    // io.LUTSwitch.ready := true.B 

    // when (io.LUTSwitch.fire) {
    //     when (io.LUTSwitch.bits.switch) {
    //         useLUT := true.B
    //     }.elsewhen(!io.LUTSwitch.bits.switch) {
    //         useLUT := false.B
    //     }
    // }

    val dataStore1 = RegInit(0.U(64.W))
    val dataStore2 = RegInit(0.U(64.W))
    val dataCount = RegInit(0.U(2.W))
    val data1Start = RegInit(false.B)
    val data1End = RegInit(false.B)
    val data2Start = RegInit(false.B)
    val data2End = RegInit(false.B)
    val option = RegInit(0.U(1.W))

    //change 2 write the above logic explicitly
    // when (dataCount === 0.U) {
    //     io.LUTInput1.ready := true.B
    //     io.LUTInput2.ready := true.B
    // }.elsewhen(dataCount =/= 0.U) {
    //     io.LUTInput1.ready := false.B
    //     io.LUTInput2.ready := false.B
    // }
    
    io.outputBundle.valid := false.B
    io.outputBundle.bits := DontCare

    // io.LUTOption.ready := true.B

    // should reduce this later
    // when (io.LUTInput1.fire && io.LUTInput2.fire) {
    io.LUTInput1.ready := dataCount === 0.U
    io.LUTInput2.ready := dataCount === 0.U
    io.MemInput.ready := dataCount === 0.U
        // io.outputBundle.valid := true.B
    // }

    when(io.LUTInput1.fire && io.LUTInput2.fire){          // This is the useLUT case
        dataStore1 := io.LUTInput2.bits.centroids
        dataStore2 := io.LUTInput1.bits.centroids
        data1Start := io.LUTInput2.bits.startRowWeight
        data1End := io.LUTInput2.bits.endRowWeight
        data2Start := io.LUTInput1.bits.startRowWeight
        data2End := io.LUTInput1.bits.endRowWeight
        dataCount := 2.U
        // io.LUTOption.ready := true.B

    }.elsewhen(io.MemInput.fire) {                        // This is the not-use-LUT case
        dataStore1 := io.MemInput.bits.centroids
        data1Start := io.MemInput.bits.startRowWeight
        data1End := io.MemInput.bits.endRowWeight
        dataCount := 1.U
        // io.LUTOption.ready := true.B
    }.otherwise {
        // io.LUTOption.ready := false.B
    }

    // when(io.LUTOption.fire) {
    //         option := io.LUTOption.bits.switch
    //     }

    when (io.outputBundle.fire) {
        dataCount := dataCount - 1.U
    }
    // }.elsewhen (io.LUTInput1.fire && io.LUTInput2.fire){
    //     dataCount := 2.U
    // }


     when(dataCount === 2.U){  //&& io.LUTInput2.valid 
        // io.LUTSwitch.ready := false.B
        io.outputBundle.bits.spRow := dataStore2
        io.outputBundle.bits.startRowChunk := data2Start
        io.outputBundle.bits.endRowChunk := data2End
        io.outputBundle.valid := true.B
        // dontTouch(LUTInput1.ready)
        // dontTouch(LUTInput2.ready) // change, try to see if it will work. 
    }.elsewhen(dataCount === 1.U) { // && io.LUTInput1.fire      && io.LUTInput1.valid
        // io.LUTSwitch.ready := false.B
        io.outputBundle.bits.spRow := dataStore1
        io.outputBundle.bits.startRowChunk := data1Start
        io.outputBundle.bits.endRowChunk := data1End
        io.outputBundle.valid := true.B
    }.otherwise {
        io.outputBundle.valid := false.B
        // io.LUTInput1.ready := .B
        // io.LUTInput2.ready := true.B
        // io.LUTSwitch.ready := true.B
    }

}