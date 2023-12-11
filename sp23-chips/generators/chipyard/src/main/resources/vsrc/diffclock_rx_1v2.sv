///////////////////////////////////////////////////////////////////////////////
// Intel Confidential                                                        
///////////////////////////////////////////////////////////////////////////////
// Copyright 2021 Intel Corporation.                                         
// The information contained herein is the proprietary and confidential      
// information of Intel or its licensors, and is supplied subject to, and    
// may be used only in accordance with, previously executed agreements       
// with Intel ,                                                                                                   
// EXCEPT AS MAY OTHERWISE BE AGREED IN WRITING:                            
// (1) ALL MATERIALS FURNISHED BY INTEL HEREUNDER ARE PROVIDED "AS IS"      
//      WITHOUT WARRANTY OF ANY KIND;                            
// (2) INTEL SPECIFICALLY DISCLAIMS ANY WARRANTY OF NONINFRINGEMENT, FITNESS 
//      FOR A PARTICULAR PURPOSE OR MERCHANTABILITY; AND                     
// (3) INTEL WILL NOT BE LIABLE FOR ANY COSTS OF PROCUREMENT OF SUBSTITUTES, 
//      LOSS OF PROFITS, INTERRUPTION OF BUSINESS, OR                       
//      FOR ANY OTHER SPECIAL, CONSEQUENTIAL OR INCIDENTAL DAMAGES,        
//      HOWEVER CAUSED, WHETHER FOR BREACH OF WARRANTY, CONTRACT,            
//      TORT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE.                     

`ifndef SYNTHESIS

`timescale 1 ns / 1 ps
//VB changes for compilation

`ifdef INTEL_NO_PWR_PINS
`ifndef INTEL_EMULATION
import UPF::*;
`endif
`endif

module diffclock_rx_1v2 (
`ifndef INTEL_NO_PWR_PINS
vnnaon_nom, vccldo_hv, vccdig_nom, vccdist_nom, vss,
`endif
powergood_vnn, diffclkrx_ldo_vref, diffclkrx_fz_ldo_vinvoltsel, diffclkrx_ldo_hiz_debug, diffclkrx_fz_ldo_fbtrim,
diffclkrx_fz_ldo_reftrim, diffclkrx_fz_strong_ladder_en, diffclkrx_fz_ldo_faststart,
diffclkrx_fz_ldo_bypass, diffclkrx_fz_ldo_extrefsel, diffclkrx_clkref, diffclkrx_ldo_idq_debug,
diffclkrx_bias_config, diffclkrx_inn, diffclkrx_inp,  diffclkrx_rxen, diffclkrx_out,
diffclkrx_viewanabus, diffclkrx_viewana_en, diffclkrx_anaviewmux_sel0,diffclkrx_odt_en, 
diffclkrx_anaviewmux_sel1,diffclkrx_viewdig_en,diffclkrx_viewdigdfx_sel,diffclkrx_viewdigout
);

parameter VNNAON_NOM_MIN  = 0.765 ;
parameter VNNAON_NOM_MAX  = 0.935 ;
parameter VCCLDO_HV_MIN   = 1.14 ;
parameter VCCLDO_HV_MAX   = 1.26 ;
parameter VCCDIG_NOM_MIN  = 0.765 ;
parameter VCCDIG_NOM_MAX  = 0.935 ;
parameter VCCDIST_NOM_MIN = 0.765 ;
parameter VCCDIST_NOM_MAX = 0.935 ;
parameter ldo_out_del     = 4 ;     // in us

output diffclkrx_out;

`ifdef USE_MSV_NETTYPES
output wreal diffclkrx_viewanabus[1:0];
`else
output wire diffclkrx_viewanabus[1:0];
`endif


output diffclkrx_viewdigout;
input powergood_vnn;						// Indicates if power supplies are ready. Receiver is powered down while this is low.
input diffclkrx_ldo_vref;       			// external or internal reference based on diffclkrx_fz_ldo_extrefsel
input [1:0]diffclkrx_fz_ldo_vinvoltsel;  	// set value of vref when internal vref for LDO is selected
input diffclkrx_ldo_hiz_debug;			 	// enable probing of analog voltages of internal LDO
input [3:0]diffclkrx_fz_ldo_fbtrim;		 	// trim bit setting for fb resistor ladder
input [3:0]diffclkrx_fz_ldo_reftrim;		// trim bit setting for ref voltage resistor ladder
input diffclkrx_fz_strong_ladder_en;		// for strong volt ref resistor ladder for LDO when external ref is selected 
input diffclkrx_fz_ldo_faststart;			// Enable ldo faststartup mode
input diffclkrx_fz_ldo_bypass;              // Enable ldo bypass mode
input diffclkrx_fz_ldo_extrefsel;			// External voltage ref select
input diffclkrx_clkref;						// 100MHz clock for fast startup of internal LDO in combination with diffclkrx_fz_ldo_faststart=1
input diffclkrx_ldo_idq_debug;
input [1:0]diffclkrx_bias_config;
input diffclkrx_inn;
input diffclkrx_inp;
input diffclkrx_rxen;
input diffclkrx_viewana_en;
input diffclkrx_anaviewmux_sel0;
input diffclkrx_anaviewmux_sel1;
input diffclkrx_viewdig_en;
input diffclkrx_viewdigdfx_sel;
input diffclkrx_odt_en;

`ifndef INTEL_NO_PWR_PINS
input  vnnaon_nom;
input  vccldo_hv;
input  vccdig_nom;
input  vccdist_nom;
input  vss;
`endif // INTEL_NO_PWR_PINS

reg [1:0] sel ;
reg [3:0] dft_sel ; 
assign sel = { diffclkrx_inp, diffclkrx_inn} ;
assign dft_sel = {diffclkrx_anaviewmux_sel1,diffclkrx_anaviewmux_sel0,diffclkrx_ldo_hiz_debug,diffclkrx_ldo_idq_debug}; 
reg rxout_int;

logic supply_ok ;
logic rxout_supp ;
logic dfxout_supp;
logic diffclkrx_viewdigout_int;
logic diffclkrx_out_1;
logic ldo_ok_internal;

localparam OTA_RANGE_MIN=0.375;
localparam OTA_RANGE_MAX=0.9;
localparam BIAS_MIN = 0.175;
localparam BIAS_MAX = 0.365;


`ifndef INTEL_NO_PWR_PINS
assign supply_ok = vnnaon_nom & vccldo_hv & vccdig_nom & ~vss ;
assign rxout_supp = vnnaon_nom & vccdist_nom ; 
assign dfxout_supp = vnnaon_nom & vccdig_nom ;
`else
   `ifdef INTEL_SIMONLY
   real vnnaon_val, vccldo_val, vccdig_val, vccdist_val ;
   supply_net_type vnnaon_n;
   supply_net_type vccldo_n;
   supply_net_type vccdig_n;
   supply_net_type vccdist_n;

   localparam string DUMMY_NET_NAME = "dummy_net";
   string heir_dumy_net; 
   string heir_vnnaon_nom_net;
   string heir_vccldo_hv_net; 
   string heir_vccdig_nom_net;
   string heir_vccdist_nom_net;

   initial begin 
       heir_dumy_net = $sformatf("%m"); 
       foreach (heir_dumy_net[i]) begin if(heir_dumy_net[i]==".") heir_dumy_net[i]="/"; end; 
       heir_vnnaon_nom_net = { heir_dumy_net, "/vnnaon_nom"};
       heir_vccldo_hv_net = { heir_dumy_net, "/vccldo_hv"}; 
       heir_vccdig_nom_net = { heir_dumy_net, "/vccdig_nom"};
       heir_vccdist_nom_net = { heir_dumy_net, "/vccdist_nom"};
       heir_dumy_net = {heir_dumy_net, "/", DUMMY_NET_NAME}; 
       supply_on(heir_dumy_net,1);
   end

   reg pClk;
    initial begin
      pClk = 0;
      fork;
        forever #0.5 pClk = ~pClk;
      join_any;
   end


   always @(pClk) begin  
   vnnaon_n    = get_supply_value(heir_vnnaon_nom_net) ;  
   vccldo_n    = get_supply_value(heir_vccldo_hv_net) ;  
   vccdig_n    = get_supply_value(heir_vccdig_nom_net) ;  
   vccdist_n   = get_supply_value(heir_vccdist_nom_net) ;  
   vnnaon_val  = get_supply_voltage(vnnaon_n);
   vccldo_val  = get_supply_voltage(vccldo_n);
   vccdig_val  = get_supply_voltage(vccdig_n);
   vccdist_val = get_supply_voltage(vccdist_n);
   end

   assign supply_ok   = ((vnnaon_val  >= VNNAON_NOM_MIN)  && (vnnaon_val <= VNNAON_NOM_MAX)) && 
		   				((vccldo_val  >= VCCLDO_HV_MIN)   && (vccldo_val <= VCCLDO_HV_MAX )) &&
						((vccdig_val  >= VCCDIG_NOM_MIN)  && (vccdig_val <= VCCDIG_NOM_MAX)) ;
   assign rxout_supp  = ((vnnaon_val  >= VNNAON_NOM_MIN)  && (vnnaon_val <= VNNAON_NOM_MAX)) && 
		   				((vccdist_val >= VCCDIST_NOM_MIN) && (vccdist_val <= VCCDIST_NOM_MAX));
   assign dfxout_supp = ((vnnaon_val  >= VNNAON_NOM_MIN)  && (vnnaon_val <= VNNAON_NOM_MAX)) && 
		   				((vccdig_val  >= VCCDIG_NOM_MIN)  && (vccdig_val  <= VCCDIG_NOM_MAX));

   `else   // EMULATION
   		assign supply_ok   = 1'b1;
   		assign rxout_supp  = 1'b1;
   		assign dfxout_supp = 1'b1;
   `endif
`endif

always @(*)
begin
		if (diffclkrx_rxen & powergood_vnn & supply_ok)
		begin
		    case ( sel ) 
			2'b01 :  rxout_int = 1'b0;
			2'b10 :  rxout_int = 1'b1;
       `ifndef INTEL_EMULATION
			2'b00 :  rxout_int = 1'hx;
			2'b11 :  rxout_int = 1'hx;
			default : rxout_int = 1'hx;
        `else
			default : rxout_int = 1'h0;           
       `endif
		    endcase
       	end  
        else 
            rxout_int = 1'b0;

end // end of always


`ifndef INTEL_EMULATION
    always @(diffclkrx_rxen) begin
    		if (diffclkrx_rxen & powergood_vnn & supply_ok)   ldo_ok_internal = #(ldo_out_del*1us) diffclkrx_rxen;
    		else ldo_ok_internal = 0;
    end
    assign diffclkrx_out_1 = diffclkrx_inp & ldo_ok_internal & diffclkrx_rxen;
`else 
    assign diffclkrx_out_1 = rxout_int;
`endif
    
bufif1 (diffclkrx_out,diffclkrx_out_1,rxout_supp);
bufif0 (diffclkrx_out,1'bx,rxout_supp);

//DFT 
//Digital viewpin
 always @(*)
 begin
		if (diffclkrx_viewdig_en & diffclkrx_rxen & powergood_vnn & supply_ok)
             diffclkrx_viewdigout_int = diffclkrx_out_1;  //rxout_int;
	    else if (dfxout_supp == 1'b0)
		`ifndef INTEL_EMULATION               
             diffclkrx_viewdigout_int = 1'bx;
        `else     
             diffclkrx_viewdigout_int = 1'b0;
        `endif     
              
        else 
              diffclkrx_viewdigout_int = 1'b0;

 end // end of always
 
 assign diffclkrx_viewdigout = diffclkrx_viewdigout_int;


`ifndef INTEL_EMULATION
real diffclkrx_viewanabus_int0;
real diffclkrx_viewanabus_int1;

real diffclkrx_voutp_ota; //internal signals used for DFT
real diffclkrx_voutn_ota;
real diffclkrx_ota_out;
real diffclkrx_tail_bias;
real vcc_diffclkrx_nom;
real diffclkrx_anadft_ldovref;
real diffclkrx_anadft_ldovfb;
real diffclkrx_ldo_out_or_debugcurrent;
//Analog viewpin 
 assign diffclkrx_voutp_ota= (ldo_ok_internal & diffclkrx_rxen) * ((diffclkrx_inp * (OTA_RANGE_MAX-OTA_RANGE_MIN))+OTA_RANGE_MIN);
 assign diffclkrx_voutn_ota= (ldo_ok_internal & diffclkrx_rxen) * ((diffclkrx_inn * (OTA_RANGE_MAX-OTA_RANGE_MIN))+OTA_RANGE_MIN);
 assign diffclkrx_ota_out  = (ldo_ok_internal & diffclkrx_rxen) & diffclkrx_inn;    //Earlier diffclkrx_inp;
 assign diffclkrx_tail_bias = (ldo_ok_internal & diffclkrx_rxen) * BIAS_MAX;
 assign diffclkrx_anadft_ldovref = (ldo_ok_internal & diffclkrx_rxen) * 0.6;
 assign diffclkrx_anadft_ldovfb = (ldo_ok_internal & diffclkrx_rxen) * 0.8;
 assign diffclkrx_ldo_out_or_debugcurrent =(ldo_ok_internal & diffclkrx_rxen) * 1.0;
 assign vcc_diffclkrx_nom =(ldo_ok_internal & diffclkrx_rxen) * 0.98;

 always @(*)
  begin
		if (diffclkrx_viewana_en) 
		begin
		    //case ( {diffclkrx_anaviewmux_sel1,diffclkrx_anaviewmux_sel0,diffclkrx_ldo_hiz_debug,diffclkrx_ldo_idq_debug} ) 
		    casez (dft_sel) 
			4'b000? :  begin
                     assign diffclkrx_viewanabus_int0 = 0.0;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_voutp_ota;
                     end 
			4'b010? :  begin
                     assign diffclkrx_viewanabus_int0 = 0.0;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_voutn_ota;
                     end
			4'b100? :  begin
                     assign diffclkrx_viewanabus_int0 = `wrealZState;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_ota_out;
                     end 
			4'b110? :  begin 
                     assign diffclkrx_viewanabus_int0 = vcc_diffclkrx_nom;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_tail_bias;
                     end 
            4'b001? :  begin
                     assign diffclkrx_viewanabus_int0 = diffclkrx_anadft_ldovref;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_voutp_ota;
                     end 
			4'b011? :  begin
                     assign diffclkrx_viewanabus_int0 = diffclkrx_anadft_ldovfb;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_voutn_ota;
                     end
			4'b1011 :  begin
                     assign diffclkrx_viewanabus_int0 = diffclkrx_ldo_out_or_debugcurrent;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_ota_out;
                     end 
			4'b1110 :  begin 
                     assign diffclkrx_viewanabus_int0 = vcc_diffclkrx_nom;
                     assign diffclkrx_viewanabus_int1 = diffclkrx_tail_bias;
                     end          
			default :  begin
                      assign diffclkrx_viewanabus_int0 = `wrealZState;
                      assign diffclkrx_viewanabus_int1 = `wrealZState; 
                     end  
		    endcase
		end  // end if if(dft_en)
	
        else 
        begin    
            assign diffclkrx_viewanabus_int0 = `wrealZState;
            assign diffclkrx_viewanabus_int1 = `wrealZState;
        end 
   end // end of always
 
`ifdef USE_MSV_NETTYPES
  assign diffclkrx_viewanabus[0] = (powergood_vnn & supply_ok) ? diffclkrx_viewanabus_int0 : `wrealZState ;
  assign diffclkrx_viewanabus[1] = (powergood_vnn & supply_ok) ? diffclkrx_viewanabus_int1 : `wrealZState;
`else
  assign diffclkrx_viewanabus[0] = (powergood_vnn & supply_ok) ? (diffclkrx_viewanabus_int0 === `wrealZState? 1'bz : (diffclkrx_viewanabus_int0 == 0 ? 1'b0 : 1'b1)) : 1'bz ;
  assign diffclkrx_viewanabus[1] = (powergood_vnn & supply_ok) ? (diffclkrx_viewanabus_int1 === `wrealZState? 1'bz : (diffclkrx_viewanabus_int1 == 0 ? 1'b0 : 1'b1)) : 1'bz ;
`endif

`else // EMULATION - no analog dfx
  assign diffclkrx_viewanabus[0] = 1'b0;
  assign diffclkrx_viewanabus[1] = 1'b0;
`endif

   specify
    (diffclkrx_inn=>diffclkrx_out) = (0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0);
    (diffclkrx_inn=>diffclkrx_viewdigout) = (0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0);
    (diffclkrx_inp=>diffclkrx_out) = (0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0);
    (diffclkrx_inp=>diffclkrx_viewdigout) = (0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0);
    (diffclkrx_rxen=>diffclkrx_out) = (0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0);
    (diffclkrx_rxen=>diffclkrx_viewdigout) = (0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0);
    (diffclkrx_viewdig_en=>diffclkrx_viewdigout) = (0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0, 0:0:0);
   endspecify


  
`ifndef INTEL_SVA_OFF
always @(*)
 begin
	if ((supply_ok === 1'b1) && (diffclkrx_rxen === 1'b1)) begin
    
		rx_check_inp_notequal_inn : assert (diffclkrx_inp !== diffclkrx_inn) else 
		$error ("Invalid combition: diffclkrx_inp and diffclkrx_inn is driven to same value. Turn off receiver enable");

        rx_check_tristate_inn 	  : assert (!$isunknown(diffclkrx_inn)) else 
        $error ("Invalid combination: diffclkrx_inn is driven to tristate. Turn off receiver enable.");
    
        rx_check_tristate_inp 	  : assert (!$isunknown(diffclkrx_inp)) else 
        $error ("Invalid combination: diffclkrx_inp is driven to tristate. Turn off receiver enable.");
	end
end

`endif

endmodule
`else 

module diffclock_rx_1v2 (
powergood_vnn, diffclkrx_ldo_vref, diffclkrx_fz_ldo_vinvoltsel, diffclkrx_ldo_hiz_debug, diffclkrx_fz_ldo_fbtrim,
diffclkrx_fz_ldo_reftrim, diffclkrx_fz_strong_ladder_en, diffclkrx_fz_ldo_faststart,
diffclkrx_fz_ldo_bypass, diffclkrx_fz_ldo_extrefsel, diffclkrx_clkref, diffclkrx_ldo_idq_debug,
diffclkrx_bias_config, diffclkrx_inn, diffclkrx_inp,  diffclkrx_rxen, diffclkrx_out,
diffclkrx_viewanabus, diffclkrx_viewana_en, diffclkrx_anaviewmux_sel0,diffclkrx_odt_en, 
diffclkrx_anaviewmux_sel1,diffclkrx_viewdig_en,diffclkrx_viewdigdfx_sel,diffclkrx_viewdigout
);
endmodule
`endif
