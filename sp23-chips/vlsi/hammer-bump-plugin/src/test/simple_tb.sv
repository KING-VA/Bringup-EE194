`timescale 1 ns/10 ps
`define INTCNOPWR

module simple_tb;
  reg [7:0] in;
  reg clk;
  wire [9:0] out;
  reg reset;
  
  ChipTop DUT(.in(in), .clk(clk), .out(out), .reset(reset));

  always # `CLOCK_PERIOD clk = ~clk;

  initial 
    begin
      clk = 0;
      reset = 1;
      in = 0;
      #2
      reset = 0;
      for (int i = 1; i < 10; i=i+1) begin 
        in = i;
        # `CLOCK_PERIOD;
        # `CLOCK_PERIOD;
      end

      #20;
      $finish;
    end
endmodule
