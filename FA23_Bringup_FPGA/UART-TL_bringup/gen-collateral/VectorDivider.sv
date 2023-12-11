// Generated by CIRCT unknown git version
// Standard header to adapt well known macros to our needs.
`ifndef RANDOMIZE
  `ifdef RANDOMIZE_REG_INIT
    `define RANDOMIZE
  `endif // RANDOMIZE_REG_INIT
`endif // not def RANDOMIZE
`ifndef RANDOMIZE
  `ifdef RANDOMIZE_MEM_INIT
    `define RANDOMIZE
  `endif // RANDOMIZE_MEM_INIT
`endif // not def RANDOMIZE

// RANDOM may be set to an expression that produces a 32-bit random unsigned value.
`ifndef RANDOM
  `define RANDOM $random
`endif // not def RANDOM

// Users can define 'PRINTF_COND' to add an extra gate to prints.
`ifndef PRINTF_COND_
  `ifdef PRINTF_COND
    `define PRINTF_COND_ (`PRINTF_COND)
  `else  // PRINTF_COND
    `define PRINTF_COND_ 1
  `endif // PRINTF_COND
`endif // not def PRINTF_COND_

// Users can define 'ASSERT_VERBOSE_COND' to add an extra gate to assert error printing.
`ifndef ASSERT_VERBOSE_COND_
  `ifdef ASSERT_VERBOSE_COND
    `define ASSERT_VERBOSE_COND_ (`ASSERT_VERBOSE_COND)
  `else  // ASSERT_VERBOSE_COND
    `define ASSERT_VERBOSE_COND_ 1
  `endif // ASSERT_VERBOSE_COND
`endif // not def ASSERT_VERBOSE_COND_

// Users can define 'STOP_COND' to add an extra gate to stop conditions.
`ifndef STOP_COND_
  `ifdef STOP_COND
    `define STOP_COND_ (`STOP_COND)
  `else  // STOP_COND
    `define STOP_COND_ 1
  `endif // STOP_COND
`endif // not def STOP_COND_

// Users can define INIT_RANDOM as general code that gets injected into the
// initializer block for modules with registers.
`ifndef INIT_RANDOM
  `define INIT_RANDOM
`endif // not def INIT_RANDOM

// If using random initialization, you can also define RANDOMIZE_DELAY to
// customize the delay used, otherwise 0.002 is used.
`ifndef RANDOMIZE_DELAY
  `define RANDOMIZE_DELAY 0.002
`endif // not def RANDOMIZE_DELAY

// Define INIT_RANDOM_PROLOG_ for use in our modules below.
`ifndef INIT_RANDOM_PROLOG_
  `ifdef RANDOMIZE
    `ifdef VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM
    `else  // VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM #`RANDOMIZE_DELAY begin end
    `endif // VERILATOR
  `else  // RANDOMIZE
    `define INIT_RANDOM_PROLOG_
  `endif // RANDOMIZE
`endif // not def INIT_RANDOM_PROLOG_

module VectorDivider(
  input         clock,
                reset,
                io_in_valid,
  input  [32:0] io_in_bits_inputs_0_0,
                io_in_bits_inputs_0_1,
                io_in_bits_inputs_0_2,
                io_in_bits_inputs_0_3,
                io_in_bits_inputs_0_4,
                io_in_bits_inputs_0_5,
                io_in_bits_inputs_0_6,
                io_in_bits_inputs_0_7,
                io_in_bits_inputs_1_0,
                io_in_bits_inputs_1_1,
                io_in_bits_inputs_1_2,
                io_in_bits_inputs_1_3,
                io_in_bits_inputs_1_4,
                io_in_bits_inputs_1_5,
                io_in_bits_inputs_1_6,
                io_in_bits_inputs_1_7,
  input         io_in_bits_sqrt,
  output        io_in_ready,
                io_out_valid,
  output [32:0] io_out_bits_0,
                io_out_bits_1,
                io_out_bits_2,
                io_out_bits_3,
                io_out_bits_4,
                io_out_bits_5,
                io_out_bits_6,
                io_out_bits_7
);

  wire       _divider_7_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_7_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_7_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_7_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  wire       _divider_6_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_6_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_6_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_6_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  wire       _divider_5_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_5_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_5_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_5_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  wire       _divider_4_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_4_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_4_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_4_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  wire       _divider_3_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_3_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_3_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_3_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  wire       _divider_2_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_2_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_2_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_2_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  wire       _divider_1_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_1_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_1_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_1_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  wire       _divider_io_inReady;	// @[VectorDivider.scala:24:25]
  wire       _divider_io_outValid_div;	// @[VectorDivider.scala:24:25]
  wire       _divider_io_outValid_sqrt;	// @[VectorDivider.scala:24:25]
  wire [4:0] _divider_io_exceptionFlags;	// @[VectorDivider.scala:24:25]
  DivSqrtRecFN_small divider (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_0),
    .io_b              (io_in_bits_inputs_1_0),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_io_inReady),
    .io_outValid_div   (_divider_io_outValid_div),
    .io_outValid_sqrt  (_divider_io_outValid_sqrt),
    .io_out            (io_out_bits_0),
    .io_exceptionFlags (_divider_io_exceptionFlags)
  );
  DivSqrtRecFN_small divider_1 (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_1),
    .io_b              (io_in_bits_inputs_1_1),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_1_io_inReady),
    .io_outValid_div   (_divider_1_io_outValid_div),
    .io_outValid_sqrt  (_divider_1_io_outValid_sqrt),
    .io_out            (io_out_bits_1),
    .io_exceptionFlags (_divider_1_io_exceptionFlags)
  );
  DivSqrtRecFN_small divider_2 (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_2),
    .io_b              (io_in_bits_inputs_1_2),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_2_io_inReady),
    .io_outValid_div   (_divider_2_io_outValid_div),
    .io_outValid_sqrt  (_divider_2_io_outValid_sqrt),
    .io_out            (io_out_bits_2),
    .io_exceptionFlags (_divider_2_io_exceptionFlags)
  );
  DivSqrtRecFN_small divider_3 (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_3),
    .io_b              (io_in_bits_inputs_1_3),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_3_io_inReady),
    .io_outValid_div   (_divider_3_io_outValid_div),
    .io_outValid_sqrt  (_divider_3_io_outValid_sqrt),
    .io_out            (io_out_bits_3),
    .io_exceptionFlags (_divider_3_io_exceptionFlags)
  );
  DivSqrtRecFN_small divider_4 (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_4),
    .io_b              (io_in_bits_inputs_1_4),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_4_io_inReady),
    .io_outValid_div   (_divider_4_io_outValid_div),
    .io_outValid_sqrt  (_divider_4_io_outValid_sqrt),
    .io_out            (io_out_bits_4),
    .io_exceptionFlags (_divider_4_io_exceptionFlags)
  );
  DivSqrtRecFN_small divider_5 (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_5),
    .io_b              (io_in_bits_inputs_1_5),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_5_io_inReady),
    .io_outValid_div   (_divider_5_io_outValid_div),
    .io_outValid_sqrt  (_divider_5_io_outValid_sqrt),
    .io_out            (io_out_bits_5),
    .io_exceptionFlags (_divider_5_io_exceptionFlags)
  );
  DivSqrtRecFN_small divider_6 (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_6),
    .io_b              (io_in_bits_inputs_1_6),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_6_io_inReady),
    .io_outValid_div   (_divider_6_io_outValid_div),
    .io_outValid_sqrt  (_divider_6_io_outValid_sqrt),
    .io_out            (io_out_bits_6),
    .io_exceptionFlags (_divider_6_io_exceptionFlags)
  );
  DivSqrtRecFN_small divider_7 (	// @[VectorDivider.scala:24:25]
    .clock             (clock),
    .reset             (reset),
    .io_inValid        (io_in_valid),
    .io_sqrtOp         (io_in_bits_sqrt),
    .io_a              (io_in_bits_inputs_0_7),
    .io_b              (io_in_bits_inputs_1_7),
    .io_roundingMode   (3'h3),	// @[VectorDivider.scala:29:29]
    .io_detectTininess (1'h0),	// @[VectorDivider.scala:30:31]
    .io_inReady        (_divider_7_io_inReady),
    .io_outValid_div   (_divider_7_io_outValid_div),
    .io_outValid_sqrt  (_divider_7_io_outValid_sqrt),
    .io_out            (io_out_bits_7),
    .io_exceptionFlags (_divider_7_io_exceptionFlags)
  );
  assign io_in_ready = _divider_io_inReady & _divider_1_io_inReady & _divider_2_io_inReady & _divider_3_io_inReady & _divider_4_io_inReady & _divider_5_io_inReady & _divider_6_io_inReady & _divider_7_io_inReady;	// @[VectorDivider.scala:24:25, :39:48]
  assign io_out_valid = (io_in_bits_sqrt ? _divider_io_outValid_sqrt : _divider_io_outValid_div) & (io_in_bits_sqrt ? _divider_1_io_outValid_sqrt : _divider_1_io_outValid_div) & (io_in_bits_sqrt ? _divider_2_io_outValid_sqrt : _divider_2_io_outValid_div) & (io_in_bits_sqrt ? _divider_3_io_outValid_sqrt : _divider_3_io_outValid_div) & (io_in_bits_sqrt ? _divider_4_io_outValid_sqrt : _divider_4_io_outValid_div) & (io_in_bits_sqrt ? _divider_5_io_outValid_sqrt : _divider_5_io_outValid_div) & (io_in_bits_sqrt ? _divider_6_io_outValid_sqrt : _divider_6_io_outValid_div) & (io_in_bits_sqrt ? _divider_7_io_outValid_sqrt : _divider_7_io_outValid_div);	// @[VectorDivider.scala:24:25, :35:13, :38:50]
endmodule

