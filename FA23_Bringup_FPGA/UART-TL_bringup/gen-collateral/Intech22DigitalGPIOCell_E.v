
module Intech22DigitalGPIOCell_E(
    inout pad,
    output i,
    input ie,
    input o,
    input oe,
    input ds,
    input pue);
  wire ana_io_1v8;
  sdio_1v8_e1 iocell(
    .outi(i),
    .ana_io_1v8(ana_io_1v8),
    .pad(pad),
    .dq(o),
    .drv0(1'b0),
    .drv1(1'b0),
    .drv2(ds),
    .enabq(!ie),
    .enq(!oe),
    .pd(1'b0),
    .ppen(1'b1),
    .prg_slew(1'b1),
    .puq(!pue),
    .pwrupzhl(1'b0),
    .pwrup_pull_en(1'b0));
endmodule
