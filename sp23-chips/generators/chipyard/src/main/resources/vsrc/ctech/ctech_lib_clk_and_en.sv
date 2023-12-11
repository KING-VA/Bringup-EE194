`include "hs_soc_clock_macros.sv"
module ctech_lib_clk_and_en (
   output logic clkout,
   input logic clk,
   input logic en
);
   `ifndef DC
   assign clkout =  clk&en;
   `else
   `CLKAND(clkout,clk,en)
   `endif
endmodule   
