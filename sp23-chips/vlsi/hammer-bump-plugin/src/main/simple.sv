`timescale 1 ns/10 ps

module ChipTop(
  input wire clk,
  input wire reset,
  input wire [7:0] in,
  output wire [7:0] out
);

  wire [9:0] in_tc;
  wire [9:0] in_fp;
  wire [7:0] out_tp;

  assign in_tc[7:0] =in;
  assign in_tc[8] =clk;
  assign in_tc[9] =reset;

  io_ring ring(
    .in (in_tc),
    .in_fp(in_fp),
    .out_tp (out_tp),
    .out (out));

  simple main_module (
    .clk   (clk),
    .reset (reset),
    .in  (in_fp),
    .out (out_tp));

endmodule

module simple(
  input  wire clk,
  input  wire reset,
  input  wire [7:0] in,
  output wire [7:0] out
); 

  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;

  wire [7:0] b_temp ;
  wire [7:0] c_temp ;

  assign b_temp = a + 1;
  assign c_temp = b + 1;

  sub_simple sub (.clk(clk), .in(c), .out(out), .reset(reset));

  always@(posedge clk) begin
    if (reset) begin
      a <= 0;
      b <= 0;
      c <= 0;
    end else begin
      a <= in;
      b <= b_temp;
      c <= c_temp;
    end
  end
endmodule

module sub_simple(
  input  wire clk,
  input reset,
  input  wire [7:0] in,
  output reg  [7:0] out
);
  reg [7:0] in_temp;

  always@(posedge clk) begin
    if (reset) begin
      in_temp <= 0;
    end else begin
      in_temp <= in;
      out     <= in_temp + 9'd2;
    end
  end
endmodule

