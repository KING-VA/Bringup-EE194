`include "hs_soc_clock_macros.sv"
module ctech_lib_clk_buf (
   input logic clk,
   output logic clkout
);
  `ifndef DC
  assign clkout =  clk;
   `else
   `CLKBF(clkout,clk)
   `endif
endmodule
