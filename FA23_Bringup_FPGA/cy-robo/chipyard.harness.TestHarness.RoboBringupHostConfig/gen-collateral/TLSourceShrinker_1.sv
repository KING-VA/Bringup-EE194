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

module TLSourceShrinker_1(
  input         clock,
                reset,
                auto_in_a_valid,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [2:0]  auto_in_a_bits_opcode,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_in_a_bits_param,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_in_a_bits_size,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [4:0]  auto_in_a_bits_source,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [30:0] auto_in_a_bits_address,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [7:0]  auto_in_a_bits_mask,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [63:0] auto_in_a_bits_data,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input         auto_in_a_bits_corrupt,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_in_d_ready,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_out_a_ready,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_out_d_valid,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [2:0]  auto_out_d_bits_opcode,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [1:0]  auto_out_d_bits_param,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [2:0]  auto_out_d_bits_size,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [3:0]  auto_out_d_bits_source,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input         auto_out_d_bits_sink,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_out_d_bits_denied,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input  [63:0] auto_out_d_bits_data,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  input         auto_out_d_bits_corrupt,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output        auto_in_a_ready,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_in_d_valid,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [2:0]  auto_in_d_bits_opcode,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [1:0]  auto_in_d_bits_param,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [2:0]  auto_in_d_bits_size,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [4:0]  auto_in_d_bits_source,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output        auto_in_d_bits_sink,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_in_d_bits_denied,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [63:0] auto_in_d_bits_data,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output        auto_in_d_bits_corrupt,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_out_a_valid,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [2:0]  auto_out_a_bits_opcode,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_out_a_bits_param,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_out_a_bits_size,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [3:0]  auto_out_a_bits_source,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [30:0] auto_out_a_bits_address,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [7:0]  auto_out_a_bits_mask,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output [63:0] auto_out_a_bits_data,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
  output        auto_out_a_bits_corrupt,	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
                auto_out_d_ready	// @[generators/rocket-chip/src/main/scala/diplomacy/LazyModule.scala:367:18]
);

  wire        nodeIn_a_ready;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:63:35]
  wire [4:0]  _sourceIdMap_ext_R0_data;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:53:30]
  reg  [15:0] allocated;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32]
  wire [15:0] _nextFreeOH_T_16 = ~allocated;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32, :55:35]
  wire [14:0] _GEN = _nextFreeOH_T_16[14:0] | {_nextFreeOH_T_16[13:0], 1'h0};	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:55:35, generators/rocket-chip/src/main/scala/util/package.scala:245:{43,48,53}]
  wire [14:0] _GEN_0 = _GEN | {_GEN[12:0], 2'h0};	// @[generators/rocket-chip/src/main/scala/util/package.scala:245:{43,48,53}]
  wire [14:0] _GEN_1 = _GEN_0 | {_GEN_0[10:0], 4'h0};	// @[generators/rocket-chip/src/main/scala/util/package.scala:245:{43,48,53}]
  wire [15:0] _GEN_2 = {~(_GEN_1 | {_GEN_1[6:0], 8'h0}), 1'h1} & _nextFreeOH_T_16;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:55:{26,35,47,53}, generators/rocket-chip/src/main/scala/util/package.scala:245:{43,48,53}]
  wire [6:0]  _GEN_3 = _GEN_2[15:9] | _GEN_2[7:1];	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:55:53, src/main/scala/chisel3/util/OneHot.scala:30:18, :31:18, :32:28]
  wire [2:0]  _GEN_4 = _GEN_3[6:4] | _GEN_3[2:0];	// @[src/main/scala/chisel3/util/OneHot.scala:30:18, :31:18, :32:28]
  wire        _nextFree_T_8 = _GEN_4[2] | _GEN_4[0];	// @[src/main/scala/chisel3/util/OneHot.scala:30:18, :31:18, :32:28]
  wire        _alloc_T = nodeIn_a_ready & auto_in_a_valid;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:63:35, src/main/scala/chisel3/util/Decoupled.scala:52:35]
  reg  [2:0]  a_first_counter;	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27]
  wire        a_first = a_first_counter == 3'h0;	// @[generators/rocket-chip/src/main/scala/tilelink/Bundles.scala:259:74, generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, :232:25]
  reg  [2:0]  d_last_counter;	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27]
  wire        block = a_first & (&allocated);	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:232:25, generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32, :57:30, :62:29]
  assign nodeIn_a_ready = auto_out_a_ready & ~block;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:62:29, :63:{35,38}]
  reg  [4:0]  nodeOut_a_bits_source_r;	// @[generators/rocket-chip/src/main/scala/util/package.scala:80:63]
  wire [12:0] _a_first_beats1_decode_T_1 = 13'h3F << auto_in_a_bits_size;	// @[generators/rocket-chip/src/main/scala/util/package.scala:235:71]
  wire        _free_T = auto_in_d_ready & auto_out_d_valid;	// @[src/main/scala/chisel3/util/Decoupled.scala:52:35]
  wire [12:0] _d_last_beats1_decode_T_1 = 13'h3F << auto_out_d_bits_size;	// @[generators/rocket-chip/src/main/scala/util/package.scala:235:71]
  always @(posedge clock) begin
    if (reset) begin
      allocated <= 16'h0;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32]
      a_first_counter <= 3'h0;	// @[generators/rocket-chip/src/main/scala/tilelink/Bundles.scala:259:74, generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27]
      d_last_counter <= 3'h0;	// @[generators/rocket-chip/src/main/scala/tilelink/Bundles.scala:259:74, generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27]
    end
    else begin
      allocated <= (allocated | (a_first & _alloc_T ? _GEN_2 : 16'h0)) & ~((d_last_counter == 3'h1 | (auto_out_d_bits_opcode[0] ? ~(_d_last_beats1_decode_T_1[5:3]) : 3'h0) == 3'h0) & _free_T ? 16'h1 << auto_out_d_bits_source : 16'h0);	// @[generators/rocket-chip/src/main/scala/tilelink/Bundles.scala:259:74, generators/rocket-chip/src/main/scala/tilelink/Edges.scala:107:36, :222:14, :230:27, :232:25, :233:{25,33,43}, generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32, :55:53, :76:29, :77:27, :78:27, :79:26, :80:{33,45,47}, generators/rocket-chip/src/main/scala/util/package.scala:235:{46,71,76}, src/main/scala/chisel3/util/Decoupled.scala:52:35, src/main/scala/chisel3/util/OneHot.scala:58:35]
      if (_alloc_T) begin	// @[src/main/scala/chisel3/util/Decoupled.scala:52:35]
        if (a_first) begin	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:232:25]
          if (auto_in_a_bits_opcode[2])	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:93:37]
            a_first_counter <= 3'h0;	// @[generators/rocket-chip/src/main/scala/tilelink/Bundles.scala:259:74, generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27]
          else	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:93:37]
            a_first_counter <= ~(_a_first_beats1_decode_T_1[5:3]);	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, generators/rocket-chip/src/main/scala/util/package.scala:235:{46,71,76}]
        end
        else	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:232:25]
          a_first_counter <= a_first_counter - 3'h1;	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, :231:28]
      end
      if (_free_T) begin	// @[src/main/scala/chisel3/util/Decoupled.scala:52:35]
        if (d_last_counter == 3'h0) begin	// @[generators/rocket-chip/src/main/scala/tilelink/Bundles.scala:259:74, generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, :232:25]
          if (auto_out_d_bits_opcode[0])	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:107:36]
            d_last_counter <= ~(_d_last_beats1_decode_T_1[5:3]);	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, generators/rocket-chip/src/main/scala/util/package.scala:235:{46,71,76}]
          else	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:107:36]
            d_last_counter <= 3'h0;	// @[generators/rocket-chip/src/main/scala/tilelink/Bundles.scala:259:74, generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27]
        end
        else	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:232:25]
          d_last_counter <= d_last_counter - 3'h1;	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, :231:28]
      end
    end
    if (a_first)	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:232:25]
      nodeOut_a_bits_source_r <= {1'h0, |(_GEN_2[15:8]), |(_GEN_3[6:3]), |(_GEN_4[2:1]), _nextFree_T_8};	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:55:53, generators/rocket-chip/src/main/scala/util/package.scala:80:63, :245:48, src/main/scala/chisel3/util/OneHot.scala:30:18, :32:{10,14,28}]
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
        allocated = _RANDOM_0[15:0];	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32]
        a_first_counter = _RANDOM_0[18:16];	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32]
        d_last_counter = _RANDOM_0[21:19];	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:230:27, generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32]
        nodeOut_a_bits_source_r = _RANDOM_0[26:22];	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:54:32, generators/rocket-chip/src/main/scala/util/package.scala:80:63]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  TLMonitor_14 monitor (	// @[generators/rocket-chip/src/main/scala/tilelink/Nodes.scala:24:25]
    .clock                (clock),
    .reset                (reset),
    .io_in_a_ready        (nodeIn_a_ready),	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:63:35]
    .io_in_a_valid        (auto_in_a_valid),
    .io_in_a_bits_opcode  (auto_in_a_bits_opcode),
    .io_in_a_bits_param   (auto_in_a_bits_param),
    .io_in_a_bits_size    (auto_in_a_bits_size),
    .io_in_a_bits_source  (auto_in_a_bits_source),
    .io_in_a_bits_address (auto_in_a_bits_address),
    .io_in_a_bits_mask    (auto_in_a_bits_mask),
    .io_in_a_bits_corrupt (auto_in_a_bits_corrupt),
    .io_in_d_ready        (auto_in_d_ready),
    .io_in_d_valid        (auto_out_d_valid),
    .io_in_d_bits_opcode  (auto_out_d_bits_opcode),
    .io_in_d_bits_param   (auto_out_d_bits_param),
    .io_in_d_bits_size    (auto_out_d_bits_size),
    .io_in_d_bits_source  (_sourceIdMap_ext_R0_data),	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:53:30]
    .io_in_d_bits_sink    (auto_out_d_bits_sink),
    .io_in_d_bits_denied  (auto_out_d_bits_denied),
    .io_in_d_bits_corrupt (auto_out_d_bits_corrupt)
  );
  sourceIdMap_combMem sourceIdMap_ext (	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:53:30]
    .R0_addr (auto_out_d_bits_source),
    .R0_en   (1'h1),
    .R0_clk  (clock),
    .W0_addr ({|(_GEN_2[15:8]), |(_GEN_3[6:3]), |(_GEN_4[2:1]), _nextFree_T_8}),	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:55:53, :73:22, src/main/scala/chisel3/util/OneHot.scala:30:18, :32:{14,28}]
    .W0_en   (a_first & _alloc_T),	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:232:25, generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:72:23, src/main/scala/chisel3/util/Decoupled.scala:52:35]
    .W0_clk  (clock),
    .W0_data (auto_in_a_bits_source),
    .R0_data (_sourceIdMap_ext_R0_data)
  );
  assign auto_in_a_ready = nodeIn_a_ready;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:63:35]
  assign auto_in_d_valid = auto_out_d_valid;
  assign auto_in_d_bits_opcode = auto_out_d_bits_opcode;
  assign auto_in_d_bits_param = auto_out_d_bits_param;
  assign auto_in_d_bits_size = auto_out_d_bits_size;
  assign auto_in_d_bits_source = _sourceIdMap_ext_R0_data;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:53:30]
  assign auto_in_d_bits_sink = auto_out_d_bits_sink;
  assign auto_in_d_bits_denied = auto_out_d_bits_denied;
  assign auto_in_d_bits_data = auto_out_d_bits_data;
  assign auto_in_d_bits_corrupt = auto_out_d_bits_corrupt;
  assign auto_out_a_valid = auto_in_a_valid & ~block;	// @[generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:62:29, :63:38, :64:35]
  assign auto_out_a_bits_opcode = auto_in_a_bits_opcode;
  assign auto_out_a_bits_param = auto_in_a_bits_param;
  assign auto_out_a_bits_size = auto_in_a_bits_size;
  assign auto_out_a_bits_source = a_first ? {|(_GEN_2[15:8]), |(_GEN_3[6:3]), |(_GEN_4[2:1]), _nextFree_T_8} : nodeOut_a_bits_source_r[3:0];	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:232:25, generators/rocket-chip/src/main/scala/tilelink/SourceShrinker.scala:55:53, generators/rocket-chip/src/main/scala/util/package.scala:80:{42,63}, src/main/scala/chisel3/util/OneHot.scala:30:18, :32:{10,14,28}]
  assign auto_out_a_bits_address = auto_in_a_bits_address;
  assign auto_out_a_bits_mask = auto_in_a_bits_mask;
  assign auto_out_a_bits_data = auto_in_a_bits_data;
  assign auto_out_a_bits_corrupt = auto_in_a_bits_corrupt;
  assign auto_out_d_ready = auto_in_d_ready;
endmodule

