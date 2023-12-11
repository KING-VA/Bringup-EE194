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

module NoCMonitor_2(
  input       clock,
              reset,
              io_in_flit_0_valid,
              io_in_flit_0_bits_head,
              io_in_flit_0_bits_tail,
  input [3:0] io_in_flit_0_bits_flow_ingress_node,
  input [2:0] io_in_flit_0_bits_flow_ingress_node_id,
  input [3:0] io_in_flit_0_bits_flow_egress_node,
  input [2:0] io_in_flit_0_bits_flow_egress_node_id,
  input [3:0] io_in_flit_0_bits_virt_channel_id
);

  reg  in_flight_0;	// @[Monitor.scala:16:26]
  reg  in_flight_1;	// @[Monitor.scala:16:26]
  reg  in_flight_2;	// @[Monitor.scala:16:26]
  reg  in_flight_3;	// @[Monitor.scala:16:26]
  reg  in_flight_4;	// @[Monitor.scala:16:26]
  reg  in_flight_5;	// @[Monitor.scala:16:26]
  reg  in_flight_6;	// @[Monitor.scala:16:26]
  reg  in_flight_7;	// @[Monitor.scala:16:26]
  reg  in_flight_8;	// @[Monitor.scala:16:26]
  reg  in_flight_9;	// @[Monitor.scala:16:26]
  wire _GEN = io_in_flit_0_bits_virt_channel_id == 4'h0;	// @[Monitor.scala:21:46]
  wire _GEN_0 = io_in_flit_0_bits_virt_channel_id == 4'h1;	// @[Monitor.scala:21:46]
  wire _GEN_1 = io_in_flit_0_bits_virt_channel_id == 4'h2;	// @[Monitor.scala:21:46]
  wire _GEN_2 = io_in_flit_0_bits_virt_channel_id == 4'h3;	// @[Monitor.scala:21:46]
  wire _GEN_3 = io_in_flit_0_bits_virt_channel_id == 4'h4;	// @[Monitor.scala:21:46]
  wire _GEN_4 = io_in_flit_0_bits_virt_channel_id == 4'h5;	// @[Monitor.scala:21:46]
  wire _GEN_5 = io_in_flit_0_bits_virt_channel_id == 4'h6;	// @[Monitor.scala:21:46]
  wire _GEN_6 = io_in_flit_0_bits_virt_channel_id == 4'h7;	// @[Monitor.scala:21:46]
  wire _GEN_7 = io_in_flit_0_bits_virt_channel_id == 4'h8;	// @[Monitor.scala:21:46]
  wire _GEN_8 = io_in_flit_0_bits_virt_channel_id == 4'h9;	// @[Monitor.scala:21:46]
  always @(posedge clock) begin
    if (reset) begin
      in_flight_0 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_1 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_2 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_3 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_4 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_5 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_6 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_7 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_8 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
      in_flight_9 <= 1'h0;	// @[Monitor.scala:16:{26,34}]
    end
    else if (io_in_flit_0_valid) begin
      in_flight_0 <= ~(io_in_flit_0_bits_tail & _GEN) & (io_in_flit_0_bits_head & _GEN | in_flight_0);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_1 <= ~(io_in_flit_0_bits_tail & _GEN_0) & (io_in_flit_0_bits_head & _GEN_0 | in_flight_1);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_2 <= ~(io_in_flit_0_bits_tail & _GEN_1) & (io_in_flit_0_bits_head & _GEN_1 | in_flight_2);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_3 <= ~(io_in_flit_0_bits_tail & _GEN_2) & (io_in_flit_0_bits_head & _GEN_2 | in_flight_3);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_4 <= ~(io_in_flit_0_bits_tail & _GEN_3) & (io_in_flit_0_bits_head & _GEN_3 | in_flight_4);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_5 <= ~(io_in_flit_0_bits_tail & _GEN_4) & (io_in_flit_0_bits_head & _GEN_4 | in_flight_5);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_6 <= ~(io_in_flit_0_bits_tail & _GEN_5) & (io_in_flit_0_bits_head & _GEN_5 | in_flight_6);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_7 <= ~(io_in_flit_0_bits_tail & _GEN_6) & (io_in_flit_0_bits_head & _GEN_6 | in_flight_7);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_8 <= ~(io_in_flit_0_bits_tail & _GEN_7) & (io_in_flit_0_bits_head & _GEN_7 | in_flight_8);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
      in_flight_9 <= ~(io_in_flit_0_bits_tail & _GEN_8) & (io_in_flit_0_bits_head & _GEN_8 | in_flight_9);	// @[Monitor.scala:16:26, :20:29, :21:46, :24:29, :25:46]
    end
  end // always @(posedge)
  `ifndef SYNTHESIS
    wire         _T_4 = io_in_flit_0_valid & io_in_flit_0_bits_head;	// @[Monitor.scala:29:22]
    wire         _T_443 = io_in_flit_0_bits_flow_ingress_node == 4'h0;	// @[Monitor.scala:21:46, Types.scala:53:21]
    wire         _T_444 = io_in_flit_0_bits_flow_egress_node == 4'h4;	// @[Monitor.scala:21:46, Types.scala:54:21]
    wire         _T_94 = io_in_flit_0_bits_flow_ingress_node_id == 3'h2;	// @[Types.scala:55:25]
    wire         _T_434 = io_in_flit_0_bits_flow_egress_node_id == 3'h2;	// @[Types.scala:55:25, :56:24]
    wire         _T_409 = io_in_flit_0_bits_flow_egress_node == 4'h5;	// @[Monitor.scala:21:46, Types.scala:54:21]
    wire         _T_423 = io_in_flit_0_bits_flow_egress_node == 4'h6;	// @[Monitor.scala:21:46, Types.scala:54:21]
    wire         _T_437 = io_in_flit_0_bits_flow_egress_node == 4'h7;	// @[Monitor.scala:21:46, Types.scala:54:21]
    wire         _T_436 = io_in_flit_0_bits_flow_ingress_node == 4'h1;	// @[Monitor.scala:21:46, Types.scala:53:21]
    wire         _T_316 = io_in_flit_0_bits_flow_ingress_node == 4'h7;	// @[Monitor.scala:21:46, Types.scala:53:21]
    wire         _T_317 = io_in_flit_0_bits_flow_egress_node == 4'h2;	// @[Monitor.scala:21:46, Types.scala:54:21]
    wire         _T_279 = io_in_flit_0_bits_flow_ingress_node_id == 3'h1;	// @[Types.scala:55:25]
    wire         _T_281 = io_in_flit_0_bits_flow_egress_node_id == 3'h1;	// @[Types.scala:55:25, :56:24]
    wire         _T_295 = io_in_flit_0_bits_flow_ingress_node == 4'h4;	// @[Monitor.scala:21:46, Types.scala:53:21]
    wire         _T_430 = io_in_flit_0_bits_flow_egress_node == 4'h3;	// @[Monitor.scala:21:46, Types.scala:54:21]
    wire         _T_302 = io_in_flit_0_bits_flow_ingress_node == 4'h5;	// @[Monitor.scala:21:46, Types.scala:53:21]
    wire         _T_309 = io_in_flit_0_bits_flow_ingress_node == 4'h6;	// @[Monitor.scala:21:46, Types.scala:53:21]
    wire         _T_446 = io_in_flit_0_bits_flow_ingress_node_id == 3'h0;	// @[Monitor.scala:32:44, Types.scala:55:25]
    wire         _T_448 = io_in_flit_0_bits_flow_egress_node_id == 3'h0;	// @[Monitor.scala:32:44, Types.scala:56:24]
    wire  [15:0] _GEN_9 = {{in_flight_0}, {in_flight_0}, {in_flight_0}, {in_flight_0}, {in_flight_0}, {in_flight_0}, {in_flight_9}, {in_flight_8}, {in_flight_7}, {in_flight_6}, {in_flight_5}, {in_flight_4}, {in_flight_3}, {in_flight_2}, {in_flight_1}, {in_flight_0}};	// @[Monitor.scala:16:26, :21:46]
    always @(posedge clock) begin	// @[Monitor.scala:22:16]
      if (io_in_flit_0_valid & io_in_flit_0_bits_head & ~reset & _GEN_9[io_in_flit_0_bits_virt_channel_id]) begin	// @[Monitor.scala:21:46, :22:16]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:22:16]
          $error("Assertion failed: Flit head/tail sequencing is broken\n    at Monitor.scala:22 assert (!in_flight(flit.bits.virt_channel_id), \"Flit head/tail sequencing is broken\")\n");	// @[Monitor.scala:22:16]
        if (`STOP_COND_)	// @[Monitor.scala:22:16]
          $fatal;	// @[Monitor.scala:22:16]
      end
      if (_T_4 & ~reset & ~((|io_in_flit_0_bits_virt_channel_id) | _T_443 & _T_444 & _T_94 & _T_434 | _T_443 & _T_409 & _T_94 & _T_434 | _T_443 & _T_423 & _T_94 & _T_434 | _T_443 & _T_437 & _T_94 & _T_434)) begin	// @[Monitor.scala:29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & ~(io_in_flit_0_bits_virt_channel_id != 4'h1 | _T_436 & _T_437 & _T_94 & _T_434 | _T_443 & _T_423 & _T_94 & _T_434 | _T_436 & _T_409 & _T_94 & _T_434 | _T_443 & _T_444 & _T_94 & _T_434 | _T_436 & _T_444 & _T_94 & _T_434 | _T_436 & _T_423 & _T_94 & _T_434 | _T_443 & _T_437 & _T_94 & _T_434 | _T_443 & _T_409 & _T_94 & _T_434)) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & ~(io_in_flit_0_bits_virt_channel_id != 4'h2 | _T_316 & _T_317 & _T_279 & _T_281 | _T_295 & _T_430 & _T_279 & _T_281 | _T_316 & _T_430 & _T_279 & _T_281 | _T_302 & _T_317 & _T_279 & _T_281 | _T_309 & _T_317 & _T_279 & _T_281 | _T_309 & _T_430 & _T_279 & _T_281 | _T_295 & _T_317 & _T_279 & _T_281 | _T_302 & _T_430 & _T_279 & _T_281 | io_in_flit_0_bits_flow_ingress_node == 4'h3 & _T_317 & io_in_flit_0_bits_flow_ingress_node_id == 3'h4 & _T_281)) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & io_in_flit_0_bits_virt_channel_id == 4'h3) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44}]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & ~(io_in_flit_0_bits_virt_channel_id != 4'h4 | _T_443 & _T_444 & _T_279 & _T_281 | _T_443 & _T_409 & _T_279 & _T_281 | _T_443 & _T_423 & _T_279 & _T_281 | _T_443 & _T_437 & _T_279 & _T_281)) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & ~(io_in_flit_0_bits_virt_channel_id != 4'h5 | _T_443 & _T_444 & _T_279 & _T_281 | _T_436 & _T_409 & _T_279 & _T_281 | _T_443 & _T_409 & _T_279 & _T_281 | _T_436 & _T_437 & _T_279 & _T_281 | _T_443 & _T_437 & _T_279 & _T_281 | _T_436 & _T_444 & _T_279 & _T_281 | _T_436 & _T_423 & _T_279 & _T_281 | _T_443 & _T_423 & _T_279 & _T_281)) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & ~(io_in_flit_0_bits_virt_channel_id != 4'h6 | _T_295 & _T_317 & _T_446 & _T_448 | _T_302 & _T_317 & _T_446 & _T_448 | _T_309 & _T_317 & _T_446 & _T_448 | _T_316 & _T_317 & _T_446 & _T_448)) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & io_in_flit_0_bits_virt_channel_id == 4'h7) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44}]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & ~(io_in_flit_0_bits_virt_channel_id != 4'h8 | _T_443 & _T_423 & _T_446 & _T_448 | _T_443 & _T_430 & _T_446 & _T_434 | _T_443 & _T_437 & _T_446 & _T_448 | _T_443 & _T_444 & _T_446 & _T_448 | _T_443 & _T_409 & _T_446 & _T_448)) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
      end
      if (_T_4 & ~reset & ~(io_in_flit_0_bits_virt_channel_id != 4'h9 | _T_436 & _T_409 & _T_446 & _T_448 | _T_443 & _T_423 & _T_446 & _T_448 | _T_443 & _T_430 & _T_446 & _T_434 | _T_443 & _T_437 & _T_446 & _T_448 | _T_443 & _T_409 & _T_446 & _T_448 | _T_436 & _T_444 & _T_446 & _T_448 | _T_436 & _T_423 & _T_446 & _T_448 | _T_436 & _T_430 & _T_446 & _T_434 | _T_436 & _T_437 & _T_446 & _T_448 | _T_443 & _T_444 & _T_446 & _T_448)) begin	// @[Monitor.scala:21:46, :29:22, :32:{17,44,52}, Types.scala:53:21, :54:21, :55:{25,45}, :56:24]
        if (`ASSERT_VERBOSE_COND_)	// @[Monitor.scala:32:17]
          $error("Assertion failed\n    at Monitor.scala:32 assert(flit.bits.virt_channel_id =/= i.U || v.possibleFlows.toSeq.map(_.isFlow(flit.bits.flow)).orR)\n");	// @[Monitor.scala:32:17]
        if (`STOP_COND_)	// @[Monitor.scala:32:17]
          $fatal;	// @[Monitor.scala:32:17]
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
        in_flight_0 = _RANDOM_0[0];	// @[Monitor.scala:16:26]
        in_flight_1 = _RANDOM_0[1];	// @[Monitor.scala:16:26]
        in_flight_2 = _RANDOM_0[2];	// @[Monitor.scala:16:26]
        in_flight_3 = _RANDOM_0[3];	// @[Monitor.scala:16:26]
        in_flight_4 = _RANDOM_0[4];	// @[Monitor.scala:16:26]
        in_flight_5 = _RANDOM_0[5];	// @[Monitor.scala:16:26]
        in_flight_6 = _RANDOM_0[6];	// @[Monitor.scala:16:26]
        in_flight_7 = _RANDOM_0[7];	// @[Monitor.scala:16:26]
        in_flight_8 = _RANDOM_0[8];	// @[Monitor.scala:16:26]
        in_flight_9 = _RANDOM_0[9];	// @[Monitor.scala:16:26]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
endmodule

