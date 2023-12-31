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

module floatMul(
  input  [31:0] io_in0,
                io_in1,
  output [31:0] io_out
);

  wire [32:0] _Mul_io_out;	// @[floatMul.scala:29:19]
  wire        Mul_io_a_rawIn_isZeroExpIn = io_in0[30:23] == 8'h0;	// @[Bitwise.scala:77:12, rawFloatFromFN.scala:47:23, :50:34]
  wire [4:0]  Mul_io_a_rawIn_normDist = io_in0[22] ? 5'h0 : io_in0[21] ? 5'h1 : io_in0[20] ? 5'h2 : io_in0[19] ? 5'h3 : io_in0[18] ? 5'h4 : io_in0[17] ? 5'h5 : io_in0[16] ? 5'h6 : io_in0[15] ? 5'h7 : io_in0[14] ? 5'h8 : io_in0[13] ? 5'h9 : io_in0[12] ? 5'hA : io_in0[11] ? 5'hB : io_in0[10] ? 5'hC : io_in0[9] ? 5'hD : io_in0[8] ? 5'hE : io_in0[7] ? 5'hF : io_in0[6] ? 5'h10 : io_in0[5] ? 5'h11 : io_in0[4] ? 5'h12 : io_in0[3] ? 5'h13 : io_in0[2] ? 5'h14 : io_in0[1] ? 5'h15 : 5'h16;	// @[Mux.scala:47:70, floatMul.scala:18:26, primitives.scala:92:52, rawFloatFromFN.scala:48:25]
  wire [53:0] _Mul_io_a_rawIn_subnormFract_T = {31'h0, io_in0[22:0]} << Mul_io_a_rawIn_normDist;	// @[Mux.scala:47:70, rawFloatFromFN.scala:48:25, :54:36]
  wire [8:0]  Mul_io_a_rawIn_adjustedExp = (Mul_io_a_rawIn_isZeroExpIn ? {4'hF, ~Mul_io_a_rawIn_normDist} : {1'h0, io_in0[30:23]}) + {7'h20, Mul_io_a_rawIn_isZeroExpIn ? 2'h2 : 2'h1};	// @[Mux.scala:47:70, rawFloatFromFN.scala:47:23, :50:34, :56:16, :57:26, :59:15, :60:27]
  wire        Mul_io_b_rawIn_isZeroExpIn = io_in1[30:23] == 8'h0;	// @[Bitwise.scala:77:12, rawFloatFromFN.scala:47:23, :50:34]
  wire [4:0]  Mul_io_b_rawIn_normDist = io_in1[22] ? 5'h0 : io_in1[21] ? 5'h1 : io_in1[20] ? 5'h2 : io_in1[19] ? 5'h3 : io_in1[18] ? 5'h4 : io_in1[17] ? 5'h5 : io_in1[16] ? 5'h6 : io_in1[15] ? 5'h7 : io_in1[14] ? 5'h8 : io_in1[13] ? 5'h9 : io_in1[12] ? 5'hA : io_in1[11] ? 5'hB : io_in1[10] ? 5'hC : io_in1[9] ? 5'hD : io_in1[8] ? 5'hE : io_in1[7] ? 5'hF : io_in1[6] ? 5'h10 : io_in1[5] ? 5'h11 : io_in1[4] ? 5'h12 : io_in1[3] ? 5'h13 : io_in1[2] ? 5'h14 : io_in1[1] ? 5'h15 : 5'h16;	// @[Mux.scala:47:70, floatMul.scala:18:26, primitives.scala:92:52, rawFloatFromFN.scala:48:25]
  wire [53:0] _Mul_io_b_rawIn_subnormFract_T = {31'h0, io_in1[22:0]} << Mul_io_b_rawIn_normDist;	// @[Mux.scala:47:70, rawFloatFromFN.scala:48:25, :54:36]
  wire [8:0]  Mul_io_b_rawIn_adjustedExp = (Mul_io_b_rawIn_isZeroExpIn ? {4'hF, ~Mul_io_b_rawIn_normDist} : {1'h0, io_in1[30:23]}) + {7'h20, Mul_io_b_rawIn_isZeroExpIn ? 2'h2 : 2'h1};	// @[Mux.scala:47:70, rawFloatFromFN.scala:47:23, :50:34, :56:16, :57:26, :59:15, :60:27]
  wire        io_out_rawIn_isInf = (&(_Mul_io_out[31:30])) & ~(_Mul_io_out[29]);	// @[floatMul.scala:29:19, rawFloatFromRecFN.scala:50:21, :52:{29,54}, :55:41, :56:{33,36}]
  wire        io_out_isSubnormal = $signed({1'h0, _Mul_io_out[31:23]}) < 10'sh82;	// @[fNFromRecFN.scala:50:39, floatMul.scala:29:19, rawFloatFromFN.scala:50:34, rawFloatFromRecFN.scala:50:21, :59:27]
  wire [23:0] _io_out_denormFract_T_1 = {1'h0, |(_Mul_io_out[31:29]), _Mul_io_out[22:1]} >> 5'h1 - _Mul_io_out[27:23];	// @[Mux.scala:47:70, fNFromRecFN.scala:51:{39,51}, :52:{38,42}, floatMul.scala:29:19, rawFloatFromFN.scala:50:34, rawFloatFromRecFN.scala:50:21, :51:{29,54}]
  MulRecFN Mul (	// @[floatMul.scala:29:19]
    .io_a   ({io_in0[31], (Mul_io_a_rawIn_isZeroExpIn & ~(|(io_in0[22:0])) ? 3'h0 : Mul_io_a_rawIn_adjustedExp[8:6]) | {2'h0, (&(Mul_io_a_rawIn_adjustedExp[8:7])) & (|(io_in0[22:0]))}, Mul_io_a_rawIn_adjustedExp[5:0], Mul_io_a_rawIn_isZeroExpIn ? {_Mul_io_a_rawIn_subnormFract_T[21:0], 1'h0} : io_in0[22:0]}),	// @[Cat.scala:33:92, rawFloatFromFN.scala:46:22, :48:25, :50:34, :51:38, :54:{36,47,64}, :59:15, :62:34, :63:{37,62}, :66:33, :72:42, recFNFromFN.scala:48:{16,53,79}, :50:23]
    .io_b   ({io_in1[31], (Mul_io_b_rawIn_isZeroExpIn & ~(|(io_in1[22:0])) ? 3'h0 : Mul_io_b_rawIn_adjustedExp[8:6]) | {2'h0, (&(Mul_io_b_rawIn_adjustedExp[8:7])) & (|(io_in1[22:0]))}, Mul_io_b_rawIn_adjustedExp[5:0], Mul_io_b_rawIn_isZeroExpIn ? {_Mul_io_b_rawIn_subnormFract_T[21:0], 1'h0} : io_in1[22:0]}),	// @[Cat.scala:33:92, rawFloatFromFN.scala:46:22, :48:25, :50:34, :51:38, :54:{36,47,64}, :59:15, :62:34, :63:{37,62}, :66:33, :72:42, recFNFromFN.scala:48:{16,53,79}, :50:23]
    .io_out (_Mul_io_out)
  );
  assign io_out = {_Mul_io_out[32], (io_out_isSubnormal ? 8'h0 : _Mul_io_out[30:23] + 8'h7F) | {8{(&(_Mul_io_out[31:30])) & _Mul_io_out[29] | io_out_rawIn_isInf}}, io_out_isSubnormal ? _io_out_denormFract_T_1[22:0] : io_out_rawIn_isInf ? 23'h0 : _Mul_io_out[22:0]};	// @[Bitwise.scala:77:12, Cat.scala:33:92, fNFromRecFN.scala:50:39, :52:{42,60}, :55:16, :57:{27,45}, :59:{15,44}, :61:16, :63:20, floatMul.scala:29:19, rawFloatFromRecFN.scala:50:21, :52:{29,54}, :55:{33,41}, :56:33, :58:25, :60:51]
endmodule

