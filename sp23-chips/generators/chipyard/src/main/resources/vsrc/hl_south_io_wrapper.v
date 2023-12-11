module hl_south_io_wrapper( 
	input dq_0,	input dq_1,	input dq_2,	input dq_3,	input dq_4,	input dq_5,	input dq_6,	input dq_7,	
	input drv0_0,	input drv0_1,	input drv0_2,	input drv0_3,	input drv0_4,	input drv0_5,	input drv0_6,	input drv0_7,
	input drv1_0, input drv1_1, input drv1_2, input drv1_3, input drv1_4, input drv1_5, input drv1_6, input drv1_7, 	
	input drv2_0, input drv2_1, input drv2_2, input drv2_3, input drv2_4, input drv2_5, input drv2_6, input drv2_7, 	
	input enabq_0, input enabq_1, input enabq_2, input enabq_3, input enabq_4, input enabq_5, input enabq_6, input enabq_7,
	input enq_0, input enq_1, input enq_2, input enq_3, input enq_4, input enq_5, input enq_6, input enq_7,     
	input pd_0,	input pd_1,	input pd_2,	input pd_3,	input pd_4,	input pd_5,	input pd_6,	input pd_7,	
	input ppen_0,	input ppen_1,	input ppen_2,	input ppen_3,	input ppen_4,	input ppen_5,	input ppen_6,	input ppen_7,
	input prg_slew_0,	input prg_slew_1,	input prg_slew_2,	input prg_slew_3,	input prg_slew_4,	input prg_slew_5,	input prg_slew_6,	input prg_slew_7,
	input puq_0,	input puq_1,	input puq_2,	input puq_3,	input puq_4,	input puq_5,	input puq_6,	input puq_7,
	input pwrup_pull_en_0,	input pwrup_pull_en_1,	input pwrup_pull_en_2,	input pwrup_pull_en_3,	input pwrup_pull_en_4,	input pwrup_pull_en_5,	input pwrup_pull_en_6,	input pwrup_pull_en_7,
	input pwrupzhl_0,	input pwrupzhl_1,	input pwrupzhl_2,	input pwrupzhl_3,	input pwrupzhl_4,	input pwrupzhl_5,	input pwrupzhl_6,	input pwrupzhl_7,
	inout pad_0, inout pad_1, inout pad_2, inout pad_3, inout pad_4, inout pad_5, inout pad_6, inout pad_7,
	output outi_0, output outi_1,	output outi_2,	output outi_3,	output outi_4,	output outi_5,	output outi_6,	output outi_7);
	
	hl_8slice_south_io hl_south_io_inst(                                                                                                                                                         
	 .dq({dq_7, dq_6, dq_5, dq_4, dq_3, dq_2, dq_1, dq_0}),
	 .drv0({drv0_7,drv0_6,drv0_5,drv0_4,drv0_3,drv0_2,drv0_1,drv0_0}),
	 .drv1({drv1_7,drv1_6,drv1_5,drv1_4,drv1_3,drv1_2,drv1_1,drv1_0}),
	 .drv2({drv2_7,drv2_6,drv2_5,drv2_4,drv2_3,drv2_2,drv2_1,drv2_0}),
	 .enabq({enabq_7,enabq_6,enabq_5,enabq_4,enabq_3,enabq_2,enabq_1,enabq_0}),
	 .enq({enq_7,enq_6,enq_5,enq_4,enq_3,enq_2,enq_1,enq_0}),
	 .outi({outi_7,outi_6,outi_5,outi_4,outi_3,outi_2,outi_1,outi_0}),
	 .pad({pad_7, pad_6, pad_5, pad_4, pad_3, pad_2, pad_1, pad_0}),
	 .pd({pd_7,pd_6,pd_5,pd_4,pd_3,pd_2,pd_1,pd_0}),
	 .ppen({ppen_7,ppen_6,ppen_5,ppen_4,ppen_3,ppen_2,ppen_1,ppen_0}),
	 .prg_slew({prg_slew_7,prg_slew_6,prg_slew_5,prg_slew_4,prg_slew_3,prg_slew_2,prg_slew_1,prg_slew_0}),
	 .puq({puq_7,puq_6,puq_5,puq_4,puq_3,puq_2,puq_1,puq_0}),
	 .pwrup_pull_en({pwrup_pull_en_7,pwrup_pull_en_6,pwrup_pull_en_5,pwrup_pull_en_4,pwrup_pull_en_3,pwrup_pull_en_2,pwrup_pull_en_1,pwrup_pull_en_0}),
	 .pwrupzhl({pwrupzhl_7,pwrupzhl_6,pwrupzhl_5,pwrupzhl_4,pwrupzhl_3,pwrupzhl_2,pwrupzhl_1,pwrupzhl_0}));                                                                      

endmodule