
`include "hs_soc_clock_macros.sv"
`ifndef DEFINE_CTECH_LIB_CG_TE
   `define DEFINE_CTECH_LIB_CG_TE
module ctech_lib_clk_gate_te (
  output logic clkout,
  input logic clk,
  input logic en,
  input logic te);
   `ifndef DC
  logic q;
  always_latch
     if (~clk)
        q <= en|te;
  assign clkout =  q & clk;
   `else
   `CLK_GATE(clkout,clk,en|te); //It should be the real cell gate_te
   `endif
endmodule

`endif
