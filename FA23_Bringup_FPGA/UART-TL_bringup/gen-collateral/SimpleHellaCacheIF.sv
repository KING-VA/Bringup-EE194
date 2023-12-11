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

module SimpleHellaCacheIF(
  input         clock,
                reset,
                io_requestor_req_valid,
  input  [39:0] io_requestor_req_bits_addr,
  input  [7:0]  io_requestor_req_bits_tag,
  input  [4:0]  io_requestor_req_bits_cmd,
  input  [1:0]  io_requestor_req_bits_dprv,
  input         io_requestor_req_bits_dv,
  input  [63:0] io_requestor_req_bits_data,
  input  [7:0]  io_requestor_req_bits_mask,
  input         io_cache_req_ready,
                io_cache_s2_nack,
                io_cache_resp_valid,
  input  [7:0]  io_cache_resp_bits_tag,
  input  [63:0] io_cache_resp_bits_data,
  input         io_cache_s2_xcpt_ma_ld,
                io_cache_s2_xcpt_ma_st,
                io_cache_s2_xcpt_pf_ld,
                io_cache_s2_xcpt_pf_st,
                io_cache_s2_xcpt_gf_ld,
                io_cache_s2_xcpt_gf_st,
                io_cache_s2_xcpt_ae_ld,
                io_cache_s2_xcpt_ae_st,
  output        io_requestor_req_ready,
                io_requestor_resp_valid,
  output [63:0] io_requestor_resp_bits_data,
  output        io_cache_req_valid,
  output [39:0] io_cache_req_bits_addr,
  output [7:0]  io_cache_req_bits_tag,
  output [4:0]  io_cache_req_bits_cmd,
  output [1:0]  io_cache_req_bits_size,
  output        io_cache_req_bits_signed,
  output [1:0]  io_cache_req_bits_dprv,
  output        io_cache_req_bits_dv,
                io_cache_req_bits_phys,
                io_cache_req_bits_no_alloc,
                io_cache_req_bits_no_xcpt,
  output [7:0]  io_cache_req_bits_mask,
  output [63:0] io_cache_s1_data_data
);

  wire        _req_arb_io_in_0_ready;	// @[SimpleHellaCacheIF.scala:104:23]
  wire        _req_arb_io_in_1_ready;	// @[SimpleHellaCacheIF.scala:104:23]
  wire        _req_arb_io_out_valid;	// @[SimpleHellaCacheIF.scala:104:23]
  wire [7:0]  _req_arb_io_out_bits_tag;	// @[SimpleHellaCacheIF.scala:104:23]
  wire [63:0] _req_arb_io_out_bits_data;	// @[SimpleHellaCacheIF.scala:104:23]
  wire        _replayq_io_req_ready;	// @[SimpleHellaCacheIF.scala:103:23]
  wire        _replayq_io_replay_valid;	// @[SimpleHellaCacheIF.scala:103:23]
  wire [39:0] _replayq_io_replay_bits_addr;	// @[SimpleHellaCacheIF.scala:103:23]
  wire [7:0]  _replayq_io_replay_bits_tag;	// @[SimpleHellaCacheIF.scala:103:23]
  wire [4:0]  _replayq_io_replay_bits_cmd;	// @[SimpleHellaCacheIF.scala:103:23]
  wire [1:0]  _replayq_io_replay_bits_size;	// @[SimpleHellaCacheIF.scala:103:23]
  wire        _replayq_io_replay_bits_signed;	// @[SimpleHellaCacheIF.scala:103:23]
  wire [1:0]  _replayq_io_replay_bits_dprv;	// @[SimpleHellaCacheIF.scala:103:23]
  wire        _replayq_io_replay_bits_dv;	// @[SimpleHellaCacheIF.scala:103:23]
  wire        _replayq_io_replay_bits_phys;	// @[SimpleHellaCacheIF.scala:103:23]
  wire        _replayq_io_replay_bits_no_alloc;	// @[SimpleHellaCacheIF.scala:103:23]
  wire        _replayq_io_replay_bits_no_xcpt;	// @[SimpleHellaCacheIF.scala:103:23]
  wire [63:0] _replayq_io_replay_bits_data;	// @[SimpleHellaCacheIF.scala:103:23]
  wire [7:0]  _replayq_io_replay_bits_mask;	// @[SimpleHellaCacheIF.scala:103:23]
  reg         s1_req_fire;	// @[SimpleHellaCacheIF.scala:119:28]
  reg         s2_req_fire;	// @[SimpleHellaCacheIF.scala:120:28]
  reg  [7:0]  s1_req_tag;	// @[SimpleHellaCacheIF.scala:121:27]
  reg  [7:0]  s2_req_tag;	// @[SimpleHellaCacheIF.scala:122:27]
  reg         REG;	// @[SimpleHellaCacheIF.scala:124:18]
  reg  [63:0] io_cache_s1_data_data_r;	// @[Reg.scala:19:16]
  wire        s0_req_fire = io_cache_req_ready & _req_arb_io_out_valid;	// @[Decoupled.scala:51:35, SimpleHellaCacheIF.scala:104:23]
  always @(posedge clock) begin
    s1_req_fire <= s0_req_fire;	// @[Decoupled.scala:51:35, SimpleHellaCacheIF.scala:119:28]
    s2_req_fire <= s1_req_fire;	// @[SimpleHellaCacheIF.scala:119:28, :120:28]
    s1_req_tag <= _req_arb_io_out_bits_tag;	// @[SimpleHellaCacheIF.scala:104:23, :121:27]
    s2_req_tag <= s1_req_tag;	// @[SimpleHellaCacheIF.scala:121:27, :122:27]
    REG <= io_cache_s2_nack;	// @[SimpleHellaCacheIF.scala:124:18]
    if (s0_req_fire)	// @[Decoupled.scala:51:35]
      io_cache_s1_data_data_r <= _req_arb_io_out_bits_data;	// @[Reg.scala:19:16, SimpleHellaCacheIF.scala:104:23]
  end // always @(posedge)
  `ifndef SYNTHESIS
    always @(posedge clock) begin	// @[SimpleHellaCacheIF.scala:124:9]
      if (~reset & ~(~REG | ~s2_req_fire | io_cache_s2_nack)) begin	// @[SimpleHellaCacheIF.scala:120:28, :124:{9,10,18,40,53}]
        if (`ASSERT_VERBOSE_COND_)	// @[SimpleHellaCacheIF.scala:124:9]
          $error("Assertion failed\n    at SimpleHellaCacheIF.scala:124 assert(!RegNext(io.cache.s2_nack) || !s2_req_fire || io.cache.s2_nack)\n");	// @[SimpleHellaCacheIF.scala:124:9]
        if (`STOP_COND_)	// @[SimpleHellaCacheIF.scala:124:9]
          $fatal;	// @[SimpleHellaCacheIF.scala:124:9]
      end
      if (~reset & ~(~io_cache_s2_nack | ~io_cache_req_ready)) begin	// @[SimpleHellaCacheIF.scala:125:{9,10,28,31}]
        if (`ASSERT_VERBOSE_COND_)	// @[SimpleHellaCacheIF.scala:125:9]
          $error("Assertion failed\n    at SimpleHellaCacheIF.scala:125 assert(!io.cache.s2_nack || !io.cache.req.ready)\n");	// @[SimpleHellaCacheIF.scala:125:9]
        if (`STOP_COND_)	// @[SimpleHellaCacheIF.scala:125:9]
          $fatal;	// @[SimpleHellaCacheIF.scala:125:9]
      end
      if (~reset & ~(~s2_req_fire | {io_cache_s2_xcpt_ma_ld, io_cache_s2_xcpt_ma_st, io_cache_s2_xcpt_pf_ld, io_cache_s2_xcpt_pf_st, io_cache_s2_xcpt_gf_ld, io_cache_s2_xcpt_gf_st, io_cache_s2_xcpt_ae_ld, io_cache_s2_xcpt_ae_st} == 8'h0)) begin	// @[SimpleHellaCacheIF.scala:120:28, :124:40, :137:{9,23,44,51}]
        if (`ASSERT_VERBOSE_COND_)	// @[SimpleHellaCacheIF.scala:137:9]
          $error("Assertion failed: SimpleHellaCacheIF exception\n    at SimpleHellaCacheIF.scala:137 assert(!s2_req_fire || !io.cache.s2_xcpt.asUInt.orR, \"SimpleHellaCacheIF exception\")\n");	// @[SimpleHellaCacheIF.scala:137:9]
        if (`STOP_COND_)	// @[SimpleHellaCacheIF.scala:137:9]
          $fatal;	// @[SimpleHellaCacheIF.scala:137:9]
      end
    end // always @(posedge)
    `ifdef FIRRTL_BEFORE_INITIAL
      `FIRRTL_BEFORE_INITIAL
    `endif // FIRRTL_BEFORE_INITIAL
    logic [31:0] _RANDOM_0;
    logic [31:0] _RANDOM_1;
    logic [31:0] _RANDOM_2;
    initial begin
      `ifdef INIT_RANDOM_PROLOG_
        `INIT_RANDOM_PROLOG_
      `endif // INIT_RANDOM_PROLOG_
      `ifdef RANDOMIZE_REG_INIT
        _RANDOM_0 = `RANDOM;
        _RANDOM_1 = `RANDOM;
        _RANDOM_2 = `RANDOM;
        s1_req_fire = _RANDOM_0[0];	// @[SimpleHellaCacheIF.scala:119:28]
        s2_req_fire = _RANDOM_0[1];	// @[SimpleHellaCacheIF.scala:119:28, :120:28]
        s1_req_tag = _RANDOM_0[9:2];	// @[SimpleHellaCacheIF.scala:119:28, :121:27]
        s2_req_tag = _RANDOM_0[17:10];	// @[SimpleHellaCacheIF.scala:119:28, :122:27]
        REG = _RANDOM_0[18];	// @[SimpleHellaCacheIF.scala:119:28, :124:18]
        io_cache_s1_data_data_r = {_RANDOM_0[31:19], _RANDOM_1, _RANDOM_2[18:0]};	// @[Reg.scala:19:16, SimpleHellaCacheIF.scala:119:28]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  SimpleHellaCacheIFReplayQueue replayq (	// @[SimpleHellaCacheIF.scala:103:23]
    .clock                   (clock),
    .reset                   (reset),
    .io_req_valid            (_req_arb_io_in_1_ready & io_requestor_req_valid),	// @[Misc.scala:25:53, SimpleHellaCacheIF.scala:104:23]
    .io_req_bits_addr        (io_requestor_req_bits_addr),
    .io_req_bits_tag         (io_requestor_req_bits_tag),
    .io_req_bits_cmd         (io_requestor_req_bits_cmd),
    .io_req_bits_dprv        (io_requestor_req_bits_dprv),
    .io_req_bits_dv          (io_requestor_req_bits_dv),
    .io_req_bits_data        (io_requestor_req_bits_data),
    .io_req_bits_mask        (io_requestor_req_bits_mask),
    .io_nack_valid           (io_cache_s2_nack & s2_req_fire),	// @[SimpleHellaCacheIF.scala:120:28, :132:45]
    .io_nack_bits            (s2_req_tag[5:0]),	// @[SimpleHellaCacheIF.scala:122:27, :133:24]
    .io_resp_valid           (io_cache_resp_valid),
    .io_resp_bits_tag        (io_cache_resp_bits_tag),
    .io_replay_ready         (_req_arb_io_in_0_ready),	// @[SimpleHellaCacheIF.scala:104:23]
    .io_req_ready            (_replayq_io_req_ready),
    .io_replay_valid         (_replayq_io_replay_valid),
    .io_replay_bits_addr     (_replayq_io_replay_bits_addr),
    .io_replay_bits_tag      (_replayq_io_replay_bits_tag),
    .io_replay_bits_cmd      (_replayq_io_replay_bits_cmd),
    .io_replay_bits_size     (_replayq_io_replay_bits_size),
    .io_replay_bits_signed   (_replayq_io_replay_bits_signed),
    .io_replay_bits_dprv     (_replayq_io_replay_bits_dprv),
    .io_replay_bits_dv       (_replayq_io_replay_bits_dv),
    .io_replay_bits_phys     (_replayq_io_replay_bits_phys),
    .io_replay_bits_no_alloc (_replayq_io_replay_bits_no_alloc),
    .io_replay_bits_no_xcpt  (_replayq_io_replay_bits_no_xcpt),
    .io_replay_bits_data     (_replayq_io_replay_bits_data),
    .io_replay_bits_mask     (_replayq_io_replay_bits_mask)
  );
  Arbiter_10 req_arb (	// @[SimpleHellaCacheIF.scala:104:23]
    .io_in_0_valid         (_replayq_io_replay_valid),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_addr     (_replayq_io_replay_bits_addr),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_tag      (_replayq_io_replay_bits_tag),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_cmd      (_replayq_io_replay_bits_cmd),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_size     (_replayq_io_replay_bits_size),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_signed   (_replayq_io_replay_bits_signed),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_dprv     (_replayq_io_replay_bits_dprv),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_dv       (_replayq_io_replay_bits_dv),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_phys     (_replayq_io_replay_bits_phys),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_no_alloc (_replayq_io_replay_bits_no_alloc),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_no_xcpt  (_replayq_io_replay_bits_no_xcpt),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_data     (_replayq_io_replay_bits_data),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_0_bits_mask     (_replayq_io_replay_bits_mask),	// @[SimpleHellaCacheIF.scala:103:23]
    .io_in_1_valid         (_replayq_io_req_ready & io_requestor_req_valid),	// @[Misc.scala:25:53, SimpleHellaCacheIF.scala:103:23]
    .io_in_1_bits_addr     (io_requestor_req_bits_addr),
    .io_in_1_bits_tag      (io_requestor_req_bits_tag),
    .io_in_1_bits_cmd      (io_requestor_req_bits_cmd),
    .io_in_1_bits_dprv     (io_requestor_req_bits_dprv),
    .io_in_1_bits_dv       (io_requestor_req_bits_dv),
    .io_in_1_bits_data     (io_requestor_req_bits_data),
    .io_in_1_bits_mask     (io_requestor_req_bits_mask),
    .io_out_ready          (io_cache_req_ready),
    .io_in_0_ready         (_req_arb_io_in_0_ready),
    .io_in_1_ready         (_req_arb_io_in_1_ready),
    .io_out_valid          (_req_arb_io_out_valid),
    .io_out_bits_addr      (io_cache_req_bits_addr),
    .io_out_bits_tag       (_req_arb_io_out_bits_tag),
    .io_out_bits_cmd       (io_cache_req_bits_cmd),
    .io_out_bits_size      (io_cache_req_bits_size),
    .io_out_bits_signed    (io_cache_req_bits_signed),
    .io_out_bits_dprv      (io_cache_req_bits_dprv),
    .io_out_bits_dv        (io_cache_req_bits_dv),
    .io_out_bits_phys      (io_cache_req_bits_phys),
    .io_out_bits_no_alloc  (io_cache_req_bits_no_alloc),
    .io_out_bits_no_xcpt   (io_cache_req_bits_no_xcpt),
    .io_out_bits_data      (_req_arb_io_out_bits_data),
    .io_out_bits_mask      (io_cache_req_bits_mask)
  );
  assign io_requestor_req_ready = _req_arb_io_in_1_ready & _replayq_io_req_ready;	// @[Misc.scala:25:53, SimpleHellaCacheIF.scala:103:23, :104:23]
  assign io_requestor_resp_valid = io_cache_resp_valid;
  assign io_requestor_resp_bits_data = io_cache_resp_bits_data;
  assign io_cache_req_valid = _req_arb_io_out_valid;	// @[SimpleHellaCacheIF.scala:104:23]
  assign io_cache_req_bits_tag = _req_arb_io_out_bits_tag;	// @[SimpleHellaCacheIF.scala:104:23]
  assign io_cache_s1_data_data = io_cache_s1_data_data_r;	// @[Reg.scala:19:16]
endmodule

