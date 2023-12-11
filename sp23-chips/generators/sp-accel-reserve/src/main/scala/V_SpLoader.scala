package spaccel_reserve

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._


class SpLoader()(implicit p: Parameters) extends Module{

    val io = IO(new Bundle { 
        val cmd_to_spload_bundle        = Flipped(Decoupled(new Cmd_to_Spload_Bundle))
        val spload_to_denseAccum_bundle = Decoupled(new Spload_to_DenseAccum_Bundle)
        val mem                         = new HellaCacheIO
    })


    // taking data from cmd_collector
    val cmd_to_spload_reg       = RegInit(0.U.asTypeOf(new Cmd_to_Spload_Bundle))
    val working                 = RegInit(false.B)
    val cmd_to_spload_reg_valid = RegInit(false.B)
    val size_ctr                = RegInit(0.U(8.W))

    io.cmd_to_spload_bundle.ready := !working
    when(io.cmd_to_spload_bundle.fire){
        cmd_to_spload_reg       := io.cmd_to_spload_bundle.bits
        working                 := true.B
        cmd_to_spload_reg_valid := true.B
    }

    // Setting miscellaneous signals for L1 access
    // No special functional purposes
    io.mem.req.bits.size := 3.U
    io.mem.req.bits.no_alloc := 0.U
    io.mem.s1_data.mask := Cat(Fill(32, 1.U(1.W)))
    io.mem.req.bits.no_xcpt := 0.U
    io.mem.req.bits.mask := Cat(Fill(32, 1.U(1.W)))
    io.mem.s1_kill := 0.U
    io.mem.req.bits.phys := 0.U
    io.mem.req.bits.dprv := 0.U
    io.mem.s1_data.data := 0.U
    io.mem.s2_kill := 0.U
    io.mem.keep_clock_enabled := 1.U
    io.mem.req.bits.signed := 0.U
	io.mem.req.bits.dv := DontCare

    //Begin iteratively reading data from L1
    //Only 1 read-inflight at a time, wouldn't impact performance since denseAccum
    //needs like 20 cycles for each access

    val sp_chunk_regs         = RegInit( VecInit(Seq.fill(4) {0.U(16.W)} ))
    val sp_chunk_regs_busy    = RegInit(false.B)
    val sp_chunk_regs_deq_idx = RegInit(0.U(2.W))
    val l1_inflight           = RegInit(false.B)

    io.mem.req.bits.tag   := DontCare
    io.mem.req.bits.cmd   := 0.U
    io.mem.req.bits.addr  := cmd_to_spload_reg.sp_ptr + (size_ctr << 1.U)  // <<1.U, because pointer already increment by 4
    io.mem.req.bits.data  := DontCare
    
    io.mem.req.valid := false.B     // doesn't seem like need to provide ready signal, CPU should always be ready for L1

    when(!l1_inflight && !sp_chunk_regs_busy 
                      && (size_ctr < cmd_to_spload_reg.sp_size)
                      && cmd_to_spload_reg_valid
        ){
            io.mem.req.valid := true.B
        }
    
    // not sure if io.mem.req has decouple interface, so not using .fire
    when(io.mem.req.valid && io.mem.req.ready){
        l1_inflight := true.B
    }
    
    //taking L1 read data into sp_chunk_regs
    //and indicate busy
    when(io.mem.resp.valid){
        sp_chunk_regs      := io.mem.resp.bits.data.asTypeOf(sp_chunk_regs)
        sp_chunk_regs_busy := true.B
        size_ctr           := size_ctr + 4.U   // each access has 4 sp_chunk 
        l1_inflight        := false.B
    }

    
    // outputing data to next-stage 
    io.spload_to_denseAccum_bundle.valid     := false.B
    io.spload_to_denseAccum_bundle.bits.finished  := false.B

    io.spload_to_denseAccum_bundle.bits.out_ptr   := cmd_to_spload_reg.out_ptr
    io.spload_to_denseAccum_bundle.bits.d_ptr     := cmd_to_spload_reg.d_ptr
    io.spload_to_denseAccum_bundle.bits.sp_idx    := 0.U
    io.spload_to_denseAccum_bundle.bits.sp_data   := 0.U
    // the only time in which we can output data 
    // is when we have things in sp_chunk_regs, whenever it's busy

    when(sp_chunk_regs_busy){

        io.spload_to_denseAccum_bundle.valid   := true.B
        io.spload_to_denseAccum_bundle.bits.sp_idx  := sp_chunk_regs(sp_chunk_regs_deq_idx)(15,8)
        io.spload_to_denseAccum_bundle.bits.sp_data := sp_chunk_regs(sp_chunk_regs_deq_idx)(7 ,0)

    }

    when(io.spload_to_denseAccum_bundle.fire){
            // when it==3, it overflow back to 0
            sp_chunk_regs_deq_idx := sp_chunk_regs_deq_idx + 1.U

            // last chunk of sp_row, need to resrt chunk_regs_busy
            when( sp_chunk_regs_deq_idx === 3.U ){
                sp_chunk_regs_busy := false.B
                
                //but this is also the last block
                //important logic, update all important state register
                when(size_ctr === cmd_to_spload_reg.sp_size){
                    working                  := false.B
                    cmd_to_spload_reg_valid  := false.B
                    size_ctr                 := 0.U
                    io.spload_to_denseAccum_bundle.bits.finished := true.B
                }
            }
    }

}






   
