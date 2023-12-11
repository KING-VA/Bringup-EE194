module hl_west_io_wrapper(
	input [3:0] dq,
	input [3:0] drv0,
	input [3:0] drv1,
	input [3:0] drv2,
	input [3:0] enabq,
	input [3:0] enq,
	input [3:0] pd,
	input [3:0] ppen,
	input [3:0] prg_slew,
	input [3:0] puq,
	input [3:0] pwrup_pull_en,
	input [3:0] pwrupzhl,
	inout pad_0,
	inout pad_1,
	inout pad_2,
	inout pad_3,
	output [3:0] outi);

	hl_4slice_west_io hl_west_io_inst(
	 .dq(~dq),
	 .drv0(drv0),
	 .drv1(drv1),
	 .drv2(drv2),
	 .enabq(enabq),
	 .enq(enq),
	 .outi(outi),
	 .pad({pad_3, pad_2, pad_1, pad_0}),
	 .pd(pd),
	 .ppen(ppen),
	 .prg_slew(prg_slew),
	 .puq(puq),
	 .pwrup_pull_en(pwrup_pull_en),
	 .pwrupzhl(pwrupzhl));

endmodule
