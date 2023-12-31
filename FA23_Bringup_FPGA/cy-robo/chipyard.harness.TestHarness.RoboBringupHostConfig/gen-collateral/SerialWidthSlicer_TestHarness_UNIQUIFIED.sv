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

module SerialWidthSlicer_TestHarness_UNIQUIFIED(
  input         clock,
                reset,
                io_wide_valid,	// @[generators/testchipip/src/main/scala/Util.scala:267:14]
  input  [31:0] io_wide_bits,	// @[generators/testchipip/src/main/scala/Util.scala:267:14]
  input         io_narrow_ready,	// @[generators/testchipip/src/main/scala/Util.scala:267:14]
  output        io_wide_ready,	// @[generators/testchipip/src/main/scala/Util.scala:267:14]
                io_narrow_valid,	// @[generators/testchipip/src/main/scala/Util.scala:267:14]
  output [7:0]  io_narrow_bits	// @[generators/testchipip/src/main/scala/Util.scala:267:14]
);

  reg  [1:0]      wide_beats;	// @[generators/testchipip/src/main/scala/Util.scala:273:27]
  wire [3:0][7:0] _GEN = {{io_wide_bits[31:24]}, {io_wide_bits[23:16]}, {io_wide_bits[15:8]}, {io_wide_bits[7:0]}};	// @[generators/testchipip/src/main/scala/Util.scala:277:{18,42}]
  always @(posedge clock) begin
    if (reset)
      wide_beats <= 2'h0;	// @[generators/testchipip/src/main/scala/Util.scala:273:27]
    else if (io_narrow_ready & io_wide_valid) begin	// @[src/main/scala/chisel3/util/Decoupled.scala:52:35]
      if (&wide_beats)	// @[generators/testchipip/src/main/scala/Util.scala:273:27, :274:35]
        wide_beats <= 2'h0;	// @[generators/testchipip/src/main/scala/Util.scala:273:27]
      else	// @[generators/testchipip/src/main/scala/Util.scala:274:35]
        wide_beats <= wide_beats + 2'h1;	// @[generators/testchipip/src/main/scala/Util.scala:273:27, :279:55]
    end
  end // always @(posedge)
  `ifndef SYNTHESIS
    `ifdef FIRRTL_BEFORE_INITIAL
      `FIRRTL_BEFORE_INITIAL
    `endif // FIRRTL_BEFORE_INITIAL
    logic [31:0] _RANDOM_0;
    initial begin
      `ifdef INIT_RANDOM_PROLOG_
        `INIT_RANDOM_PROLOG_
      `endif // INIT_RANDOM_PROLOG_
      `ifdef RANDOMIZE_REG_INIT
        _RANDOM_0 = `RANDOM;
        wide_beats = _RANDOM_0[1:0];	// @[generators/testchipip/src/main/scala/Util.scala:273:27]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  assign io_wide_ready = (&wide_beats) & io_narrow_ready;	// @[generators/testchipip/src/main/scala/Util.scala:273:27, :274:35, :281:35]
  assign io_narrow_valid = io_wide_valid;
  assign io_narrow_bits = _GEN[wide_beats];	// @[generators/testchipip/src/main/scala/Util.scala:273:27, :277:18]
endmodule

