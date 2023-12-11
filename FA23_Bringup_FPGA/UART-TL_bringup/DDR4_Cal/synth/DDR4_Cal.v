// DDR4_Cal.v

// Generated using ACDS version 22.4 94

`timescale 1 ps / 1 ps
module DDR4_Cal (
		output wire          calbus_read_0,          //   emif_calbus_0.calbus_read,          EMIF Calibration component bus for read
		output wire          calbus_write_0,         //                .calbus_write,         EMIF Calibration component bus for write
		output wire [19:0]   calbus_address_0,       //                .calbus_address,       EMIF Calibration component bus for address
		output wire [31:0]   calbus_wdata_0,         //                .calbus_wdata,         EMIF Calibration component bus for write data
		input  wire [31:0]   calbus_rdata_0,         //                .calbus_rdata,         EMIF Calibration component bus for read data
		input  wire [4095:0] calbus_seq_param_tbl_0, //                .calbus_seq_param_tbl, EMIF Calibration component bus for parameter table data
		output wire          calbus_read_1,          //   emif_calbus_1.calbus_read,          EMIF Calibration component bus for read
		output wire          calbus_write_1,         //                .calbus_write,         EMIF Calibration component bus for write
		output wire [19:0]   calbus_address_1,       //                .calbus_address,       EMIF Calibration component bus for address
		output wire [31:0]   calbus_wdata_1,         //                .calbus_wdata,         EMIF Calibration component bus for write data
		input  wire [31:0]   calbus_rdata_1,         //                .calbus_rdata,         EMIF Calibration component bus for read data
		input  wire [4095:0] calbus_seq_param_tbl_1, //                .calbus_seq_param_tbl, EMIF Calibration component bus for parameter table data
		output wire          calbus_clk              // emif_calbus_clk.clk,                  EMIF Calibration component bus for the clock
	);

	DDR4_Cal_altera_emif_cal_262_c4fgnxa emif_cal_0 (
		.calbus_read_0          (calbus_read_0),          //  output,     width = 1,   emif_calbus_0.calbus_read
		.calbus_write_0         (calbus_write_0),         //  output,     width = 1,                .calbus_write
		.calbus_address_0       (calbus_address_0),       //  output,    width = 20,                .calbus_address
		.calbus_wdata_0         (calbus_wdata_0),         //  output,    width = 32,                .calbus_wdata
		.calbus_rdata_0         (calbus_rdata_0),         //   input,    width = 32,                .calbus_rdata
		.calbus_seq_param_tbl_0 (calbus_seq_param_tbl_0), //   input,  width = 4096,                .calbus_seq_param_tbl
		.calbus_read_1          (calbus_read_1),          //  output,     width = 1,   emif_calbus_1.calbus_read
		.calbus_write_1         (calbus_write_1),         //  output,     width = 1,                .calbus_write
		.calbus_address_1       (calbus_address_1),       //  output,    width = 20,                .calbus_address
		.calbus_wdata_1         (calbus_wdata_1),         //  output,    width = 32,                .calbus_wdata
		.calbus_rdata_1         (calbus_rdata_1),         //   input,    width = 32,                .calbus_rdata
		.calbus_seq_param_tbl_1 (calbus_seq_param_tbl_1), //   input,  width = 4096,                .calbus_seq_param_tbl
		.calbus_clk             (calbus_clk)              //  output,     width = 1, emif_calbus_clk.clk
	);

endmodule
