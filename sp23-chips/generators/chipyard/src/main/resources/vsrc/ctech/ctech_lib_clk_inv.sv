`include "hs_soc_clock_macros.sv"
module ctech_lib_clk_inv (
   input logic clk,
   output logic clkout
);
   `ifndef DC
   assign clkout =  ~clk;
   `else
    `CLKINV(clkout,clk)
   `endif
endmodule
