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

module KalmanTop(
  input         clock,
                reset,
                io_cmd_valid,
  input  [6:0]  io_cmd_bits_inst_funct,
  input  [4:0]  io_cmd_bits_inst_rd,
  input  [63:0] io_cmd_bits_rs1,
                io_cmd_bits_rs2,
  input  [1:0]  io_cmd_bits_status_dprv,
  input         io_cmd_bits_status_dv,
                io_resp_ready,
                io_mem_req_ready,
                io_mem_resp_valid,
  input  [63:0] io_mem_resp_bits_data,
  output        io_cmd_ready,
                io_resp_valid,
  output [4:0]  io_resp_bits_rd,
  output [63:0] io_resp_bits_data,
  output        io_mem_req_valid,
  output [39:0] io_mem_req_bits_addr,
  output [7:0]  io_mem_req_bits_tag,
  output [4:0]  io_mem_req_bits_cmd,
  output [1:0]  io_mem_req_bits_dprv,
  output        io_mem_req_bits_dv,
  output [63:0] io_mem_req_bits_data,
  output [7:0]  io_mem_req_bits_mask,
  output        io_busy
);

  wire        _vectorUnitResponseQueue_io_enq_ready;	// @[Decoupled.scala:375:21]
  wire        _vectorUnitResponseQueue_io_deq_valid;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_0;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_1;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_2;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_3;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_4;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_5;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_6;	// @[Decoupled.scala:375:21]
  wire [31:0] _vectorUnitResponseQueue_io_deq_bits_7;	// @[Decoupled.scala:375:21]
  wire        _vectorUnit_io_req_ready;	// @[KalmanTop.scala:42:26]
  wire        _vectorUnit_io_resp_valid;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_0;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_1;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_2;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_3;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_4;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_5;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_6;	// @[KalmanTop.scala:42:26]
  wire [31:0] _vectorUnit_io_resp_bits_7;	// @[KalmanTop.scala:42:26]
  wire        _vectorUnit_io_mem_in_valid;	// @[KalmanTop.scala:42:26]
  wire [63:0] _vectorUnit_io_mem_in_bits_addr;	// @[KalmanTop.scala:42:26]
  wire [63:0] _vectorUnit_io_mem_in_bits_data;	// @[KalmanTop.scala:42:26]
  wire [7:0]  _vectorUnit_io_mem_in_bits_mask;	// @[KalmanTop.scala:42:26]
  wire        _vectorUnit_io_mem_in_bits_write;	// @[KalmanTop.scala:42:26]
  wire        _vectorUnit_io_mem_out_ready;	// @[KalmanTop.scala:42:26]
  wire        _l1Unit_io_req_ready;	// @[KalmanTop.scala:33:22]
  wire        _l1Unit_io_resp_valid;	// @[KalmanTop.scala:33:22]
  wire [63:0] _l1Unit_io_resp_bits_data;	// @[KalmanTop.scala:33:22]
  reg  [4:0]  cmd_inst_rd;	// @[KalmanTop.scala:29:20]
  reg  [1:0]  cmd_status_dprv;	// @[KalmanTop.scala:29:20]
  reg         cmd_status_dv;	// @[KalmanTop.scala:29:20]
  reg         busy;	// @[KalmanTop.scala:30:21]
  wire        _T_21 = _vectorUnit_io_req_ready & io_cmd_valid;	// @[Decoupled.scala:51:35, KalmanTop.scala:42:26]
  always @(posedge clock) begin
    if (reset) begin
      cmd_inst_rd <= 5'h0;	// @[KalmanTop.scala:29:{20,33}]
      cmd_status_dprv <= 2'h0;	// @[KalmanTop.scala:29:{20,33}]
      cmd_status_dv <= 1'h0;	// @[KalmanTop.scala:29:20]
      busy <= 1'h0;	// @[KalmanTop.scala:30:21]
    end
    else begin
      if (_T_21) begin	// @[Decoupled.scala:51:35]
        cmd_inst_rd <= io_cmd_bits_inst_rd;	// @[KalmanTop.scala:29:20]
        cmd_status_dprv <= io_cmd_bits_status_dprv;	// @[KalmanTop.scala:29:20]
        cmd_status_dv <= io_cmd_bits_status_dv;	// @[KalmanTop.scala:29:20]
      end
      busy <= ~(io_resp_ready & _vectorUnitResponseQueue_io_deq_valid) & (_T_21 | busy);	// @[Decoupled.scala:51:35, :375:21, KalmanTop.scala:30:21, :52:21, :54:10, :68:38, :69:10]
    end
  end // always @(posedge)
  `ifndef SYNTHESIS
    always @(posedge clock) begin	// @[KalmanTop.scala:53:11]
      if (_T_21 & ~reset & ~(io_cmd_bits_inst_funct[4:0] == 5'h0 | io_cmd_bits_inst_funct[4:0] == 5'h1 | io_cmd_bits_inst_funct[4:0] == 5'h2 | io_cmd_bits_inst_funct[4:0] == 5'h3 | io_cmd_bits_inst_funct[4:0] == 5'h4 | io_cmd_bits_inst_funct[4:0] == 5'h5 | io_cmd_bits_inst_funct[4:0] == 5'h6 | io_cmd_bits_inst_funct[4:0] == 5'h7 | io_cmd_bits_inst_funct[4:0] == 5'h8 | io_cmd_bits_inst_funct[4:0] == 5'h9 | io_cmd_bits_inst_funct[4:0] == 5'h10)) begin	// @[Decoupled.scala:51:35, KalmanTop.scala:29:33, :51:{32,55}, :53:11]
        if (`ASSERT_VERBOSE_COND_)	// @[KalmanTop.scala:53:11]
          $error("Assertion failed\n    at KalmanTop.scala:53 assert(opw)\n");	// @[KalmanTop.scala:53:11]
        if (`STOP_COND_)	// @[KalmanTop.scala:53:11]
          $fatal;	// @[KalmanTop.scala:53:11]
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
        cmd_inst_rd = _RANDOM_0[24:20];	// @[KalmanTop.scala:29:20]
        cmd_status_dprv = _RANDOM_6[4:3];	// @[KalmanTop.scala:29:20]
        cmd_status_dv = _RANDOM_6[5];	// @[KalmanTop.scala:29:20]
        busy = _RANDOM_8[9];	// @[KalmanTop.scala:30:21]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  L1Controller l1Unit (	// @[KalmanTop.scala:33:22]
    .clock                 (clock),
    .reset                 (reset),
    .io_req_valid          (_vectorUnit_io_mem_in_valid),	// @[KalmanTop.scala:42:26]
    .io_req_bits_addr      (_vectorUnit_io_mem_in_bits_addr),	// @[KalmanTop.scala:42:26]
    .io_req_bits_data      (_vectorUnit_io_mem_in_bits_data),	// @[KalmanTop.scala:42:26]
    .io_req_bits_mask      (_vectorUnit_io_mem_in_bits_mask),	// @[KalmanTop.scala:42:26]
    .io_req_bits_write     (_vectorUnit_io_mem_in_bits_write),	// @[KalmanTop.scala:42:26]
    .io_resp_ready         (_vectorUnit_io_mem_out_ready),	// @[KalmanTop.scala:42:26]
    .io_dprv               (cmd_status_dprv),	// @[KalmanTop.scala:29:20]
    .io_dv                 (cmd_status_dv),	// @[KalmanTop.scala:29:20]
    .io_mem_req_ready      (io_mem_req_ready),
    .io_mem_resp_valid     (io_mem_resp_valid),
    .io_mem_resp_bits_data (io_mem_resp_bits_data),
    .io_req_ready          (_l1Unit_io_req_ready),
    .io_resp_valid         (_l1Unit_io_resp_valid),
    .io_resp_bits_data     (_l1Unit_io_resp_bits_data),
    .io_mem_req_valid      (io_mem_req_valid),
    .io_mem_req_bits_addr  (io_mem_req_bits_addr),
    .io_mem_req_bits_tag   (io_mem_req_bits_tag),
    .io_mem_req_bits_cmd   (io_mem_req_bits_cmd),
    .io_mem_req_bits_dprv  (io_mem_req_bits_dprv),
    .io_mem_req_bits_dv    (io_mem_req_bits_dv),
    .io_mem_req_bits_data  (io_mem_req_bits_data),
    .io_mem_req_bits_mask  (io_mem_req_bits_mask)
  );
  VectorUnit vectorUnit (	// @[KalmanTop.scala:42:26]
    .clock                (clock),
    .reset                (reset),
    .io_req_valid         (io_cmd_valid),
    .io_req_bits_addr     (io_cmd_bits_rs2),
    .io_req_bits_v0       (io_cmd_bits_rs1[2:0]),	// @[KalmanTop.scala:60:10]
    .io_req_bits_v1       (io_cmd_bits_rs2[2:0]),	// @[KalmanTop.scala:61:10]
    .io_req_bits_op       (io_cmd_bits_inst_funct[4:0]),	// @[KalmanTop.scala:51:55]
    .io_resp_ready        (_vectorUnitResponseQueue_io_enq_ready),	// @[Decoupled.scala:375:21]
    .io_mem_in_ready      (_l1Unit_io_req_ready),	// @[KalmanTop.scala:33:22]
    .io_mem_out_valid     (_l1Unit_io_resp_valid),	// @[KalmanTop.scala:33:22]
    .io_mem_out_bits_data (_l1Unit_io_resp_bits_data),	// @[KalmanTop.scala:33:22]
    .io_req_ready         (_vectorUnit_io_req_ready),
    .io_resp_valid        (_vectorUnit_io_resp_valid),
    .io_resp_bits_0       (_vectorUnit_io_resp_bits_0),
    .io_resp_bits_1       (_vectorUnit_io_resp_bits_1),
    .io_resp_bits_2       (_vectorUnit_io_resp_bits_2),
    .io_resp_bits_3       (_vectorUnit_io_resp_bits_3),
    .io_resp_bits_4       (_vectorUnit_io_resp_bits_4),
    .io_resp_bits_5       (_vectorUnit_io_resp_bits_5),
    .io_resp_bits_6       (_vectorUnit_io_resp_bits_6),
    .io_resp_bits_7       (_vectorUnit_io_resp_bits_7),
    .io_mem_in_valid      (_vectorUnit_io_mem_in_valid),
    .io_mem_in_bits_addr  (_vectorUnit_io_mem_in_bits_addr),
    .io_mem_in_bits_data  (_vectorUnit_io_mem_in_bits_data),
    .io_mem_in_bits_mask  (_vectorUnit_io_mem_in_bits_mask),
    .io_mem_in_bits_write (_vectorUnit_io_mem_in_bits_write),
    .io_mem_out_ready     (_vectorUnit_io_mem_out_ready)
  );
  Queue_287 vectorUnitResponseQueue (	// @[Decoupled.scala:375:21]
    .clock         (clock),
    .reset         (reset),
    .io_enq_valid  (_vectorUnit_io_resp_valid),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_0 (_vectorUnit_io_resp_bits_0),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_1 (_vectorUnit_io_resp_bits_1),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_2 (_vectorUnit_io_resp_bits_2),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_3 (_vectorUnit_io_resp_bits_3),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_4 (_vectorUnit_io_resp_bits_4),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_5 (_vectorUnit_io_resp_bits_5),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_6 (_vectorUnit_io_resp_bits_6),	// @[KalmanTop.scala:42:26]
    .io_enq_bits_7 (_vectorUnit_io_resp_bits_7),	// @[KalmanTop.scala:42:26]
    .io_deq_ready  (io_resp_ready),
    .io_enq_ready  (_vectorUnitResponseQueue_io_enq_ready),
    .io_deq_valid  (_vectorUnitResponseQueue_io_deq_valid),
    .io_deq_bits_0 (_vectorUnitResponseQueue_io_deq_bits_0),
    .io_deq_bits_1 (_vectorUnitResponseQueue_io_deq_bits_1),
    .io_deq_bits_2 (_vectorUnitResponseQueue_io_deq_bits_2),
    .io_deq_bits_3 (_vectorUnitResponseQueue_io_deq_bits_3),
    .io_deq_bits_4 (_vectorUnitResponseQueue_io_deq_bits_4),
    .io_deq_bits_5 (_vectorUnitResponseQueue_io_deq_bits_5),
    .io_deq_bits_6 (_vectorUnitResponseQueue_io_deq_bits_6),
    .io_deq_bits_7 (_vectorUnitResponseQueue_io_deq_bits_7)
  );
  assign io_cmd_ready = _vectorUnit_io_req_ready;	// @[KalmanTop.scala:42:26]
  assign io_resp_valid = _vectorUnitResponseQueue_io_deq_valid;	// @[Decoupled.scala:375:21]
  assign io_resp_bits_rd = cmd_inst_rd;	// @[KalmanTop.scala:29:20]
  assign io_resp_bits_data = {_vectorUnitResponseQueue_io_deq_bits_1, _vectorUnitResponseQueue_io_deq_bits_0};	// @[Decoupled.scala:375:21, KalmanTop.scala:73:12]
  assign io_busy = busy;	// @[KalmanTop.scala:30:21]
endmodule

