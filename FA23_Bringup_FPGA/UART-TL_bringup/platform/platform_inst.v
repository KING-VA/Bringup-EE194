	platform u0 (
		.clk_clk                                   (_connected_to_clk_clk_),                                   //   input,   width = 1,                       clk.clk
		.emif_fm_0_local_reset_req_local_reset_req (_connected_to_emif_fm_0_local_reset_req_local_reset_req_), //   input,   width = 1, emif_fm_0_local_reset_req.local_reset_req
		.emif_fm_0_oct_oct_rzqin                   (_connected_to_emif_fm_0_oct_oct_rzqin_),                   //   input,   width = 1,             emif_fm_0_oct.oct_rzqin
		.emif_fm_0_mem_mem_ck                      (_connected_to_emif_fm_0_mem_mem_ck_),                      //  output,   width = 1,             emif_fm_0_mem.mem_ck
		.emif_fm_0_mem_mem_ck_n                    (_connected_to_emif_fm_0_mem_mem_ck_n_),                    //  output,   width = 1,                          .mem_ck_n
		.emif_fm_0_mem_mem_a                       (_connected_to_emif_fm_0_mem_mem_a_),                       //  output,  width = 17,                          .mem_a
		.emif_fm_0_mem_mem_act_n                   (_connected_to_emif_fm_0_mem_mem_act_n_),                   //  output,   width = 1,                          .mem_act_n
		.emif_fm_0_mem_mem_ba                      (_connected_to_emif_fm_0_mem_mem_ba_),                      //  output,   width = 2,                          .mem_ba
		.emif_fm_0_mem_mem_bg                      (_connected_to_emif_fm_0_mem_mem_bg_),                      //  output,   width = 2,                          .mem_bg
		.emif_fm_0_mem_mem_cke                     (_connected_to_emif_fm_0_mem_mem_cke_),                     //  output,   width = 1,                          .mem_cke
		.emif_fm_0_mem_mem_cs_n                    (_connected_to_emif_fm_0_mem_mem_cs_n_),                    //  output,   width = 1,                          .mem_cs_n
		.emif_fm_0_mem_mem_odt                     (_connected_to_emif_fm_0_mem_mem_odt_),                     //  output,   width = 1,                          .mem_odt
		.emif_fm_0_mem_mem_reset_n                 (_connected_to_emif_fm_0_mem_mem_reset_n_),                 //  output,   width = 1,                          .mem_reset_n
		.emif_fm_0_mem_mem_par                     (_connected_to_emif_fm_0_mem_mem_par_),                     //  output,   width = 1,                          .mem_par
		.emif_fm_0_mem_mem_alert_n                 (_connected_to_emif_fm_0_mem_mem_alert_n_),                 //   input,   width = 1,                          .mem_alert_n
		.emif_fm_0_mem_mem_dqs                     (_connected_to_emif_fm_0_mem_mem_dqs_),                     //   inout,   width = 8,                          .mem_dqs
		.emif_fm_0_mem_mem_dqs_n                   (_connected_to_emif_fm_0_mem_mem_dqs_n_),                   //   inout,   width = 8,                          .mem_dqs_n
		.emif_fm_0_mem_mem_dq                      (_connected_to_emif_fm_0_mem_mem_dq_),                      //   inout,  width = 64,                          .mem_dq
		.emif_fm_0_mem_mem_dbi_n                   (_connected_to_emif_fm_0_mem_mem_dbi_n_),                   //   inout,   width = 8,                          .mem_dbi_n
		.reset_reset                               (_connected_to_reset_reset_),                               //   input,   width = 1,                     reset.reset
		.uart_writeresponsevalid_n                 (_connected_to_uart_writeresponsevalid_n_),                 //  output,   width = 1,                      uart.writeresponsevalid_n
		.uart_beginbursttransfer                   (_connected_to_uart_beginbursttransfer_),                   //   input,   width = 1,                          .beginbursttransfer
		.serial_serial_in_ready                    (_connected_to_serial_serial_in_ready_),                    //  output,   width = 1,                    serial.serial_in_ready
		.serial_serial_out_valid                   (_connected_to_serial_serial_out_valid_),                   //  output,   width = 1,                          .serial_out_valid
		.serial_serial_out                         (_connected_to_serial_serial_out_),                         //  output,   width = 1,                          .serial_out
		.serial_led                                (_connected_to_serial_led_),                                //  output,   width = 1,                          .led
		.serial_serial_in_valid                    (_connected_to_serial_serial_in_valid_),                    //   input,   width = 1,                          .serial_in_valid
		.serial_serial_in                          (_connected_to_serial_serial_in_),                          //   input,   width = 1,                          .serial_in
		.serial_serial_out_ready                   (_connected_to_serial_serial_out_ready_)                    //   input,   width = 1,                          .serial_out_ready
	);

