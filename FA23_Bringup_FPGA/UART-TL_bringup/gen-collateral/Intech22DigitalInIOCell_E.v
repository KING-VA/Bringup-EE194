
module Intech22DigitalInIOCell_E(
    input pad,
    output i,
    input ie);
  wire ana_io_1v8;
  sdio_1v8_e1 iocell(
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
