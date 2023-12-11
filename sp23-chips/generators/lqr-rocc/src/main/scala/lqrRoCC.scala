package lqrRoCC

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._

import freechips.rocketchip.util._



class lqrAccelerator(opcodes: OpcodeSet)
    (implicit p: Parameters) extends LazyRoCC(opcodes) {
  override lazy val module = new lqrAcceleratorModule(this)
}

class lqrAcceleratorModule(outer: lqrAccelerator, data_w: Int = 32, n: Int = 12) (implicit p: Parameters) extends LazyRoCCModuleImp(outer) with HasCoreParameters {

      // TODO: Take another look at "hascoreparameters" and 
      // if (implicit p: Parameters) needed

  println(s"LQR Accelerator of width ${data_w}, n=${n}\n")

  val controllerUnit = Module(new controller(data_w, n))

  // declare ports facing RoCC Core
  controllerUnit.io.core_rs1_data <> io.cmd.bits.rs1
  controllerUnit.io.core_rs2_data <> io.cmd.bits.rs2
  controllerUnit.io.core_funct <> io.cmd.bits.inst.funct
  controllerUnit.io.core_inst_rd <> io.cmd.bits.inst.rd
  controllerUnit.io.core_req_val <> io.cmd.valid
  when (io.cmd.fire){
    controllerUnit.io.core_req_fire := true.B
  }.otherwise{
    controllerUnit.io.core_req_fire := false.B
  }
  controllerUnit.io.core_resp_ready <> io.resp.ready

  io.cmd.ready := controllerUnit.io.core_req_rdy
  io.resp.bits.rd := controllerUnit.io.core_resp_rd
  io.resp.bits.data := controllerUnit.io.core_resp_data
  io.resp.valid := controllerUnit.io.core_resp_valid

  // declare ports facing RoCC Mem
  // 1. request content + ready/valid 
  controllerUnit.io.mem_req_rdy := io.mem.req.ready
  controllerUnit.io.mem_resp_val <> io.mem.resp.valid
  controllerUnit.io.mem_resp_tag <> io.mem.resp.bits.tag
  controllerUnit.io.mem_resp_data <> io.mem.resp.bits.data

  io.mem.req.valid := controllerUnit.io.mem_req_val
  io.mem.req.bits.tag := controllerUnit.io.mem_req_tag
  io.mem.req.bits.cmd := controllerUnit.io.mem_req_cmd
  io.mem.req.bits.size := controllerUnit.io.mem_req_size
  io.mem.req.bits.addr := controllerUnit.io.mem_req_addr

  // 2. Other Configurations
  io.mem.req.bits.data := 0.U(32.W)
  io.mem.req.bits.signed := false.B
  io.mem.req.bits.no_alloc := false.B
  io.mem.req.bits.mask := ~(0.U((32 / 8).W))
  io.mem.req.bits.phys := false.B
  io.mem.req.bits.dprv := PRV.M.U
  io.mem.req.bits.dv := false.B
  io.mem.req.bits.no_xcpt := true.B
  
  io.mem.s1_data.data := RegNext(io.mem.req.bits.data)
  io.mem.s1_data.mask := RegNext(io.mem.req.bits.mask)
  io.mem.s1_kill := false.B
  io.mem.s2_kill := false.B
  


  io.busy := controllerUnit.io.isHandling




  val datapathUnit = Module(new datapath(data_w, n))
  controllerUnit.io.comp_valid := datapathUnit.io.valid
  controllerUnit.io.comp_result := datapathUnit.io.out

  datapathUnit.io.enable := controllerUnit.io.comp_enable
  for (i <- 0 until n){
    datapathUnit.io.vec1(i) <> controllerUnit.io.vec1(i)
    datapathUnit.io.vec2(i) <> controllerUnit.io.vec2(i)
  }


  // TODO: interrupt?
  io.interrupt := false.B


}
