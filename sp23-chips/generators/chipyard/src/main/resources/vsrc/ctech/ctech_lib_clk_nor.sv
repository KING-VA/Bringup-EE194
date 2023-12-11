`include "hs_soc_clock_macros.sv"
module ctech_lib_clk_nor (
   output logic clkout,
   input logic clk1,
   input logic clk2
);
   `ifndef DC
   assign clkout =  ~(clk2|clk1);
   `else
   `MAKE_CLKNOR(clkout,clk1,clk2)
   `endif
endmodule
