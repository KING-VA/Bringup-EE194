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

module TLXbar_4(
  input         clock,
                reset,
                auto_in_1_a_valid,
  input  [27:0] auto_in_1_a_bits_address,
  input  [63:0] auto_in_1_a_bits_data,
  input         auto_in_0_a_valid,
  input  [2:0]  auto_in_0_a_bits_opcode,
                auto_in_0_a_bits_param,
  input  [3:0]  auto_in_0_a_bits_size,
  input  [2:0]  auto_in_0_a_bits_source,
  input  [27:0] auto_in_0_a_bits_address,
  input  [7:0]  auto_in_0_a_bits_mask,
  input  [63:0] auto_in_0_a_bits_data,
  input         auto_in_0_a_bits_corrupt,
                auto_in_0_d_ready,
                auto_out_a_ready,
                auto_out_d_valid,
  input  [2:0]  auto_out_d_bits_opcode,
  input  [1:0]  auto_out_d_bits_param,
  input  [3:0]  auto_out_d_bits_size,
                auto_out_d_bits_source,
  input         auto_out_d_bits_sink,
                auto_out_d_bits_denied,
  input  [63:0] auto_out_d_bits_data,
  input         auto_out_d_bits_corrupt,
  output        auto_in_1_a_ready,
                auto_in_1_d_valid,
                auto_in_0_a_ready,
                auto_in_0_d_valid,
  output [2:0]  auto_in_0_d_bits_opcode,
  output [1:0]  auto_in_0_d_bits_param,
  output [3:0]  auto_in_0_d_bits_size,
  output [2:0]  auto_in_0_d_bits_source,
  output        auto_in_0_d_bits_sink,
                auto_in_0_d_bits_denied,
  output [63:0] auto_in_0_d_bits_data,
  output        auto_in_0_d_bits_corrupt,
                auto_out_a_valid,
  output [2:0]  auto_out_a_bits_opcode,
                auto_out_a_bits_param,
  output [3:0]  auto_out_a_bits_size,
                auto_out_a_bits_source,
  output [27:0] auto_out_a_bits_address,
  output [7:0]  auto_out_a_bits_mask,
  output [63:0] auto_out_a_bits_data,
  output        auto_out_a_bits_corrupt,
                auto_out_d_ready
);

  wire        requestDOI_0_1 = auto_out_d_bits_source == 4'h8;	// @[Parameters.scala:46:9, Xbar.scala:427:24]
  reg  [8:0]  beatsLeft;	// @[Arbiter.scala:88:30]
  wire        idle = beatsLeft == 9'h0;	// @[Arbiter.scala:88:30, :89:28, :112:73, Edges.scala:220:14]
  wire [1:0]  readys_valid = {auto_in_1_a_valid, auto_in_0_a_valid};	// @[Cat.scala:33:92]
  reg  [1:0]  readys_mask;	// @[Arbiter.scala:24:23]
  wire [1:0]  _readys_filter_T_1 = readys_valid & ~readys_mask;	// @[Arbiter.scala:24:23, :25:{28,30}, Cat.scala:33:92]
  wire [1:0]  readys_readys = ~({readys_mask[1], _readys_filter_T_1[1] | readys_mask[0]} & {|_readys_filter_T_1, auto_in_1_a_valid | _readys_filter_T_1[0]});	// @[Arbiter.scala:24:23, :25:28, :26:58, :27:{18,29,39,48}, package.scala:254:43]
  wire        earlyWinner_0 = readys_readys[0] & auto_in_0_a_valid;	// @[Arbiter.scala:27:18, :96:86, :98:79]
  wire        earlyWinner_1 = readys_readys[1] & auto_in_1_a_valid;	// @[Arbiter.scala:27:18, :96:86, :98:79]
  wire        _out_0_a_earlyValid_T = auto_in_0_a_valid | auto_in_1_a_valid;	// @[Arbiter.scala:108:36]
  reg         state_0;	// @[Arbiter.scala:117:26]
  reg         state_1;	// @[Arbiter.scala:117:26]
  wire        muxStateEarly_0 = idle ? earlyWinner_0 : state_0;	// @[Arbiter.scala:89:28, :98:79, :117:26, :118:30]
  wire        muxStateEarly_1 = idle ? earlyWinner_1 : state_1;	// @[Arbiter.scala:89:28, :98:79, :117:26, :118:30]
  wire        x1_out_1_valid = idle ? _out_0_a_earlyValid_T : state_0 & auto_in_0_a_valid | state_1 & auto_in_1_a_valid;	// @[Arbiter.scala:89:28, :108:36, :117:26, :126:29, Mux.scala:27:73]
  wire [26:0] _beatsAI_decode_T_1 = 27'hFFF << auto_in_0_a_bits_size;	// @[package.scala:235:71]
  wire [1:0]  _readys_mask_T = readys_readys & readys_valid;	// @[Arbiter.scala:27:18, :29:29, Cat.scala:33:92]
  wire        latch = idle & auto_out_a_ready;	// @[Arbiter.scala:89:28, :90:24]
  wire        winnerQual_0 = readys_readys[0] & auto_in_0_a_valid;	// @[Arbiter.scala:27:18, :96:86, :99:79]
  always @(posedge clock) begin
    if (reset) begin
      beatsLeft <= 9'h0;	// @[Arbiter.scala:88:30, :112:73, Edges.scala:220:14]
      readys_mask <= 2'h3;	// @[Arbiter.scala:24:23]
      state_0 <= 1'h0;	// @[Arbiter.scala:117:26]
      state_1 <= 1'h0;	// @[Arbiter.scala:117:26]
    end
    else begin
      if (latch) begin	// @[Arbiter.scala:90:24]
        if (winnerQual_0 & ~(auto_in_0_a_bits_opcode[2]))	// @[Arbiter.scala:99:79, :112:73, Edges.scala:91:{28,37}, :220:14]
          beatsLeft <= ~(_beatsAI_decode_T_1[11:3]);	// @[Arbiter.scala:88:30, package.scala:235:{46,71,76}]
        else	// @[Arbiter.scala:112:73, Edges.scala:220:14]
          beatsLeft <= 9'h0;	// @[Arbiter.scala:88:30, :112:73, Edges.scala:220:14]
      end
      else	// @[Arbiter.scala:90:24]
        beatsLeft <= beatsLeft - {8'h0, auto_out_a_ready & x1_out_1_valid};	// @[Arbiter.scala:88:30, :114:52, :126:29, Bundles.scala:259:74, ReadyValidCancel.scala:49:33]
      if (latch & (|readys_valid))	// @[Arbiter.scala:28:{18,27}, :90:24, Cat.scala:33:92]
        readys_mask <= _readys_mask_T | {_readys_mask_T[0], 1'h0};	// @[Arbiter.scala:24:23, :29:29, package.scala:245:{43,53}]
      if (idle) begin	// @[Arbiter.scala:89:28]
        state_0 <= winnerQual_0;	// @[Arbiter.scala:99:79, :117:26]
        state_1 <= readys_readys[1] & auto_in_1_a_valid;	// @[Arbiter.scala:27:18, :96:86, :99:79, :117:26]
      end
    end
  end // always @(posedge)
  `ifndef SYNTHESIS
    always @(posedge clock) begin	// @[Arbiter.scala:106:13]
      if (~reset & ~(~earlyWinner_0 | ~earlyWinner_1)) begin	// @[Arbiter.scala:98:79, :106:{13,61,64,67}]
        if (`ASSERT_VERBOSE_COND_)	// @[Arbiter.scala:106:13]
          $error("Assertion failed\n    at Arbiter.scala:106 assert((prefixOR zip earlyWinner) map { case (p,w) => !p || !w } reduce {_ && _})\n");	// @[Arbiter.scala:106:13]
        if (`STOP_COND_)	// @[Arbiter.scala:106:13]
          $fatal;	// @[Arbiter.scala:106:13]
      end
      if (~reset & ~(~_out_0_a_earlyValid_T | earlyWinner_0 | earlyWinner_1)) begin	// @[Arbiter.scala:98:79, :108:{14,15,36,41}]
        if (`ASSERT_VERBOSE_COND_)	// @[Arbiter.scala:108:14]
          $error("Assertion failed\n    at Arbiter.scala:108 assert (!earlyValids.reduce(_||_) || earlyWinner.reduce(_||_))\n");	// @[Arbiter.scala:108:14]
        if (`STOP_COND_)	// @[Arbiter.scala:108:14]
          $fatal;	// @[Arbiter.scala:108:14]
      end
    end // always @(posedge)
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
        beatsLeft = _RANDOM_0[8:0];	// @[Arbiter.scala:88:30]
        readys_mask = _RANDOM_0[10:9];	// @[Arbiter.scala:24:23, :88:30]
        state_0 = _RANDOM_0[11];	// @[Arbiter.scala:88:30, :117:26]
        state_1 = _RANDOM_0[12];	// @[Arbiter.scala:88:30, :117:26]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  assign auto_in_1_a_ready = auto_out_a_ready & (idle ? readys_readys[1] : state_1);	// @[Arbiter.scala:27:18, :89:28, :96:86, :117:26, :122:24, :124:31]
  assign auto_in_1_d_valid = auto_out_d_valid & requestDOI_0_1;	// @[Parameters.scala:46:9, Xbar.scala:182:40]
  assign auto_in_0_a_ready = auto_out_a_ready & (idle ? readys_readys[0] : state_0);	// @[Arbiter.scala:27:18, :89:28, :96:86, :117:26, :122:24, :124:31]
  assign auto_in_0_d_valid = auto_out_d_valid & ~(auto_out_d_bits_source[3]);	// @[Parameters.scala:54:{10,32}, Xbar.scala:182:40]
  assign auto_in_0_d_bits_opcode = auto_out_d_bits_opcode;
  assign auto_in_0_d_bits_param = auto_out_d_bits_param;
  assign auto_in_0_d_bits_size = auto_out_d_bits_size;
  assign auto_in_0_d_bits_source = auto_out_d_bits_source[2:0];	// @[Xbar.scala:231:69]
  assign auto_in_0_d_bits_sink = auto_out_d_bits_sink;
  assign auto_in_0_d_bits_denied = auto_out_d_bits_denied;
  assign auto_in_0_d_bits_data = auto_out_d_bits_data;
  assign auto_in_0_d_bits_corrupt = auto_out_d_bits_corrupt;
  assign auto_out_a_valid = x1_out_1_valid;	// @[Arbiter.scala:126:29]
  assign auto_out_a_bits_opcode = muxStateEarly_0 ? auto_in_0_a_bits_opcode : 3'h0;	// @[Arbiter.scala:118:30, Mux.scala:27:73]
  assign auto_out_a_bits_param = muxStateEarly_0 ? auto_in_0_a_bits_param : 3'h0;	// @[Arbiter.scala:118:30, Mux.scala:27:73]
  assign auto_out_a_bits_size = (muxStateEarly_0 ? auto_in_0_a_bits_size : 4'h0) | {2'h0, muxStateEarly_1, 1'h0};	// @[Arbiter.scala:26:66, :118:30, Bundles.scala:259:74, Mux.scala:27:73]
  assign auto_out_a_bits_source = (muxStateEarly_0 ? {1'h0, auto_in_0_a_bits_source} : 4'h0) | {muxStateEarly_1, 3'h0};	// @[Arbiter.scala:118:30, Bundles.scala:259:74, Mux.scala:27:73, Xbar.scala:240:29]
  assign auto_out_a_bits_address = (muxStateEarly_0 ? auto_in_0_a_bits_address : 28'h0) | (muxStateEarly_1 ? auto_in_1_a_bits_address : 28'h0);	// @[Arbiter.scala:118:30, Bundles.scala:259:74, Mux.scala:27:73]
  assign auto_out_a_bits_mask = (muxStateEarly_0 ? auto_in_0_a_bits_mask : 8'h0) | (muxStateEarly_1 ? 8'hF : 8'h0);	// @[Arbiter.scala:118:30, Bundles.scala:259:74, Mux.scala:27:73]
  assign auto_out_a_bits_data = (muxStateEarly_0 ? auto_in_0_a_bits_data : 64'h0) | (muxStateEarly_1 ? auto_in_1_a_bits_data : 64'h0);	// @[Arbiter.scala:118:30, Bundles.scala:259:74, Mux.scala:27:73]
  assign auto_out_a_bits_corrupt = muxStateEarly_0 & auto_in_0_a_bits_corrupt;	// @[Arbiter.scala:118:30, Mux.scala:27:73]
  assign auto_out_d_ready = ~(auto_out_d_bits_source[3]) & auto_in_0_d_ready | requestDOI_0_1;	// @[Mux.scala:27:73, Parameters.scala:46:9, :54:{10,32}]
endmodule

