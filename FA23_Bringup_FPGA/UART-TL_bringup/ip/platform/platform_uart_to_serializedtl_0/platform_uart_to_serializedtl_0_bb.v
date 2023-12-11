module platform_uart_to_serializedtl_0 (
		input  wire        clock,                   //        clock_reset.clk
		input  wire        reset,                   //              reset.reset
		input  wire        axi_ios_0_aw_ready,      // altera_axi4_master.awready
		input  wire        axi_ios_0_w_ready,       //                   .wready
		input  wire        axi_ios_0_b_valid,       //                   .bvalid
		input  wire [3:0]  axi_ios_0_b_bits_id,     //                   .bid
		input  wire [1:0]  axi_ios_0_b_bits_resp,   //                   .bresp
		input  wire        axi_ios_0_ar_ready,      //                   .arready
		input  wire        axi_ios_0_r_valid,       //                   .rvalid
		input  wire [3:0]  axi_ios_0_r_bits_id,     //                   .rid
		input  wire [63:0] axi_ios_0_r_bits_data,   //                   .rdata
		input  wire [1:0]  axi_ios_0_r_bits_resp,   //                   .rresp
		input  wire        axi_ios_0_r_bits_last,   //                   .rlast
		output wire        axi_ios_0_aw_valid,      //                   .awvalid
		output wire [3:0]  axi_ios_0_aw_bits_id,    //                   .awid
		output wire [36:0] axi_ios_0_aw_bits_addr,  //                   .awaddr
		output wire [7:0]  axi_ios_0_aw_bits_len,   //                   .awlen
		output wire [2:0]  axi_ios_0_aw_bits_size,  //                   .awsize
		output wire [1:0]  axi_ios_0_aw_bits_burst, //                   .awburst
		output wire        axi_ios_0_aw_bits_lock,  //                   .awlock
		output wire [3:0]  axi_ios_0_aw_bits_cache, //                   .awcache
		output wire [2:0]  axi_ios_0_aw_bits_prot,  //                   .awprot
		output wire [3:0]  axi_ios_0_aw_bits_qos,   //                   .awqos
		output wire        axi_ios_0_w_valid,       //                   .wvalid
		output wire [63:0] axi_ios_0_w_bits_data,   //                   .wdata
		output wire [7:0]  axi_ios_0_w_bits_strb,   //                   .wstrb
		output wire        axi_ios_0_w_bits_last,   //                   .wlast
		output wire        axi_ios_0_b_ready,       //                   .bready
		output wire        axi_ios_0_ar_valid,      //                   .arvalid
		output wire [3:0]  axi_ios_0_ar_bits_id,    //                   .arid
		output wire [36:0] axi_ios_0_ar_bits_addr,  //                   .araddr
		output wire [7:0]  axi_ios_0_ar_bits_len,   //                   .arlen
		output wire [2:0]  axi_ios_0_ar_bits_size,  //                   .arsize
		output wire [1:0]  axi_ios_0_ar_bits_burst, //                   .arburst
		output wire        axi_ios_0_ar_bits_lock,  //                   .arlock
		output wire [3:0]  axi_ios_0_ar_bits_cache, //                   .arcache
		output wire [2:0]  axi_ios_0_ar_bits_prot,  //                   .arprot
		output wire [3:0]  axi_ios_0_ar_bits_qos,   //                   .arqos
		output wire        axi_ios_0_r_ready,       //                   .rready
		output wire        io_uart_txd,             //               uart.writeresponsevalid_n
		input  wire        io_uart_rxd,             //                   .beginbursttransfer
		output wire        io_serial_in_ready,      //             serial.serial_in_ready
		output wire        io_serial_out_valid,     //                   .serial_out_valid
		output wire        io_serial_out_bits,      //                   .serial_out
		output wire        io_dropped,              //                   .led
		input  wire        io_serial_in_valid,      //                   .serial_in_valid
		input  wire        io_serial_in_bits,       //                   .serial_in
		input  wire        io_serial_out_ready      //                   .serial_out_ready
	);
endmodule

