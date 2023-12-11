
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
