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

module vectorAdd(
  input         clock,
                reset,
                io_cmd_valid,
  input  [4:0]  io_cmd_bits_inst_rd,
  input  [63:0] io_cmd_bits_rs1,
                io_cmd_bits_rs2,
  input         io_resp_ready,
  output        io_cmd_ready,
                io_resp_valid,
  output [4:0]  io_resp_bits_rd,
  output [63:0] io_resp_bits_data,
  output        io_busy
);

  wire [7:0]  sum_vec_wire_7;	// @[vectorAdd.scala:82:40]
  wire [7:0]  sum_vec_wire_6;	// @[vectorAdd.scala:82:40]
  wire [7:0]  sum_vec_wire_5;	// @[vectorAdd.scala:82:40]
  wire [7:0]  sum_vec_wire_4;	// @[vectorAdd.scala:82:40]
  wire [7:0]  sum_vec_wire_3;	// @[vectorAdd.scala:82:40]
  wire [7:0]  sum_vec_wire_2;	// @[vectorAdd.scala:82:40]
  wire [7:0]  sum_vec_wire_1;	// @[vectorAdd.scala:82:40]
  wire [7:0]  sum_vec_wire_0;	// @[vectorAdd.scala:82:40]
  reg  [4:0]  cmd_bits_reg_inst_rd;	// @[vectorAdd.scala:52:29]
  reg  [63:0] cmd_bits_reg_rs1;	// @[vectorAdd.scala:52:29]
  reg  [63:0] cmd_bits_reg_rs2;	// @[vectorAdd.scala:52:29]
  reg         state_reg;	// @[vectorAdd.scala:53:26]
  assign sum_vec_wire_0 = cmd_bits_reg_rs1[7:0] + cmd_bits_reg_rs2[7:0];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  assign sum_vec_wire_1 = cmd_bits_reg_rs1[15:8] + cmd_bits_reg_rs2[15:8];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  assign sum_vec_wire_2 = cmd_bits_reg_rs1[23:16] + cmd_bits_reg_rs2[23:16];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  assign sum_vec_wire_3 = cmd_bits_reg_rs1[31:24] + cmd_bits_reg_rs2[31:24];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  assign sum_vec_wire_4 = cmd_bits_reg_rs1[39:32] + cmd_bits_reg_rs2[39:32];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  assign sum_vec_wire_5 = cmd_bits_reg_rs1[47:40] + cmd_bits_reg_rs2[47:40];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  assign sum_vec_wire_6 = cmd_bits_reg_rs1[55:48] + cmd_bits_reg_rs2[55:48];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  assign sum_vec_wire_7 = cmd_bits_reg_rs1[63:56] + cmd_bits_reg_rs2[63:56];	// @[vectorAdd.scala:52:29, :77:44, :78:44, :82:40]
  wire        _T_1 = ~state_reg & io_cmd_valid;	// @[Decoupled.scala:51:35, vectorAdd.scala:53:26, :56:19]
  always @(posedge clock) begin
    if (reset) begin
      cmd_bits_reg_inst_rd <= 5'h0;	// @[vectorAdd.scala:52:{29,42}]
      cmd_bits_reg_rs1 <= 64'h0;	// @[vectorAdd.scala:52:{29,42}]
      cmd_bits_reg_rs2 <= 64'h0;	// @[vectorAdd.scala:52:{29,42}]
      state_reg <= 1'h0;	// @[vectorAdd.scala:52:42, :53:26]
    end
    else begin
      if (~state_reg & _T_1) begin	// @[Decoupled.scala:51:35, vectorAdd.scala:52:29, :53:26, :62:{19,28}, :63:24, :65:20]
        cmd_bits_reg_inst_rd <= io_cmd_bits_inst_rd;	// @[vectorAdd.scala:52:29]
        cmd_bits_reg_rs1 <= io_cmd_bits_rs1;	// @[vectorAdd.scala:52:29]
        cmd_bits_reg_rs2 <= io_cmd_bits_rs2;	// @[vectorAdd.scala:52:29]
      end
      if (state_reg)	// @[vectorAdd.scala:53:26]
        state_reg <= io_resp_ready & state_reg ^ state_reg;	// @[Decoupled.scala:51:35, vectorAdd.scala:53:26, :68:25, :69:17]
      else	// @[vectorAdd.scala:53:26]
        state_reg <= _T_1 ^ state_reg;	// @[Decoupled.scala:51:35, vectorAdd.scala:53:26, :63:24, :64:17]
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
        cmd_bits_reg_inst_rd = _RANDOM_0[24:20];	// @[vectorAdd.scala:52:29]
        cmd_bits_reg_rs1 = {_RANDOM_1, _RANDOM_2};	// @[vectorAdd.scala:52:29]
        cmd_bits_reg_rs2 = {_RANDOM_3, _RANDOM_4};	// @[vectorAdd.scala:52:29]
        state_reg = _RANDOM_5[0];	// @[vectorAdd.scala:53:26]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  assign io_cmd_ready = ~state_reg;	// @[vectorAdd.scala:53:26, :56:19]
  assign io_resp_valid = state_reg;	// @[vectorAdd.scala:53:26]
  assign io_resp_bits_rd = cmd_bits_reg_inst_rd;	// @[vectorAdd.scala:52:29]
  assign io_resp_bits_data = {sum_vec_wire_7, sum_vec_wire_6, sum_vec_wire_5, sum_vec_wire_4, sum_vec_wire_3, sum_vec_wire_2, sum_vec_wire_1, sum_vec_wire_0};	// @[vectorAdd.scala:74:45, :82:40]
  assign io_busy = state_reg;	// @[vectorAdd.scala:53:26]
endmodule

