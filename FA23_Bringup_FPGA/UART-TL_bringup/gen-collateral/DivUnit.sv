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

module DivUnit(
  input         clock,
                reset,
                io_req_valid,
  input  [3:0]  io_req_bits_uop_ctrl_op_fcn,
  input         io_req_bits_uop_ctrl_fcn_dw,
  input  [7:0]  io_req_bits_uop_br_mask,
  input  [4:0]  io_req_bits_uop_rob_idx,
  input  [5:0]  io_req_bits_uop_pdst,
  input         io_req_bits_uop_bypassable,
                io_req_bits_uop_is_amo,
                io_req_bits_uop_uses_stq,
  input  [1:0]  io_req_bits_uop_dst_rtype,
  input  [63:0] io_req_bits_rs1_data,
                io_req_bits_rs2_data,
  input         io_req_bits_kill,
                io_resp_ready,
  input  [7:0]  io_brupdate_b1_resolve_mask,
                io_brupdate_b1_mispredict_mask,
  output        io_req_ready,
                io_resp_valid,
  output [4:0]  io_resp_bits_uop_rob_idx,
  output [5:0]  io_resp_bits_uop_pdst,
  output        io_resp_bits_uop_bypassable,
                io_resp_bits_uop_is_amo,
                io_resp_bits_uop_uses_stq,
  output [1:0]  io_resp_bits_uop_dst_rtype,
  output [63:0] io_resp_bits_data
);

  wire       _div_io_req_ready;	// @[functional-unit.scala:672:19]
  wire       _div_io_resp_valid;	// @[functional-unit.scala:672:19]
  reg  [7:0] r_uop_br_mask;	// @[functional-unit.scala:642:18]
  reg  [4:0] r_uop_rob_idx;	// @[functional-unit.scala:642:18]
  reg  [5:0] r_uop_pdst;	// @[functional-unit.scala:642:18]
  reg        r_uop_bypassable;	// @[functional-unit.scala:642:18]
  reg        r_uop_is_amo;	// @[functional-unit.scala:642:18]
  reg        r_uop_uses_stq;	// @[functional-unit.scala:642:18]
  reg  [1:0] r_uop_dst_rtype;	// @[functional-unit.scala:642:18]
  wire       _T = _div_io_req_ready & io_req_valid;	// @[Decoupled.scala:51:35, functional-unit.scala:672:19]
  wire       do_kill = _T ? (|(io_brupdate_b1_mispredict_mask & io_req_bits_uop_br_mask)) | io_req_bits_kill : (|(io_brupdate_b1_mispredict_mask & r_uop_br_mask)) | io_req_bits_kill;	// @[Decoupled.scala:51:35, functional-unit.scala:642:18, :647:22, :649:{13,63}, :653:{13,53}, util.scala:118:{51,59}]
  always @(posedge clock) begin
    if (_T) begin	// @[Decoupled.scala:51:35]
      r_uop_br_mask <= io_req_bits_uop_br_mask & ~io_brupdate_b1_resolve_mask;	// @[functional-unit.scala:642:18, util.scala:85:{25,27}]
      r_uop_rob_idx <= io_req_bits_uop_rob_idx;	// @[functional-unit.scala:642:18]
      r_uop_pdst <= io_req_bits_uop_pdst;	// @[functional-unit.scala:642:18]
      r_uop_bypassable <= io_req_bits_uop_bypassable;	// @[functional-unit.scala:642:18]
      r_uop_is_amo <= io_req_bits_uop_is_amo;	// @[functional-unit.scala:642:18]
      r_uop_uses_stq <= io_req_bits_uop_uses_stq;	// @[functional-unit.scala:642:18]
      r_uop_dst_rtype <= io_req_bits_uop_dst_rtype;	// @[functional-unit.scala:642:18]
    end
    else	// @[Decoupled.scala:51:35]
      r_uop_br_mask <= r_uop_br_mask & ~io_brupdate_b1_resolve_mask;	// @[functional-unit.scala:642:18, util.scala:85:{25,27}]
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
        r_uop_br_mask = {_RANDOM_4[31:28], _RANDOM_5[3:0]};	// @[functional-unit.scala:642:18]
        r_uop_rob_idx = _RANDOM_6[23:19];	// @[functional-unit.scala:642:18]
        r_uop_pdst = _RANDOM_7[5:0];	// @[functional-unit.scala:642:18]
        r_uop_bypassable = _RANDOM_10[7];	// @[functional-unit.scala:642:18]
        r_uop_is_amo = _RANDOM_10[18];	// @[functional-unit.scala:642:18]
        r_uop_uses_stq = _RANDOM_10[20];	// @[functional-unit.scala:642:18]
        r_uop_dst_rtype = _RANDOM_11[19:18];	// @[functional-unit.scala:642:18]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  MulDiv_2 div (	// @[functional-unit.scala:672:19]
    .clock             (clock),
    .reset             (reset),
    .io_req_valid      (io_req_valid & ~do_kill),	// @[functional-unit.scala:647:22, :649:13, :653:13, :675:{39,42}]
    .io_req_bits_fn    (io_req_bits_uop_ctrl_op_fcn),
    .io_req_bits_dw    (io_req_bits_uop_ctrl_fcn_dw),
    .io_req_bits_in1   (io_req_bits_rs1_data),
    .io_req_bits_in2   (io_req_bits_rs2_data),
    .io_kill           (do_kill),	// @[functional-unit.scala:647:22, :649:13, :653:13]
    .io_resp_ready     (io_resp_ready),
    .io_req_ready      (_div_io_req_ready),
    .io_resp_valid     (_div_io_resp_valid),
    .io_resp_bits_data (io_resp_bits_data)
  );
  assign io_req_ready = _div_io_req_ready;	// @[functional-unit.scala:672:19]
  assign io_resp_valid = _div_io_resp_valid & ~do_kill;	// @[functional-unit.scala:647:22, :649:13, :653:13, :672:19, :675:42, :687:44]
  assign io_resp_bits_uop_rob_idx = r_uop_rob_idx;	// @[functional-unit.scala:642:18]
  assign io_resp_bits_uop_pdst = r_uop_pdst;	// @[functional-unit.scala:642:18]
  assign io_resp_bits_uop_bypassable = r_uop_bypassable;	// @[functional-unit.scala:642:18]
  assign io_resp_bits_uop_is_amo = r_uop_is_amo;	// @[functional-unit.scala:642:18]
  assign io_resp_bits_uop_uses_stq = r_uop_uses_stq;	// @[functional-unit.scala:642:18]
  assign io_resp_bits_uop_dst_rtype = r_uop_dst_rtype;	// @[functional-unit.scala:642:18]
endmodule
