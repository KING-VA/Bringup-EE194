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

module AsyncQueueSource_20(
  input         clock,
                reset,
                io_enq_valid,
  input  [2:0]  io_enq_bits_opcode,
                io_enq_bits_param,
  input  [3:0]  io_enq_bits_size,
  input  [1:0]  io_enq_bits_source,
  input  [34:0] io_enq_bits_address,
  input  [63:0] io_enq_bits_data,
  input  [3:0]  io_async_ridx,
  input         io_async_safe_ridx_valid,
                io_async_safe_sink_reset_n,
  output        io_enq_ready,
  output [2:0]  io_async_mem_0_opcode,
                io_async_mem_0_param,
  output [3:0]  io_async_mem_0_size,
  output [1:0]  io_async_mem_0_source,
  output [34:0] io_async_mem_0_address,
  output [63:0] io_async_mem_0_data,
  output        io_async_mem_0_corrupt,
  output [2:0]  io_async_mem_1_opcode,
                io_async_mem_1_param,
  output [3:0]  io_async_mem_1_size,
  output [1:0]  io_async_mem_1_source,
  output [34:0] io_async_mem_1_address,
  output [63:0] io_async_mem_1_data,
  output        io_async_mem_1_corrupt,
  output [2:0]  io_async_mem_2_opcode,
                io_async_mem_2_param,
  output [3:0]  io_async_mem_2_size,
  output [1:0]  io_async_mem_2_source,
  output [34:0] io_async_mem_2_address,
  output [63:0] io_async_mem_2_data,
  output        io_async_mem_2_corrupt,
  output [2:0]  io_async_mem_3_opcode,
                io_async_mem_3_param,
  output [3:0]  io_async_mem_3_size,
  output [1:0]  io_async_mem_3_source,
  output [34:0] io_async_mem_3_address,
  output [63:0] io_async_mem_3_data,
  output        io_async_mem_3_corrupt,
  output [2:0]  io_async_mem_4_opcode,
                io_async_mem_4_param,
  output [3:0]  io_async_mem_4_size,
  output [1:0]  io_async_mem_4_source,
  output [34:0] io_async_mem_4_address,
  output [63:0] io_async_mem_4_data,
  output        io_async_mem_4_corrupt,
  output [2:0]  io_async_mem_5_opcode,
                io_async_mem_5_param,
  output [3:0]  io_async_mem_5_size,
  output [1:0]  io_async_mem_5_source,
  output [34:0] io_async_mem_5_address,
  output [63:0] io_async_mem_5_data,
  output        io_async_mem_5_corrupt,
  output [2:0]  io_async_mem_6_opcode,
                io_async_mem_6_param,
  output [3:0]  io_async_mem_6_size,
  output [1:0]  io_async_mem_6_source,
  output [34:0] io_async_mem_6_address,
  output [63:0] io_async_mem_6_data,
  output        io_async_mem_6_corrupt,
  output [2:0]  io_async_mem_7_opcode,
                io_async_mem_7_param,
  output [3:0]  io_async_mem_7_size,
  output [1:0]  io_async_mem_7_source,
  output [34:0] io_async_mem_7_address,
  output [63:0] io_async_mem_7_data,
  output        io_async_mem_7_corrupt,
  output [3:0]  io_async_widx,
  output        io_async_safe_widx_valid,
                io_async_safe_source_reset_n
);

  wire        _io_enq_ready_output;	// @[AsyncQueue.scala:89:29]
  wire        _sink_valid_io_out;	// @[AsyncQueue.scala:104:30]
  wire        _sink_extend_io_out;	// @[AsyncQueue.scala:103:30]
  wire        _source_valid_0_io_out;	// @[AsyncQueue.scala:100:32]
  wire [3:0]  _ridx_ridx_gray_io_q;	// @[ShiftReg.scala:45:23]
  reg  [2:0]  mem_0_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_0_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_0_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_0_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_0_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_0_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_0_corrupt;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_1_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_1_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_1_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_1_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_1_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_1_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_1_corrupt;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_2_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_2_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_2_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_2_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_2_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_2_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_2_corrupt;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_3_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_3_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_3_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_3_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_3_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_3_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_3_corrupt;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_4_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_4_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_4_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_4_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_4_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_4_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_4_corrupt;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_5_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_5_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_5_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_5_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_5_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_5_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_5_corrupt;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_6_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_6_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_6_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_6_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_6_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_6_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_6_corrupt;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_7_opcode;	// @[AsyncQueue.scala:80:16]
  reg  [2:0]  mem_7_param;	// @[AsyncQueue.scala:80:16]
  reg  [3:0]  mem_7_size;	// @[AsyncQueue.scala:80:16]
  reg  [1:0]  mem_7_source;	// @[AsyncQueue.scala:80:16]
  reg  [34:0] mem_7_address;	// @[AsyncQueue.scala:80:16]
  reg  [63:0] mem_7_data;	// @[AsyncQueue.scala:80:16]
  reg         mem_7_corrupt;	// @[AsyncQueue.scala:80:16]
  wire        _T = _io_enq_ready_output & io_enq_valid;	// @[AsyncQueue.scala:89:29, Decoupled.scala:51:35]
  reg  [3:0]  widx_widx_bin;	// @[AsyncQueue.scala:52:25]
  reg         ready_reg;	// @[AsyncQueue.scala:88:56]
  assign _io_enq_ready_output = ready_reg & _sink_valid_io_out;	// @[AsyncQueue.scala:88:56, :89:29, :104:30]
  reg  [3:0]  widx_gray;	// @[AsyncQueue.scala:91:55]
  wire [2:0]  index = widx_gray[2:0] ^ {widx_gray[3], 2'h0};	// @[AsyncQueue.scala:85:{52,64,80,93}, :91:55]
  wire        _GEN = _T & index == 3'h0;	// @[AsyncQueue.scala:52:25, :80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  wire        _GEN_0 = _T & index == 3'h1;	// @[AsyncQueue.scala:80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  wire        _GEN_1 = _T & index == 3'h2;	// @[AsyncQueue.scala:80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  wire        _GEN_2 = _T & index == 3'h3;	// @[AsyncQueue.scala:80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  wire        _GEN_3 = _T & index == 3'h4;	// @[AsyncQueue.scala:80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  wire        _GEN_4 = _T & index == 3'h5;	// @[AsyncQueue.scala:80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  wire        _GEN_5 = _T & index == 3'h6;	// @[AsyncQueue.scala:80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  wire        _GEN_6 = _T & (&index);	// @[AsyncQueue.scala:80:16, :85:64, :86:{24,37}, Decoupled.scala:51:35]
  always @(posedge clock) begin
    if (_GEN) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_0_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_0_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_0_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_0_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_0_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_0_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_0_corrupt <= ~_GEN & mem_0_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
    if (_GEN_0) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_1_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_1_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_1_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_1_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_1_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_1_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_1_corrupt <= ~_GEN_0 & mem_1_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
    if (_GEN_1) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_2_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_2_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_2_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_2_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_2_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_2_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_2_corrupt <= ~_GEN_1 & mem_2_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
    if (_GEN_2) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_3_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_3_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_3_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_3_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_3_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_3_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_3_corrupt <= ~_GEN_2 & mem_3_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
    if (_GEN_3) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_4_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_4_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_4_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_4_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_4_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_4_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_4_corrupt <= ~_GEN_3 & mem_4_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
    if (_GEN_4) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_5_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_5_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_5_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_5_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_5_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_5_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_5_corrupt <= ~_GEN_4 & mem_5_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
    if (_GEN_5) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_6_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_6_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_6_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_6_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_6_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_6_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_6_corrupt <= ~_GEN_5 & mem_6_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
    if (_GEN_6) begin	// @[AsyncQueue.scala:80:16, :86:{24,37}]
      mem_7_opcode <= io_enq_bits_opcode;	// @[AsyncQueue.scala:80:16]
      mem_7_param <= io_enq_bits_param;	// @[AsyncQueue.scala:80:16]
      mem_7_size <= io_enq_bits_size;	// @[AsyncQueue.scala:80:16]
      mem_7_source <= io_enq_bits_source;	// @[AsyncQueue.scala:80:16]
      mem_7_address <= io_enq_bits_address;	// @[AsyncQueue.scala:80:16]
      mem_7_data <= io_enq_bits_data;	// @[AsyncQueue.scala:80:16]
    end
    mem_7_corrupt <= ~_GEN_6 & mem_7_corrupt;	// @[AsyncQueue.scala:80:16, :86:{24,37}]
  end // always @(posedge)
  wire [3:0]  _widx_incremented_T_1 = widx_widx_bin + {3'h0, _T};	// @[AsyncQueue.scala:52:25, :53:43, Decoupled.scala:51:35]
  wire [3:0]  widx_incremented = _sink_valid_io_out ? _widx_incremented_T_1 : 4'h0;	// @[AsyncQueue.scala:53:{23,43}, :104:30]
  wire [3:0]  widx = widx_incremented ^ {1'h0, widx_incremented[3:1]};	// @[AsyncQueue.scala:53:23, :54:{17,32}]
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      widx_widx_bin <= 4'h0;	// @[AsyncQueue.scala:52:25, :53:23]
      ready_reg <= 1'h0;	// @[AsyncQueue.scala:88:56]
      widx_gray <= 4'h0;	// @[AsyncQueue.scala:53:23, :91:55]
    end
    else begin
      if (_sink_valid_io_out)	// @[AsyncQueue.scala:104:30]
        widx_widx_bin <= _widx_incremented_T_1;	// @[AsyncQueue.scala:52:25, :53:43]
      else	// @[AsyncQueue.scala:104:30]
        widx_widx_bin <= 4'h0;	// @[AsyncQueue.scala:52:25, :53:23]
      ready_reg <= _sink_valid_io_out & widx != (_ridx_ridx_gray_io_q ^ 4'hC);	// @[AsyncQueue.scala:54:17, :83:{26,34,44}, :88:56, :104:30, ShiftReg.scala:45:23]
      widx_gray <= widx;	// @[AsyncQueue.scala:54:17, :91:55]
    end
  end // always @(posedge, posedge)
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
    logic [31:0] _RANDOM_16;
    logic [31:0] _RANDOM_17;
    logic [31:0] _RANDOM_18;
    logic [31:0] _RANDOM_19;
    logic [31:0] _RANDOM_20;
    logic [31:0] _RANDOM_21;
    logic [31:0] _RANDOM_22;
    logic [31:0] _RANDOM_23;
    logic [31:0] _RANDOM_24;
    logic [31:0] _RANDOM_25;
    logic [31:0] _RANDOM_26;
    logic [31:0] _RANDOM_27;
    logic [31:0] _RANDOM_28;
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
        _RANDOM_16 = `RANDOM;
        _RANDOM_17 = `RANDOM;
        _RANDOM_18 = `RANDOM;
        _RANDOM_19 = `RANDOM;
        _RANDOM_20 = `RANDOM;
        _RANDOM_21 = `RANDOM;
        _RANDOM_22 = `RANDOM;
        _RANDOM_23 = `RANDOM;
        _RANDOM_24 = `RANDOM;
        _RANDOM_25 = `RANDOM;
        _RANDOM_26 = `RANDOM;
        _RANDOM_27 = `RANDOM;
        _RANDOM_28 = `RANDOM;
        mem_0_opcode = _RANDOM_0[2:0];	// @[AsyncQueue.scala:80:16]
        mem_0_param = _RANDOM_0[5:3];	// @[AsyncQueue.scala:80:16]
        mem_0_size = _RANDOM_0[9:6];	// @[AsyncQueue.scala:80:16]
        mem_0_source = _RANDOM_0[11:10];	// @[AsyncQueue.scala:80:16]
        mem_0_address = {_RANDOM_0[31:12], _RANDOM_1[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_0_data = {_RANDOM_1[31:15], _RANDOM_2, _RANDOM_3[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_0_corrupt = _RANDOM_3[15];	// @[AsyncQueue.scala:80:16]
        mem_1_opcode = _RANDOM_3[18:16];	// @[AsyncQueue.scala:80:16]
        mem_1_param = _RANDOM_3[21:19];	// @[AsyncQueue.scala:80:16]
        mem_1_size = _RANDOM_3[25:22];	// @[AsyncQueue.scala:80:16]
        mem_1_source = _RANDOM_3[27:26];	// @[AsyncQueue.scala:80:16]
        mem_1_address = {_RANDOM_3[31:28], _RANDOM_4[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_1_data = {_RANDOM_4[31], _RANDOM_5, _RANDOM_6[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_1_corrupt = _RANDOM_6[31];	// @[AsyncQueue.scala:80:16]
        mem_2_opcode = _RANDOM_7[2:0];	// @[AsyncQueue.scala:80:16]
        mem_2_param = _RANDOM_7[5:3];	// @[AsyncQueue.scala:80:16]
        mem_2_size = _RANDOM_7[9:6];	// @[AsyncQueue.scala:80:16]
        mem_2_source = _RANDOM_7[11:10];	// @[AsyncQueue.scala:80:16]
        mem_2_address = {_RANDOM_7[31:12], _RANDOM_8[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_2_data = {_RANDOM_8[31:15], _RANDOM_9, _RANDOM_10[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_2_corrupt = _RANDOM_10[15];	// @[AsyncQueue.scala:80:16]
        mem_3_opcode = _RANDOM_10[18:16];	// @[AsyncQueue.scala:80:16]
        mem_3_param = _RANDOM_10[21:19];	// @[AsyncQueue.scala:80:16]
        mem_3_size = _RANDOM_10[25:22];	// @[AsyncQueue.scala:80:16]
        mem_3_source = _RANDOM_10[27:26];	// @[AsyncQueue.scala:80:16]
        mem_3_address = {_RANDOM_10[31:28], _RANDOM_11[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_3_data = {_RANDOM_11[31], _RANDOM_12, _RANDOM_13[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_3_corrupt = _RANDOM_13[31];	// @[AsyncQueue.scala:80:16]
        mem_4_opcode = _RANDOM_14[2:0];	// @[AsyncQueue.scala:80:16]
        mem_4_param = _RANDOM_14[5:3];	// @[AsyncQueue.scala:80:16]
        mem_4_size = _RANDOM_14[9:6];	// @[AsyncQueue.scala:80:16]
        mem_4_source = _RANDOM_14[11:10];	// @[AsyncQueue.scala:80:16]
        mem_4_address = {_RANDOM_14[31:12], _RANDOM_15[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_4_data = {_RANDOM_15[31:15], _RANDOM_16, _RANDOM_17[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_4_corrupt = _RANDOM_17[15];	// @[AsyncQueue.scala:80:16]
        mem_5_opcode = _RANDOM_17[18:16];	// @[AsyncQueue.scala:80:16]
        mem_5_param = _RANDOM_17[21:19];	// @[AsyncQueue.scala:80:16]
        mem_5_size = _RANDOM_17[25:22];	// @[AsyncQueue.scala:80:16]
        mem_5_source = _RANDOM_17[27:26];	// @[AsyncQueue.scala:80:16]
        mem_5_address = {_RANDOM_17[31:28], _RANDOM_18[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_5_data = {_RANDOM_18[31], _RANDOM_19, _RANDOM_20[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_5_corrupt = _RANDOM_20[31];	// @[AsyncQueue.scala:80:16]
        mem_6_opcode = _RANDOM_21[2:0];	// @[AsyncQueue.scala:80:16]
        mem_6_param = _RANDOM_21[5:3];	// @[AsyncQueue.scala:80:16]
        mem_6_size = _RANDOM_21[9:6];	// @[AsyncQueue.scala:80:16]
        mem_6_source = _RANDOM_21[11:10];	// @[AsyncQueue.scala:80:16]
        mem_6_address = {_RANDOM_21[31:12], _RANDOM_22[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_6_data = {_RANDOM_22[31:15], _RANDOM_23, _RANDOM_24[14:0]};	// @[AsyncQueue.scala:80:16]
        mem_6_corrupt = _RANDOM_24[15];	// @[AsyncQueue.scala:80:16]
        mem_7_opcode = _RANDOM_24[18:16];	// @[AsyncQueue.scala:80:16]
        mem_7_param = _RANDOM_24[21:19];	// @[AsyncQueue.scala:80:16]
        mem_7_size = _RANDOM_24[25:22];	// @[AsyncQueue.scala:80:16]
        mem_7_source = _RANDOM_24[27:26];	// @[AsyncQueue.scala:80:16]
        mem_7_address = {_RANDOM_24[31:28], _RANDOM_25[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_7_data = {_RANDOM_25[31], _RANDOM_26, _RANDOM_27[30:0]};	// @[AsyncQueue.scala:80:16]
        mem_7_corrupt = _RANDOM_27[31];	// @[AsyncQueue.scala:80:16]
        widx_widx_bin = _RANDOM_28[3:0];	// @[AsyncQueue.scala:52:25]
        ready_reg = _RANDOM_28[4];	// @[AsyncQueue.scala:52:25, :88:56]
        widx_gray = _RANDOM_28[8:5];	// @[AsyncQueue.scala:52:25, :91:55]
      `endif // RANDOMIZE_REG_INIT
      `ifdef RANDOMIZE
        if (reset) begin
          widx_widx_bin = 4'h0;	// @[AsyncQueue.scala:52:25, :53:23]
          ready_reg = 1'h0;	// @[AsyncQueue.scala:88:56]
          widx_gray = 4'h0;	// @[AsyncQueue.scala:53:23, :91:55]
        end
      `endif // RANDOMIZE
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  AsyncResetSynchronizerShiftReg_w4_d3_i0 ridx_ridx_gray (	// @[ShiftReg.scala:45:23]
    .clock (clock),
    .reset (reset),
    .io_d  (io_async_ridx),
    .io_q  (_ridx_ridx_gray_io_q)
  );
  AsyncValidSync source_valid_0 (	// @[AsyncQueue.scala:100:32]
    .io_in  (1'h1),	// @[AsyncQueue.scala:79:28]
    .clock  (clock),
    .reset  (reset | ~io_async_safe_sink_reset_n),	// @[AsyncQueue.scala:105:{43,46}]
    .io_out (_source_valid_0_io_out)
  );
  AsyncValidSync source_valid_1 (	// @[AsyncQueue.scala:101:32]
    .io_in  (_source_valid_0_io_out),	// @[AsyncQueue.scala:100:32]
    .clock  (clock),
    .reset  (reset | ~io_async_safe_sink_reset_n),	// @[AsyncQueue.scala:105:46, :106:43]
    .io_out (io_async_safe_widx_valid)
  );
  AsyncValidSync sink_extend (	// @[AsyncQueue.scala:103:30]
    .io_in  (io_async_safe_ridx_valid),
    .clock  (clock),
    .reset  (reset | ~io_async_safe_sink_reset_n),	// @[AsyncQueue.scala:105:46, :107:43]
    .io_out (_sink_extend_io_out)
  );
  AsyncValidSync sink_valid (	// @[AsyncQueue.scala:104:30]
    .io_in  (_sink_extend_io_out),	// @[AsyncQueue.scala:103:30]
    .clock  (clock),
    .reset  (reset),
    .io_out (_sink_valid_io_out)
  );
  assign io_enq_ready = _io_enq_ready_output;	// @[AsyncQueue.scala:89:29]
  assign io_async_mem_0_opcode = mem_0_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_0_param = mem_0_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_0_size = mem_0_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_0_source = mem_0_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_0_address = mem_0_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_0_data = mem_0_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_0_corrupt = mem_0_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_1_opcode = mem_1_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_1_param = mem_1_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_1_size = mem_1_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_1_source = mem_1_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_1_address = mem_1_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_1_data = mem_1_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_1_corrupt = mem_1_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_2_opcode = mem_2_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_2_param = mem_2_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_2_size = mem_2_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_2_source = mem_2_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_2_address = mem_2_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_2_data = mem_2_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_2_corrupt = mem_2_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_3_opcode = mem_3_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_3_param = mem_3_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_3_size = mem_3_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_3_source = mem_3_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_3_address = mem_3_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_3_data = mem_3_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_3_corrupt = mem_3_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_4_opcode = mem_4_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_4_param = mem_4_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_4_size = mem_4_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_4_source = mem_4_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_4_address = mem_4_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_4_data = mem_4_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_4_corrupt = mem_4_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_5_opcode = mem_5_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_5_param = mem_5_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_5_size = mem_5_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_5_source = mem_5_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_5_address = mem_5_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_5_data = mem_5_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_5_corrupt = mem_5_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_6_opcode = mem_6_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_6_param = mem_6_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_6_size = mem_6_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_6_source = mem_6_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_6_address = mem_6_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_6_data = mem_6_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_6_corrupt = mem_6_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_7_opcode = mem_7_opcode;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_7_param = mem_7_param;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_7_size = mem_7_size;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_7_source = mem_7_source;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_7_address = mem_7_address;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_7_data = mem_7_data;	// @[AsyncQueue.scala:80:16]
  assign io_async_mem_7_corrupt = mem_7_corrupt;	// @[AsyncQueue.scala:80:16]
  assign io_async_widx = widx_gray;	// @[AsyncQueue.scala:91:55]
  assign io_async_safe_source_reset_n = ~reset;	// @[AsyncQueue.scala:121:27]
endmodule

