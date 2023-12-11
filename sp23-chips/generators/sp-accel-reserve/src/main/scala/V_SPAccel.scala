package spaccel_reserve

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._

class SparseAccel()(implicit p: Parameters) extends LazyRoCC(OpcodeSet.custom0) {
	
	println(s"Added Sparse Accelerator Reserve")

	override val tlNode = TLIdentityNode()

	val dense_accum_top = LazyModule(new DenseAccum(RV_DEPTH=32))
	val writer_top      = LazyModule(new Writer)


	// Connect top with dense_accum in diplomatic interface
	tlNode := dense_accum_top.node
	tlNode := writer_top.node

	override lazy val module = new LazyRoCCModuleImp(this) {



		val cmd_collector = Module(new CMDCollector()).io
		val sp_loader     = Module(new SpLoader()).io
		val dense_accum   = dense_accum_top.module.io
		val writer        = writer_top.module.io

		//Connecting Top -> cmd_collector
		cmd_collector.rocc <> io.cmd
		io.resp <> cmd_collector.resp

		//Connecting cmd_collector to sp_loader
		cmd_collector.cmd_to_spload_bundle <> sp_loader.cmd_to_spload_bundle
		sp_loader.mem <> io.mem

		//Connect sp_loader with denseAccum
		sp_loader.spload_to_denseAccum_bundle <> dense_accum.spload_to_denseAccum_bundle

		//Connect desenAccum to writer
		dense_accum.denseAccum_to_writer_bundle <> writer.denseAccum_to_writer_bundle

		//Setting the correct busy signal
		val accelerator_busy = RegInit(false.B)
		io.busy := accelerator_busy
		io.cmd.ready := !accelerator_busy

		when(cmd_collector.accel_in_progress){
			accelerator_busy := true.B        // busy after cmd dispatch
		}
		when(writer.write_fully_issued){
			accelerator_busy := false.B       // not busy after write issued
		}
	}








}

