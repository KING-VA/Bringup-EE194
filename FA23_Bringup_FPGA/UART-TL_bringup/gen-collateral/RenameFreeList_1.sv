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

module RenameFreeList_1(
  input        clock,
               reset,
               io_reqs_0,
               io_dealloc_pregs_0_valid,
  input  [5:0] io_dealloc_pregs_0_bits,
  input        io_ren_br_tags_0_valid,
  input  [2:0] io_ren_br_tags_0_bits,
               io_brupdate_b2_uop_br_tag,
  input        io_brupdate_b2_mispredict,
               io_debug_pipeline_empty,
  output       io_alloc_pregs_0_valid,
  output [5:0] io_alloc_pregs_0_bits
);

  reg  [5:0]       r_sel;	// @[Reg.scala:19:16]
  reg  [47:0]      free_list;	// @[rename-freelist.scala:50:26]
  reg  [47:0]      br_alloc_lists_0;	// @[rename-freelist.scala:51:27]
  reg  [47:0]      br_alloc_lists_1;	// @[rename-freelist.scala:51:27]
  reg  [47:0]      br_alloc_lists_2;	// @[rename-freelist.scala:51:27]
  reg  [47:0]      br_alloc_lists_3;	// @[rename-freelist.scala:51:27]
  reg  [47:0]      br_alloc_lists_4;	// @[rename-freelist.scala:51:27]
  reg  [47:0]      br_alloc_lists_5;	// @[rename-freelist.scala:51:27]
  reg  [47:0]      br_alloc_lists_6;	// @[rename-freelist.scala:51:27]
  reg  [47:0]      br_alloc_lists_7;	// @[rename-freelist.scala:51:27]
  wire [47:0]      sels_0 = free_list[0] ? 48'h1 : free_list[1] ? 48'h2 : free_list[2] ? 48'h4 : free_list[3] ? 48'h8 : free_list[4] ? 48'h10 : free_list[5] ? 48'h20 : free_list[6] ? 48'h40 : free_list[7] ? 48'h80 : free_list[8] ? 48'h100 : free_list[9] ? 48'h200 : free_list[10] ? 48'h400 : free_list[11] ? 48'h800 : free_list[12] ? 48'h1000 : free_list[13] ? 48'h2000 : free_list[14] ? 48'h4000 : free_list[15] ? 48'h8000 : free_list[16] ? 48'h10000 : free_list[17] ? 48'h20000 : free_list[18] ? 48'h40000 : free_list[19] ? 48'h80000 : free_list[20] ? 48'h100000 : free_list[21] ? 48'h200000 : free_list[22] ? 48'h400000 : free_list[23] ? 48'h800000 : free_list[24] ? 48'h1000000 : free_list[25] ? 48'h2000000 : free_list[26] ? 48'h4000000 : free_list[27] ? 48'h8000000 : free_list[28] ? 48'h10000000 : free_list[29] ? 48'h20000000 : free_list[30] ? 48'h40000000 : free_list[31] ? 48'h80000000 : free_list[32] ? 48'h100000000 : free_list[33] ? 48'h200000000 : free_list[34] ? 48'h400000000 : free_list[35] ? 48'h800000000 : free_list[36] ? 48'h1000000000 : free_list[37] ? 48'h2000000000 : free_list[38] ? 48'h4000000000 : free_list[39] ? 48'h8000000000 : free_list[40] ? 48'h10000000000 : free_list[41] ? 48'h20000000000 : free_list[42] ? 48'h40000000000 : free_list[43] ? 48'h80000000000 : free_list[44] ? 48'h100000000000 : free_list[45] ? 48'h200000000000 : free_list[46] ? 48'h400000000000 : {free_list[47], 47'h0};	// @[Mux.scala:47:70, OneHot.scala:84:71, rename-freelist.scala:50:{26,45}]
  wire [63:0]      allocs_0 = 64'h1 << r_sel;	// @[OneHot.scala:57:35, Reg.scala:19:16]
  wire [7:0][47:0] _GEN = {{br_alloc_lists_7}, {br_alloc_lists_6}, {br_alloc_lists_5}, {br_alloc_lists_4}, {br_alloc_lists_3}, {br_alloc_lists_2}, {br_alloc_lists_1}, {br_alloc_lists_0}};	// @[rename-freelist.scala:51:27, :63:63]
  wire [47:0]      br_deallocs = _GEN[io_brupdate_b2_uop_br_tag] & {48{io_brupdate_b2_mispredict}};	// @[Bitwise.scala:77:12, rename-freelist.scala:63:63]
  wire [63:0]      _dealloc_mask_T = 64'h1 << io_dealloc_pregs_0_bits;	// @[OneHot.scala:57:35]
  wire [47:0]      dealloc_mask = _dealloc_mask_T[47:0] & {48{io_dealloc_pregs_0_valid}} | br_deallocs;	// @[Bitwise.scala:77:12, OneHot.scala:57:35, rename-freelist.scala:63:63, :64:{64,79,110}]
  reg              r_valid;	// @[rename-freelist.scala:81:26]
  wire             sel_fire_0 = (~r_valid | io_reqs_0) & (|sels_0);	// @[Mux.scala:47:70, rename-freelist.scala:80:27, :81:26, :85:{21,30,45}]
  wire [30:0]      _GEN_0 = {16'h0, sels_0[47:33]} | sels_0[31:1];	// @[Mux.scala:47:70, OneHot.scala:31:18, :32:28, rename-freelist.scala:59:88]
  wire [14:0]      _GEN_1 = _GEN_0[30:16] | _GEN_0[14:0];	// @[OneHot.scala:30:18, :31:18, :32:28]
  wire [6:0]       _GEN_2 = _GEN_1[14:8] | _GEN_1[6:0];	// @[OneHot.scala:30:18, :31:18, :32:28]
  wire [2:0]       _GEN_3 = _GEN_2[6:4] | _GEN_2[2:0];	// @[OneHot.scala:30:18, :31:18, :32:28]
  wire [47:0]      _GEN_4 = allocs_0[47:0] & {48{io_reqs_0}};	// @[Bitwise.scala:77:12, OneHot.scala:57:35, rename-freelist.scala:59:88]
  always @(posedge clock) begin
    if (reset) begin
      free_list <= 48'hFFFFFFFFFFFE;	// @[rename-freelist.scala:50:{26,45}]
      r_valid <= 1'h0;	// @[rename-freelist.scala:51:27, :81:26]
    end
    else begin
      free_list <= (free_list & ~(sels_0 & {48{sel_fire_0}}) | dealloc_mask) & 48'hFFFFFFFFFFFE;	// @[Bitwise.scala:77:12, Mux.scala:47:70, rename-freelist.scala:50:{26,45}, :62:60, :64:110, :76:{27,29,39,55}, :85:45]
      r_valid <= r_valid & ~io_reqs_0 | (|sels_0);	// @[Mux.scala:47:70, rename-freelist.scala:80:27, :81:26, :84:{24,27,39}]
    end
    br_alloc_lists_0 <= io_ren_br_tags_0_bits == 3'h0 & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_0 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, OneHot.scala:57:35, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    br_alloc_lists_1 <= io_ren_br_tags_0_bits == 3'h1 & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_1 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, OneHot.scala:57:35, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    br_alloc_lists_2 <= io_ren_br_tags_0_bits == 3'h2 & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_2 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, OneHot.scala:57:35, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    br_alloc_lists_3 <= io_ren_br_tags_0_bits == 3'h3 & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_3 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, OneHot.scala:57:35, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    br_alloc_lists_4 <= io_ren_br_tags_0_bits == 3'h4 & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_4 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, OneHot.scala:57:35, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    br_alloc_lists_5 <= io_ren_br_tags_0_bits == 3'h5 & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_5 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, OneHot.scala:57:35, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    br_alloc_lists_6 <= io_ren_br_tags_0_bits == 3'h6 & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_6 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, OneHot.scala:57:35, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    br_alloc_lists_7 <= (&io_ren_br_tags_0_bits) & io_ren_br_tags_0_valid ? 48'h0 : br_alloc_lists_7 & ~br_deallocs | _GEN_4;	// @[Mux.scala:47:70, rename-freelist.scala:51:27, :59:88, :63:63, :69:{72,85}, :71:29, :72:{58,60,73}]
    if (sel_fire_0)	// @[rename-freelist.scala:85:45]
      r_sel <= {|(sels_0[47:32]), |(_GEN_0[30:15]), |(_GEN_1[14:7]), |(_GEN_2[6:3]), |(_GEN_3[2:1]), _GEN_3[2] | _GEN_3[0]};	// @[Cat.scala:33:92, Mux.scala:47:70, OneHot.scala:30:18, :31:18, :32:{14,28}, Reg.scala:19:16]
  end // always @(posedge)
  `ifndef SYNTHESIS
    wire  [47:0] _GEN_5 = free_list | allocs_0[47:0] & {48{r_valid}};	// @[Bitwise.scala:77:12, OneHot.scala:57:35, rename-freelist.scala:50:26, :81:26, :91:{34,77}]
    always @(posedge clock) begin	// @[rename-freelist.scala:94:10]
      if (~reset & (|(_GEN_5 & dealloc_mask))) begin	// @[rename-freelist.scala:64:110, :91:34, :94:{10,31,47}]
        if (`ASSERT_VERBOSE_COND_)	// @[rename-freelist.scala:94:10]
          $error("Assertion failed: [freelist] Returning a free physical register.\n    at rename-freelist.scala:94 assert (!(io.debug.freelist & dealloc_mask).orR, \"[freelist] Returning a free physical register.\")\n");	// @[rename-freelist.scala:94:10]
        if (`STOP_COND_)	// @[rename-freelist.scala:94:10]
          $fatal;	// @[rename-freelist.scala:94:10]
      end
      if (~reset & ~(~io_debug_pipeline_empty | {1'h0, {1'h0, {1'h0, {1'h0, {1'h0, _GEN_5[0]} + {1'h0, _GEN_5[1]} + {1'h0, _GEN_5[2]}} + {1'h0, {1'h0, _GEN_5[3]} + {1'h0, _GEN_5[4]} + {1'h0, _GEN_5[5]}}} + {1'h0, {1'h0, {1'h0, _GEN_5[6]} + {1'h0, _GEN_5[7]} + {1'h0, _GEN_5[8]}} + {1'h0, {1'h0, _GEN_5[9]} + {1'h0, _GEN_5[10]} + {1'h0, _GEN_5[11]}}}} + {1'h0, {1'h0, {1'h0, {1'h0, _GEN_5[12]} + {1'h0, _GEN_5[13]} + {1'h0, _GEN_5[14]}} + {1'h0, {1'h0, _GEN_5[15]} + {1'h0, _GEN_5[16]} + {1'h0, _GEN_5[17]}}} + {1'h0, {1'h0, {1'h0, _GEN_5[18]} + {1'h0, _GEN_5[19]} + {1'h0, _GEN_5[20]}} + {1'h0, {1'h0, _GEN_5[21]} + {1'h0, _GEN_5[22]} + {1'h0, _GEN_5[23]}}}}} + {1'h0, {1'h0, {1'h0, {1'h0, {1'h0, _GEN_5[24]} + {1'h0, _GEN_5[25]} + {1'h0, _GEN_5[26]}} + {1'h0, {1'h0, _GEN_5[27]} + {1'h0, _GEN_5[28]} + {1'h0, _GEN_5[29]}}} + {1'h0, {1'h0, {1'h0, _GEN_5[30]} + {1'h0, _GEN_5[31]} + {1'h0, _GEN_5[32]}} + {1'h0, {1'h0, _GEN_5[33]} + {1'h0, _GEN_5[34]} + {1'h0, _GEN_5[35]}}}} + {1'h0, {1'h0, {1'h0, {1'h0, _GEN_5[36]} + {1'h0, _GEN_5[37]} + {1'h0, _GEN_5[38]}} + {1'h0, {1'h0, _GEN_5[39]} + {1'h0, _GEN_5[40]} + {1'h0, _GEN_5[41]}}} + {1'h0, {1'h0, {1'h0, _GEN_5[42]} + {1'h0, _GEN_5[43]} + {1'h0, _GEN_5[44]}} + {1'h0, {1'h0, _GEN_5[45]} + {1'h0, _GEN_5[46]} + {1'h0, _GEN_5[47]}}}}} > 6'hE)) begin	// @[Bitwise.scala:51:90, :53:100, rename-freelist.scala:51:27, :91:34, :95:{10,11,36,67}]
        if (`ASSERT_VERBOSE_COND_)	// @[rename-freelist.scala:95:10]
          $error("Assertion failed: [freelist] Leaking physical registers.\n    at rename-freelist.scala:95 assert (!io.debug.pipeline_empty || PopCount(io.debug.freelist) >= (numPregs - numLregs - 1).U,\n");	// @[rename-freelist.scala:95:10]
        if (`STOP_COND_)	// @[rename-freelist.scala:95:10]
          $fatal;	// @[rename-freelist.scala:95:10]
      end
    end // always @(posedge)
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
        free_list = {_RANDOM_0, _RANDOM_1[15:0]};	// @[rename-freelist.scala:50:26]
        br_alloc_lists_0 = {_RANDOM_1[31:16], _RANDOM_2};	// @[rename-freelist.scala:50:26, :51:27]
        br_alloc_lists_1 = {_RANDOM_3, _RANDOM_4[15:0]};	// @[rename-freelist.scala:51:27]
        br_alloc_lists_2 = {_RANDOM_4[31:16], _RANDOM_5};	// @[rename-freelist.scala:51:27]
        br_alloc_lists_3 = {_RANDOM_6, _RANDOM_7[15:0]};	// @[rename-freelist.scala:51:27]
        br_alloc_lists_4 = {_RANDOM_7[31:16], _RANDOM_8};	// @[rename-freelist.scala:51:27]
        br_alloc_lists_5 = {_RANDOM_9, _RANDOM_10[15:0]};	// @[rename-freelist.scala:51:27]
        br_alloc_lists_6 = {_RANDOM_10[31:16], _RANDOM_11};	// @[rename-freelist.scala:51:27]
        br_alloc_lists_7 = {_RANDOM_12, _RANDOM_13[15:0]};	// @[rename-freelist.scala:51:27]
        r_valid = _RANDOM_13[16];	// @[rename-freelist.scala:51:27, :81:26]
        r_sel = _RANDOM_13[22:17];	// @[Reg.scala:19:16, rename-freelist.scala:51:27]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  assign io_alloc_pregs_0_valid = r_valid;	// @[rename-freelist.scala:81:26]
  assign io_alloc_pregs_0_bits = r_sel;	// @[Reg.scala:19:16]
endmodule

