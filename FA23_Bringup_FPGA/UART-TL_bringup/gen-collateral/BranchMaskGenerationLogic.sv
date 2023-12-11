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

module BranchMaskGenerationLogic(
  input        clock,
               reset,
               io_is_branch_0,
               io_will_fire_0,
  input  [7:0] io_brupdate_b1_resolve_mask,
               io_brupdate_b2_uop_br_mask,
  input        io_brupdate_b2_mispredict,
               io_flush_pipeline,
  output [2:0] io_br_tag_0,
  output [7:0] io_br_mask_0,
  output       io_is_full_0
);

  reg [7:0] branch_mask;	// @[decode.scala:750:28]
  always @(posedge clock) begin
    if (reset)
      branch_mask <= 8'h0;	// @[decode.scala:750:28]
    else if (io_flush_pipeline)
      branch_mask <= 8'h0;	// @[decode.scala:750:28]
    else
      branch_mask <= ({8{io_will_fire_0}} & (branch_mask[0] ? (branch_mask[1] ? (branch_mask[2] ? (branch_mask[3] ? (branch_mask[4] ? (branch_mask[5] ? (branch_mask[6] ? {~(branch_mask[7]), 7'h0} : 8'h40) : 8'h20) : 8'h10) : 8'h8) : 8'h4) : 8'h2) : 8'h1) | branch_mask) & ~io_brupdate_b1_resolve_mask & (io_brupdate_b2_mispredict ? io_brupdate_b2_uop_br_mask : 8'hFF);	// @[decode.scala:750:28, :760:41, :765:18, :768:{13,27,32}, :770:{22,30}, :785:20, :794:19, :797:57, util.scala:89:23]
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
        branch_mask = _RANDOM_0[7:0];	// @[decode.scala:750:28]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  assign io_br_tag_0 = branch_mask[0] ? (branch_mask[1] ? (branch_mask[2] ? (branch_mask[3] ? (branch_mask[4] ? (branch_mask[5] ? (branch_mask[6] ? {3{~(branch_mask[7])}} : 3'h6) : 3'h5) : 3'h4) : 3'h3) : 3'h2) : 3'h1) : 3'h0;	// @[decode.scala:750:28, :764:16, :768:{13,27,32}, :769:20]
  assign io_br_mask_0 = branch_mask & ~io_brupdate_b1_resolve_mask;	// @[decode.scala:750:28, util.scala:89:{21,23}]
  assign io_is_full_0 = (&branch_mask) & io_is_branch_0;	// @[decode.scala:750:28, :760:{37,63}]
endmodule

