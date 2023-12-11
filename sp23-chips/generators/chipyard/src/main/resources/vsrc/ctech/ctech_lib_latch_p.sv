`include "hs_soc_clock_macros.sv"
module ctech_lib_latch_p (
   output logic o,
   input logic d,
   input logic clkb
);
   `ifndef DC
   always_latch
   if (~clkb)
      o <= d;
   `else
   //b15lsn080al1n08x5 latch_p_dcszo (.clkb(clkb), .o(o), .d(d));
      b15lsn080as1n02x3 ctech_lib_latch_p_dcszo (.o(o), .clkb(clkb), .d(d));
   `endif
endmodule
