package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

abstract class AccelPTWModule()(implicit val p: Parameters) extends Module with HasCoreParameters

class AccelPTW(implicit p: Parameters) extends AccelPTWModule()(p) {
        val io = IO(new Bundle {
            val ptw = new TLBPTWIO
            val req = Flipped(Decoupled(new MemControllerPTWVirtualInterface))
            val resp = Decoupled(new MemControllerPTWPhysicalInterface)
            val busy = Output(Bool())
            val interrupt = Output(Bool())
        })

        val req_addr = Reg(UInt(64.W))
        val req_offset = req_addr(pgIdxBits - 1, 0)
        val req_vpn = req_addr(64 - 1, pgIdxBits)
        val pte = Reg(new PTE)

        val prev_virtual_addr = Reg(UInt(64.W))
        val prev_physical_addr = Reg(UInt(64.W))
        val physical_addr = Reg(UInt(64.W))

        val s_idle :: s_ptw_req :: s_ptw_resp :: s_resp :: Nil = Enum(4)
        val state = RegInit(s_idle)

        io.req.ready := (state === s_idle)

        when (io.req.fire) {
            req_addr := io.req.bits.virtual_addr
            when (req_addr === prev_virtual_addr) {
                state := s_resp
            } .otherwise {
                state := s_ptw_req
            }
        }

        private val ptw = io.ptw

        // when requesting ptw, enter ptw response state
        when (ptw.req.fire) {
            state := s_ptw_resp
        }

        when (state === s_ptw_resp && ptw.resp.valid) {
            pte := ptw.resp.bits.pte
            state := s_resp
        }

        when (io.resp.fire) {
            prev_virtual_addr := req_addr
            prev_physical_addr := physical_addr
            state := s_idle
        }

        physical_addr := Mux(req_addr === prev_virtual_addr, prev_physical_addr, Cat(pte.ppn, req_offset))

        ptw.req.valid := (state === s_ptw_req)
        ptw.req.bits.valid := true.B
        ptw.req.bits.bits.addr := req_vpn
        // double check these three initializing signals
        ptw.req.bits.bits.need_gpa := false.B
        ptw.req.bits.bits.vstage1 := false.B
        ptw.req.bits.bits.stage2 := false.B

        io.resp.valid := (state === s_resp)
        io.resp.bits.physical_addr := physical_addr

        io.busy := (state =/= s_idle)
        io.interrupt := false.B       // interrupt when ptw failed?
    }