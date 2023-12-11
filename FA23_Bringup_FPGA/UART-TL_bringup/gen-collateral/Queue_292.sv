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

module Queue_292(
  input         clock,
                reset,
                io_enq_valid,
  input  [39:0] io_enq_bits_pc,
  input         io_enq_bits_preds_0_taken,
                io_enq_bits_preds_0_is_br,
                io_enq_bits_preds_0_is_jal,
                io_enq_bits_preds_0_predicted_pc_valid,
  input  [39:0] io_enq_bits_preds_0_predicted_pc_bits,
  input         io_enq_bits_preds_1_taken,
                io_enq_bits_preds_1_is_br,
                io_enq_bits_preds_1_is_jal,
                io_enq_bits_preds_1_predicted_pc_valid,
  input  [39:0] io_enq_bits_preds_1_predicted_pc_bits,
  input         io_enq_bits_preds_2_taken,
                io_enq_bits_preds_2_is_br,
                io_enq_bits_preds_2_is_jal,
                io_enq_bits_preds_2_predicted_pc_valid,
  input  [39:0] io_enq_bits_preds_2_predicted_pc_bits,
  input         io_enq_bits_preds_3_taken,
                io_enq_bits_preds_3_is_br,
                io_enq_bits_preds_3_is_jal,
                io_enq_bits_preds_3_predicted_pc_valid,
  input  [39:0] io_enq_bits_preds_3_predicted_pc_bits,
  input  [49:0] io_enq_bits_meta_0,
  input         io_deq_ready,
  output [39:0] io_deq_bits_pc,
  output        io_deq_bits_preds_0_taken,
                io_deq_bits_preds_0_predicted_pc_valid,
  output [39:0] io_deq_bits_preds_0_predicted_pc_bits,
  output        io_deq_bits_preds_1_taken,
                io_deq_bits_preds_1_predicted_pc_valid,
  output [39:0] io_deq_bits_preds_1_predicted_pc_bits,
  output        io_deq_bits_preds_2_taken,
                io_deq_bits_preds_2_predicted_pc_valid,
  output [39:0] io_deq_bits_preds_2_predicted_pc_bits,
  output        io_deq_bits_preds_3_taken,
                io_deq_bits_preds_3_predicted_pc_valid,
  output [39:0] io_deq_bits_preds_3_predicted_pc_bits,
  output [49:0] io_deq_bits_meta_0,
  output        io_deq_bits_lhist_0
);

  wire         _GEN;	// @[Decoupled.scala:303:16, :323:{24,39}]
  wire [266:0] _ram_ext_R0_data;	// @[Decoupled.scala:273:95]
  reg          maybe_full;	// @[Decoupled.scala:276:27]
  wire         do_enq = ~(~maybe_full & io_deq_ready) & _GEN & io_enq_valid;	// @[Decoupled.scala:276:27, :278:28, :280:27, :303:16, :315:17, :318:{26,35}, :323:{24,39}]
  assign _GEN = io_deq_ready | ~maybe_full;	// @[Decoupled.scala:276:27, :303:{16,19}, :323:{24,39}]
  always @(posedge clock) begin
    if (reset)
      maybe_full <= 1'h0;	// @[Decoupled.scala:276:27]
    else if (do_enq != (maybe_full & io_deq_ready & (io_enq_valid | maybe_full)))	// @[Decoupled.scala:276:27, :280:27, :281:27, :293:15, :302:16, :314:{24,39}, :315:17, :317:14, :318:{26,35}]
      maybe_full <= do_enq;	// @[Decoupled.scala:276:27, :280:27, :315:17, :318:{26,35}]
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
        maybe_full = _RANDOM_0[0];	// @[Decoupled.scala:276:27]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  ram_combMem_42 ram_ext (	// @[Decoupled.scala:273:95]
    .R0_addr (1'h0),
    .R0_en   (1'h1),
    .R0_clk  (clock),
    .W0_addr (1'h0),
    .W0_en   (do_enq),	// @[Decoupled.scala:280:27, :315:17, :318:{26,35}]
    .W0_clk  (clock),
    .W0_data ({1'h0, io_enq_bits_meta_0, io_enq_bits_preds_3_predicted_pc_bits, io_enq_bits_preds_3_predicted_pc_valid, io_enq_bits_preds_3_is_jal, io_enq_bits_preds_3_is_br, io_enq_bits_preds_3_taken, io_enq_bits_preds_2_predicted_pc_bits, io_enq_bits_preds_2_predicted_pc_valid, io_enq_bits_preds_2_is_jal, io_enq_bits_preds_2_is_br, io_enq_bits_preds_2_taken, io_enq_bits_preds_1_predicted_pc_bits, io_enq_bits_preds_1_predicted_pc_valid, io_enq_bits_preds_1_is_jal, io_enq_bits_preds_1_is_br, io_enq_bits_preds_1_taken, io_enq_bits_preds_0_predicted_pc_bits, io_enq_bits_preds_0_predicted_pc_valid, io_enq_bits_preds_0_is_jal, io_enq_bits_preds_0_is_br, io_enq_bits_preds_0_taken, io_enq_bits_pc}),	// @[Decoupled.scala:273:95]
    .R0_data (_ram_ext_R0_data)
  );
  assign io_deq_bits_pc = maybe_full ? _ram_ext_R0_data[39:0] : io_enq_bits_pc;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_0_taken = maybe_full ? _ram_ext_R0_data[40] : io_enq_bits_preds_0_taken;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_0_predicted_pc_valid = maybe_full ? _ram_ext_R0_data[43] : io_enq_bits_preds_0_predicted_pc_valid;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_0_predicted_pc_bits = maybe_full ? _ram_ext_R0_data[83:44] : io_enq_bits_preds_0_predicted_pc_bits;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_1_taken = maybe_full ? _ram_ext_R0_data[84] : io_enq_bits_preds_1_taken;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_1_predicted_pc_valid = maybe_full ? _ram_ext_R0_data[87] : io_enq_bits_preds_1_predicted_pc_valid;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_1_predicted_pc_bits = maybe_full ? _ram_ext_R0_data[127:88] : io_enq_bits_preds_1_predicted_pc_bits;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_2_taken = maybe_full ? _ram_ext_R0_data[128] : io_enq_bits_preds_2_taken;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_2_predicted_pc_valid = maybe_full ? _ram_ext_R0_data[131] : io_enq_bits_preds_2_predicted_pc_valid;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_2_predicted_pc_bits = maybe_full ? _ram_ext_R0_data[171:132] : io_enq_bits_preds_2_predicted_pc_bits;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_3_taken = maybe_full ? _ram_ext_R0_data[172] : io_enq_bits_preds_3_taken;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_3_predicted_pc_valid = maybe_full ? _ram_ext_R0_data[175] : io_enq_bits_preds_3_predicted_pc_valid;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_preds_3_predicted_pc_bits = maybe_full ? _ram_ext_R0_data[215:176] : io_enq_bits_preds_3_predicted_pc_bits;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_meta_0 = maybe_full ? _ram_ext_R0_data[265:216] : io_enq_bits_meta_0;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_lhist_0 = maybe_full & _ram_ext_R0_data[266];	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
endmodule

