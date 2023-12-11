`include "hs_soc_clock_macros.sv"
module ctech_lib_clk_mux_2to1 (
   input logic clk1,
   input logic clk2,
   input logic s,
   output logic clkout
);
   `ifndef DC
   assign clkout = (s==1'b1)?clk1:clk2;
   `else
    `MAKE_CLK_2TO1MUX(clkout,clk2,clk1,s)
   `endif
endmodule
