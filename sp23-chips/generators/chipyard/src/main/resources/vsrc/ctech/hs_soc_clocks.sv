//=============================================================================
//  Copyright (c) 2010 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
//=============================================================================
//
// Description:
// This file should only be used by VISA module and for local synthesis purpose only. 
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// DO NOT use this file in any formal synthesis environment.
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// Please contact library group for proper soc_clocks.sv for each process (1269, 1271 etc)
//
//=============================================================================
//
`ifndef SOC_CLOCKS_SV
`define SOC_CLOCKS_SV

`include "hs_soc_macros.sv"
`include "hs_soc_power_macros.sv"
`include "hs_soc_dfx_macros.sv"
`include "hs_soc_clock_macros.sv"
`include "hs_chv_macro_tech_map.vh"
/*
`define MAKE_CLK_2TO1MUX(outclk,in1,in2,sel) \
`ifdef SYNTH_1269HBN \
yc8hbncb01lnd4 ckmux1_dcszo (.o(outclk), .d1(in2), .d2(in1), .s(sel)); \
`elsif SYNTH_1271B8  \
 b05cbn01ln0o0 \``out``_dcszo [$bits(outclk)-1:0] (.clkout(outclk), .clk1(in2), .clk2(in1), .s(sel));           \
`elsif SYNTH_1271B14 \
b14cmx2lnd4 ckmux1_dcszo (.o(outclk), .d1(in2), .d2(in1), .s(sel)); \
`elsif SYNTH_D04_XN  \
 d04gmx22xd0c0 \``out``_dcszo [$bits(outclk)-1:0] (.clkout(outclk), .clk1(in2), .clk2(in1), .s(sel));           \
`elsif SYNTH_D04  \
 d04gmx22wd0c0 \``out``_dcszo [$bits(outclk)-1:0] (.clkout(outclk), .clk1(in2), .clk2(in1), .s(sel));           \
`else \
   assign outclk = (in2 & sel) | (in1 & ~sel); \
`endif

`define MAKE_CLK_DIV_1_TO_10_USYNC(clkout, divvalonehot, clkin, usync, asyncrstb )      	\
div1to10macro_usync \div1to10macro_usync_``clkout (                      			\
                                                            .clk_out(clkout),    		\
                                                            .div_val_onehot(divvalonehot),      \
                                                            .clk_in(clkin),        		\
                                                            .usync_in(usync),        		\
                                                            .asyncrst_in(asyncrstb)         	\
                                                          );

`define MAKE_CLK_DIV2_RESET(ckdiv2rout,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)                      \
clockdivffreset \``clockdivffreset_``ckdiv2rout (                                   \
                                               .ffoutreset(ckdiv2rout),             \
                                               .ffinreset(ckdiv2rin),               \
                                               .clockinreset(ckdiv2clkin),          \
                                               .resetckdivff(ckdiv2resetin)         \
                                              );

`define MAKE_CLK_DIV4_RESET(ckdiv4rout,ckdiv4rin,ckdiv4resetin)                 \
clockdiv4ffreset \``clockdiv4ffreset_``ckdiv4rout (                             \
                                               .clk_out(ckdiv4rout),         	\
                                               .clk_in(ckdiv4rin),              \
                                               .reset_in(ckdiv4resetin)         \
                                              );

`define MAKE_CLK_DIV8(ckdiv8out,ipinckdiv8in,usyncdiv8in)        \
clkdiv8 \``clk_div8_``ckdiv8out (                                \
                               .div8ckdiv8out (ckdiv8out),       \
                               .div8ipinckdiv8in (ipinckdiv8in), \
                               .div8usyncdiv8in (usyncdiv8in)    \
                              );

`define MAKE_CLK_DIV4(ckdiv4out,ipinckdiv4in,usyncdiv4in)        \
clkdiv4 \``clk_div4_``ckdiv4out (                                \
                               .div4ckdiv4out (ckdiv4out),       \
                               .div4ipinckdiv4in (ipinckdiv4in), \
                               .div4usyncdiv4in (usyncdiv4in)    \
                              );

// LIB_clkanden
// LIB_SOC_CLKAND
`define CLK_AND_EN(enclk,clk,en) \
`ifdef SYNTH_1269HBN  \
yc8hbncb02lnd4 \``clkand_dcszo_``enclk  (.ck(clk), .en(en), .o(enclk));   \
`elsif SYNTH_1271B8  \
 b05cbn02ln0g0 \``clkand_dcszo_``enclk (.clk(clk), .en(en), .clkout(enclk)); \
`elsif SYNTH_1271B14  \
b14can0lnd0 \``clkand_dcszo_``enclk  <$typeof(enclk)> (.ck(<(clk)>), .en(<(en)>), .o(<(enclk)>));  \
`elsif SYNTH_D04_XN  \
 d04gan00xd0b0 \``clkand_dcszo_``enclk   (.clk(clk), .en(en), .clkout(enclk)); \
`elsif SYNTH_D04  \
 //d04gan00wd0b0 \``clkand_dcszo_``enclk   (.clk(clk), .en(en), .clkout(enclk)); \
 d04gan00ld0b0 \``clkand_dcszo_``enclk   (.clk(clk), .en(en), .clkout(enclk)); \
`else \
assign enclk = (clk & en); \
`endif
 
// new clock gate cell from BXT for ihl2

`define LIB_CLKGATE(enclk, clk, en, te)                                  \
    //d04cgc01ld0h0 \``enclk``_dcszo (.clkout(clkout),.clk(clk),.en(en),.te(te));  //p1273.1 ICG
    d04cgc01ld0f0 \``enclk``_dcszo (.clkout(clkout),.clk(clk),.en(en),.te(te));  //p1273.1 ICG


`define CLK_GATE_W_OVERRIDE(enclk, clk, en, te)           \
`ifdef DC    \
  `LIB_CLKGATE(enclk, clk, en, te)                                    \
`else \
  logic        cken_int; \
  logic        latched_cken; \
  assign cken_int = en | te; \
  always_latch \
    begin : ctech_clock_gate \
      if (~clk) latched_cken <= cken_int; \
    end \
  always_comb enclk = latched_cken & clk; \
`endif

//end here ICG

//LATCH_P
`define LATCH_P(q,i,clock)                                  \
   always_latch                                             \
      begin                                                 \
         if (~clock) q <=  i;                               \
      end

// LIB_SOC_CLKAND
`define CLKAND(outclk,inclk,enable)                                                                                              \
`ifdef SYNTH_D04_XN                                                                                                     \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
    d04gna00xd0b0 \``clknand_dcszo_``outclk  (.clk(inclk), .en(enable), .clkout(\``tmp_``outclk )); \
    d04gin00xd0b0 \``clkinv_dcszo_``outclk  (.clk(\``tmp_``outclk ), .clkout(outclk));                  \
`elsif SYNTH_D04                                                                                                                 \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
    //d04gna00wd0b0 \``clknand_dcszo_``outclk (.clk((inclk)), .en((enable)), .clkout((\``tmp_``outclk ))); \
    d04gna00ld0b0 \``clknand_dcszo_``outclk (.clk((inclk)), .en((enable)), .clkout((\``tmp_``outclk ))); \
    //d04gin00wd0b0 \``clkinv_dcszo_``outclk  (.clk((\``tmp_``outclk )), .clkout((outclk)));                  \
    d04gin00ld0b0 \``clkinv_dcszo_``outclk  (.clk((\``tmp_``outclk )), .clkout((outclk)));                  \
`elsif SYNTH_B12                                                                                                                 \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
    b12cna0wnd0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>));         \
    b12ci00wnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                          \
`elsif SYNTH_B11                                                                                                                 \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
    b11cna0wnd0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>));         \
    b11ci00wnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                          \
`elsif SYNTH_1269HBN                                                                                                             \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
    yc8hbncb02lnd4 \``clkand_dcszo_``outclk  (.ck(inclk), .en(enable), .o(\``tmp_``outclk));       \
`elsif SYNTH_1271B12                                                                                                             \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
    b12can0wnd0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>));         \
`elsif SYNTH_1273B4                                                                                                              \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
    //d04gan00wd0b0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.clk(<(inclk)>), .en(<(enable)>), .clkout(<(\``tmp_``outclk )>)); \
    d04gan00ld0b0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.clk(<(inclk)>), .en(<(enable)>), .clkout(<(\``tmp_``outclk )>)); \
`else \
    assign outclk = (inclk & enable); \
`endif

// LIB_clkinv
`define MAKE_CLK_INV(clkout,clkin)                               \
`ifdef SYNTH_D04                                                 \
    //d04gin00wd0b0 clkinv1_dcszo (.c``lkout(clkout),.clk(clkin)); \
    d04gin00ld0b0 clkinv1_dcszo (.c``lkout(clkout),.clk(clkin)); \
`elsif SYNTH_D04_XN                                                 \
    d04gin00xd0b0 clkinv1_dcszo (.c``lkout(clkout),.clk(clkin)); \
`elsif SYNTH_B12                                                 \
    b12ci00wnd0 clkinv1_dcszo (.o(clkout),.ck(clkin));           \
`elsif SYNTH_TG                                                  \
   b12in00lnx10tg clkinv1_dcszo (.oehv(clkout),.aehv(clkin));    \
`elsif SYNTH_B11                                                 \
    b11ci00wnd0 clkinv1_dcszo (.o(clkout),.ck(clkin));           \
`elsif SYNTH_1269HBN                                             \
    yc8hbnci00lnd0 clkinv1_dcszo (.o(clkout),.ck(clkin));        \
`elsif SYNTH_1271B12                                             \
    b12ci00wnd0 \``clkinvout``_i0_dcszo (.o(clkout),.ck(clkin)); \
`elsif SYNTH_1271B14                                             \
    b14ci00lnd0 clkinv1_dcszo (.o(clkout),.ck(clkin));           \
 `elsif SYNTH_1271B8 \
    b05cin00ld0m7 clkinv1_dcszo (.c``lkout(clkout),.clk(clkin)); \
`elsif SYNTH_1273B4                                              \
    d04gin00wd0b0 clkinv1_dcszo (.c``lkout(clkout),.clk(clkin)); \
`else \
  assign clkout = ~clkin; \
`endif

// LIB_ASYNC_RST_2MSFF_META
`define ASYNC_RST_2MSFF_META(data_ff,data,clk,resetb)                                                                                            \
`ifdef SYNTH_D04_TBD                                                                                                                              \
    d04xau03wd0b0  \``data_ff``_dcszo <$typeof(data_ff)> (.o(<(data_ff)>), .d(<(data)>), .c``lk(clk), .rb(resetb), .so(), .si(1'b0), .ss(1'b0)); \
`elsif SYNTH_B12                                                                                                                                 \
    b12mas2wnx10  \``data_ff``_dcszo <$typeof(data_ff)> (.o(<(data_ff)>), .d(<(data)>), .ck(clk), .rb(resetb), .so(), .si(1'b0), .ss(1'b0));     \
`elsif SYNTH_B11                                                                                                                                 \
    b11mas2wnx10  \``data_ff``_dcszo <$typeof(data_ff)> (.o(<(data_ff)>), .d(<(data)>), .ck(clk), .rb(resetb), .so(), .si(1'b0), .ss(1'b0));     \
`elsif SYNTH_1269HBN                                                                                                                             \
    yc8hbnmas02lnx10 \``data_ff``_dcszo (.o(data_ff), .d(data), .ck(clk), .rb(resetb));                               \
`elsif SYNTH_1271B12                                                                                                                             \
    b12mas2wnx10  \``data_ff``_dcszo <$typeof(data_ff)> (.o(<(data_ff)>), .d(<(data)>), .ck(clk), .rb(resetb), .so(), .si(1'b0), .ss(1'b0));     \
`elsif SYNTH_1271B14                                                                                                                             \
    b14mas2lnx10  \``data_ff``_dcszo <$typeof(data_ff)> (.o(<(data_ff)>), .d(<(data)>), .ck(clk), .rb(resetb), .so(), .si(1'b0), .ss(1'b0));     \
`else                                                                   \
  logic [$bits(data)-1:0] \``staged_``data_ff ;                         \
  always_ff @(posedge clk or negedge resetb ) begin                     \
    if ( ~resetb )       \``staged_``data_ff <= '0;                     \
    else               \``staged_``data_ff <=  data;                    \
  end                                                                   \
  always_ff @(posedge clk or negedge resetb) begin                      \
    if ( ~resetb )       data_ff<= '0;                                  \
    else               data_ff <=  \``staged_``data_ff ;                \
  end                                                                   \
`endif


// LIB_ASYNC_SET_2MSFF_META
`define ASYNC_SET_2MSFF_META(q, i, clk, ipsb)                                                                              \
`ifdef SYNTH_D04_TBD                                                                                                        \
    d04xau0cwd0b0  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .c``lk(clk), .psb(ipsb), .so(), .si(1'b0), .ss(1'b0)); \
`elsif SYNTH_B12                                                                                                           \
    b12mas1wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .psb(ipsb), .so(), .si(1'b0), .ss(1'b0));     \
`elsif SYNTH_B11                                                                                                           \
    b11mas1wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .psb(ipsb), .so(), .si(1'b0), .ss(1'b0));     \
`else \
  logic [$bits(i)-1:0] \``staged_``q ;                          \
  always_ff @(posedge clk or negedge ipsb ) begin               \
    if ( ~ipsb )        \``staged_``q <= '1;                    \
    else                \``staged_``q <=  i;                    \
  end                                                           \
  always_ff @(posedge clk or negedge ipsb) begin                \
    if ( ~ipsb )        q <= '1;                                \
    else                q <=  \``staged_``q ;                   \
  end                                                           \
`endif

// LIB_clknor
`define CLK_NOR(o,ck1,ck2)                                                               \
`ifdef SYNTH_D04                                                                         \
    //d04gno02wd0b0 \``o``_cknor_dcszo (.clkout(o),.clk1(ck1),.clk2(ck2));                 \
    d04gno02ld0b0 \``o``_cknor_dcszo (.clkout(o),.clk1(ck1),.clk2(ck2));                 \
`elsif SYNTH_D04_XN                                                                         \
    d04gno02xd0b0 \``o``_cknor_dcszo (.clkout(o),.clk1(ck1),.clk2(ck2));                 \
`elsif SYNTH_B12                                                                         \
    b12cno2wnd1  \``o``_cknor_dcszo (.o(o),.ck1(ck1),.ck2(ck2));                         \
`elsif SYNTH_TG                                                                          \
   b12no02lnx10tg   \``o``_cknor_dcszo (.oehv(o),.aehv(ck1),.behv(ck2));                 \
`elsif SYNTH_B11                                                                         \
    b11cno2wnd1  \``o``_cknor_dcszo (.o(o),.ck1(ck1),.ck2(ck2));                         \
`elsif SYNTH_1269HBN                                                                     \
    yc8hbnnoc00ln0b5 cknor_dcszo (.o(o),.clk(ck1),.en(ck2));                             \
`elsif SYNTH_1271B12                                                                     \
    b12cno2wnd1 cknor_dcszo (.o(o),.ck1(ck1),.ck2(ck2));                                 \
`elsif SYNTH_1271B14                                                                     \
    b14cno2lnd0 cknor_dcszo (.o(o),.ck1(ck1),.ck2(ck2));                                 \
`elsif SYNTH_1271B8                                                                      \
    b05noc02ld0g0 cknor_dcszo (.clkout(o), .clk1(ck1), .clk2(ck2));                      \
`else                                                                                    \
  assign o = ~(ck1 | ck2);                                                               \
`endif                                                                                   \
 

// LIB_clknor
`define MAKE_CLKNOR(clkout,clkin1,clkin2)                                                \
`ifdef SYNTH_D04                                                                         \
    //d04gno02wd0b0 \``clkout``_cknor_dcszo (.clkout(clkout),.clk1(clkin1),.clk2(clkin2)); \
    d04gno02ld0b0 \``clkout``_cknor_dcszo (.clkout(clkout),.clk1(clkin1),.clk2(clkin2)); \
`elsif SYNTH_D04_XN                                                                         \
    d04gno02xd0b0 \``clkout``_cknor_dcszo (.clkout(clkout),.clk1(clkin1),.clk2(clkin2)); \
`elsif SYNTH_B12                                                                         \
    b12cno2wnd1  \``clkout``_cknor_dcszo (.o(clkout),.ck1(clkin1),.ck2(clkin2));         \
`elsif SYNTH_TG                                                                          \
   b12no02lnx10tg   \``clkout``_cknor_dcszo (.oehv(clkout),.aehv(clkin1),.behv(clkin2)); \
`elsif SYNTH_B11                                                                         \
    b11cno2wnd1  \``clkout``_cknor_dcszo (.o(clkout),.ck1(clkin1),.ck2(clkin2));         \
`elsif SYNTH_1269HBN                                                                     \
    yc8hbnnoc00ln0b5 cknor_dcszo (.o(clkout),.clk(clkin1),.en(clkin2));                  \
`elsif SYNTH_1271B12                                                                     \
    b12cno2wnd1 cknor_dcszo (.o(clkout),.ck1(clkin1),.ck2(clkin2));                      \
`elsif SYNTH_1271B14                                                                     \
    b14cno2lnd0 cknor_dcszo (.o(clkout),.ck1(clkin1),.ck2(clkin2));                      \
`elsif SYNTH_1271B8                                                                      \
    b05noc02ld0g0 cknor_dcszo (.clkout(clkout), .clk1(clkin1), .clk2(clkin2));           \
`else \
  assign clkout = ~(clkin1 | clkin2); \
`endif

// LIB_CLKBF_SOC
`define CLKBF(clkbufout,clkbufin)                                                    \
`ifdef SYNTH_D04                                                               \
    //d04gbc00wd0e0 \``clkbufout``_i0_dcszo (.clkout(clkbufout),.clk(clkbufin)); \
    d04gbc00ld0e0 \``clkbufout``_i0_dcszo (.clkout(clkbufout),.clk(clkbufin)); \
`elsif SYNTH_D04_XN                                                               \
    d04gbc00xd0e0 \``clkbufout``_i0_dcszo (.clkout(clkbufout),.clk(clkbufin)); \
`elsif SYNTH_B12                                                               \
    b12cb00wnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));         \
`elsif SYNTH_B11                                                               \
    b11cb00wnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));         \
`elsif SYNTH_1269HBN                                                           \
    yc8hbncb00lnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));      \
`elsif SYNTH_1271B12                                                           \
    b12dwcbwnd1 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));         \
`elsif SYNTH_1271B14                                                           \
    b14cb00lnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));         \
`else                                                                          \
  assign clkbufout = clkbufin;                                                       \
`endif
*/
`endif //  `ifndef SOC_CLOCKS_SV
