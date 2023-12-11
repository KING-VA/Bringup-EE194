package spaccel_reserve

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._

class Writer()(implicit p: Parameters) extends LazyModule{

    val write_node = TLClientNode(Seq(TLMasterPortParameters.v1(Seq(TLMasterParameters.v1(name="SPL2WriteNode",  sourceId = IdRange(0, 16))))))
    val node = TLIdentityNode()
    node := write_node

    lazy val module = new DenseAccumImpl
    class DenseAccumImpl extends LazyModuleImp(this) {
        
        val io = IO(new Bundle {
            val denseAccum_to_writer_bundle = Flipped(Decoupled(new DenseAccum_to_Writer_Bundle))
            val write_fully_issued = Output(Bool())
        })

        io.write_fully_issued := false.B

        val BLOCK_COUNT = 16
        val (tl_out_write, edgesOut_write) = write_node.out(0)

       
        val unique_write_source_id = RegInit(0.U(8.W))
        val block_wrote = RegInit(0.U(8.W))
        
        //Creating a queue to use as a pipeline register
        val pipe = Module(new Queue(new DenseAccum_to_Writer_Bundle, 2, true, false)).io
        pipe.enq.bits <> io.denseAccum_to_writer_bundle.bits


        //write_source_id == 16 means all write issue has been finished, can not take in new write req until all write
        io.denseAccum_to_writer_bundle.ready := pipe.enq.ready && !(unique_write_source_id === 16.U)
        pipe.deq.ready := tl_out_write.a.ready
        pipe.enq.valid := io.denseAccum_to_writer_bundle.valid
        tl_out_write.a.valid := pipe.deq.valid

        when (pipe.deq.valid && !(unique_write_source_id === 16.U)) {
            tl_out_write.a.valid := true.B
            tl_out_write.a.bits := edgesOut_write.Put(
                fromSource = unique_write_source_id,
                toAddress = pipe.deq.bits.out_ptr + (pipe.deq.bits.transfer_ctr << 3.U),
                lgSize = 3.U,
                data = pipe.deq.bits.out_data
            )._2
            dontTouch(tl_out_write.a)
        }

        when (tl_out_write.a.fire) {
            unique_write_source_id := unique_write_source_id + 1.U
            when(unique_write_source_id === 15.U){
                io.write_fully_issued := true.B
            }
        }

        tl_out_write.d.ready := true.B  // always ready to receive info for write
        when(tl_out_write.d.fire) {
            when(block_wrote === (BLOCK_COUNT-1).U){
                block_wrote := 0.U
                unique_write_source_id := 0.U
            }.otherwise{
                block_wrote := block_wrote + 1.U
            }
        }

    }


}











