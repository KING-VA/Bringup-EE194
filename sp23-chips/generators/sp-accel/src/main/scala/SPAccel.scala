package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._


class SparseAccel()(implicit p: Parameters) extends LazyRoCC(OpcodeSet.custom0, nPTWPorts = 2) {
        println(s"Added Sparse Accelerator")
	override val tlNode = TLIdentityNode()

	val mem_controller_top = LazyModule(new AccelMemController)

	// Connect Sparse Top and Memory controller with Diplomatic Interface
	tlNode :=* mem_controller_top.node

	override lazy val module = new LazyRoCCModuleImp(this) {

		val cmd_dispatch = Module(new AccelCmdDispatch()).io
		val sparse = Module(new AccelSparseLoadController()).io
		val dense = Module(new AccelDenseLoadController()).io
		val sparse_decode = Module(new AccelSparseDecoder()).io
		val accumulator = Module(new AccelAccumulator()).io
		val mem_controller = mem_controller_top.module.io
		val accel_ptw1 = Module(new AccelPTW()).io // for mem control accum
		val accel_ptw2 = Module(new AccelPTW()).io // for mem control dense
		val lut = Module(new AccelLUT()).io
		val vir_w_ctr = Module(new AccelVirtualWeightControl()).io
		cmd_dispatch.rocc <> io.cmd
		io.resp <> cmd_dispatch.resp
		io.busy := sparse.busy || dense.busy || sparse_decode.busy || accumulator.busy || mem_controller.busy || cmd_dispatch.busy || sparse_decode.inputBundle.valid || accumulator.mem_controller_accumulator.valid
		mem_controller.mem <> io.mem
		mem_controller.sparse_decoder_credit := sparse_decode.inputBundle.fire
		mem_controller.accumulator_credit := accumulator.mem_controller_accumulator.fire

		sparse.inputBundle <> cmd_dispatch.sparse
		sparse.LUTSwitch <> cmd_dispatch.LUTSwitchSpLoad // This is the added instruction. 
		mem_controller.sparse <> sparse.outputBundle
		dense.cmd <> cmd_dispatch.dense
		accumulator.cmd <> cmd_dispatch.accumulator
		mem_controller.cmd <> cmd_dispatch.mem_controller

		mem_controller.dense <> dense.mem_controller
		// sparse_decode.inputBundle <> Queue(mem_controller.sparse_decoder, 8)

		dense.sparse_decoder <> sparse_decode.outputBundleDenseLoadCtrl
		accumulator.sparse_decoder <> sparse_decode.outputBundleAcc

		mem_controller.accumulator_mem_controller <>  accumulator.accumulator_mem_controller
		accumulator.mem_controller_accumulator <> Queue(mem_controller.mem_controller_accumulator, 8)

		io.mem <> mem_controller.mem
		
		io.ptw(0) <> accel_ptw1.ptw
		io.ptw(1) <> accel_ptw2.ptw
		accel_ptw1.req <> mem_controller.ptw_virtual_accum
		accel_ptw1.resp <> mem_controller.ptw_physical_accum
		accel_ptw2.req <> mem_controller.ptw_virtual_dense
		accel_ptw2.resp <> mem_controller.ptw_physical_dense
		lut.write <> cmd_dispatch.writeLUT
		lut.readCmd <> cmd_dispatch.LUTCmd
		lut.readData <> cmd_dispatch.LUTData
		lut.inputBundle <> Queue(mem_controller.sparse_decoder, 8)
		lut.LUTSwitch <> cmd_dispatch.LUTSwitch
		vir_w_ctr.MemInput <> lut.outputNoLUT
		
		vir_w_ctr.LUTInput1 <> lut.outputBundleAcc1
		vir_w_ctr.LUTInput2 <> lut.outputBundleAcc2
		sparse_decode.inputBundle <>  Queue(vir_w_ctr.outputBundle, 8)
	}
}

