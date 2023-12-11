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

module RotatingSingleVCAllocator_3(
  input  clock,
         reset,
         io_req_5_valid,
         io_req_5_bits_vc_sel_5_0,
         io_req_5_bits_vc_sel_4_0,
         io_req_5_bits_vc_sel_3_0,
         io_req_5_bits_vc_sel_2_0,
         io_req_5_bits_vc_sel_1_0,
         io_req_5_bits_vc_sel_0_0,
         io_req_5_bits_vc_sel_0_1,
         io_req_5_bits_vc_sel_0_2,
         io_req_5_bits_vc_sel_0_3,
         io_req_5_bits_vc_sel_0_4,
         io_req_5_bits_vc_sel_0_5,
         io_req_5_bits_vc_sel_0_6,
         io_req_5_bits_vc_sel_0_7,
         io_req_5_bits_vc_sel_0_8,
         io_req_5_bits_vc_sel_0_9,
         io_req_1_valid,
         io_req_1_bits_vc_sel_5_0,
         io_req_1_bits_vc_sel_4_0,
         io_req_1_bits_vc_sel_3_0,
         io_req_1_bits_vc_sel_2_0,
         io_req_1_bits_vc_sel_1_0,
         io_req_1_bits_vc_sel_0_0,
         io_req_1_bits_vc_sel_0_1,
         io_req_1_bits_vc_sel_0_2,
         io_req_1_bits_vc_sel_0_3,
         io_req_1_bits_vc_sel_0_4,
         io_req_1_bits_vc_sel_0_5,
         io_req_1_bits_vc_sel_0_6,
         io_req_1_bits_vc_sel_0_7,
         io_req_1_bits_vc_sel_0_8,
         io_req_1_bits_vc_sel_0_9,
         io_req_0_valid,
         io_req_0_bits_vc_sel_5_0,
         io_req_0_bits_vc_sel_4_0,
         io_req_0_bits_vc_sel_3_0,
         io_req_0_bits_vc_sel_2_0,
         io_req_0_bits_vc_sel_1_0,
         io_req_0_bits_vc_sel_0_0,
         io_req_0_bits_vc_sel_0_1,
         io_req_0_bits_vc_sel_0_2,
         io_req_0_bits_vc_sel_0_4,
         io_req_0_bits_vc_sel_0_5,
         io_req_0_bits_vc_sel_0_8,
         io_req_0_bits_vc_sel_0_9,
         io_channel_status_5_0_occupied,
         io_channel_status_4_0_occupied,
         io_channel_status_3_0_occupied,
         io_channel_status_2_0_occupied,
         io_channel_status_1_0_occupied,
         io_channel_status_0_0_occupied,
         io_channel_status_0_1_occupied,
         io_channel_status_0_3_occupied,
         io_channel_status_0_4_occupied,
         io_channel_status_0_5_occupied,
         io_channel_status_0_8_occupied,
         io_channel_status_0_9_occupied,
  output io_req_5_ready,
         io_req_4_ready,
         io_req_3_ready,
         io_req_2_ready,
         io_req_1_ready,
         io_req_0_ready,
         io_resp_5_vc_sel_5_0,
         io_resp_5_vc_sel_4_0,
         io_resp_5_vc_sel_3_0,
         io_resp_5_vc_sel_2_0,
         io_resp_5_vc_sel_1_0,
         io_resp_5_vc_sel_0_0,
         io_resp_5_vc_sel_0_1,
         io_resp_5_vc_sel_0_2,
         io_resp_5_vc_sel_0_3,
         io_resp_5_vc_sel_0_4,
         io_resp_5_vc_sel_0_5,
         io_resp_5_vc_sel_0_6,
         io_resp_5_vc_sel_0_7,
         io_resp_5_vc_sel_0_8,
         io_resp_5_vc_sel_0_9,
         io_resp_4_vc_sel_5_0,
         io_resp_4_vc_sel_4_0,
         io_resp_4_vc_sel_3_0,
         io_resp_4_vc_sel_2_0,
         io_resp_4_vc_sel_1_0,
         io_resp_4_vc_sel_0_0,
         io_resp_4_vc_sel_0_1,
         io_resp_4_vc_sel_0_2,
         io_resp_4_vc_sel_0_3,
         io_resp_4_vc_sel_0_4,
         io_resp_4_vc_sel_0_5,
         io_resp_4_vc_sel_0_6,
         io_resp_4_vc_sel_0_7,
         io_resp_4_vc_sel_0_8,
         io_resp_4_vc_sel_0_9,
         io_resp_3_vc_sel_5_0,
         io_resp_3_vc_sel_4_0,
         io_resp_3_vc_sel_3_0,
         io_resp_3_vc_sel_2_0,
         io_resp_3_vc_sel_1_0,
         io_resp_3_vc_sel_0_0,
         io_resp_3_vc_sel_0_1,
         io_resp_3_vc_sel_0_2,
         io_resp_3_vc_sel_0_3,
         io_resp_3_vc_sel_0_4,
         io_resp_3_vc_sel_0_5,
         io_resp_3_vc_sel_0_6,
         io_resp_3_vc_sel_0_7,
         io_resp_3_vc_sel_0_8,
         io_resp_3_vc_sel_0_9,
         io_resp_2_vc_sel_5_0,
         io_resp_2_vc_sel_4_0,
         io_resp_2_vc_sel_3_0,
         io_resp_2_vc_sel_2_0,
         io_resp_2_vc_sel_1_0,
         io_resp_2_vc_sel_0_0,
         io_resp_2_vc_sel_0_1,
         io_resp_2_vc_sel_0_2,
         io_resp_2_vc_sel_0_3,
         io_resp_2_vc_sel_0_4,
         io_resp_2_vc_sel_0_5,
         io_resp_2_vc_sel_0_6,
         io_resp_2_vc_sel_0_7,
         io_resp_2_vc_sel_0_8,
         io_resp_2_vc_sel_0_9,
         io_resp_1_vc_sel_5_0,
         io_resp_1_vc_sel_4_0,
         io_resp_1_vc_sel_3_0,
         io_resp_1_vc_sel_2_0,
         io_resp_1_vc_sel_1_0,
         io_resp_1_vc_sel_0_0,
         io_resp_1_vc_sel_0_1,
         io_resp_1_vc_sel_0_2,
         io_resp_1_vc_sel_0_3,
         io_resp_1_vc_sel_0_4,
         io_resp_1_vc_sel_0_5,
         io_resp_1_vc_sel_0_6,
         io_resp_1_vc_sel_0_7,
         io_resp_1_vc_sel_0_8,
         io_resp_1_vc_sel_0_9,
         io_resp_0_vc_sel_5_0,
         io_resp_0_vc_sel_4_0,
         io_resp_0_vc_sel_3_0,
         io_resp_0_vc_sel_2_0,
         io_resp_0_vc_sel_1_0,
         io_resp_0_vc_sel_0_0,
         io_resp_0_vc_sel_0_1,
         io_resp_0_vc_sel_0_2,
         io_resp_0_vc_sel_0_4,
         io_resp_0_vc_sel_0_5,
         io_resp_0_vc_sel_0_8,
         io_resp_0_vc_sel_0_9,
         io_out_allocs_5_0_alloc,
         io_out_allocs_4_0_alloc,
         io_out_allocs_3_0_alloc,
         io_out_allocs_2_0_alloc,
         io_out_allocs_1_0_alloc,
         io_out_allocs_0_0_alloc,
         io_out_allocs_0_1_alloc,
         io_out_allocs_0_3_alloc,
         io_out_allocs_0_4_alloc,
         io_out_allocs_0_5_alloc,
         io_out_allocs_0_8_alloc,
         io_out_allocs_0_9_alloc
);

  wire        in_arb_vals_5;	// @[SingleVCAllocator.scala:32:39]
  wire        in_arb_vals_1;	// @[SingleVCAllocator.scala:32:39]
  wire        in_arb_vals_0;	// @[SingleVCAllocator.scala:32:39]
  reg  [5:0]  mask;	// @[SingleVCAllocator.scala:16:21]
  wire [5:0]  _in_arb_filter_T_3 = {in_arb_vals_5, 3'h0, in_arb_vals_1, in_arb_vals_0} & ~mask;	// @[SingleVCAllocator.scala:16:21, :19:{77,84,86}, :32:39]
  wire [11:0] in_arb_filter = _in_arb_filter_T_3[0] ? 12'h1 : _in_arb_filter_T_3[1] ? 12'h2 : _in_arb_filter_T_3[5] ? 12'h20 : in_arb_vals_0 ? 12'h40 : in_arb_vals_1 ? 12'h80 : {in_arb_vals_5, 11'h0};	// @[Mux.scala:47:70, OneHot.scala:84:71, SingleVCAllocator.scala:19:84, :32:39]
  wire [5:0]  in_arb_sel = in_arb_filter[5:0] | in_arb_filter[11:6];	// @[Mux.scala:47:70, SingleVCAllocator.scala:20:{34,57,74}]
  wire        _in_alloc_T = in_arb_vals_0 | in_arb_vals_1;	// @[SingleVCAllocator.scala:32:39, package.scala:73:59]
  wire        in_arb_reqs_0_0_0 = io_req_0_bits_vc_sel_0_0 & ~io_channel_status_0_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_0_1 = io_req_0_bits_vc_sel_0_1 & ~io_channel_status_0_1_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_0_4 = io_req_0_bits_vc_sel_0_4 & ~io_channel_status_0_4_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_0_5 = io_req_0_bits_vc_sel_0_5 & ~io_channel_status_0_5_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_0_8 = io_req_0_bits_vc_sel_0_8 & ~io_channel_status_0_8_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_0_9 = io_req_0_bits_vc_sel_0_9 & ~io_channel_status_0_9_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_1_0 = io_req_0_bits_vc_sel_1_0 & ~io_channel_status_1_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_2_0 = io_req_0_bits_vc_sel_2_0 & ~io_channel_status_2_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_3_0 = io_req_0_bits_vc_sel_3_0 & ~io_channel_status_3_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_4_0 = io_req_0_bits_vc_sel_4_0 & ~io_channel_status_4_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_0_5_0 = io_req_0_bits_vc_sel_5_0 & ~io_channel_status_5_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  assign in_arb_vals_0 = io_req_0_valid & (in_arb_reqs_0_0_0 | in_arb_reqs_0_0_1 | io_req_0_bits_vc_sel_0_2 | in_arb_reqs_0_0_4 | in_arb_reqs_0_0_5 | in_arb_reqs_0_0_8 | in_arb_reqs_0_0_9 | in_arb_reqs_0_1_0 | in_arb_reqs_0_2_0 | in_arb_reqs_0_3_0 | in_arb_reqs_0_4_0 | in_arb_reqs_0_5_0);	// @[SingleVCAllocator.scala:28:61, :32:39, package.scala:73:59]
  wire        in_arb_reqs_1_0_0 = io_req_1_bits_vc_sel_0_0 & ~io_channel_status_0_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_0_1 = io_req_1_bits_vc_sel_0_1 & ~io_channel_status_0_1_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_0_3 = io_req_1_bits_vc_sel_0_3 & ~io_channel_status_0_3_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_0_4 = io_req_1_bits_vc_sel_0_4 & ~io_channel_status_0_4_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_0_5 = io_req_1_bits_vc_sel_0_5 & ~io_channel_status_0_5_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_0_8 = io_req_1_bits_vc_sel_0_8 & ~io_channel_status_0_8_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_0_9 = io_req_1_bits_vc_sel_0_9 & ~io_channel_status_0_9_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_1_0 = io_req_1_bits_vc_sel_1_0 & ~io_channel_status_1_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_2_0 = io_req_1_bits_vc_sel_2_0 & ~io_channel_status_2_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_3_0 = io_req_1_bits_vc_sel_3_0 & ~io_channel_status_3_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_4_0 = io_req_1_bits_vc_sel_4_0 & ~io_channel_status_4_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_1_5_0 = io_req_1_bits_vc_sel_5_0 & ~io_channel_status_5_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  assign in_arb_vals_1 = io_req_1_valid & (in_arb_reqs_1_0_0 | in_arb_reqs_1_0_1 | io_req_1_bits_vc_sel_0_2 | in_arb_reqs_1_0_3 | in_arb_reqs_1_0_4 | in_arb_reqs_1_0_5 | io_req_1_bits_vc_sel_0_6 | io_req_1_bits_vc_sel_0_7 | in_arb_reqs_1_0_8 | in_arb_reqs_1_0_9 | in_arb_reqs_1_1_0 | in_arb_reqs_1_2_0 | in_arb_reqs_1_3_0 | in_arb_reqs_1_4_0 | in_arb_reqs_1_5_0);	// @[SingleVCAllocator.scala:28:61, :32:39, package.scala:73:59]
  wire        in_arb_reqs_5_0_0 = io_req_5_bits_vc_sel_0_0 & ~io_channel_status_0_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_0_1 = io_req_5_bits_vc_sel_0_1 & ~io_channel_status_0_1_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_0_3 = io_req_5_bits_vc_sel_0_3 & ~io_channel_status_0_3_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_0_4 = io_req_5_bits_vc_sel_0_4 & ~io_channel_status_0_4_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_0_5 = io_req_5_bits_vc_sel_0_5 & ~io_channel_status_0_5_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_0_8 = io_req_5_bits_vc_sel_0_8 & ~io_channel_status_0_8_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_0_9 = io_req_5_bits_vc_sel_0_9 & ~io_channel_status_0_9_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_1_0 = io_req_5_bits_vc_sel_1_0 & ~io_channel_status_1_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_2_0 = io_req_5_bits_vc_sel_2_0 & ~io_channel_status_2_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_3_0 = io_req_5_bits_vc_sel_3_0 & ~io_channel_status_3_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_4_0 = io_req_5_bits_vc_sel_4_0 & ~io_channel_status_4_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  wire        in_arb_reqs_5_5_0 = io_req_5_bits_vc_sel_5_0 & ~io_channel_status_5_0_occupied;	// @[SingleVCAllocator.scala:28:{61,64}]
  assign in_arb_vals_5 = io_req_5_valid & (in_arb_reqs_5_0_0 | in_arb_reqs_5_0_1 | io_req_5_bits_vc_sel_0_2 | in_arb_reqs_5_0_3 | in_arb_reqs_5_0_4 | in_arb_reqs_5_0_5 | io_req_5_bits_vc_sel_0_6 | io_req_5_bits_vc_sel_0_7 | in_arb_reqs_5_0_8 | in_arb_reqs_5_0_9 | in_arb_reqs_5_1_0 | in_arb_reqs_5_2_0 | in_arb_reqs_5_3_0 | in_arb_reqs_5_4_0 | in_arb_reqs_5_5_0);	// @[SingleVCAllocator.scala:28:61, :32:39, package.scala:73:59]
  wire        _in_vc_sel_WIRE_1 = in_arb_sel[0] & in_arb_reqs_0_0_0 | in_arb_sel[1] & in_arb_reqs_1_0_0 | in_arb_sel[5] & in_arb_reqs_5_0_0;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_2 = in_arb_sel[0] & in_arb_reqs_0_0_1 | in_arb_sel[1] & in_arb_reqs_1_0_1 | in_arb_sel[5] & in_arb_reqs_5_0_1;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_3 = in_arb_sel[0] & io_req_0_bits_vc_sel_0_2 | in_arb_sel[1] & io_req_1_bits_vc_sel_0_2 | in_arb_sel[5] & io_req_5_bits_vc_sel_0_2;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57]
  wire        _in_vc_sel_WIRE_4 = in_arb_sel[1] & in_arb_reqs_1_0_3 | in_arb_sel[5] & in_arb_reqs_5_0_3;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_5 = in_arb_sel[0] & in_arb_reqs_0_0_4 | in_arb_sel[1] & in_arb_reqs_1_0_4 | in_arb_sel[5] & in_arb_reqs_5_0_4;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_6 = in_arb_sel[0] & in_arb_reqs_0_0_5 | in_arb_sel[1] & in_arb_reqs_1_0_5 | in_arb_sel[5] & in_arb_reqs_5_0_5;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_7 = in_arb_sel[1] & io_req_1_bits_vc_sel_0_6 | in_arb_sel[5] & io_req_5_bits_vc_sel_0_6;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57]
  wire        _in_vc_sel_WIRE_8 = in_arb_sel[1] & io_req_1_bits_vc_sel_0_7 | in_arb_sel[5] & io_req_5_bits_vc_sel_0_7;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57]
  wire        _in_vc_sel_WIRE_9 = in_arb_sel[0] & in_arb_reqs_0_0_8 | in_arb_sel[1] & in_arb_reqs_1_0_8 | in_arb_sel[5] & in_arb_reqs_5_0_8;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_10 = in_arb_sel[0] & in_arb_reqs_0_0_9 | in_arb_sel[1] & in_arb_reqs_1_0_9 | in_arb_sel[5] & in_arb_reqs_5_0_9;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_12 = in_arb_sel[0] & in_arb_reqs_0_1_0 | in_arb_sel[1] & in_arb_reqs_1_1_0 | in_arb_sel[5] & in_arb_reqs_5_1_0;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_14 = in_arb_sel[0] & in_arb_reqs_0_2_0 | in_arb_sel[1] & in_arb_reqs_1_2_0 | in_arb_sel[5] & in_arb_reqs_5_2_0;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_16 = in_arb_sel[0] & in_arb_reqs_0_3_0 | in_arb_sel[1] & in_arb_reqs_1_3_0 | in_arb_sel[5] & in_arb_reqs_5_3_0;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_18 = in_arb_sel[0] & in_arb_reqs_0_4_0 | in_arb_sel[1] & in_arb_reqs_1_4_0 | in_arb_sel[5] & in_arb_reqs_5_4_0;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_vc_sel_WIRE_20 = in_arb_sel[0] & in_arb_reqs_0_5_0 | in_arb_sel[1] & in_arb_reqs_1_5_0 | in_arb_sel[5] & in_arb_reqs_5_5_0;	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:20:57, :28:61]
  wire        _in_alloc_T_4 = _in_alloc_T | in_arb_vals_5;	// @[SingleVCAllocator.scala:32:39, package.scala:73:59]
  reg  [14:0] in_alloc_mask;	// @[ISLIP.scala:17:25]
  wire [14:0] _in_alloc_full_T_1 = {_in_vc_sel_WIRE_20, _in_vc_sel_WIRE_18, _in_vc_sel_WIRE_16, _in_vc_sel_WIRE_14, _in_vc_sel_WIRE_12, _in_vc_sel_WIRE_10, _in_vc_sel_WIRE_9, _in_vc_sel_WIRE_8, _in_vc_sel_WIRE_7, _in_vc_sel_WIRE_6, _in_vc_sel_WIRE_5, _in_vc_sel_WIRE_4, _in_vc_sel_WIRE_3, _in_vc_sel_WIRE_2, _in_vc_sel_WIRE_1} & ~in_alloc_mask;	// @[ISLIP.scala:17:25, :18:{29,31}, :33:18, Mux.scala:27:73]
  wire [29:0] in_alloc_oh = _in_alloc_full_T_1[0] ? 30'h1 : _in_alloc_full_T_1[1] ? 30'h2 : _in_alloc_full_T_1[2] ? 30'h4 : _in_alloc_full_T_1[3] ? 30'h8 : _in_alloc_full_T_1[4] ? 30'h10 : _in_alloc_full_T_1[5] ? 30'h20 : _in_alloc_full_T_1[6] ? 30'h40 : _in_alloc_full_T_1[7] ? 30'h80 : _in_alloc_full_T_1[8] ? 30'h100 : _in_alloc_full_T_1[9] ? 30'h200 : _in_alloc_full_T_1[10] ? 30'h400 : _in_alloc_full_T_1[11] ? 30'h800 : _in_alloc_full_T_1[12] ? 30'h1000 : _in_alloc_full_T_1[13] ? 30'h2000 : _in_alloc_full_T_1[14] ? 30'h4000 : _in_vc_sel_WIRE_1 ? 30'h8000 : _in_vc_sel_WIRE_2 ? 30'h10000 : _in_vc_sel_WIRE_3 ? 30'h20000 : _in_vc_sel_WIRE_4 ? 30'h40000 : _in_vc_sel_WIRE_5 ? 30'h80000 : _in_vc_sel_WIRE_6 ? 30'h100000 : _in_vc_sel_WIRE_7 ? 30'h200000 : _in_vc_sel_WIRE_8 ? 30'h400000 : _in_vc_sel_WIRE_9 ? 30'h800000 : _in_vc_sel_WIRE_10 ? 30'h1000000 : _in_vc_sel_WIRE_12 ? 30'h2000000 : _in_vc_sel_WIRE_14 ? 30'h4000000 : _in_vc_sel_WIRE_16 ? 30'h8000000 : _in_vc_sel_WIRE_18 ? 30'h10000000 : {_in_vc_sel_WIRE_20, 29'h0};	// @[ISLIP.scala:18:29, Mux.scala:27:73, :47:70, OneHot.scala:84:71]
  wire [14:0] _in_alloc_WIRE_1 = in_alloc_oh[14:0] | in_alloc_oh[29:15];	// @[ISLIP.scala:20:{20,28,34}, Mux.scala:47:70]
  wire        in_alloc_5_0 = _in_alloc_T_4 & _in_alloc_WIRE_1[14];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_4_0 = _in_alloc_T_4 & _in_alloc_WIRE_1[13];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_3_0 = _in_alloc_T_4 & _in_alloc_WIRE_1[12];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_2_0 = _in_alloc_T_4 & _in_alloc_WIRE_1[11];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_1_0 = _in_alloc_T_4 & _in_alloc_WIRE_1[10];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_0 = _in_alloc_T_4 & _in_alloc_WIRE_1[0];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_1 = _in_alloc_T_4 & _in_alloc_WIRE_1[1];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_2 = _in_alloc_T_4 & _in_alloc_WIRE_1[2];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_3 = _in_alloc_T_4 & _in_alloc_WIRE_1[3];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_4 = _in_alloc_T_4 & _in_alloc_WIRE_1[4];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_5 = _in_alloc_T_4 & _in_alloc_WIRE_1[5];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_6 = _in_alloc_T_4 & _in_alloc_WIRE_1[6];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_7 = _in_alloc_T_4 & _in_alloc_WIRE_1[7];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_8 = _in_alloc_T_4 & _in_alloc_WIRE_1[8];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  wire        in_alloc_0_9 = _in_alloc_T_4 & _in_alloc_WIRE_1[9];	// @[ISLIP.scala:20:28, :33:40, SingleVCAllocator.scala:41:18, package.scala:73:59]
  always @(posedge clock) begin
    if (reset) begin
      mask <= 6'h0;	// @[SingleVCAllocator.scala:16:21]
      in_alloc_mask <= 15'h0;	// @[ISLIP.scala:17:25]
    end
    else begin
      if (_in_alloc_T | in_arb_vals_5)	// @[SingleVCAllocator.scala:32:39, package.scala:73:59]
        mask <= {1'h0, {1'h0, {1'h0, {1'h0, {1'h0, in_arb_sel[0]} | {2{in_arb_sel[1]}}} | {3{in_arb_sel[2]}}} | {4{in_arb_sel[3]}}} | {5{in_arb_sel[4]}}} | {6{in_arb_sel[5]}};	// @[Mux.scala:27:73, :29:36, SingleVCAllocator.scala:16:21, :20:57]
      if (in_arb_sel[0] & io_req_0_valid | in_arb_sel[1] & io_req_1_valid | in_arb_sel[5] & io_req_5_valid) begin	// @[Decoupled.scala:51:35, Mux.scala:29:36, SingleVCAllocator.scala:20:57, package.scala:73:59]
        if (_in_alloc_WIRE_1[0])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h1;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[1])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h3;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[2])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h7;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[3])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'hF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[4])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h1F;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[5])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h3F;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[6])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h7F;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[7])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'hFF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[8])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h1FF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[9])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h3FF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[10])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h7FF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[11])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'hFFF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[12])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h1FFF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else if (_in_alloc_WIRE_1[13])	// @[ISLIP.scala:20:28, :23:14]
          in_alloc_mask <= 15'h3FFF;	// @[ISLIP.scala:17:25, Mux.scala:101:16]
        else	// @[ISLIP.scala:23:14]
          in_alloc_mask <= {15{_in_alloc_WIRE_1[14]}};	// @[ISLIP.scala:17:25, :20:28, :23:14, Mux.scala:101:16]
      end
    end
  end // always @(posedge)
  `ifndef SYNTHESIS
    wire  [1:0]  _GEN = {1'h0, in_alloc_0_1};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_0 = {1'h0, in_alloc_0_2};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_1 = {1'h0, in_alloc_0_0};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_2 = {1'h0, in_alloc_0_3};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_3 = {1'h0, in_alloc_0_4};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_4 = {1'h0, in_alloc_0_5};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_5 = {1'h0, in_alloc_0_6};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_6 = {1'h0, in_alloc_0_7};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_7 = {1'h0, in_alloc_0_8};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_8 = {1'h0, in_alloc_0_9};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_9 = {1'h0, in_alloc_1_0};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_10 = {1'h0, in_alloc_2_0};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_11 = {1'h0, in_alloc_3_0};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_12 = {1'h0, in_alloc_4_0};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [1:0]  _GEN_13 = {1'h0, in_alloc_5_0};	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:41:18]
    wire  [3:0]  _T_48 = {1'h0, {1'h0, _GEN_1 + _GEN + _GEN_0} + {1'h0, _GEN_2 + _GEN_3} + {1'h0, _GEN_4 + _GEN_5}} + {1'h0, {1'h0, _GEN_6 + _GEN_7} + {1'h0, _GEN_8 + _GEN_9}} + {1'h0, {1'h0, _GEN_10 + _GEN_11} + {1'h0, _GEN_12 + _GEN_13}};	// @[Bitwise.scala:51:90]
    wire  [3:0]  _T_96 = {1'h0, {1'h0, _GEN_1 + _GEN + _GEN_0} + {1'h0, _GEN_2 + _GEN_3} + {1'h0, _GEN_4 + _GEN_5}} + {1'h0, {1'h0, _GEN_6 + _GEN_7} + {1'h0, _GEN_8 + _GEN_9}} + {1'h0, {1'h0, _GEN_10 + _GEN_11} + {1'h0, _GEN_12 + _GEN_13}};	// @[Bitwise.scala:51:90]
    wire  [3:0]  _T_144 = {1'h0, {1'h0, _GEN_1 + _GEN + _GEN_0} + {1'h0, _GEN_2 + _GEN_3} + {1'h0, _GEN_4 + _GEN_5}} + {1'h0, {1'h0, _GEN_6 + _GEN_7} + {1'h0, _GEN_8 + _GEN_9}} + {1'h0, {1'h0, _GEN_10 + _GEN_11} + {1'h0, _GEN_12 + _GEN_13}};	// @[Bitwise.scala:51:90]
    wire  [3:0]  _T_192 = {1'h0, {1'h0, _GEN_1 + _GEN + _GEN_0} + {1'h0, _GEN_2 + _GEN_3} + {1'h0, _GEN_4 + _GEN_5}} + {1'h0, {1'h0, _GEN_6 + _GEN_7} + {1'h0, _GEN_8 + _GEN_9}} + {1'h0, {1'h0, _GEN_10 + _GEN_11} + {1'h0, _GEN_12 + _GEN_13}};	// @[Bitwise.scala:51:90]
    wire  [3:0]  _T_240 = {1'h0, {1'h0, _GEN_1 + _GEN + _GEN_0} + {1'h0, _GEN_2 + _GEN_3} + {1'h0, _GEN_4 + _GEN_5}} + {1'h0, {1'h0, _GEN_6 + _GEN_7} + {1'h0, _GEN_8 + _GEN_9}} + {1'h0, {1'h0, _GEN_10 + _GEN_11} + {1'h0, _GEN_12 + _GEN_13}};	// @[Bitwise.scala:51:90]
    wire  [3:0]  _T_288 = {1'h0, {1'h0, _GEN_1 + _GEN + _GEN_0} + {1'h0, _GEN_2 + _GEN_3} + {1'h0, _GEN_4 + _GEN_5}} + {1'h0, {1'h0, _GEN_6 + _GEN_7} + {1'h0, _GEN_8 + _GEN_9}} + {1'h0, {1'h0, _GEN_10 + _GEN_11} + {1'h0, _GEN_12 + _GEN_13}};	// @[Bitwise.scala:51:90]
    always @(posedge clock) begin	// @[SingleVCAllocator.scala:53:11]
      if (~reset & (|(_T_48[3:1]))) begin	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:53:{11,47}]
        if (`ASSERT_VERBOSE_COND_)	// @[SingleVCAllocator.scala:53:11]
          $error("Assertion failed\n    at SingleVCAllocator.scala:53 assert(PopCount(io.resp(i).vc_sel.asUInt) <= 1.U)\n");	// @[SingleVCAllocator.scala:53:11]
        if (`STOP_COND_)	// @[SingleVCAllocator.scala:53:11]
          $fatal;	// @[SingleVCAllocator.scala:53:11]
      end
      if (~reset & (|(_T_96[3:1]))) begin	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:53:{11,47}]
        if (`ASSERT_VERBOSE_COND_)	// @[SingleVCAllocator.scala:53:11]
          $error("Assertion failed\n    at SingleVCAllocator.scala:53 assert(PopCount(io.resp(i).vc_sel.asUInt) <= 1.U)\n");	// @[SingleVCAllocator.scala:53:11]
        if (`STOP_COND_)	// @[SingleVCAllocator.scala:53:11]
          $fatal;	// @[SingleVCAllocator.scala:53:11]
      end
      if (~reset & (|(_T_144[3:1]))) begin	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:53:{11,47}]
        if (`ASSERT_VERBOSE_COND_)	// @[SingleVCAllocator.scala:53:11]
          $error("Assertion failed\n    at SingleVCAllocator.scala:53 assert(PopCount(io.resp(i).vc_sel.asUInt) <= 1.U)\n");	// @[SingleVCAllocator.scala:53:11]
        if (`STOP_COND_)	// @[SingleVCAllocator.scala:53:11]
          $fatal;	// @[SingleVCAllocator.scala:53:11]
      end
      if (~reset & (|(_T_192[3:1]))) begin	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:53:{11,47}]
        if (`ASSERT_VERBOSE_COND_)	// @[SingleVCAllocator.scala:53:11]
          $error("Assertion failed\n    at SingleVCAllocator.scala:53 assert(PopCount(io.resp(i).vc_sel.asUInt) <= 1.U)\n");	// @[SingleVCAllocator.scala:53:11]
        if (`STOP_COND_)	// @[SingleVCAllocator.scala:53:11]
          $fatal;	// @[SingleVCAllocator.scala:53:11]
      end
      if (~reset & (|(_T_240[3:1]))) begin	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:53:{11,47}]
        if (`ASSERT_VERBOSE_COND_)	// @[SingleVCAllocator.scala:53:11]
          $error("Assertion failed\n    at SingleVCAllocator.scala:53 assert(PopCount(io.resp(i).vc_sel.asUInt) <= 1.U)\n");	// @[SingleVCAllocator.scala:53:11]
        if (`STOP_COND_)	// @[SingleVCAllocator.scala:53:11]
          $fatal;	// @[SingleVCAllocator.scala:53:11]
      end
      if (~reset & (|(_T_288[3:1]))) begin	// @[Bitwise.scala:51:90, SingleVCAllocator.scala:53:{11,47}]
        if (`ASSERT_VERBOSE_COND_)	// @[SingleVCAllocator.scala:53:11]
          $error("Assertion failed\n    at SingleVCAllocator.scala:53 assert(PopCount(io.resp(i).vc_sel.asUInt) <= 1.U)\n");	// @[SingleVCAllocator.scala:53:11]
        if (`STOP_COND_)	// @[SingleVCAllocator.scala:53:11]
          $fatal;	// @[SingleVCAllocator.scala:53:11]
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
        mask = _RANDOM_0[5:0];	// @[SingleVCAllocator.scala:16:21]
        in_alloc_mask = _RANDOM_0[20:6];	// @[ISLIP.scala:17:25, SingleVCAllocator.scala:16:21]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  assign io_req_5_ready = in_arb_sel[5];	// @[Mux.scala:29:36, SingleVCAllocator.scala:20:57]
  assign io_req_4_ready = in_arb_sel[4];	// @[Mux.scala:29:36, SingleVCAllocator.scala:20:57]
  assign io_req_3_ready = in_arb_sel[3];	// @[Mux.scala:29:36, SingleVCAllocator.scala:20:57]
  assign io_req_2_ready = in_arb_sel[2];	// @[Mux.scala:29:36, SingleVCAllocator.scala:20:57]
  assign io_req_1_ready = in_arb_sel[1];	// @[Mux.scala:29:36, SingleVCAllocator.scala:20:57]
  assign io_req_0_ready = in_arb_sel[0];	// @[Mux.scala:29:36, SingleVCAllocator.scala:20:57]
  assign io_resp_5_vc_sel_5_0 = in_alloc_5_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_4_0 = in_alloc_4_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_3_0 = in_alloc_3_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_2_0 = in_alloc_2_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_1_0 = in_alloc_1_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_0 = in_alloc_0_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_1 = in_alloc_0_1;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_2 = in_alloc_0_2;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_3 = in_alloc_0_3;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_4 = in_alloc_0_4;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_5 = in_alloc_0_5;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_6 = in_alloc_0_6;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_7 = in_alloc_0_7;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_8 = in_alloc_0_8;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_5_vc_sel_0_9 = in_alloc_0_9;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_5_0 = in_alloc_5_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_4_0 = in_alloc_4_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_3_0 = in_alloc_3_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_2_0 = in_alloc_2_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_1_0 = in_alloc_1_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_0 = in_alloc_0_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_1 = in_alloc_0_1;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_2 = in_alloc_0_2;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_3 = in_alloc_0_3;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_4 = in_alloc_0_4;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_5 = in_alloc_0_5;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_6 = in_alloc_0_6;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_7 = in_alloc_0_7;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_8 = in_alloc_0_8;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_4_vc_sel_0_9 = in_alloc_0_9;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_5_0 = in_alloc_5_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_4_0 = in_alloc_4_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_3_0 = in_alloc_3_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_2_0 = in_alloc_2_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_1_0 = in_alloc_1_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_0 = in_alloc_0_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_1 = in_alloc_0_1;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_2 = in_alloc_0_2;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_3 = in_alloc_0_3;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_4 = in_alloc_0_4;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_5 = in_alloc_0_5;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_6 = in_alloc_0_6;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_7 = in_alloc_0_7;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_8 = in_alloc_0_8;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_3_vc_sel_0_9 = in_alloc_0_9;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_5_0 = in_alloc_5_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_4_0 = in_alloc_4_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_3_0 = in_alloc_3_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_2_0 = in_alloc_2_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_1_0 = in_alloc_1_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_0 = in_alloc_0_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_1 = in_alloc_0_1;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_2 = in_alloc_0_2;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_3 = in_alloc_0_3;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_4 = in_alloc_0_4;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_5 = in_alloc_0_5;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_6 = in_alloc_0_6;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_7 = in_alloc_0_7;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_8 = in_alloc_0_8;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_2_vc_sel_0_9 = in_alloc_0_9;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_5_0 = in_alloc_5_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_4_0 = in_alloc_4_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_3_0 = in_alloc_3_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_2_0 = in_alloc_2_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_1_0 = in_alloc_1_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_0 = in_alloc_0_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_1 = in_alloc_0_1;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_2 = in_alloc_0_2;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_3 = in_alloc_0_3;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_4 = in_alloc_0_4;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_5 = in_alloc_0_5;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_6 = in_alloc_0_6;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_7 = in_alloc_0_7;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_8 = in_alloc_0_8;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_1_vc_sel_0_9 = in_alloc_0_9;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_5_0 = in_alloc_5_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_4_0 = in_alloc_4_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_3_0 = in_alloc_3_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_2_0 = in_alloc_2_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_1_0 = in_alloc_1_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_0_0 = in_alloc_0_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_0_1 = in_alloc_0_1;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_0_2 = in_alloc_0_2;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_0_4 = in_alloc_0_4;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_0_5 = in_alloc_0_5;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_0_8 = in_alloc_0_8;	// @[SingleVCAllocator.scala:41:18]
  assign io_resp_0_vc_sel_0_9 = in_alloc_0_9;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_5_0_alloc = in_alloc_5_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_4_0_alloc = in_alloc_4_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_3_0_alloc = in_alloc_3_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_2_0_alloc = in_alloc_2_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_1_0_alloc = in_alloc_1_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_0_0_alloc = in_alloc_0_0;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_0_1_alloc = in_alloc_0_1;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_0_3_alloc = in_alloc_0_3;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_0_4_alloc = in_alloc_0_4;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_0_5_alloc = in_alloc_0_5;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_0_8_alloc = in_alloc_0_8;	// @[SingleVCAllocator.scala:41:18]
  assign io_out_allocs_0_9_alloc = in_alloc_0_9;	// @[SingleVCAllocator.scala:41:18]
endmodule

