`include "hs_soc_clock_macros.sv"
module ctech_lib_clk_gate_and (
   input logic clk,
   input logic en,
   output logic clkout
);
   `ifndef DC
   logic en_latch;
   always_latch
   if (~clk)
      en_latch <= en;
   assign clkout =  clk&en_latch;
   `else
        soc_rbe_clk isoc_rbe_clk (
           .ckrcbxpn(clkout),
           .ckgridxpn(clk),
           .latrcben(en)
       );
   `endif
endmodule
