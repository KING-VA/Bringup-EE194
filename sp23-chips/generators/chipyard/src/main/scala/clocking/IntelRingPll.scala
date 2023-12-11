package chipyard.clocking

import chisel3._
import chisel3.util._

import freechips.rocketchip.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.util._
import freechips.rocketchip.prci._
import freechips.rocketchip.util.ElaborationArtefacts

class ringpll() extends BlackBox with HasBlackBoxResource {
     val io = IO(new Bundle {
        val powergood_vnn       = Input(UInt(1.W))    
        val ldo_enable          = Input(UInt(1.W))    
        val fz_ldo_vinvoltsel   = Input(UInt(2.W))    
        val fz_ldo_faststart    = Input(UInt(1.W))    
        val fz_ldo_bypass       = Input(UInt(1.W))    
        val fz_ldo_extrefsel    = Input(UInt(1.W))    
        val fz_ldo_fbtrim       = Input(UInt(4.W))    
        val fz_ldo_reftrim      = Input(UInt(4.W))    

        val clkref              = Input(Clock())            
        val bypass              = Input(UInt(1.W))         
        val pllen               = Input(UInt(1.W))          

        val ratio               = Input(UInt(10.W)) 
        val fraction            = Input(UInt(24.W)) 
        val mdiv_ratio          = Input(UInt(6.W))  
        val vcodiv_ratio        = Input(UInt(2.W))  
        val zdiv0_ratio         = Input(UInt(10.W)) 
        val zdiv0_ratio_p5      = Input(UInt(1.W))  
        val zdiv1_ratio         = Input(UInt(10.W)) 
        val zdiv1_ratio_p5      = Input(UInt(1.W))  

        val fz_cp1trim          = Input(UInt(5.W))       
        val fz_cp2trim          = Input(UInt(5.W))       
        val fz_cpnbias          = Input(UInt(2.W))       
        val fz_dca_cb           = Input(UInt(2.W))       
        val fz_dca_ctrl         = Input(UInt(6.W))       

        val fz_irefgen          = Input(UInt(5.W))   
        val fz_lockcnt          = Input(UInt(3.W))   
        val fz_lockforce        = Input(UInt(1.W))   
        val fz_lockthresh       = Input(UInt(4.W))   
        val fz_nopfdpwrgate     = Input(UInt(1.W))   
        val fz_pfd_pw           = Input(UInt(3.W))   
        val fz_pfddly           = Input(UInt(2.W))   
        val fz_skadj            = Input(UInt(5.W))   
        val fz_spare            = Input(UInt(5.W))   
        val fz_startup          = Input(UInt(6.W))  
        val fz_tight_loopb      = Input(UInt(1.W))   
        val fz_vcosel           = Input(UInt(1.W))   
        val fz_vcotrim          = Input(UInt(11.W))  

        val ssc_frac_step       = Input(UInt(24.W))
        val ssc_cyc_to_peak_m1  = Input(UInt(9.W))
        val ssc_en              = Input(UInt(1.W))
        val mash_order_plus_one = Input(UInt(1.W))

        val fz_lockstickyb      = Input(UInt(1.W))
        val fz_lpfclksel        = Input(UInt(1.W))
        val idvdisable_bi       = Input(UInt(1.W)) 
        val idvfreqai           = Input(UInt(1.W))
        val idvfreqbi           = Input(UInt(1.W))
        val idvpulsei           = Input(UInt(1.W))
        val idvtclki            = Input(UInt(1.W))
        val idvtctrli           = Input(UInt(1.W))
        val idvtdi              = Input(UInt(1.W))
        val idvtresi            = Input(UInt(1.W))
        val idfx_fscan_sdi      = Input(UInt(3.W)) 
        val idfx_fscan_mode     = Input(UInt(1.W))
        val idfx_fscan_shiften  = Input(UInt(1.W))
        val idfx_fscan_rstbypen = Input(UInt(1.W))
        val idfx_fscan_byprstb  = Input(UInt(1.W))
        val idfx_fscan_clkungate = Input(UInt(1.W))
        val ldo_vref             = Input(UInt(1.W))
        val tck                  = Input(UInt(1.W))
        val tcapturedr 		     = Input(UInt(1.W))
        val tdi                  = Input(UInt(1.W))
        val treg_en 		     = Input(UInt(1.W))
        val trst_n 		         = Input(UInt(1.W))
        val tshiftdr             = Input(UInt(1.W))
        val tupdatedr            = Input(UInt(1.W))
        val pllfwen_b            = Input(UInt(1.W))
        
        val lock                = Output(UInt(1.W))     
        val clkpll              = Output(Clock())
        val clkpll0	            = Output(Clock())	
        val clkpll1	            = Output(Clock())	
    })
    addResource("/vsrc/ringpll.sv")
}

//base address 0x08002000
class IntelRingPllCtrl(address: BigInt, tlbus: TLBusWrapper)(implicit p:Parameters) extends LazyModule {
    val device = new SimpleDevice("ringpll-ctrl", Nil)
    val tlNode = TLRegisterNode(Seq(AddressSet(address, 0x800-1)), device, "reg/control", beatBytes=tlbus.beatBytes)
    tlbus.toVariableWidthSlave(Some("ringpll-ctrl")) { tlNode := TLBuffer() }
    
    lazy val module = new Impl 
    class Impl extends LazyModuleImp(this) { 
        val io = IO(new Bundle {
            val fz_tight_loopb    = Output(UInt(1.W)) 
            val fz_lockforce      = Output(UInt(1.W))
            val fz_lockcnt        = Output(UInt(3.W))
            val fz_lockthresh     = Output(UInt(4.W)) 
            val fz_pfd_pw         = Output(UInt(3.W))
            val fz_dca_ctrl       = Output(UInt(6.W)) 
            val fz_dca_cb         = Output(UInt(2.W))
            val fz_irefgen        = Output(UInt(5.W))
            val fz_startup        = Output(UInt(6.W))
            val fz_cp1trim        = Output(UInt(5.W))
            val fz_cp2trim        = Output(UInt(5.W))
            val fz_nopfdpwrgate   = Output(UInt(1.W))
            val fz_pfddly         = Output(UInt(2.W))
            val fz_cpnbias        = Output(UInt(2.W))
            val fz_vcotrim        = Output(UInt(11.W))
            val fz_skadj          = Output(UInt(5.W))
            val fz_vcosel         = Output(UInt(1.W))
            val fz_spare          = Output(UInt(5.W))
            val fz_ldo_faststart  = Output(UInt(1.W))
            val fz_ldo_bypass     = Output(UInt(1.W))
            val fz_ldo_vinvoltsel = Output(UInt(2.W))
            val fz_ldo_fbtrim     = Output(UInt(4.W))
            val fz_ldo_reftrim    = Output(UInt(4.W))
            val powergood_vnn     = Output(UInt(1.W))   
            val pllen             = Output(UInt(1.W))
            val bypass            = Output(UInt(1.W)) 
            val ldo_enable        = Output(UInt(1.W)) 
            val fz_ldo_extrefsel  = Output(UInt(1.W)) 

            val ratio             = Output(UInt(10.W))
            val fraction          = Output(UInt(24.W))
            val mdiv_ratio        = Output(UInt(6.W))
            val vcodiv_ratio      = Output(UInt(2.W))
            val zdiv0_ratio       = Output(UInt(10.W))   
            val zdiv0_ratio_p5    = Output(UInt(1.W))
            val zdiv1_ratio       = Output(UInt(10.W)) 
            val zdiv1_ratio_p5    = Output(UInt(1.W)) 

            val ssc_frac_step       = Output(UInt(24.W))
            val ssc_cyc_to_peak_m1  = Output(UInt(9.W))
            val ssc_en              = Output(UInt(1.W))
            val mash_order_plus_one = Output(UInt(1.W))

            val fz_lockstickyb       = Output(UInt(1.W))
            val fz_lpfclksel         = Output(UInt(1.W))
            val idvdisable_bi        = Output(UInt(1.W)) 
            val idvfreqai            = Output(UInt(1.W))
            val idvfreqbi            = Output(UInt(1.W))
            val idvpulsei            = Output(UInt(1.W))
            val idvtclki             = Output(UInt(1.W))
            val idvtctrli            = Output(UInt(1.W))
            val idvtdi               = Output(UInt(1.W))
            val idvtresi             = Output(UInt(1.W))
            val idfx_fscan_sdi       = Output(UInt(3.W)) 
            val idfx_fscan_mode      = Output(UInt(1.W))
            val idfx_fscan_shiften   = Output(UInt(1.W))
            val idfx_fscan_rstbypen  = Output(UInt(1.W))
            val idfx_fscan_byprstb   = Output(UInt(1.W))
            val idfx_fscan_clkungate = Output(UInt(1.W))
            val ldo_vref             = Output(UInt(1.W))
            val tck                  = Output(UInt(1.W))
            val tcapturedr 		     = Output(UInt(1.W))
            val tdi                  = Output(UInt(1.W))
            val treg_en 		     = Output(UInt(1.W))
            val trst_n 		         = Output(UInt(1.W))
            val tshiftdr             = Output(UInt(1.W))
            val tupdatedr            = Output(UInt(1.W))
            val pllfwen_b            = Output(UInt(1.W))
        })

        val fz_tight_loopb    = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val fz_lockforce      = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val fz_lockcnt        = withReset(reset) { Module(new AsyncResetRegVec(w=3, init=7)) }
        val fz_lockthresh     = withReset(reset) { Module(new AsyncResetRegVec(w=4, init=1)) } 
        val fz_pfd_pw         = withReset(reset) { Module(new AsyncResetRegVec(w=3, init=0)) }
        val fz_dca_ctrl       = withReset(reset) { Module(new AsyncResetRegVec(w=6, init=0)) } 
        val fz_dca_cb         = withReset(reset) { Module(new AsyncResetRegVec(w=2, init=0)) }
        val fz_irefgen        = withReset(reset) { Module(new AsyncResetRegVec(w=5, init=6)) }
        val fz_startup        = withReset(reset) { Module(new AsyncResetRegVec(w=6, init=0)) }
        val fz_cp1trim        = withReset(reset) { Module(new AsyncResetRegVec(w=5, init=8)) }
        val fz_cp2trim        = withReset(reset) { Module(new AsyncResetRegVec(w=5, init=2)) }
        val fz_nopfdpwrgate   = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val fz_pfddly         = withReset(reset) { Module(new AsyncResetRegVec(w=2, init=0)) }
        val fz_cpnbias        = withReset(reset) { Module(new AsyncResetRegVec(w=2, init=0)) }
        val fz_vcotrim        = withReset(reset) { Module(new AsyncResetRegVec(w=11, init=737)) }
        val fz_skadj          = withReset(reset) { Module(new AsyncResetRegVec(w=5, init=0)) }
        val fz_vcosel         = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=1)) }
        val fz_spare          = withReset(reset) { Module(new AsyncResetRegVec(w=5, init=3)) }
        val fz_ldo_faststart  = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val fz_ldo_bypass     = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val fz_ldo_vinvoltsel = withReset(reset) { Module(new AsyncResetRegVec(w=2, init=0)) }
        val fz_ldo_fbtrim     = withReset(reset) { Module(new AsyncResetRegVec(w=4, init=11)) }
        val fz_ldo_reftrim    = withReset(reset) { Module(new AsyncResetRegVec(w=4, init=11)) }
        val powergood_vnn     = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val pllen             = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val bypass            = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val ldo_enable        = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val fz_ldo_extrefsel  = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) } 
        
        val ratio             = withReset(reset) { Module(new AsyncResetRegVec(w=10, init=20)) }
        val fraction          = withReset(reset) { Module(new AsyncResetRegVec(w=24, init=0)) }
        val mdiv_ratio        = withReset(reset) { Module(new AsyncResetRegVec(w=6, init=0)) }
        val vcodiv_ratio      = withReset(reset) { Module(new AsyncResetRegVec(w=2, init=0)) }
        val zdiv0_ratio       = withReset(reset) { Module(new AsyncResetRegVec(w=10, init=0)) }   
        val zdiv0_ratio_p5    = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val zdiv1_ratio       = withReset(reset) { Module(new AsyncResetRegVec(w=10, init=0)) } 
        val zdiv1_ratio_p5    = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) } 

        val ssc_frac_step       = withReset(reset) { Module(new AsyncResetRegVec(w=24, init=0)) }
        val ssc_cyc_to_peak_m1  = withReset(reset) { Module(new AsyncResetRegVec(w=9, init=0)) }
        val ssc_en              = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val mash_order_plus_one = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }

        val fz_lockstickyb       = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val fz_lpfclksel         = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idvdisable_bi        = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) } 
        val idvfreqai            = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idvfreqbi            = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idvpulsei            = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idvtclki             = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idvtctrli            = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idvtdi               = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idvtresi             = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idfx_fscan_sdi       = withReset(reset) { Module(new AsyncResetRegVec(w=3, init=0)) }
        val idfx_fscan_mode      = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idfx_fscan_shiften   = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idfx_fscan_rstbypen  = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idfx_fscan_byprstb   = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val idfx_fscan_clkungate = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val ldo_vref             = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val tck                  = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val tcapturedr 		     = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val tdi                  = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val treg_en 		     = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val trst_n 		         = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val tshiftdr             = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val tupdatedr            = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }
        val pllfwen_b            = withReset(reset) { Module(new AsyncResetRegVec(w=1, init=0)) }

        io.fz_tight_loopb    := fz_tight_loopb.io.q
        io.fz_lockforce      := fz_lockforce.io.q
        io.fz_lockcnt        := fz_lockcnt.io.q
        io.fz_lockthresh     := fz_lockthresh.io.q 
        io.fz_pfd_pw         := fz_pfd_pw.io.q
        io.fz_dca_ctrl       := fz_dca_ctrl.io.q 
        io.fz_dca_cb         := fz_dca_cb.io.q
        io.fz_irefgen        := fz_irefgen.io.q
        io.fz_startup        := fz_startup.io.q
        io.fz_cp1trim        := fz_cp1trim.io.q
        io.fz_cp2trim        := fz_cp2trim.io.q
        io.fz_nopfdpwrgate   := fz_nopfdpwrgate.io.q
        io.fz_pfddly         := fz_pfddly.io.q
        io.fz_cpnbias        := fz_cpnbias.io.q
        io.fz_vcotrim        := fz_vcotrim.io.q
        io.fz_skadj          := fz_skadj.io.q
        io.fz_vcosel         := fz_vcosel.io.q
        io.fz_spare          := fz_spare.io.q
        io.fz_ldo_faststart  := fz_ldo_faststart.io.q
        io.fz_ldo_bypass     := fz_ldo_bypass.io.q
        io.fz_ldo_vinvoltsel := fz_ldo_vinvoltsel.io.q
        io.fz_ldo_fbtrim     := fz_ldo_fbtrim.io.q
        io.fz_ldo_reftrim    := fz_ldo_reftrim.io.q
        io.powergood_vnn     := powergood_vnn.io.q
        io.pllen             := pllen.io.q
        io.ldo_enable        := ldo_enable.io.q
        io.bypass            := bypass.io.q
        io.fz_ldo_extrefsel  := fz_ldo_extrefsel.io.q
        io.ratio             := ratio.io.q
        io.fraction          := fraction.io.q
        io.mdiv_ratio        := mdiv_ratio.io.q
        io.vcodiv_ratio      := vcodiv_ratio.io.q
        io.zdiv0_ratio       := zdiv0_ratio.io.q   
        io.zdiv0_ratio_p5    := zdiv0_ratio_p5.io.q
        io.zdiv1_ratio       := zdiv1_ratio.io.q 
        io.zdiv1_ratio_p5    := zdiv1_ratio_p5.io.q 

        io.ssc_cyc_to_peak_m1  := ssc_cyc_to_peak_m1.io.q
        io.ssc_en              := ssc_en.io.q
        io.ssc_frac_step       := ssc_frac_step.io.q
        io.mash_order_plus_one := mash_order_plus_one.io.q

        io.fz_lockstickyb       := fz_lockstickyb.io.q
        io.fz_lpfclksel         := fz_lpfclksel.io.q
        io.idvdisable_bi        := idvdisable_bi.io.q 
        io.idvfreqai            := idvfreqai.io.q
        io.idvfreqbi            := idvfreqbi.io.q
        io.idvpulsei            := idvpulsei.io.q
        io.idvtclki             := idvtclki.io.q
        io.idvtctrli            := idvtctrli.io.q
        io.idvtdi               := idvtdi.io.q
        io.idvtresi             := idvtresi.io.q
        io.idfx_fscan_sdi       := idfx_fscan_sdi.io.q
        io.idfx_fscan_mode      := idfx_fscan_mode.io.q
        io.idfx_fscan_shiften   := idfx_fscan_shiften.io.q
        io.idfx_fscan_rstbypen  := idfx_fscan_rstbypen.io.q
        io.idfx_fscan_byprstb   := idfx_fscan_byprstb.io.q
        io.idfx_fscan_clkungate := idfx_fscan_clkungate.io.q
        io.ldo_vref             := ldo_vref.io.q
        io.tck                  := tck.io.q
        io.tcapturedr 		    := tcapturedr.io.q
        io.tdi                  := tdi.io.q
        io.treg_en 		        := treg_en.io.q
        io.trst_n 		        := trst_n.io.q
        io.tshiftdr             := tshiftdr.io.q
        io.tupdatedr            := tupdatedr.io.q
        io.pllfwen_b            := pllfwen_b.io.q

        tlNode.regmap(
            0x00 -> Seq(RegField.rwReg(1, fz_tight_loopb.io)),
            0x04 -> Seq(RegField.rwReg(1, fz_lockforce.io)),
            0x08 -> Seq(RegField.rwReg(3, fz_lockcnt.io)),
            0x0C -> Seq(RegField.rwReg(4, fz_lockthresh.io)),
            0x10 -> Seq(RegField.rwReg(3, fz_pfd_pw.io)),
            0x14 -> Seq(RegField.rwReg(6, fz_dca_ctrl.io)),
            0x18 -> Seq(RegField.rwReg(2, fz_dca_cb.io)),
            0x1C -> Seq(RegField.rwReg(5, fz_irefgen.io)),
            0x20 -> Seq(RegField.rwReg(6, fz_startup.io)),
            0x24 -> Seq(RegField.rwReg(5, fz_cp1trim.io)),
            0x28 -> Seq(RegField.rwReg(5, fz_cp2trim.io)),
            0x2C -> Seq(RegField.rwReg(1, fz_nopfdpwrgate.io)),
            0x30 -> Seq(RegField.rwReg(2, fz_pfddly.io)),
            0x34 -> Seq(RegField.rwReg(2, fz_cpnbias.io)),
            0x38 -> Seq(RegField.rwReg(11, fz_vcotrim.io)),
            0x3C -> Seq(RegField.rwReg(5, fz_skadj.io)),
            0x40 -> Seq(RegField.rwReg(1, fz_vcosel.io)),
            0x44 -> Seq(RegField.rwReg(5, fz_spare.io)),
            0x48 -> Seq(RegField.rwReg(1, fz_ldo_faststart.io)),
            0x4C -> Seq(RegField.rwReg(1, fz_ldo_bypass.io)),
            0x50 -> Seq(RegField.rwReg(2, fz_ldo_vinvoltsel.io)),
            0x54 -> Seq(RegField.rwReg(4, fz_ldo_fbtrim.io)),
            0x58 -> Seq(RegField.rwReg(4, fz_ldo_reftrim.io)),
            0x5C -> Seq(RegField.rwReg(1, powergood_vnn.io)),
            0x60 -> Seq(RegField.rwReg(1, pllen.io)),
            0x64 -> Seq(RegField.rwReg(1, ldo_enable.io)),
            0x68 -> Seq(RegField.rwReg(1, bypass.io)),
            0x6C -> Seq(RegField.rwReg(10, ratio.io)),
            0x70 -> Seq(RegField.rwReg(24, fraction.io)),
            0x74 -> Seq(RegField.rwReg(6, mdiv_ratio.io)),
            0x78 -> Seq(RegField.rwReg(10, zdiv0_ratio.io)),
            0x7C -> Seq(RegField.rwReg(1, zdiv0_ratio_p5.io)),
            0x80 -> Seq(RegField.rwReg(10, zdiv1_ratio.io)),
            0x84 -> Seq(RegField.rwReg(1, zdiv1_ratio_p5.io)),
            0x88 -> Seq(RegField.rwReg(2, vcodiv_ratio.io)),
            0x8C -> Seq(RegField.rwReg(1, fz_ldo_extrefsel.io)),
            0x90 -> Seq(RegField.rwReg(24, ssc_frac_step.io)),
            0x94 -> Seq(RegField.rwReg(9, ssc_cyc_to_peak_m1.io)),
            0x98 -> Seq(RegField.rwReg(1, ssc_en.io)),
            0x9C -> Seq(RegField.rwReg(1, mash_order_plus_one.io)),
            0xA0 -> Seq(RegField.rwReg(1, fz_lockstickyb.io)),
            0xA4 -> Seq(RegField.rwReg(1, fz_lpfclksel.io)),
            0xA8 -> Seq(RegField.rwReg(1, idvdisable_bi.io)),
            0xAC -> Seq(RegField.rwReg(1, idvfreqai.io)),
            0xB0 -> Seq(RegField.rwReg(1, idvfreqbi.io)),
            0xB4 -> Seq(RegField.rwReg(1, idvpulsei.io)),
            0xB8 -> Seq(RegField.rwReg(1, idvtclki.io)),
            0xBC -> Seq(RegField.rwReg(1, idvtctrli.io)),
            0xC0 -> Seq(RegField.rwReg(1, idvtdi.io)),
            0xC4 -> Seq(RegField.rwReg(1, idvtresi.io)),
            0xC8 -> Seq(RegField.rwReg(3, idfx_fscan_sdi.io)),
            0xCC -> Seq(RegField.rwReg(1, idfx_fscan_mode.io)),
            0xD0 -> Seq(RegField.rwReg(1, idfx_fscan_shiften.io)),
            0xD4 -> Seq(RegField.rwReg(1, idfx_fscan_rstbypen.io)),
            0xD8 -> Seq(RegField.rwReg(1, idfx_fscan_byprstb.io)),
            0xDC -> Seq(RegField.rwReg(1, idfx_fscan_clkungate.io)),
            0xE0 -> Seq(RegField.rwReg(1, tck.io)),
            0xE4 -> Seq(RegField.rwReg(1, tcapturedr.io)),
            0xE8 -> Seq(RegField.rwReg(1, tdi.io)),
            0xEC -> Seq(RegField.rwReg(1, treg_en.io)),
            0xF0 -> Seq(RegField.rwReg(1, trst_n.io)),
            0xF4 -> Seq(RegField.rwReg(1, tshiftdr.io)),
            0xF8 -> Seq(RegField.rwReg(1, tupdatedr.io)),
            0xFC -> Seq(RegField.rwReg(1, ldo_vref.io)),
            0x100 -> Seq(RegField.rwReg(1, pllfwen_b.io)),
        )
    }
}


class IntelRingPll extends Module {
    val io = IO(new Bundle {
        val lock            = Output(UInt(1.W))
        val clkpll          = Output(Clock())
        val clkpll0	        = Output(Clock())	
        val clkpll1	        = Output(Clock())	

        val clkref          = Input(Clock()) 

        val fz_tight_loopb    = Input(UInt(1.W)) 
        val fz_lockforce      = Input(UInt(1.W))
        val fz_lockcnt        = Input(UInt(3.W))
        val fz_lockthresh     = Input(UInt(4.W)) 
        val fz_pfd_pw         = Input(UInt(3.W))
        val fz_dca_ctrl       = Input(UInt(6.W)) 
        val fz_dca_cb         = Input(UInt(2.W))
        val fz_irefgen        = Input(UInt(5.W))
        val fz_startup        = Input(UInt(6.W))
        val fz_cp1trim        = Input(UInt(5.W))
        val fz_cp2trim        = Input(UInt(5.W))
        val fz_nopfdpwrgate   = Input(UInt(1.W))
        val fz_pfddly         = Input(UInt(2.W))
        val fz_cpnbias        = Input(UInt(2.W))
        val fz_vcotrim        = Input(UInt(11.W))
        val fz_skadj          = Input(UInt(5.W))
        val fz_vcosel         = Input(UInt(1.W))
        val fz_spare          = Input(UInt(5.W))
        val fz_ldo_faststart  = Input(UInt(1.W))
        val fz_ldo_bypass     = Input(UInt(1.W))
        val fz_ldo_vinvoltsel = Input(UInt(2.W))
        val fz_ldo_fbtrim     = Input(UInt(4.W))
        val fz_ldo_reftrim    = Input(UInt(4.W))
        val powergood_vnn     = Input(UInt(1.W))   
        val pllen             = Input(UInt(1.W))
        val bypass            = Input(UInt(1.W)) 
        val ldo_enable        = Input(UInt(1.W)) 
        val fz_ldo_extrefsel  = Input(UInt(1.W)) 

        val ratio             = Input(UInt(10.W))
        val fraction          = Input(UInt(24.W))
        val mdiv_ratio        = Input(UInt(6.W))
        val vcodiv_ratio      = Input(UInt(2.W))
        val zdiv0_ratio       = Input(UInt(10.W))   
        val zdiv0_ratio_p5    = Input(UInt(1.W))
        val zdiv1_ratio       = Input(UInt(10.W)) 
        val zdiv1_ratio_p5    = Input(UInt(1.W)) 

        val ssc_frac_step       = Input(UInt(24.W))
        val ssc_cyc_to_peak_m1  = Input(UInt(9.W))
        val ssc_en              = Input(UInt(1.W))
        val mash_order_plus_one = Input(UInt(1.W))

        val fz_lockstickyb      = Input(UInt(1.W))
        val fz_lpfclksel        = Input(UInt(1.W))
        val idvdisable_bi       = Input(UInt(1.W)) 
        val idvfreqai           = Input(UInt(1.W))
        val idvfreqbi           = Input(UInt(1.W))
        val idvpulsei           = Input(UInt(1.W))
        val idvtclki            = Input(UInt(1.W))
        val idvtctrli           = Input(UInt(1.W))
        val idvtdi              = Input(UInt(1.W))
        val idvtresi            = Input(UInt(1.W))
        val idfx_fscan_sdi      = Input(UInt(3.W)) 
        val idfx_fscan_mode     = Input(UInt(1.W))
        val idfx_fscan_shiften  = Input(UInt(1.W))
        val idfx_fscan_rstbypen = Input(UInt(1.W))
        val idfx_fscan_byprstb  = Input(UInt(1.W))
        val idfx_fscan_clkungate = Input(UInt(1.W))
        val ldo_vref             = Input(UInt(1.W))
        val tck                  = Input(UInt(1.W))
        val tcapturedr 		     = Input(UInt(1.W))
        val tdi                  = Input(UInt(1.W))
        val treg_en 		     = Input(UInt(1.W))
        val trst_n 		         = Input(UInt(1.W))
        val tshiftdr             = Input(UInt(1.W))
        val tupdatedr            = Input(UInt(1.W))
        val pllfwen_b            = Input(UInt(1.W))
    })
    val pll = Module(new ringpll())

    pll.io.clkref              := io.clkref

    pll.io.powergood_vnn       := io.powergood_vnn
    pll.io.ldo_enable          := io.ldo_enable                 
    pll.io.bypass              := io.bypass         
    pll.io.pllen               := io.pllen         

    pll.io.ratio               := io.ratio
    pll.io.fraction            := io.fraction
    pll.io.mdiv_ratio          := io.mdiv_ratio
    pll.io.vcodiv_ratio        := io.vcodiv_ratio
    pll.io.zdiv0_ratio         := io.zdiv0_ratio
    pll.io.zdiv0_ratio_p5      := io.zdiv0_ratio_p5
    pll.io.zdiv1_ratio         := io.zdiv1_ratio
    pll.io.zdiv1_ratio_p5      := io.zdiv1_ratio_p5

    pll.io.fz_ldo_vinvoltsel   := io.fz_ldo_vinvoltsel    
    pll.io.fz_ldo_faststart    := io.fz_ldo_faststart    
    pll.io.fz_ldo_bypass       := io.fz_ldo_bypass    
    pll.io.fz_ldo_extrefsel    := io.fz_ldo_extrefsel    
    pll.io.fz_ldo_fbtrim       := io.fz_ldo_fbtrim    
    pll.io.fz_ldo_reftrim      := io.fz_ldo_reftrim 
    pll.io.fz_cp1trim          := io.fz_cp1trim       
    pll.io.fz_cp2trim          := io.fz_cp2trim     
    pll.io.fz_cpnbias          := io.fz_cpnbias      
    pll.io.fz_dca_cb           := io.fz_dca_cb       
    pll.io.fz_dca_ctrl         := io.fz_dca_ctrl     
    pll.io.fz_irefgen          := io.fz_irefgen  
    pll.io.fz_lockcnt          := io.fz_lockcnt  
    pll.io.fz_lockforce        := io.fz_lockforce  
    pll.io.fz_lockthresh       := io.fz_lockthresh  
    pll.io.fz_nopfdpwrgate     := io.fz_nopfdpwrgate   
    pll.io.fz_pfd_pw           := io.fz_pfd_pw   
    pll.io.fz_pfddly           := io.fz_pfddly   
    pll.io.fz_skadj            := io.fz_skadj   
    pll.io.fz_spare            := io.fz_spare   
    pll.io.fz_startup          := io.fz_startup   
    pll.io.fz_tight_loopb      := io.fz_tight_loopb   
    pll.io.fz_vcosel           := io.fz_vcosel   
    pll.io.fz_vcotrim          := io.fz_vcotrim 

    pll.io.ssc_frac_step       := io.ssc_frac_step
    pll.io.ssc_cyc_to_peak_m1  := io.ssc_cyc_to_peak_m1
    pll.io.ssc_en              := io.ssc_en
    pll.io.mash_order_plus_one := io.mash_order_plus_one

    pll.io.fz_lockstickyb       := io.fz_lockstickyb
    pll.io.fz_lpfclksel         := io.fz_lpfclksel
    pll.io.idvdisable_bi        := io.idvdisable_bi 
    pll.io.idvfreqai            := io.idvfreqai
    pll.io.idvfreqbi            := io.idvfreqbi
    pll.io.idvpulsei            := io.idvpulsei
    pll.io.idvtclki             := io.idvtclki
    pll.io.idvtctrli            := io.idvtctrli
    pll.io.idvtdi               := io.idvtdi
    pll.io.idvtresi             := io.idvtresi
    pll.io.idfx_fscan_sdi       := io.idfx_fscan_sdi
    pll.io.idfx_fscan_mode      := io.idfx_fscan_mode
    pll.io.idfx_fscan_shiften   := io.idfx_fscan_shiften
    pll.io.idfx_fscan_rstbypen  := io.idfx_fscan_rstbypen
    pll.io.idfx_fscan_byprstb   := io.idfx_fscan_byprstb
    pll.io.idfx_fscan_clkungate := io.idfx_fscan_clkungate
    pll.io.ldo_vref             := io.ldo_vref
    pll.io.tck                  := io.tck
    pll.io.tcapturedr 		    := io.tcapturedr
    pll.io.tdi                  := io.tdi
    pll.io.treg_en 		        := io.treg_en
    pll.io.trst_n 		        := io.trst_n
    pll.io.tshiftdr             := io.tshiftdr
    pll.io.tupdatedr            := io.tupdatedr
    pll.io.pllfwen_b            := io.pllfwen_b

    io.lock                 := pll.io.lock    
    io.clkpll               := pll.io.clkpll
    io.clkpll0	            := pll.io.clkpll0	
    io.clkpll1	            := pll.io.clkpll1	
}


