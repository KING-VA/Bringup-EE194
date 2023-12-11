module platform (
		input  wire        clk_clk,                                   //                       clk.clk
		input  wire        emif_fm_0_local_reset_req_local_reset_req, // emif_fm_0_local_reset_req.local_reset_req
		input  wire        emif_fm_0_oct_oct_rzqin,                   //             emif_fm_0_oct.oct_rzqin
		output wire [0:0]  emif_fm_0_mem_mem_ck,                      //             emif_fm_0_mem.mem_ck
		output wire [0:0]  emif_fm_0_mem_mem_ck_n,                    //                          .mem_ck_n
		output wire [16:0] emif_fm_0_mem_mem_a,                       //                          .mem_a
		output wire [0:0]  emif_fm_0_mem_mem_act_n,                   //                          .mem_act_n
		output wire [1:0]  emif_fm_0_mem_mem_ba,                      //                          .mem_ba
		output wire [1:0]  emif_fm_0_mem_mem_bg,                      //                          .mem_bg
		output wire [0:0]  emif_fm_0_mem_mem_cke,                     //                          .mem_cke
		output wire [0:0]  emif_fm_0_mem_mem_cs_n,                    //                          .mem_cs_n
		output wire [0:0]  emif_fm_0_mem_mem_odt,                     //                          .mem_odt
		output wire [0:0]  emif_fm_0_mem_mem_reset_n,                 //                          .mem_reset_n
		output wire [0:0]  emif_fm_0_mem_mem_par,                     //                          .mem_par
		input  wire [0:0]  emif_fm_0_mem_mem_alert_n,                 //                          .mem_alert_n
		inout  wire [7:0]  emif_fm_0_mem_mem_dqs,                     //                          .mem_dqs
		inout  wire [7:0]  emif_fm_0_mem_mem_dqs_n,                   //                          .mem_dqs_n
		inout  wire [63:0] emif_fm_0_mem_mem_dq,                      //                          .mem_dq
		inout  wire [7:0]  emif_fm_0_mem_mem_dbi_n,                   //                          .mem_dbi_n
		input  wire        reset_reset,                               //                     reset.reset
		output wire        uart_writeresponsevalid_n,                 //                      uart.writeresponsevalid_n
		input  wire        uart_beginbursttransfer,                   //                          .beginbursttransfer
		output wire        serial_serial_in_ready,                    //                    serial.serial_in_ready
		output wire        serial_serial_out_valid,                   //                          .serial_out_valid
		output wire        serial_serial_out,                         //                          .serial_out
		output wire        serial_led,                                //                          .led
		input  wire        serial_serial_in_valid,                    //                          .serial_in_valid
		input  wire        serial_serial_in,                          //                          .serial_in
		input  wire        serial_serial_out_ready                    //                          .serial_out_ready
	);
endmodule

