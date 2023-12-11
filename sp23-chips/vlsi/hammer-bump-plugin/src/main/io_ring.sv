parameter in_pads  = 10;
parameter out_pads = 8;

module io_ring(
  input  wire [in_pads-1:0] in,
  output wire [in_pads-1:0] in_fp,
  input  wire [out_pads-1:0] out_tp,
  output wire [out_pads-1:0] out);
  wire ana_io_1v8;
  wire outi;

  genvar i;
  for (i = 0; i < in_pads; i++) begin : in_pads
    Intech22DigitalInIOCell_N in_pad(.pad(in[i]), .i(in_fp[i]), .ie(1'b0));
  end

  for (i = 0; i < out_pads; i++) begin : out_pads
    Intech22DigitalOutIOCell_E out_pad(.pad(out[i]), .o(!out_tp[i]), .oe(1'b0));
  end

endmodule

module Intech22DigitalOutIOCell_N(
    output pad,
    input o,
    input oe);
  wire ana_io_1v8;
  wire outi;
  sdio_1v8_n1 iocell(
    .outi(outi),
    .ana_io_1v8(ana_io_1v8),
    .pad(pad),
    .dq(!o),
    .drv0(1'b0),
    .drv1(1'b0),
    .drv2(1'b1),
    .enabq(1'b1),
    .enq(!oe),
    .pd(1'b0),
    .ppen(1'b1),
    .prg_slew(1'b1),
    .puq(1'b1),
    .pwrupzhl(1'b0),
    .pwrup_pull_en(1'b0));
endmodule

module Intech22DigitalInIOCell_N(
    input pad,
    output i,
    input ie);
  wire ana_io_1v8;
  sdio_1v8_n1 iocell(
    .outi(i),
    .ana_io_1v8(ana_io_1v8),
    .pad(pad),
    .dq(1'b0),
    .drv0(1'b0),
    .drv1(1'b0),
    .drv2(1'b1),
    .enabq(!ie),
    .enq(1'b1),
    .pd(1'b0),
    .ppen(1'b1),
    .prg_slew(1'b1),
    .puq(1'b1),
    .pwrupzhl(1'b0),
    .pwrup_pull_en(1'b0));
endmodule

module Intech22DigitalOutIOCell_E(
    output pad,
    input o,
    input oe);
  wire ana_io_1v8;
  wire outi;
  sdio_1v8_e1 iocell(
    .outi(outi),
    .ana_io_1v8(ana_io_1v8),
    .pad(pad),
    .dq(!o),
    .drv0(1'b0),
    .drv1(1'b0),
    .drv2(1'b1),
    .enabq(1'b1),
    .enq(!oe),
    .pd(1'b0),
    .ppen(1'b1),
    .prg_slew(1'b1),
    .puq(1'b1),
    .pwrupzhl(1'b0),
    .pwrup_pull_en(1'b0));
endmodule