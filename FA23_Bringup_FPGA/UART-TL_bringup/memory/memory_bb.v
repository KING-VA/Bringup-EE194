module memory (
		input  wire          clk_clk,                                    //                       clk.clk
		input  wire          emif_fm_0_local_reset_req_local_reset_req,  // emif_fm_0_local_reset_req.local_reset_req
		input  wire          emif_fm_0_pll_ref_clk_clk,                  //     emif_fm_0_pll_ref_clk.clk
		input  wire          emif_fm_0_oct_oct_rzqin,                    //             emif_fm_0_oct.oct_rzqin
		output wire [0:0]    emif_fm_0_mem_mem_ck,                       //             emif_fm_0_mem.mem_ck
		output wire [0:0]    emif_fm_0_mem_mem_ck_n,                     //                          .mem_ck_n
		output wire [16:0]   emif_fm_0_mem_mem_a,                        //                          .mem_a
		output wire [0:0]    emif_fm_0_mem_mem_act_n,                    //                          .mem_act_n
		output wire [1:0]    emif_fm_0_mem_mem_ba,                       //                          .mem_ba
		output wire [1:0]    emif_fm_0_mem_mem_bg,                       //                          .mem_bg
		output wire [0:0]    emif_fm_0_mem_mem_cke,                      //                          .mem_cke
		output wire [0:0]    emif_fm_0_mem_mem_cs_n,                     //                          .mem_cs_n
		output wire [0:0]    emif_fm_0_mem_mem_odt,                      //                          .mem_odt
		output wire [0:0]    emif_fm_0_mem_mem_reset_n,                  //                          .mem_reset_n
		output wire [0:0]    emif_fm_0_mem_mem_par,                      //                          .mem_par
		input  wire [0:0]    emif_fm_0_mem_mem_alert_n,                  //                          .mem_alert_n
		inout  wire [7:0]    emif_fm_0_mem_mem_dqs,                      //                          .mem_dqs
		inout  wire [7:0]    emif_fm_0_mem_mem_dqs_n,                    //                          .mem_dqs_n
		inout  wire [63:0]   emif_fm_0_mem_mem_dq,                       //                          .mem_dq
		inout  wire [7:0]    emif_fm_0_mem_mem_dbi_n,                    //                          .mem_dbi_n
		input  wire          emif_fm_0_emif_calbus_calbus_read,          //     emif_fm_0_emif_calbus.calbus_read
		input  wire          emif_fm_0_emif_calbus_calbus_write,         //                          .calbus_write
		input  wire [19:0]   emif_fm_0_emif_calbus_calbus_address,       //                          .calbus_address
		input  wire [31:0]   emif_fm_0_emif_calbus_calbus_wdata,         //                          .calbus_wdata
		output wire [31:0]   emif_fm_0_emif_calbus_calbus_rdata,         //                          .calbus_rdata
		output wire [4095:0] emif_fm_0_emif_calbus_calbus_seq_param_tbl, //                          .calbus_seq_param_tbl
		input  wire          emif_fm_0_emif_calbus_clk_clk,              // emif_fm_0_emif_calbus_clk.clk
		input  wire          reset_reset                                 //                     reset.reset
	);
endmodule

