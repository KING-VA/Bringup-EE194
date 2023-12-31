	platform_uart_to_serializedtl_0 u0 (
		.clock                   (_connected_to_clock_),                   //   input,   width = 1,        clock_reset.clk
		.reset                   (_connected_to_reset_),                   //   input,   width = 1,              reset.reset
		.axi_ios_0_aw_ready      (_connected_to_axi_ios_0_aw_ready_),      //   input,   width = 1, altera_axi4_master.awready
		.axi_ios_0_w_ready       (_connected_to_axi_ios_0_w_ready_),       //   input,   width = 1,                   .wready
		.axi_ios_0_b_valid       (_connected_to_axi_ios_0_b_valid_),       //   input,   width = 1,                   .bvalid
		.axi_ios_0_b_bits_id     (_connected_to_axi_ios_0_b_bits_id_),     //   input,   width = 4,                   .bid
		.axi_ios_0_b_bits_resp   (_connected_to_axi_ios_0_b_bits_resp_),   //   input,   width = 2,                   .bresp
		.axi_ios_0_ar_ready      (_connected_to_axi_ios_0_ar_ready_),      //   input,   width = 1,                   .arready
		.axi_ios_0_r_valid       (_connected_to_axi_ios_0_r_valid_),       //   input,   width = 1,                   .rvalid
		.axi_ios_0_r_bits_id     (_connected_to_axi_ios_0_r_bits_id_),     //   input,   width = 4,                   .rid
		.axi_ios_0_r_bits_data   (_connected_to_axi_ios_0_r_bits_data_),   //   input,  width = 64,                   .rdata
		.axi_ios_0_r_bits_resp   (_connected_to_axi_ios_0_r_bits_resp_),   //   input,   width = 2,                   .rresp
		.axi_ios_0_r_bits_last   (_connected_to_axi_ios_0_r_bits_last_),   //   input,   width = 1,                   .rlast
		.axi_ios_0_aw_valid      (_connected_to_axi_ios_0_aw_valid_),      //  output,   width = 1,                   .awvalid
		.axi_ios_0_aw_bits_id    (_connected_to_axi_ios_0_aw_bits_id_),    //  output,   width = 4,                   .awid
		.axi_ios_0_aw_bits_addr  (_connected_to_axi_ios_0_aw_bits_addr_),  //  output,  width = 37,                   .awaddr
		.axi_ios_0_aw_bits_len   (_connected_to_axi_ios_0_aw_bits_len_),   //  output,   width = 8,                   .awlen
		.axi_ios_0_aw_bits_size  (_connected_to_axi_ios_0_aw_bits_size_),  //  output,   width = 3,                   .awsize
		.axi_ios_0_aw_bits_burst (_connected_to_axi_ios_0_aw_bits_burst_), //  output,   width = 2,                   .awburst
		.axi_ios_0_aw_bits_lock  (_connected_to_axi_ios_0_aw_bits_lock_),  //  output,   width = 1,                   .awlock
		.axi_ios_0_aw_bits_cache (_connected_to_axi_ios_0_aw_bits_cache_), //  output,   width = 4,                   .awcache
		.axi_ios_0_aw_bits_prot  (_connected_to_axi_ios_0_aw_bits_prot_),  //  output,   width = 3,                   .awprot
		.axi_ios_0_aw_bits_qos   (_connected_to_axi_ios_0_aw_bits_qos_),   //  output,   width = 4,                   .awqos
		.axi_ios_0_w_valid       (_connected_to_axi_ios_0_w_valid_),       //  output,   width = 1,                   .wvalid
		.axi_ios_0_w_bits_data   (_connected_to_axi_ios_0_w_bits_data_),   //  output,  width = 64,                   .wdata
		.axi_ios_0_w_bits_strb   (_connected_to_axi_ios_0_w_bits_strb_),   //  output,   width = 8,                   .wstrb
		.axi_ios_0_w_bits_last   (_connected_to_axi_ios_0_w_bits_last_),   //  output,   width = 1,                   .wlast
		.axi_ios_0_b_ready       (_connected_to_axi_ios_0_b_ready_),       //  output,   width = 1,                   .bready
		.axi_ios_0_ar_valid      (_connected_to_axi_ios_0_ar_valid_),      //  output,   width = 1,                   .arvalid
		.axi_ios_0_ar_bits_id    (_connected_to_axi_ios_0_ar_bits_id_),    //  output,   width = 4,                   .arid
		.axi_ios_0_ar_bits_addr  (_connected_to_axi_ios_0_ar_bits_addr_),  //  output,  width = 37,                   .araddr
		.axi_ios_0_ar_bits_len   (_connected_to_axi_ios_0_ar_bits_len_),   //  output,   width = 8,                   .arlen
		.axi_ios_0_ar_bits_size  (_connected_to_axi_ios_0_ar_bits_size_),  //  output,   width = 3,                   .arsize
		.axi_ios_0_ar_bits_burst (_connected_to_axi_ios_0_ar_bits_burst_), //  output,   width = 2,                   .arburst
		.axi_ios_0_ar_bits_lock  (_connected_to_axi_ios_0_ar_bits_lock_),  //  output,   width = 1,                   .arlock
		.axi_ios_0_ar_bits_cache (_connected_to_axi_ios_0_ar_bits_cache_), //  output,   width = 4,                   .arcache
		.axi_ios_0_ar_bits_prot  (_connected_to_axi_ios_0_ar_bits_prot_),  //  output,   width = 3,                   .arprot
		.axi_ios_0_ar_bits_qos   (_connected_to_axi_ios_0_ar_bits_qos_),   //  output,   width = 4,                   .arqos
		.axi_ios_0_r_ready       (_connected_to_axi_ios_0_r_ready_),       //  output,   width = 1,                   .rready
		.io_uart_txd             (_connected_to_io_uart_txd_),             //  output,   width = 1,               uart.writeresponsevalid_n
		.io_uart_rxd             (_connected_to_io_uart_rxd_),             //   input,   width = 1,                   .beginbursttransfer
		.io_serial_in_ready      (_connected_to_io_serial_in_ready_),      //  output,   width = 1,             serial.serial_in_ready
		.io_serial_out_valid     (_connected_to_io_serial_out_valid_),     //  output,   width = 1,                   .serial_out_valid
		.io_serial_out_bits      (_connected_to_io_serial_out_bits_),      //  output,   width = 1,                   .serial_out
		.io_dropped              (_connected_to_io_dropped_),              //  output,   width = 1,                   .led
		.io_serial_in_valid      (_connected_to_io_serial_in_valid_),      //   input,   width = 1,                   .serial_in_valid
		.io_serial_in_bits       (_connected_to_io_serial_in_bits_),       //   input,   width = 1,                   .serial_in
		.io_serial_out_ready     (_connected_to_io_serial_out_ready_)      //   input,   width = 1,                   .serial_out_ready
	);

