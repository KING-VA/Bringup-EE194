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

module TLPLIC(
  input         clock,
                reset,
                auto_int_in_0,
                auto_in_a_valid,
  input  [2:0]  auto_in_a_bits_opcode,
                auto_in_a_bits_param,
  input  [1:0]  auto_in_a_bits_size,
  input  [9:0]  auto_in_a_bits_source,
  input  [27:0] auto_in_a_bits_address,
  input  [7:0]  auto_in_a_bits_mask,
  input  [63:0] auto_in_a_bits_data,
  input         auto_in_a_bits_corrupt,
                auto_in_d_ready,
  output        auto_int_out_5_0,
                auto_int_out_4_0,
                auto_int_out_3_0,
                auto_int_out_2_0,
                auto_int_out_1_0,
                auto_int_out_0_0,
                auto_in_a_ready,
                auto_in_d_valid,
  output [2:0]  auto_in_d_bits_opcode,
  output [1:0]  auto_in_d_bits_size,
  output [9:0]  auto_in_d_bits_source,
  output [63:0] auto_in_d_bits_data
);

  wire        out_woready_2;	// @[RegisterRouter.scala:82:24]
  wire        out_woready_9;	// @[RegisterRouter.scala:82:24]
  wire        out_woready_15;	// @[RegisterRouter.scala:82:24]
  wire        out_woready_21;	// @[RegisterRouter.scala:82:24]
  wire        out_woready_12;	// @[RegisterRouter.scala:82:24]
  wire        out_woready_18;	// @[RegisterRouter.scala:82:24]
  wire        _out_rofireMux_T_1;	// @[RegisterRouter.scala:82:24]
  wire        out_backSel_104;	// @[RegisterRouter.scala:82:24]
  wire        out_backSel_96;	// @[RegisterRouter.scala:82:24]
  wire        out_backSel_88;	// @[RegisterRouter.scala:82:24]
  wire        out_backSel_80;	// @[RegisterRouter.scala:82:24]
  wire        out_backSel_72;	// @[RegisterRouter.scala:82:24]
  wire        out_backSel_64;	// @[RegisterRouter.scala:82:24]
  wire        completer_2;	// @[Plic.scala:295:35]
  wire        completerDev;	// @[RegisterRouter.scala:82:24, package.scala:155:13]
  wire        completer_0;	// @[Plic.scala:295:35]
  wire        completer_3;	// @[Plic.scala:295:35]
  wire        completer_1;	// @[Plic.scala:295:35]
  wire        completer_4;	// @[Plic.scala:295:35]
  wire        completer_5;	// @[Plic.scala:295:35]
  wire        _out_back_io_enq_ready;	// @[Decoupled.scala:375:21]
  wire        _out_back_io_deq_valid;	// @[Decoupled.scala:375:21]
  wire        _out_back_io_deq_bits_read;	// @[Decoupled.scala:375:21]
  wire [22:0] _out_back_io_deq_bits_index;	// @[Decoupled.scala:375:21]
  wire [63:0] _out_back_io_deq_bits_data;	// @[Decoupled.scala:375:21]
  wire [7:0]  _out_back_io_deq_bits_mask;	// @[Decoupled.scala:375:21]
  wire [9:0]  _out_back_io_deq_bits_extra_tlrr_extra_source;	// @[Decoupled.scala:375:21]
  wire [1:0]  _out_back_io_deq_bits_extra_tlrr_extra_size;	// @[Decoupled.scala:375:21]
  wire        _fanin_5_io_dev;	// @[Plic.scala:184:25]
  wire        _fanin_5_io_max;	// @[Plic.scala:184:25]
  wire        _fanin_4_io_dev;	// @[Plic.scala:184:25]
  wire        _fanin_4_io_max;	// @[Plic.scala:184:25]
  wire        _fanin_3_io_dev;	// @[Plic.scala:184:25]
  wire        _fanin_3_io_max;	// @[Plic.scala:184:25]
  wire        _fanin_2_io_dev;	// @[Plic.scala:184:25]
  wire        _fanin_2_io_max;	// @[Plic.scala:184:25]
  wire        _fanin_1_io_dev;	// @[Plic.scala:184:25]
  wire        _fanin_1_io_max;	// @[Plic.scala:184:25]
  wire        _fanin_io_dev;	// @[Plic.scala:184:25]
  wire        _fanin_io_max;	// @[Plic.scala:184:25]
  wire        _gateways_gateway_io_plic_valid;	// @[Plic.scala:156:27]
  reg         priority_0;	// @[Plic.scala:163:31]
  reg         threshold_0;	// @[Plic.scala:166:31]
  reg         threshold_1;	// @[Plic.scala:166:31]
  reg         threshold_2;	// @[Plic.scala:166:31]
  reg         threshold_3;	// @[Plic.scala:166:31]
  reg         threshold_4;	// @[Plic.scala:166:31]
  reg         threshold_5;	// @[Plic.scala:166:31]
  reg         pending_0;	// @[Plic.scala:168:22]
  reg         enables_0_0;	// @[Plic.scala:174:26]
  reg         enables_1_0;	// @[Plic.scala:174:26]
  reg         enables_2_0;	// @[Plic.scala:174:26]
  reg         enables_3_0;	// @[Plic.scala:174:26]
  reg         enables_4_0;	// @[Plic.scala:174:26]
  reg         enables_5_0;	// @[Plic.scala:174:26]
  reg         maxDevs_0;	// @[Plic.scala:181:22]
  reg         maxDevs_1;	// @[Plic.scala:181:22]
  reg         maxDevs_2;	// @[Plic.scala:181:22]
  reg         maxDevs_3;	// @[Plic.scala:181:22]
  reg         maxDevs_4;	// @[Plic.scala:181:22]
  reg         maxDevs_5;	// @[Plic.scala:181:22]
  reg         x1_0_REG;	// @[Plic.scala:188:41]
  reg         bundleOut_1_0_REG;	// @[Plic.scala:188:41]
  reg         bundleOut_2_0_REG;	// @[Plic.scala:188:41]
  reg         bundleOut_3_0_REG;	// @[Plic.scala:188:41]
  reg         bundleOut_4_0_REG;	// @[Plic.scala:188:41]
  reg         bundleOut_5_0_REG;	// @[Plic.scala:188:41]
  wire [1:0]  _GEN = {1'h0, completerDev};	// @[OneHot.scala:64:12, Plic.scala:163:31, RegisterRouter.scala:82:24, package.scala:155:13]
  wire        _out_T_27 = {_out_back_io_deq_bits_index[22:19], _out_back_io_deq_bits_index[17:12], _out_back_io_deq_bits_index[8:7], _out_back_io_deq_bits_index[3:0]} == 16'h0;	// @[Decoupled.scala:375:21, RegisterRouter.scala:82:24]
  wire [31:0] _out_womask_T_21 = {{8{_out_back_io_deq_bits_mask[7]}}, {8{_out_back_io_deq_bits_mask[6]}}, {8{_out_back_io_deq_bits_mask[5]}}, {8{_out_back_io_deq_bits_mask[4]}}};	// @[Bitwise.scala:28:17, :77:12, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
  wire        claimer_5 = _out_rofireMux_T_1 & out_backSel_104 & _out_T_27 & (|_out_womask_T_21);	// @[RegisterRouter.scala:82:24]
  wire [1:0]  _out_completer_5_T = {enables_5_0, 1'h0} >> _GEN;	// @[Cat.scala:33:92, OneHot.scala:64:12, Plic.scala:163:31, :174:26, :295:51]
  assign completer_5 = out_woready_2 & (&_out_womask_T_21) & _out_completer_5_T[0];	// @[Plic.scala:295:{35,51}, RegisterRouter.scala:82:24]
  wire        claimer_4 = _out_rofireMux_T_1 & out_backSel_96 & _out_T_27 & (|_out_womask_T_21);	// @[RegisterRouter.scala:82:24]
  wire [1:0]  _out_completer_4_T = {enables_4_0, 1'h0} >> _GEN;	// @[Cat.scala:33:92, OneHot.scala:64:12, Plic.scala:163:31, :174:26, :295:51]
  assign completer_4 = out_woready_9 & (&_out_womask_T_21) & _out_completer_4_T[0];	// @[Plic.scala:295:{35,51}, RegisterRouter.scala:82:24]
  wire        claimer_1 = _out_rofireMux_T_1 & out_backSel_72 & _out_T_27 & (|_out_womask_T_21);	// @[RegisterRouter.scala:82:24]
  wire [1:0]  _out_completer_1_T = {enables_1_0, 1'h0} >> _GEN;	// @[Cat.scala:33:92, OneHot.scala:64:12, Plic.scala:163:31, :174:26, :295:51]
  assign completer_1 = out_woready_12 & (&_out_womask_T_21) & _out_completer_1_T[0];	// @[Plic.scala:295:{35,51}, RegisterRouter.scala:82:24]
  wire        claimer_3 = _out_rofireMux_T_1 & out_backSel_88 & _out_T_27 & (|_out_womask_T_21);	// @[RegisterRouter.scala:82:24]
  wire [1:0]  _out_completer_3_T = {enables_3_0, 1'h0} >> _GEN;	// @[Cat.scala:33:92, OneHot.scala:64:12, Plic.scala:163:31, :174:26, :295:51]
  assign completer_3 = out_woready_15 & (&_out_womask_T_21) & _out_completer_3_T[0];	// @[Plic.scala:295:{35,51}, RegisterRouter.scala:82:24]
  wire        claimer_0 = _out_rofireMux_T_1 & out_backSel_64 & _out_T_27 & (|_out_womask_T_21);	// @[RegisterRouter.scala:82:24]
  wire [1:0]  _out_completer_0_T = {enables_0_0, 1'h0} >> _GEN;	// @[Cat.scala:33:92, OneHot.scala:64:12, Plic.scala:163:31, :174:26, :295:51]
  assign completer_0 = out_woready_18 & (&_out_womask_T_21) & _out_completer_0_T[0];	// @[Plic.scala:295:{35,51}, RegisterRouter.scala:82:24]
  wire        claimer_2 = _out_rofireMux_T_1 & out_backSel_80 & _out_T_27 & (|_out_womask_T_21);	// @[RegisterRouter.scala:82:24]
  assign completerDev = _out_back_io_deq_bits_data[32];	// @[Decoupled.scala:375:21, RegisterRouter.scala:82:24, package.scala:155:13]
  wire [1:0]  _out_completer_2_T = {enables_2_0, 1'h0} >> _GEN;	// @[Cat.scala:33:92, OneHot.scala:64:12, Plic.scala:163:31, :174:26, :295:51]
  assign completer_2 = out_woready_21 & (&_out_womask_T_21) & _out_completer_2_T[0];	// @[Plic.scala:295:{35,51}, RegisterRouter.scala:82:24]
  wire [6:0]  out_oindex = {_out_back_io_deq_bits_index[18], _out_back_io_deq_bits_index[11:9], _out_back_io_deq_bits_index[6:4]};	// @[Cat.scala:33:92, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
  wire [6:0]  _GEN_0 = {_out_back_io_deq_bits_index[18], _out_back_io_deq_bits_index[11:9], _out_back_io_deq_bits_index[6:4]};	// @[Cat.scala:33:92, Decoupled.scala:375:21, OneHot.scala:57:35, RegisterRouter.scala:82:24]
  assign out_backSel_64 = _GEN_0 == 7'h40;	// @[MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
  assign out_backSel_72 = _GEN_0 == 7'h48;	// @[MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
  assign out_backSel_80 = _GEN_0 == 7'h50;	// @[MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
  assign out_backSel_88 = _GEN_0 == 7'h58;	// @[MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
  assign out_backSel_96 = _GEN_0 == 7'h60;	// @[MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
  assign out_backSel_104 = _GEN_0 == 7'h68;	// @[MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
  wire        _out_wofireMux_T = _out_back_io_deq_valid & auto_in_d_ready;	// @[Decoupled.scala:375:21, RegisterRouter.scala:82:24]
  assign _out_rofireMux_T_1 = _out_wofireMux_T & _out_back_io_deq_bits_read;	// @[Decoupled.scala:375:21, RegisterRouter.scala:82:24]
  wire        _out_wofireMux_T_2 = _out_wofireMux_T & ~_out_back_io_deq_bits_read;	// @[Decoupled.scala:375:21, RegisterRouter.scala:82:24]
  assign out_woready_18 = _out_wofireMux_T_2 & out_backSel_64 & _out_T_27;	// @[RegisterRouter.scala:82:24]
  assign out_woready_12 = _out_wofireMux_T_2 & out_backSel_72 & _out_T_27;	// @[RegisterRouter.scala:82:24]
  assign out_woready_21 = _out_wofireMux_T_2 & out_backSel_80 & _out_T_27;	// @[RegisterRouter.scala:82:24]
  assign out_woready_15 = _out_wofireMux_T_2 & out_backSel_88 & _out_T_27;	// @[RegisterRouter.scala:82:24]
  assign out_woready_9 = _out_wofireMux_T_2 & out_backSel_96 & _out_T_27;	// @[RegisterRouter.scala:82:24]
  assign out_woready_2 = _out_wofireMux_T_2 & out_backSel_104 & _out_T_27;	// @[RegisterRouter.scala:82:24]
  wire        _out_out_bits_data_T_14 = out_oindex == 7'h0;	// @[Cat.scala:33:92, MuxLiteral.scala:54:22]
  wire [2:0]  bundleIn_0_d_bits_opcode = {2'h0, _out_back_io_deq_bits_read};	// @[Decoupled.scala:375:21, RegisterRouter.scala:82:24, :97:19]
  wire        claimedDevs_1 = claimer_0 & maxDevs_0 | claimer_1 & maxDevs_1 | claimer_2 & maxDevs_2 | claimer_3 & maxDevs_3 | claimer_4 & maxDevs_4 | claimer_5 & maxDevs_5;	// @[Plic.scala:181:22, :246:{49,96}, RegisterRouter.scala:82:24]
  always @(posedge clock) begin
    if (_out_wofireMux_T_2 & _GEN_0 == 7'h0 & _out_T_27 & _out_back_io_deq_bits_mask[4])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
      priority_0 <= _out_back_io_deq_bits_data[32];	// @[Decoupled.scala:375:21, Plic.scala:163:31, RegisterRouter.scala:82:24]
    if (out_woready_18 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
      threshold_0 <= _out_back_io_deq_bits_data[0];	// @[Decoupled.scala:375:21, Plic.scala:166:31, RegisterRouter.scala:82:24]
    if (out_woready_12 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
      threshold_1 <= _out_back_io_deq_bits_data[0];	// @[Decoupled.scala:375:21, Plic.scala:166:31, RegisterRouter.scala:82:24]
    if (out_woready_21 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
      threshold_2 <= _out_back_io_deq_bits_data[0];	// @[Decoupled.scala:375:21, Plic.scala:166:31, RegisterRouter.scala:82:24]
    if (out_woready_15 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
      threshold_3 <= _out_back_io_deq_bits_data[0];	// @[Decoupled.scala:375:21, Plic.scala:166:31, RegisterRouter.scala:82:24]
    if (out_woready_9 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
      threshold_4 <= _out_back_io_deq_bits_data[0];	// @[Decoupled.scala:375:21, Plic.scala:166:31, RegisterRouter.scala:82:24]
    if (out_woready_2 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, RegisterRouter.scala:82:24]
      threshold_5 <= _out_back_io_deq_bits_data[0];	// @[Decoupled.scala:375:21, Plic.scala:166:31, RegisterRouter.scala:82:24]
    if (_out_wofireMux_T_2 & _GEN_0 == 7'h10 & _out_T_27 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
      enables_0_0 <= _out_back_io_deq_bits_data[1];	// @[Decoupled.scala:375:21, Plic.scala:174:26, RegisterRouter.scala:82:24]
    if (_out_wofireMux_T_2 & _GEN_0 == 7'h11 & _out_T_27 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
      enables_1_0 <= _out_back_io_deq_bits_data[1];	// @[Decoupled.scala:375:21, Plic.scala:174:26, RegisterRouter.scala:82:24]
    if (_out_wofireMux_T_2 & _GEN_0 == 7'h12 & _out_T_27 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
      enables_2_0 <= _out_back_io_deq_bits_data[1];	// @[Decoupled.scala:375:21, Plic.scala:174:26, RegisterRouter.scala:82:24]
    if (_out_wofireMux_T_2 & _GEN_0 == 7'h13 & _out_T_27 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
      enables_3_0 <= _out_back_io_deq_bits_data[1];	// @[Decoupled.scala:375:21, Plic.scala:174:26, RegisterRouter.scala:82:24]
    if (_out_wofireMux_T_2 & _GEN_0 == 7'h14 & _out_T_27 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
      enables_4_0 <= _out_back_io_deq_bits_data[1];	// @[Decoupled.scala:375:21, Plic.scala:174:26, RegisterRouter.scala:82:24]
    if (_out_wofireMux_T_2 & _GEN_0 == 7'h15 & _out_T_27 & _out_back_io_deq_bits_mask[0])	// @[Bitwise.scala:28:17, Decoupled.scala:375:21, MuxLiteral.scala:54:22, OneHot.scala:57:35, RegisterRouter.scala:82:24]
      enables_5_0 <= _out_back_io_deq_bits_data[1];	// @[Decoupled.scala:375:21, Plic.scala:174:26, RegisterRouter.scala:82:24]
    maxDevs_0 <= _fanin_io_dev;	// @[Plic.scala:181:22, :184:25]
    maxDevs_1 <= _fanin_1_io_dev;	// @[Plic.scala:181:22, :184:25]
    maxDevs_2 <= _fanin_2_io_dev;	// @[Plic.scala:181:22, :184:25]
    maxDevs_3 <= _fanin_3_io_dev;	// @[Plic.scala:181:22, :184:25]
    maxDevs_4 <= _fanin_4_io_dev;	// @[Plic.scala:181:22, :184:25]
    maxDevs_5 <= _fanin_5_io_dev;	// @[Plic.scala:181:22, :184:25]
    x1_0_REG <= _fanin_io_max;	// @[Plic.scala:184:25, :188:41]
    bundleOut_1_0_REG <= _fanin_1_io_max;	// @[Plic.scala:184:25, :188:41]
    bundleOut_2_0_REG <= _fanin_2_io_max;	// @[Plic.scala:184:25, :188:41]
    bundleOut_3_0_REG <= _fanin_3_io_max;	// @[Plic.scala:184:25, :188:41]
    bundleOut_4_0_REG <= _fanin_4_io_max;	// @[Plic.scala:184:25, :188:41]
    bundleOut_5_0_REG <= _fanin_5_io_max;	// @[Plic.scala:184:25, :188:41]
    if (reset)
      pending_0 <= 1'h0;	// @[Plic.scala:163:31, :168:22]
    else if (claimedDevs_1 | _gateways_gateway_io_plic_valid)	// @[Plic.scala:156:27, :246:96, :251:15]
      pending_0 <= ~claimedDevs_1;	// @[Plic.scala:168:22, :246:96, :251:34]
  end // always @(posedge)
  `ifndef SYNTHESIS
    always @(posedge clock) begin	// @[Plic.scala:245:11]
      if (~reset & (|({claimer_5, claimer_4, claimer_3, claimer_2, claimer_1, claimer_0} & {claimer_5, claimer_4, claimer_3, claimer_2, claimer_1, claimer_0} - 6'h1))) begin	// @[Plic.scala:245:{11,21,28,46,58}, RegisterRouter.scala:82:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Plic.scala:245:11]
          $error("Assertion failed\n    at Plic.scala:245 assert((claimer.asUInt & (claimer.asUInt - UInt(1))) === UInt(0)) // One-Hot\n");	// @[Plic.scala:245:11]
        if (`STOP_COND_)	// @[Plic.scala:245:11]
          $fatal;	// @[Plic.scala:245:11]
      end
      if (~reset & (|({completer_5, completer_4, completer_3, completer_2, completer_1, completer_0} & {completer_5, completer_4, completer_3, completer_2, completer_1, completer_0} - 6'h1))) begin	// @[Plic.scala:262:{11,23,30,50,62}, :295:35]
        if (`ASSERT_VERBOSE_COND_)	// @[Plic.scala:262:11]
          $error("Assertion failed\n    at Plic.scala:262 assert((completer.asUInt & (completer.asUInt - UInt(1))) === UInt(0)) // One-Hot\n");	// @[Plic.scala:262:11]
        if (`STOP_COND_)	// @[Plic.scala:262:11]
          $fatal;	// @[Plic.scala:262:11]
      end
      if (~reset & completerDev != _out_back_io_deq_bits_data[32]) begin	// @[Decoupled.scala:375:21, Plic.scala:292:{19,33}, RegisterRouter.scala:82:24, package.scala:155:13]
        if (`ASSERT_VERBOSE_COND_)	// @[Plic.scala:292:19]
          $error("Assertion failed: completerDev should be consistent for all harts\n    at Plic.scala:292 assert(completerDev === data.extract(log2Ceil(nDevices+1)-1, 0),\n");	// @[Plic.scala:292:19]
        if (`STOP_COND_)	// @[Plic.scala:292:19]
          $fatal;	// @[Plic.scala:292:19]
      end
      if (~reset & completerDev != _out_back_io_deq_bits_data[32]) begin	// @[Decoupled.scala:375:21, Plic.scala:292:{19,33}, RegisterRouter.scala:82:24, package.scala:155:13]
        if (`ASSERT_VERBOSE_COND_)	// @[Plic.scala:292:19]
          $error("Assertion failed: completerDev should be consistent for all harts\n    at Plic.scala:292 assert(completerDev === data.extract(log2Ceil(nDevices+1)-1, 0),\n");	// @[Plic.scala:292:19]
        if (`STOP_COND_)	// @[Plic.scala:292:19]
          $fatal;	// @[Plic.scala:292:19]
      end
      if (~reset & completerDev != _out_back_io_deq_bits_data[32]) begin	// @[Decoupled.scala:375:21, Plic.scala:292:{19,33}, RegisterRouter.scala:82:24, package.scala:155:13]
        if (`ASSERT_VERBOSE_COND_)	// @[Plic.scala:292:19]
          $error("Assertion failed: completerDev should be consistent for all harts\n    at Plic.scala:292 assert(completerDev === data.extract(log2Ceil(nDevices+1)-1, 0),\n");	// @[Plic.scala:292:19]
        if (`STOP_COND_)	// @[Plic.scala:292:19]
          $fatal;	// @[Plic.scala:292:19]
      end
      if (~reset & completerDev != _out_back_io_deq_bits_data[32]) begin	// @[Decoupled.scala:375:21, Plic.scala:292:{19,33}, RegisterRouter.scala:82:24, package.scala:155:13]
        if (`ASSERT_VERBOSE_COND_)	// @[Plic.scala:292:19]
          $error("Assertion failed: completerDev should be consistent for all harts\n    at Plic.scala:292 assert(completerDev === data.extract(log2Ceil(nDevices+1)-1, 0),\n");	// @[Plic.scala:292:19]
        if (`STOP_COND_)	// @[Plic.scala:292:19]
          $fatal;	// @[Plic.scala:292:19]
      end
      if (~reset & completerDev != _out_back_io_deq_bits_data[32]) begin	// @[Decoupled.scala:375:21, Plic.scala:292:{19,33}, RegisterRouter.scala:82:24, package.scala:155:13]
        if (`ASSERT_VERBOSE_COND_)	// @[Plic.scala:292:19]
          $error("Assertion failed: completerDev should be consistent for all harts\n    at Plic.scala:292 assert(completerDev === data.extract(log2Ceil(nDevices+1)-1, 0),\n");	// @[Plic.scala:292:19]
        if (`STOP_COND_)	// @[Plic.scala:292:19]
          $fatal;	// @[Plic.scala:292:19]
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
        priority_0 = _RANDOM_0[0];	// @[Plic.scala:163:31]
        threshold_0 = _RANDOM_0[1];	// @[Plic.scala:163:31, :166:31]
        threshold_1 = _RANDOM_0[2];	// @[Plic.scala:163:31, :166:31]
        threshold_2 = _RANDOM_0[3];	// @[Plic.scala:163:31, :166:31]
        threshold_3 = _RANDOM_0[4];	// @[Plic.scala:163:31, :166:31]
        threshold_4 = _RANDOM_0[5];	// @[Plic.scala:163:31, :166:31]
        threshold_5 = _RANDOM_0[6];	// @[Plic.scala:163:31, :166:31]
        pending_0 = _RANDOM_0[7];	// @[Plic.scala:163:31, :168:22]
        enables_0_0 = _RANDOM_0[8];	// @[Plic.scala:163:31, :174:26]
        enables_1_0 = _RANDOM_0[9];	// @[Plic.scala:163:31, :174:26]
        enables_2_0 = _RANDOM_0[10];	// @[Plic.scala:163:31, :174:26]
        enables_3_0 = _RANDOM_0[11];	// @[Plic.scala:163:31, :174:26]
        enables_4_0 = _RANDOM_0[12];	// @[Plic.scala:163:31, :174:26]
        enables_5_0 = _RANDOM_0[13];	// @[Plic.scala:163:31, :174:26]
        maxDevs_0 = _RANDOM_0[14];	// @[Plic.scala:163:31, :181:22]
        maxDevs_1 = _RANDOM_0[15];	// @[Plic.scala:163:31, :181:22]
        maxDevs_2 = _RANDOM_0[16];	// @[Plic.scala:163:31, :181:22]
        maxDevs_3 = _RANDOM_0[17];	// @[Plic.scala:163:31, :181:22]
        maxDevs_4 = _RANDOM_0[18];	// @[Plic.scala:163:31, :181:22]
        maxDevs_5 = _RANDOM_0[19];	// @[Plic.scala:163:31, :181:22]
        x1_0_REG = _RANDOM_0[20];	// @[Plic.scala:163:31, :188:41]
        bundleOut_1_0_REG = _RANDOM_0[21];	// @[Plic.scala:163:31, :188:41]
        bundleOut_2_0_REG = _RANDOM_0[22];	// @[Plic.scala:163:31, :188:41]
        bundleOut_3_0_REG = _RANDOM_0[23];	// @[Plic.scala:163:31, :188:41]
        bundleOut_4_0_REG = _RANDOM_0[24];	// @[Plic.scala:163:31, :188:41]
        bundleOut_5_0_REG = _RANDOM_0[25];	// @[Plic.scala:163:31, :188:41]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  TLMonitor_80 monitor (	// @[Nodes.scala:24:25]
    .clock                (clock),
    .reset                (reset),
    .io_in_a_ready        (_out_back_io_enq_ready),	// @[Decoupled.scala:375:21]
    .io_in_a_valid        (auto_in_a_valid),
    .io_in_a_bits_opcode  (auto_in_a_bits_opcode),
    .io_in_a_bits_param   (auto_in_a_bits_param),
    .io_in_a_bits_size    (auto_in_a_bits_size),
    .io_in_a_bits_source  (auto_in_a_bits_source),
    .io_in_a_bits_address (auto_in_a_bits_address),
    .io_in_a_bits_mask    (auto_in_a_bits_mask),
    .io_in_a_bits_corrupt (auto_in_a_bits_corrupt),
    .io_in_d_ready        (auto_in_d_ready),
    .io_in_d_valid        (_out_back_io_deq_valid),	// @[Decoupled.scala:375:21]
    .io_in_d_bits_opcode  (bundleIn_0_d_bits_opcode),	// @[RegisterRouter.scala:97:19]
    .io_in_d_bits_size    (_out_back_io_deq_bits_extra_tlrr_extra_size),	// @[Decoupled.scala:375:21]
    .io_in_d_bits_source  (_out_back_io_deq_bits_extra_tlrr_extra_source)	// @[Decoupled.scala:375:21]
  );
  LevelGateway gateways_gateway (	// @[Plic.scala:156:27]
    .clock            (clock),
    .reset            (reset),
    .io_interrupt     (auto_int_in_0),
    .io_plic_ready    (~pending_0),	// @[Plic.scala:168:22, :250:18]
    .io_plic_complete ((completer_0 | completer_1 | completer_2 | completer_3 | completer_4 | completer_5) & completerDev),	// @[Plic.scala:264:{28,48}, :295:35, RegisterRouter.scala:82:24, package.scala:155:13]
    .io_plic_valid    (_gateways_gateway_io_plic_valid)
  );
  PLICFanIn fanin (	// @[Plic.scala:184:25]
    .io_prio_0 (priority_0),	// @[Plic.scala:163:31]
    .io_ip     (enables_0_0 & pending_0),	// @[Plic.scala:168:22, :174:26, :186:40]
    .io_dev    (_fanin_io_dev),
    .io_max    (_fanin_io_max)
  );
  PLICFanIn fanin_1 (	// @[Plic.scala:184:25]
    .io_prio_0 (priority_0),	// @[Plic.scala:163:31]
    .io_ip     (enables_1_0 & pending_0),	// @[Plic.scala:168:22, :174:26, :186:40]
    .io_dev    (_fanin_1_io_dev),
    .io_max    (_fanin_1_io_max)
  );
  PLICFanIn fanin_2 (	// @[Plic.scala:184:25]
    .io_prio_0 (priority_0),	// @[Plic.scala:163:31]
    .io_ip     (enables_2_0 & pending_0),	// @[Plic.scala:168:22, :174:26, :186:40]
    .io_dev    (_fanin_2_io_dev),
    .io_max    (_fanin_2_io_max)
  );
  PLICFanIn fanin_3 (	// @[Plic.scala:184:25]
    .io_prio_0 (priority_0),	// @[Plic.scala:163:31]
    .io_ip     (enables_3_0 & pending_0),	// @[Plic.scala:168:22, :174:26, :186:40]
    .io_dev    (_fanin_3_io_dev),
    .io_max    (_fanin_3_io_max)
  );
  PLICFanIn fanin_4 (	// @[Plic.scala:184:25]
    .io_prio_0 (priority_0),	// @[Plic.scala:163:31]
    .io_ip     (enables_4_0 & pending_0),	// @[Plic.scala:168:22, :174:26, :186:40]
    .io_dev    (_fanin_4_io_dev),
    .io_max    (_fanin_4_io_max)
  );
  PLICFanIn fanin_5 (	// @[Plic.scala:184:25]
    .io_prio_0 (priority_0),	// @[Plic.scala:163:31]
    .io_ip     (enables_5_0 & pending_0),	// @[Plic.scala:168:22, :174:26, :186:40]
    .io_dev    (_fanin_5_io_dev),
    .io_max    (_fanin_5_io_max)
  );
  Queue_295 out_back (	// @[Decoupled.scala:375:21]
    .clock                               (clock),
    .reset                               (reset),
    .io_enq_valid                        (auto_in_a_valid),
    .io_enq_bits_read                    (auto_in_a_bits_opcode == 3'h4),	// @[RegisterRouter.scala:71:36]
    .io_enq_bits_index                   (auto_in_a_bits_address[25:3]),	// @[Edges.scala:191:34, RegisterRouter.scala:72:19]
    .io_enq_bits_data                    (auto_in_a_bits_data),
    .io_enq_bits_mask                    (auto_in_a_bits_mask),
    .io_enq_bits_extra_tlrr_extra_source (auto_in_a_bits_source),
    .io_enq_bits_extra_tlrr_extra_size   (auto_in_a_bits_size),
    .io_deq_ready                        (auto_in_d_ready),
    .io_enq_ready                        (_out_back_io_enq_ready),
    .io_deq_valid                        (_out_back_io_deq_valid),
    .io_deq_bits_read                    (_out_back_io_deq_bits_read),
    .io_deq_bits_index                   (_out_back_io_deq_bits_index),
    .io_deq_bits_data                    (_out_back_io_deq_bits_data),
    .io_deq_bits_mask                    (_out_back_io_deq_bits_mask),
    .io_deq_bits_extra_tlrr_extra_source (_out_back_io_deq_bits_extra_tlrr_extra_source),
    .io_deq_bits_extra_tlrr_extra_size   (_out_back_io_deq_bits_extra_tlrr_extra_size)
  );
  assign auto_int_out_5_0 = bundleOut_5_0_REG > threshold_5;	// @[Plic.scala:166:31, :188:{41,63}]
  assign auto_int_out_4_0 = bundleOut_4_0_REG > threshold_4;	// @[Plic.scala:166:31, :188:{41,63}]
  assign auto_int_out_3_0 = bundleOut_3_0_REG > threshold_3;	// @[Plic.scala:166:31, :188:{41,63}]
  assign auto_int_out_2_0 = bundleOut_2_0_REG > threshold_2;	// @[Plic.scala:166:31, :188:{41,63}]
  assign auto_int_out_1_0 = bundleOut_1_0_REG > threshold_1;	// @[Plic.scala:166:31, :188:{41,63}]
  assign auto_int_out_0_0 = x1_0_REG > threshold_0;	// @[Plic.scala:166:31, :188:{41,63}]
  assign auto_in_a_ready = _out_back_io_enq_ready;	// @[Decoupled.scala:375:21]
  assign auto_in_d_valid = _out_back_io_deq_valid;	// @[Decoupled.scala:375:21]
  assign auto_in_d_bits_opcode = bundleIn_0_d_bits_opcode;	// @[RegisterRouter.scala:97:19]
  assign auto_in_d_bits_size = _out_back_io_deq_bits_extra_tlrr_extra_size;	// @[Decoupled.scala:375:21]
  assign auto_in_d_bits_source = _out_back_io_deq_bits_extra_tlrr_extra_source;	// @[Decoupled.scala:375:21]
  assign auto_in_d_bits_data = ~(_out_out_bits_data_T_14 | out_oindex == 7'h8 | out_oindex == 7'h10 | out_oindex == 7'h11 | out_oindex == 7'h12 | out_oindex == 7'h13 | out_oindex == 7'h14 | out_oindex == 7'h15 | out_oindex == 7'h40 | out_oindex == 7'h48 | out_oindex == 7'h50 | out_oindex == 7'h58 | out_oindex == 7'h60 | out_oindex == 7'h68) | _out_T_27 ? (_out_out_bits_data_T_14 ? {31'h0, priority_0, 32'h0} : out_oindex == 7'h8 ? {62'h0, pending_0, 1'h0} : out_oindex == 7'h10 ? {62'h0, enables_0_0, 1'h0} : out_oindex == 7'h11 ? {62'h0, enables_1_0, 1'h0} : out_oindex == 7'h12 ? {62'h0, enables_2_0, 1'h0} : out_oindex == 7'h13 ? {62'h0, enables_3_0, 1'h0} : out_oindex == 7'h14 ? {62'h0, enables_4_0, 1'h0} : out_oindex == 7'h15 ? {62'h0, enables_5_0, 1'h0} : out_oindex == 7'h40 ? {31'h0, maxDevs_0, 31'h0, threshold_0} : out_oindex == 7'h48 ? {31'h0, maxDevs_1, 31'h0, threshold_1} : out_oindex == 7'h50 ? {31'h0, maxDevs_2, 31'h0, threshold_2} : out_oindex == 7'h58 ? {31'h0, maxDevs_3, 31'h0, threshold_3} : out_oindex == 7'h60 ? {31'h0, maxDevs_4, 31'h0, threshold_4} : out_oindex == 7'h68 ? {31'h0, maxDevs_5, 31'h0, threshold_5} : 64'h0) : 64'h0;	// @[Cat.scala:33:92, MuxLiteral.scala:52:28, :54:{22,28}, Plic.scala:163:31, :166:31, :168:22, :174:26, :181:22, RegisterRouter.scala:82:24]
endmodule

