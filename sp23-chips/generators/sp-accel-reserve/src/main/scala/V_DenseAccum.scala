package spaccel_reserve

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._


class Sp_Chunk extends Bundle {
    val sp_idx  = UInt(8.W)
    val sp_data = UInt(8.W)   // will be casted into SInt upon multiplication
}


class DenseAccum(RV_DEPTH : Int = 32)(implicit p: Parameters) extends LazyModule{

    val read_node = TLClientNode(Seq(TLMasterPortParameters.v1(Seq(TLMasterParameters.v1(name="SPL2ReadNode",  sourceId = IdRange(0, RV_DEPTH))))))
    val node = TLIdentityNode()
    node := read_node

    lazy val module = new DenseAccumImpl
    class DenseAccumImpl extends LazyModuleImp(this) {
        
        val io = IO(new Bundle {
            val spload_to_denseAccum_bundle = Flipped(Decoupled(new Spload_to_DenseAccum_Bundle))
            val denseAccum_to_writer_bundle = Decoupled(new DenseAccum_to_Writer_Bundle)
        })



        //Creating Reservation Station, the data structure at the heart of this design
        //each entry corresponds to one SP_chunk
        //val RV_DEPTH   = 32 
        val rv_station = RegInit(VecInit(Seq.fill(RV_DEPTH) (0.U.asTypeOf( new Sp_Chunk ))))
        
        // sEmpty -> sValid -> sInflight -> sEmpty
        val sEmpty :: sValid :: sInflight :: Nil = Enum(3)
        val rv_status = RegInit(VecInit(Seq.fill(RV_DEPTH) (sEmpty) ) )


        // important wire which holds value of the current rv_station
        val idx_first_empty = Wire(UInt(8.W))
        val has_empty_entry = Wire(Bool())
        idx_first_empty := 0.U
        for (i <- (0 until RV_DEPTH).reverse) {
            when(rv_status(i) === sEmpty){
                idx_first_empty := i.U
            }
        }
        has_empty_entry := rv_status.map(_ === sEmpty).reduce(_||_)

        val idx_first_valid = Wire(UInt(8.W))
        val has_valid_entry = Wire(Bool())
        idx_first_valid := 0.U
        for (i <- (0 until RV_DEPTH).reverse){
            when (rv_status(i) === sValid){
                idx_first_valid := i.U
            }
        }
        has_valid_entry := rv_status.map(_ === sValid).reduce(_||_)

        val rv_station_is_empty = Wire(Bool())
        rv_station_is_empty := rv_status.map(_ === sEmpty).reduce(_&&_)    // all entries empty



        //Handling Logic of Enq to the RV station
        val saw_last_sp_chunk = RegInit(false.B)
        val d_ptr_reg         = RegInit(0.U(64.W))
        val out_ptr_reg       = RegInit(0.U(64.W))
        val working           = RegInit(false.B)

        io.spload_to_denseAccum_bundle.ready := has_empty_entry
        val enq_data = Wire(UInt(16.W))
        enq_data := Cat(io.spload_to_denseAccum_bundle.bits.sp_idx, io.spload_to_denseAccum_bundle.bits.sp_data) // idx :: data, 16bits

        // A new data has been Enque
        when(io.spload_to_denseAccum_bundle.fire){

            rv_station(idx_first_empty) := enq_data.asTypeOf(new Sp_Chunk)
            rv_status(idx_first_empty)  := sValid

            when(io.spload_to_denseAccum_bundle.bits.finished){
                saw_last_sp_chunk := true.B
            }
            when(!working){
                d_ptr_reg       := io.spload_to_denseAccum_bundle.bits.d_ptr
                out_ptr_reg     := io.spload_to_denseAccum_bundle.bits.out_ptr
                working         := true.B
            }

        }

        // Issuing request to L2
        val (tl_out_read, edgesOut_read) = read_node.out(0)
        tl_out_read.a.valid := false.B

        when(has_valid_entry){
            tl_out_read.a.valid := true.B
            tl_out_read.a.bits  := edgesOut_read.Get(
                fromSource = idx_first_valid,
                toAddress  = d_ptr_reg + (rv_station(idx_first_valid).sp_idx << 6.U),
                lgSize     = 6.U   // 512 bits == 64 bytes == 2**6
            )._2
        }
        when(tl_out_read.a.fire){
            rv_status(idx_first_valid) := sInflight  //update status
        }
        dontTouch(tl_out_read.a)



        // Creating Accumulator
        // And handling incoming data from L2
        val DENSE_ROW_MAX_WORDS       = 8                  
        val overflow_accumulator_reg  = RegInit(0.U.asTypeOf(Vec(DENSE_ROW_MAX_WORDS, Vec(8, SInt(24.W)))))    // 8 X 8 X 24, 8 word total, each word has 8 elements, each element is 24 bits signed-register
        val word_counter              = RegInit(0.U(3.W))            // 3 bits wide to express 8 words total
        
        //Creating new pipelined regs to decrease the critical path
        val pl_reg_signed_sp_data     = RegInit(0.S(8.W))
        val pl_reg_signed_d_data_vec  = RegInit(0.U.asTypeOf(Vec(8, SInt(8.W))))
        val signed_sp_data            = WireInit(0.S(8.W))                        // one 8 bit signed int
        val signed_d_data_vec         = WireInit(VecInit(Seq.fill(8) {0.S(8.W)}))     // 8 of 8 signed int

        pl_reg_signed_sp_data         := 0.U.asTypeOf(pl_reg_signed_sp_data)
        pl_reg_signed_d_data_vec      := 0.U.asTypeOf(pl_reg_signed_d_data_vec)
        signed_sp_data                := pl_reg_signed_sp_data                                                   
        signed_d_data_vec             := pl_reg_signed_d_data_vec                        

        // below can be re-written with zip syntax
        for (i <- 0 until 8) {
            overflow_accumulator_reg(word_counter)(i) := overflow_accumulator_reg(word_counter)(i) + (signed_sp_data * signed_d_data_vec(i))
        }

        // handling incoming L2 request
        // and waking up the correct entry from the reservation station

        //Directing the correct data to Accumulator
        tl_out_read.d.ready := true.B
        when(tl_out_read.d.fire){
            // unconditionally increment word_counter, the overflow will take-care of itself
            word_counter := word_counter + 1.U
            // index into correct sp_data
            pl_reg_signed_sp_data    := rv_station(tl_out_read.d.bits.source).sp_data.asTypeOf(signed_sp_data)
            // porting the correct d_data
            pl_reg_signed_d_data_vec := tl_out_read.d.bits.data.asTypeOf(signed_d_data_vec)

            when(word_counter === (DENSE_ROW_MAX_WORDS-1).U){
                // reset entry status back to empty, notice we only do this when ctr==7, this means this entry's all 8 blocks will be processed by the end of this cycle
                rv_status(tl_out_read.d.bits.source) := sEmpty
            }

        }

        // outputing data to next stage, Write stage
        val transfer_ctr_reg                                  = RegInit(0.U(4.W))
        io.denseAccum_to_writer_bundle.valid                 := false.B
        io.denseAccum_to_writer_bundle.bits.out_ptr          := out_ptr_reg
        io.denseAccum_to_writer_bundle.bits.transfer_ctr     := transfer_ctr_reg



        //checking making sure datas are in range
        val overflow_data_vec4   = WireInit(VecInit(Seq.fill(4) {0.S(24.W)}))
        val inrange_data_vec4    = WireInit(VecInit(Seq.fill(4) {0.S(16.W)}))
        overflow_data_vec4       := 0.U.asTypeOf(overflow_data_vec4)
        inrange_data_vec4        := 0.U.asTypeOf(inrange_data_vec4)

        //this is a particular tricky part, let me know if the code doesnt make sense
        //we are finding out which 64 bits of the overflow data we should check for overflow, and send out
        val word_idx = Wire(UInt(3.W))
        word_idx := transfer_ctr_reg(3,1)
        for (i <- 0 until 4){
            when(transfer_ctr_reg(0) === 0.U){
                overflow_data_vec4(i)       := overflow_accumulator_reg(word_idx)(i)
            }
            when(transfer_ctr_reg(0) === 1.U){
                overflow_data_vec4(i)       := overflow_accumulator_reg(word_idx)(i+4)
            }
        }
        //Checking overflow
        for (i <- 0 until 4){
            inrange_data_vec4(i) := overflow_data_vec4(i)
            when(overflow_data_vec4(i) < -32768.S){
                inrange_data_vec4(i) := -32768.S
            }
            when(overflow_data_vec4(i) > 32767.S){
                inrange_data_vec4(i):= 32767.S
            }
        }

        io.denseAccum_to_writer_bundle.bits.out_data := inrange_data_vec4.asTypeOf(UInt(64.W))
           
        
        when(rv_station_is_empty && working && saw_last_sp_chunk){
            io.denseAccum_to_writer_bundle.valid := true.B
        }

        // Once output data is transfered, reset all Internal state
        when(io.denseAccum_to_writer_bundle.fire){
            transfer_ctr_reg := transfer_ctr_reg + 1.U  // overflow will take-care of it

            when(transfer_ctr_reg === (DENSE_ROW_MAX_WORDS*2-1).U){
                working                     := false.B
                rv_station                  := 0.U.asTypeOf(rv_station)
                saw_last_sp_chunk           := false.B
                d_ptr_reg                   := 0.U
                out_ptr_reg                 := 0.U
                overflow_accumulator_reg    := 0.U.asTypeOf(overflow_accumulator_reg)
            }

        }
    }


}