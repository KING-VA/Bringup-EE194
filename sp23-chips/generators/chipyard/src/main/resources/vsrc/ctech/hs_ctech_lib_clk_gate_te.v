//////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------------------------
// -- Intel Proprietary
// -- Copyright (C) 2015 Intel Corporation
// -- All Rights Reserved
// ------------------------------------------------------------------
// Company: Intel Corporation	
// Engineer: Santosh Ghosh
// 
// Create Date:    10:38:37 11/16/2015 
// Design Name: 
// Module Name:    tce_clock_gate 
// Project Name: 	 KVG/TCE
//////////////////////////////////////////////////////////////////////////////////
`ifndef DEFINE_CTECH_LIB_CG_TE
   `define DEFINE_CTECH_LIB_CG_TE
module ctech_lib_clk_gate_te(
  output logic clkout, //out clock
  input logic clk, //in clock
  input logic en, //enable
  input logic te //test enable
  );

  `ifndef DC
    logic q;
    always_latch
     if (~clk)
        q <= en|te;
    assign clkout =  q & clk;
  `else
    //"ERROR, do not use this file for DC"
    `CLK_GATE(clkout,clk,en|te); 
  `endif

endmodule

`endif
