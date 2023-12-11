`include "hs_soc_clock_macros.sv"
module ctech_lib_clk_or_en (output logic clkout, input logic clk, input logic en);
   `ifndef DC
   assign clkout = clk|en;
   `else
   `MAKE_CLK_OREN(clkout,clk,en)
   `endif
endmodule
