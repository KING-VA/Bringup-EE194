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

module dotCompute(
  input         clock,
                reset,
  input  [31:0] io_vec1_0,
                io_vec1_1,
                io_vec1_2,
                io_vec1_3,
                io_vec1_4,
                io_vec1_5,
                io_vec1_6,
                io_vec1_7,
                io_vec1_8,
                io_vec1_9,
                io_vec1_10,
                io_vec1_11,
                io_vec1_12,
                io_vec1_13,
                io_vec1_14,
                io_vec1_15,
                io_vec2_0,
                io_vec2_1,
                io_vec2_2,
                io_vec2_3,
                io_vec2_4,
                io_vec2_5,
                io_vec2_6,
                io_vec2_7,
                io_vec2_8,
                io_vec2_9,
                io_vec2_10,
                io_vec2_11,
                io_vec2_12,
                io_vec2_13,
                io_vec2_14,
                io_vec2_15,
  output [31:0] io_out
);

  wire [31:0] _floatMul_15_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_14_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_13_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_12_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_11_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_10_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_9_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_8_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_7_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_6_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_5_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_4_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_3_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_2_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_1_io_out;	// @[dotCompute.scala:18:40]
  wire [31:0] _floatMul_io_out;	// @[dotCompute.scala:18:40]
  reg  [31:0] mul_result_vec_0;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_1;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_2;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_3;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_4;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_5;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_6;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_7;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_8;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_9;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_10;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_11;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_12;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_13;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_14;	// @[dotCompute.scala:21:33]
  reg  [31:0] mul_result_vec_15;	// @[dotCompute.scala:21:33]
  always @(posedge clock) begin
    if (reset) begin
      mul_result_vec_0 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_1 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_2 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_3 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_4 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_5 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_6 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_7 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_8 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_9 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_10 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_11 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_12 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_13 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_14 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
      mul_result_vec_15 <= 32'h0;	// @[dotCompute.scala:21:{33,41}]
    end
    else begin
      mul_result_vec_0 <= _floatMul_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_1 <= _floatMul_1_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_2 <= _floatMul_2_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_3 <= _floatMul_3_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_4 <= _floatMul_4_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_5 <= _floatMul_5_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_6 <= _floatMul_6_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_7 <= _floatMul_7_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_8 <= _floatMul_8_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_9 <= _floatMul_9_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_10 <= _floatMul_10_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_11 <= _floatMul_11_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_12 <= _floatMul_12_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_13 <= _floatMul_13_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_14 <= _floatMul_14_io_out;	// @[dotCompute.scala:18:40, :21:33]
      mul_result_vec_15 <= _floatMul_15_io_out;	// @[dotCompute.scala:18:40, :21:33]
    end
  end // always @(posedge)
  `ifndef SYNTHESIS
    `ifdef FIRRTL_BEFORE_INITIAL
      `FIRRTL_BEFORE_INITIAL
    `endif // FIRRTL_BEFORE_INITIAL
    logic [31:0] _RANDOM_0;
    logic [31:0] _RANDOM_1;
    logic [31:0] _RANDOM_2;
    logic [31:0] _RANDOM_3;
    logic [31:0] _RANDOM_4;
    logic [31:0] _RANDOM_5;
    logic [31:0] _RANDOM_6;
    logic [31:0] _RANDOM_7;
    logic [31:0] _RANDOM_8;
    logic [31:0] _RANDOM_9;
    logic [31:0] _RANDOM_10;
    logic [31:0] _RANDOM_11;
    logic [31:0] _RANDOM_12;
    logic [31:0] _RANDOM_13;
    logic [31:0] _RANDOM_14;
    logic [31:0] _RANDOM_15;
    initial begin
      `ifdef INIT_RANDOM_PROLOG_
        `INIT_RANDOM_PROLOG_
      `endif // INIT_RANDOM_PROLOG_
      `ifdef RANDOMIZE_REG_INIT
        _RANDOM_0 = `RANDOM;
        _RANDOM_1 = `RANDOM;
        _RANDOM_2 = `RANDOM;
        _RANDOM_3 = `RANDOM;
        _RANDOM_4 = `RANDOM;
        _RANDOM_5 = `RANDOM;
        _RANDOM_6 = `RANDOM;
        _RANDOM_7 = `RANDOM;
        _RANDOM_8 = `RANDOM;
        _RANDOM_9 = `RANDOM;
        _RANDOM_10 = `RANDOM;
        _RANDOM_11 = `RANDOM;
        _RANDOM_12 = `RANDOM;
        _RANDOM_13 = `RANDOM;
        _RANDOM_14 = `RANDOM;
        _RANDOM_15 = `RANDOM;
        mul_result_vec_0 = _RANDOM_0;	// @[dotCompute.scala:21:33]
        mul_result_vec_1 = _RANDOM_1;	// @[dotCompute.scala:21:33]
        mul_result_vec_2 = _RANDOM_2;	// @[dotCompute.scala:21:33]
        mul_result_vec_3 = _RANDOM_3;	// @[dotCompute.scala:21:33]
        mul_result_vec_4 = _RANDOM_4;	// @[dotCompute.scala:21:33]
        mul_result_vec_5 = _RANDOM_5;	// @[dotCompute.scala:21:33]
        mul_result_vec_6 = _RANDOM_6;	// @[dotCompute.scala:21:33]
        mul_result_vec_7 = _RANDOM_7;	// @[dotCompute.scala:21:33]
        mul_result_vec_8 = _RANDOM_8;	// @[dotCompute.scala:21:33]
        mul_result_vec_9 = _RANDOM_9;	// @[dotCompute.scala:21:33]
        mul_result_vec_10 = _RANDOM_10;	// @[dotCompute.scala:21:33]
        mul_result_vec_11 = _RANDOM_11;	// @[dotCompute.scala:21:33]
        mul_result_vec_12 = _RANDOM_12;	// @[dotCompute.scala:21:33]
        mul_result_vec_13 = _RANDOM_13;	// @[dotCompute.scala:21:33]
        mul_result_vec_14 = _RANDOM_14;	// @[dotCompute.scala:21:33]
        mul_result_vec_15 = _RANDOM_15;	// @[dotCompute.scala:21:33]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  floatMul floatMul (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_0),
    .io_in1 (io_vec2_0),
    .io_out (_floatMul_io_out)
  );
  floatMul floatMul_1 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_1),
    .io_in1 (io_vec2_1),
    .io_out (_floatMul_1_io_out)
  );
  floatMul floatMul_2 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_2),
    .io_in1 (io_vec2_2),
    .io_out (_floatMul_2_io_out)
  );
  floatMul floatMul_3 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_3),
    .io_in1 (io_vec2_3),
    .io_out (_floatMul_3_io_out)
  );
  floatMul floatMul_4 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_4),
    .io_in1 (io_vec2_4),
    .io_out (_floatMul_4_io_out)
  );
  floatMul floatMul_5 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_5),
    .io_in1 (io_vec2_5),
    .io_out (_floatMul_5_io_out)
  );
  floatMul floatMul_6 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_6),
    .io_in1 (io_vec2_6),
    .io_out (_floatMul_6_io_out)
  );
  floatMul floatMul_7 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_7),
    .io_in1 (io_vec2_7),
    .io_out (_floatMul_7_io_out)
  );
  floatMul floatMul_8 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_8),
    .io_in1 (io_vec2_8),
    .io_out (_floatMul_8_io_out)
  );
  floatMul floatMul_9 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_9),
    .io_in1 (io_vec2_9),
    .io_out (_floatMul_9_io_out)
  );
  floatMul floatMul_10 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_10),
    .io_in1 (io_vec2_10),
    .io_out (_floatMul_10_io_out)
  );
  floatMul floatMul_11 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_11),
    .io_in1 (io_vec2_11),
    .io_out (_floatMul_11_io_out)
  );
  floatMul floatMul_12 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_12),
    .io_in1 (io_vec2_12),
    .io_out (_floatMul_12_io_out)
  );
  floatMul floatMul_13 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_13),
    .io_in1 (io_vec2_13),
    .io_out (_floatMul_13_io_out)
  );
  floatMul floatMul_14 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_14),
    .io_in1 (io_vec2_14),
    .io_out (_floatMul_14_io_out)
  );
  floatMul floatMul_15 (	// @[dotCompute.scala:18:40]
    .io_in0 (io_vec1_15),
    .io_in1 (io_vec2_15),
    .io_out (_floatMul_15_io_out)
  );
  floatAddTree floatAddTree (	// @[dotCompute.scala:28:27]
    .clock     (clock),
    .reset     (reset),
    .io_vec_0  (mul_result_vec_0),	// @[dotCompute.scala:21:33]
    .io_vec_1  (mul_result_vec_1),	// @[dotCompute.scala:21:33]
    .io_vec_2  (mul_result_vec_2),	// @[dotCompute.scala:21:33]
    .io_vec_3  (mul_result_vec_3),	// @[dotCompute.scala:21:33]
    .io_vec_4  (mul_result_vec_4),	// @[dotCompute.scala:21:33]
    .io_vec_5  (mul_result_vec_5),	// @[dotCompute.scala:21:33]
    .io_vec_6  (mul_result_vec_6),	// @[dotCompute.scala:21:33]
    .io_vec_7  (mul_result_vec_7),	// @[dotCompute.scala:21:33]
    .io_vec_8  (mul_result_vec_8),	// @[dotCompute.scala:21:33]
    .io_vec_9  (mul_result_vec_9),	// @[dotCompute.scala:21:33]
    .io_vec_10 (mul_result_vec_10),	// @[dotCompute.scala:21:33]
    .io_vec_11 (mul_result_vec_11),	// @[dotCompute.scala:21:33]
    .io_vec_12 (mul_result_vec_12),	// @[dotCompute.scala:21:33]
    .io_vec_13 (mul_result_vec_13),	// @[dotCompute.scala:21:33]
    .io_vec_14 (mul_result_vec_14),	// @[dotCompute.scala:21:33]
    .io_vec_15 (mul_result_vec_15),	// @[dotCompute.scala:21:33]
    .io_out    (io_out)
  );
endmodule

