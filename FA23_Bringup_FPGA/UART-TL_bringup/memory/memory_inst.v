	memory u0 (
		.clk_clk                                    (_connected_to_clk_clk_),                                    //   input,     width = 1,                       clk.clk
		.emif_fm_0_local_reset_req_local_reset_req  (_connected_to_emif_fm_0_local_reset_req_local_reset_req_),  //   input,     width = 1, emif_fm_0_local_reset_req.local_reset_req
		.emif_fm_0_pll_ref_clk_clk                  (_connected_to_emif_fm_0_pll_ref_clk_clk_),                  //   input,     width = 1,     emif_fm_0_pll_ref_clk.clk
		.emif_fm_0_oct_oct_rzqin                    (_connected_to_emif_fm_0_oct_oct_rzqin_),                    //   input,     width = 1,             emif_fm_0_oct.oct_rzqin
		.emif_fm_0_mem_mem_ck                       (_connected_to_emif_fm_0_mem_mem_ck_),                       //  output,     width = 1,             emif_fm_0_mem.mem_ck
		.emif_fm_0_mem_mem_ck_n                     (_connected_to_emif_fm_0_mem_mem_ck_n_),                     //  output,     width = 1,                          .mem_ck_n
		.emif_fm_0_mem_mem_a                        (_connected_to_emif_fm_0_mem_mem_a_),                        //  output,    width = 17,                          .mem_a
		.emif_fm_0_mem_mem_act_n                    (_connected_to_emif_fm_0_mem_mem_act_n_),                    //  output,     width = 1,                          .mem_act_n
		.emif_fm_0_mem_mem_ba                       (_connected_to_emif_fm_0_mem_mem_ba_),                       //  output,     width = 2,                          .mem_ba
		.emif_fm_0_mem_mem_bg                       (_connected_to_emif_fm_0_mem_mem_bg_),                       //  output,     width = 2,                          .mem_bg
		.emif_fm_0_mem_mem_cke                      (_connected_to_emif_fm_0_mem_mem_cke_),                      //  output,     width = 1,                          .mem_cke
		.emif_fm_0_mem_mem_cs_n                     (_connected_to_emif_fm_0_mem_mem_cs_n_),                     //  output,     width = 1,                          .mem_cs_n
		.emif_fm_0_mem_mem_odt                      (_connected_to_emif_fm_0_mem_mem_odt_),                      //  output,     width = 1,                          .mem_odt
		.emif_fm_0_mem_mem_reset_n                  (_connected_to_emif_fm_0_mem_mem_reset_n_),                  //  output,     width = 1,                          .mem_reset_n
		.emif_fm_0_mem_mem_par                      (_connected_to_emif_fm_0_mem_mem_par_),                      //  output,     width = 1,                          .mem_par
		.emif_fm_0_mem_mem_alert_n                  (_connected_to_emif_fm_0_mem_mem_alert_n_),                  //   input,     width = 1,                          .mem_alert_n
		.emif_fm_0_mem_mem_dqs                      (_connected_to_emif_fm_0_mem_mem_dqs_),                      //   inout,     width = 8,                          .mem_dqs
		.emif_fm_0_mem_mem_dqs_n                    (_connected_to_emif_fm_0_mem_mem_dqs_n_),                    //   inout,     width = 8,                          .mem_dqs_n
		.emif_fm_0_mem_mem_dq                       (_connected_to_emif_fm_0_mem_mem_dq_),                       //   inout,    width = 64,                          .mem_dq
		.emif_fm_0_mem_mem_dbi_n                    (_connected_to_emif_fm_0_mem_mem_dbi_n_),                    //   inout,     width = 8,                          .mem_dbi_n
		.emif_fm_0_emif_calbus_calbus_read          (_connected_to_emif_fm_0_emif_calbus_calbus_read_),          //   input,     width = 1,     emif_fm_0_emif_calbus.calbus_read
		.emif_fm_0_emif_calbus_calbus_write         (_connected_to_emif_fm_0_emif_calbus_calbus_write_),         //   input,     width = 1,                          .calbus_write
		.emif_fm_0_emif_calbus_calbus_address       (_connected_to_emif_fm_0_emif_calbus_calbus_address_),       //   input,    width = 20,                          .calbus_address
		.emif_fm_0_emif_calbus_calbus_wdata         (_connected_to_emif_fm_0_emif_calbus_calbus_wdata_),         //   input,    width = 32,                          .calbus_wdata
		.emif_fm_0_emif_calbus_calbus_rdata         (_connected_to_emif_fm_0_emif_calbus_calbus_rdata_),         //  output,    width = 32,                          .calbus_rdata
		.emif_fm_0_emif_calbus_calbus_seq_param_tbl (_connected_to_emif_fm_0_emif_calbus_calbus_seq_param_tbl_), //  output,  width = 4096,                          .calbus_seq_param_tbl
		.emif_fm_0_emif_calbus_clk_clk              (_connected_to_emif_fm_0_emif_calbus_clk_clk_),              //   input,     width = 1, emif_fm_0_emif_calbus_clk.clk
		.reset_reset                                (_connected_to_reset_reset_)                                 //   input,     width = 1,                     reset.reset
	);

