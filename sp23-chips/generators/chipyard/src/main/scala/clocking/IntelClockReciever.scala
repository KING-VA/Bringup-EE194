package chipyard.clocking

import chisel3._
import chisel3.util._
import freechips.rocketchip.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy.{AsynchronousCrossing}
import freechips.rocketchip.system._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.util._
import freechips.rocketchip.prci._
import freechips.rocketchip.util.ElaborationArtefacts

class diffclock_rx_1v2() extends BlackBox with HasBlackBoxResource {
     val io = IO(new Bundle {
        val diffclkrx_out                  = Output(Clock())
        val powergood_vnn                  = Input(UInt(1.W))
        val diffclkrx_fz_ldo_vinvoltsel    = Input(UInt(2.W))
        val diffclkrx_fz_ldo_fbtrim        = Input(UInt(4.W))
        val diffclkrx_fz_ldo_reftrim       = Input(UInt(4.W))
        val diffclkrx_fz_strong_ladder_en  = Input(UInt(1.W))
        val diffclkrx_fz_ldo_faststart     = Input(UInt(1.W))
        val diffclkrx_fz_ldo_bypass        = Input(UInt(1.W))
        val diffclkrx_fz_ldo_extrefsel     = Input(UInt(1.W))
        val diffclkrx_clkref               = Input(Clock())
        val diffclkrx_bias_config          = Input(UInt(2.W))
        val diffclkrx_inn                  = Input(UInt(1.W)) 
        val diffclkrx_inp                  = Input(UInt(1.W)) 
        val diffclkrx_rxen                 = Input(UInt(1.W)) 
        val diffclkrx_odt_en               = Input(UInt(1.W))
    })
    addResource("vsrc/diffclock_rx_1v2.sv")
}

//base address will be 0x10000800
class IntelClockRecieverCtrl(address: BigInt, tlbus: TLBusWrapper)(implicit p: Parameters) extends LazyModule {
    val device = new SimpleDevice("clk_reciever-ctrl", Nil)
    val tlNode = TLRegisterNode(Seq(AddressSet(address, 0x400 - 1)), device, "reg/control", beatBytes=tlbus.beatBytes)
    tlbus.toVariableWidthSlave(Some("clk_reciever-ctrl")) { tlNode := TLBuffer() }

    lazy val module = new Impl 
    class Impl extends LazyModuleImp(this) {
        val io = IO(new Bundle {
            val powergood_vnn                  = Output(UInt(1.W))
            val diffclkrx_fz_ldo_vinvoltsel    = Output(UInt(2.W))
            val diffclkrx_fz_ldo_fbtrim        = Output(UInt(4.W))
            val diffclkrx_fz_ldo_reftrim       = Output(UInt(4.W))
            val diffclkrx_fz_strong_ladder_en  = Output(UInt(1.W))
            val diffclkrx_fz_ldo_faststart     = Output(UInt(1.W))
            val diffclkrx_fz_ldo_bypass        = Output(UInt(1.W))
            val diffclkrx_bias_config          = Output(UInt(2.W))
            val diffclkrx_rxen                 = Output(UInt(1.W)) 
        })

        val powergood_vnn                  = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val diffclkrx_fz_ldo_vinvoltsel    = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val diffclkrx_fz_ldo_fbtrim        = withReset(reset) { Module(new AsyncResetRegVec(w=4, init=15)) }
        val diffclkrx_fz_ldo_reftrim       = withReset(reset) { Module(new AsyncResetRegVec(w=4, init=12)) }
        val diffclkrx_fz_strong_ladder_en  = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val diffclkrx_fz_ldo_faststart     = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val diffclkrx_fz_ldo_bypass        = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val diffclkrx_bias_config          = withReset(reset) { Module(new AsyncResetRegVec(w=2, init=0)) }
        val diffclkrx_rxen                 = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) } 
    
        io.powergood_vnn                  := powergood_vnn.io.q
        io.diffclkrx_fz_ldo_vinvoltsel    := diffclkrx_fz_ldo_vinvoltsel.io.q
        io.diffclkrx_fz_ldo_fbtrim        := diffclkrx_fz_ldo_fbtrim.io.q
        io.diffclkrx_fz_ldo_reftrim       := diffclkrx_fz_ldo_reftrim.io.q
        io.diffclkrx_fz_strong_ladder_en  := diffclkrx_fz_strong_ladder_en.io.q
        io.diffclkrx_fz_ldo_faststart     := diffclkrx_fz_ldo_faststart.io.q
        io.diffclkrx_fz_ldo_bypass        := diffclkrx_fz_ldo_bypass.io.q
        io.diffclkrx_bias_config          := diffclkrx_bias_config.io.q
        io.diffclkrx_rxen                 := diffclkrx_rxen.io.q 

        tlNode.regmap(
            0x00 -> Seq(RegField.rwReg(1, powergood_vnn.io)),
            0x04 -> Seq(RegField.rwReg(1, diffclkrx_fz_ldo_vinvoltsel.io)),
            0x08 -> Seq(RegField.rwReg(4, diffclkrx_fz_ldo_fbtrim.io)),
            0x0C -> Seq(RegField.rwReg(4, diffclkrx_fz_ldo_reftrim.io)),
            0x10 -> Seq(RegField.rwReg(1, diffclkrx_fz_strong_ladder_en.io)),
            0x14 -> Seq(RegField.rwReg(1, diffclkrx_fz_ldo_faststart.io)),
            0x18 -> Seq(RegField.rwReg(1, diffclkrx_fz_ldo_bypass.io)),
            0x1C -> Seq(RegField.rwReg(2, diffclkrx_bias_config.io)),
            0x20 -> Seq(RegField.rwReg(1, diffclkrx_rxen.io)),
        )
    }
}

class IntelClockReciever extends Module {
    val io = IO(new Bundle {
        val diffclkrx_out = Output(Clock())	

        val diffclkrx_inn = Input(UInt(1.W)) 
        val diffclkrx_inp = Input(UInt(1.W))
        val clkref        = Input(Clock()) 

        val powergood_vnn                  = Input(UInt(1.W))
        val diffclkrx_fz_ldo_vinvoltsel    = Input(UInt(2.W))
        val diffclkrx_fz_ldo_fbtrim        = Input(UInt(4.W))
        val diffclkrx_fz_ldo_reftrim       = Input(UInt(4.W))
        val diffclkrx_fz_strong_ladder_en  = Input(UInt(1.W))
        val diffclkrx_fz_ldo_faststart     = Input(UInt(1.W))
        val diffclkrx_fz_ldo_bypass        = Input(UInt(1.W))
        val diffclkrx_bias_config          = Input(UInt(2.W))
        val diffclkrx_rxen                 = Input(UInt(1.W)) 
    })
    val clkr = Module(new diffclock_rx_1v2())

    clkr.io.powergood_vnn                  := io.powergood_vnn
    clkr.io.diffclkrx_fz_ldo_vinvoltsel    := io.diffclkrx_fz_ldo_vinvoltsel 
    clkr.io.diffclkrx_fz_ldo_fbtrim        := io.diffclkrx_fz_ldo_fbtrim
    clkr.io.diffclkrx_fz_ldo_reftrim       := io.diffclkrx_fz_ldo_reftrim
    clkr.io.diffclkrx_fz_strong_ladder_en  := io.diffclkrx_fz_strong_ladder_en
    clkr.io.diffclkrx_fz_ldo_faststart     := io.diffclkrx_fz_ldo_faststart
    clkr.io.diffclkrx_fz_ldo_bypass        := io.diffclkrx_fz_ldo_bypass 
    clkr.io.diffclkrx_fz_ldo_extrefsel     := 0.U
    clkr.io.diffclkrx_clkref               := io.clkref
    clkr.io.diffclkrx_bias_config          := io.diffclkrx_bias_config
    clkr.io.diffclkrx_inn                  := io.diffclkrx_inn
    clkr.io.diffclkrx_inp                  := io.diffclkrx_inp
    clkr.io.diffclkrx_rxen                 := io.diffclkrx_rxen
    clkr.io.diffclkrx_odt_en               := 1.U

    io.diffclkrx_out := clkr.io.diffclkrx_out    	
}