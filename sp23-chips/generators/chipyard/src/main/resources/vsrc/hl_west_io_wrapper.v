module hl_west_io_wrapper(
	input dq_0,	input dq_1,	input dq_2,	input dq_3,
	input drv0_0,	input drv0_1,	input drv0_2,	input drv0_3,
	input drv1_0, input drv1_1, input drv1_2, input drv1_3,
	input drv2_0, input drv2_1, input drv2_2, input drv2_3,
	input enabq_0, input enabq_1, input enabq_2, input enabq_3,
	input enq_0, input enq_1, input enq_2, input enq_3,
	input pd_0,	input pd_1,	input pd_2,	input pd_3,
	input ppen_0,	input ppen_1,	input ppen_2,	input ppen_3,
	input prg_slew_0,	input prg_slew_1,	input prg_slew_2,	input prg_slew_3,
	input puq_0,	input puq_1,	input puq_2,	input puq_3,
	input pwrup_pull_en_0,	input pwrup_pull_en_1,	input pwrup_pull_en_2,	input pwrup_pull_en_3,
	input pwrupzhl_0,	input pwrupzhl_1,	input pwrupzhl_2,	input pwrupzhl_3,
	inout pad_0, inout pad_1, inout pad_2, inout pad_3,
	output outi_0, output outi_1,	output outi_2,	output outi_3);

	hl_4slice_west_io hl_west_io_inst(
	 .dq({dq_3, dq_2, dq_1, dq_0}),
	 .drv0({drv0_3,drv0_2,drv0_1,drv0_0}),
	 .drv1({drv1_3,drv1_2,drv1_1,drv1_0}),
	 .drv2({drv2_3,drv2_2,drv2_1,drv2_0}),
	 .enabq({enabq_3,enabq_2,enabq_1,enabq_0}),
	 .enq({enq_3,enq_2,enq_1,enq_0}),
	 .outi({outi_3,outi_2,outi_1,outi_0}),
	 .pad({pad_3, pad_2, pad_1, pad_0}),
	 .pd({pd_3,pd_2,pd_1,pd_0}),
	 .ppen({ppen_3,ppen_2,ppen_1,ppen_0}),
	 .prg_slew({prg_slew_3,prg_slew_2,prg_slew_1,prg_slew_0}),
	 .puq({puq_3,puq_2,puq_1,puq_0}),
	 .pwrup_pull_en({pwrup_pull_en_3,pwrup_pull_en_2,pwrup_pull_en_1,pwrup_pull_en_0}),
	 .pwrupzhl({pwrupzhl_3,pwrupzhl_2,pwrupzhl_1,pwrupzhl_0}));    
endmodule
