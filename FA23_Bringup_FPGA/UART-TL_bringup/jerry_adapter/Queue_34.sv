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

module Queue_34(
  input         clock,
                reset,
                io_enq_valid,
  input  [3:0]  io_enq_bits_id,
  input  [31:0] io_enq_bits_addr,
  input  [7:0]  io_enq_bits_len,
  input  [2:0]  io_enq_bits_size,
  input  [3:0]  io_enq_bits_echo_tl_state_size,
                io_enq_bits_echo_tl_state_source,
  input         io_enq_bits_wen,
                io_deq_ready,
  output        io_enq_ready,
                io_deq_valid,
  output [3:0]  io_deq_bits_id,
  output [31:0] io_deq_bits_addr,
  output [7:0]  io_deq_bits_len,
  output [2:0]  io_deq_bits_size,
  output [1:0]  io_deq_bits_burst,
  output        io_deq_bits_lock,
  output [3:0]  io_deq_bits_cache,
  output [2:0]  io_deq_bits_prot,
  output [3:0]  io_deq_bits_qos,
                io_deq_bits_echo_tl_state_size,
                io_deq_bits_echo_tl_state_source,
  output        io_deq_bits_wen
);

  wire [69:0] _ram_ext_R0_data;	// @[Decoupled.scala:273:95]
  reg         maybe_full;	// @[Decoupled.scala:276:27]
  wire        _io_deq_valid_output = io_enq_valid | maybe_full;	// @[Decoupled.scala:276:27, :302:16, :314:{24,39}]
  wire        do_enq = ~(~maybe_full & io_deq_ready) & ~maybe_full & io_enq_valid;	// @[Decoupled.scala:276:27, :278:28, :280:27, :303:19, :315:17, :318:{26,35}]
  always @(posedge clock) begin
    if (reset)
      maybe_full <= 1'h0;	// @[Decoupled.scala:276:27]
    else if (do_enq != (maybe_full & io_deq_ready & _io_deq_valid_output))	// @[Decoupled.scala:276:27, :280:27, :281:27, :293:15, :302:16, :314:{24,39}, :315:17, :317:14, :318:{26,35}]
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
  ram_combMem_1 ram_ext (	// @[Decoupled.scala:273:95]
    .R0_addr (1'h0),
    .R0_en   (1'h1),
    .R0_clk  (clock),
    .W0_addr (1'h0),
    .W0_en   (do_enq),	// @[Decoupled.scala:280:27, :315:17, :318:{26,35}]
    .W0_clk  (clock),
    .W0_data ({io_enq_bits_wen, io_enq_bits_echo_tl_state_source, io_enq_bits_echo_tl_state_size, 14'h81, io_enq_bits_size, io_enq_bits_len, io_enq_bits_addr, io_enq_bits_id}),	// @[Decoupled.scala:273:95]
    .R0_data (_ram_ext_R0_data)
  );
  assign io_enq_ready = ~maybe_full;	// @[Decoupled.scala:276:27, :303:19]
  assign io_deq_valid = _io_deq_valid_output;	// @[Decoupled.scala:302:16, :314:{24,39}]
  assign io_deq_bits_id = maybe_full ? _ram_ext_R0_data[3:0] : io_enq_bits_id;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_addr = maybe_full ? _ram_ext_R0_data[35:4] : io_enq_bits_addr;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_len = maybe_full ? _ram_ext_R0_data[43:36] : io_enq_bits_len;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_size = maybe_full ? _ram_ext_R0_data[46:44] : io_enq_bits_size;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_burst = maybe_full ? _ram_ext_R0_data[48:47] : 2'h1;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_lock = maybe_full & _ram_ext_R0_data[49];	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_cache = maybe_full ? _ram_ext_R0_data[53:50] : 4'h0;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_prot = maybe_full ? _ram_ext_R0_data[56:54] : 3'h1;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_qos = maybe_full ? _ram_ext_R0_data[60:57] : 4'h0;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_echo_tl_state_size = maybe_full ? _ram_ext_R0_data[64:61] : io_enq_bits_echo_tl_state_size;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_echo_tl_state_source = maybe_full ? _ram_ext_R0_data[68:65] : io_enq_bits_echo_tl_state_source;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
  assign io_deq_bits_wen = maybe_full ? _ram_ext_R0_data[69] : io_enq_bits_wen;	// @[Decoupled.scala:273:95, :276:27, :310:17, :315:17, :316:19]
endmodule

