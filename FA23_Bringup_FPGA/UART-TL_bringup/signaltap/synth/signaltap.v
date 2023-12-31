// signaltap.v

// Generated using ACDS version 22.4 94

`timescale 1 ps / 1 ps
module signaltap (
		input  wire [63:0] acq_data_in,    //     tap.acq_data_in
		input  wire [31:0] acq_trigger_in, //        .acq_trigger_in
		input  wire        acq_clk         // acq_clk.clk
	);

	sld_signaltap_syn #(
		.SLD_DATA_BITS               (64),
		.SLD_SAMPLE_DEPTH            (131072),
		.SLD_RAM_BLOCK_TYPE          ("AUTO"),
		.SLD_STORAGE_QUALIFIER_MODE  ("OFF"),
		.SLD_TRIGGER_BITS            (32),
		.SLD_TRIGGER_LEVEL           (1),
		.SLD_TRIGGER_IN_ENABLED      (0),
		.SLD_ENABLE_ADVANCED_TRIGGER (0),
		.SLD_TRIGGER_LEVEL_PIPELINE  (1),
		.SLD_TRIGGER_PIPELINE        (0),
		.SLD_RAM_PIPELINE            (0),
		.SLD_COUNTER_PIPELINE        (0),
		.SLD_NODE_INFO               (806383104),
		.SLD_INCREMENTAL_ROUTING     (0),
		.SLD_NODE_CRC_BITS           (32),
		.SLD_NODE_CRC_HIWORD         (12216),
		.SLD_NODE_CRC_LOWORD         (13207)
	) signaltap_ii_logic_analyzer_0 (
		.acq_data_in    (acq_data_in),    //   input,  width = 64,     tap.acq_data_in
		.acq_trigger_in (acq_trigger_in), //   input,  width = 32,        .acq_trigger_in
		.acq_clk        (acq_clk)         //   input,   width = 1, acq_clk.clk
	);

endmodule
