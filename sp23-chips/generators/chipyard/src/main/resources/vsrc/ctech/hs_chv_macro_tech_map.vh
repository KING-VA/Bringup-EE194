//==============================================================
//  Copyright (c) 2011 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//==============================================================
//
// MOAD Begin
//     File/Block                             : chv_macro_tech_map.vh
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : none
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none  
//     Library (must be same as module name)  : none
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : shared
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner : james.e.pickens@intel.com
// Primary Contact   : james.e.pickens@intel.com
//
// MOAD End
//===============================================================


`ifndef __vlv_macro_tech_map__vh
`define __vlv_macro_tech_map__vh

//`ifdef DC
//`define SYNTH_D04
//`endif

//module power_switch_wrapper (gtdout,a,vccin,o);
//input vccin, a;
//output gtdout, o;
//`ifdef SYNTH_D04
//    assign o = a;
//    // TODO: Find the real p1273 power switch
//    // b12pwb0wfx10 power_switch(.o(o),.a(a));
//`elsif SYNTH_B12
//   b12pwb0wfx10 power_switch(.o(o),.a(a));
//`elsif SYNTH_B11
//   b11pwb0wfx10 power_switch(.o(o),.a(a));
//`endif
//endmodule


//`define LIB_POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)                                      \
//    power_switch_wrapper \``vcc_out``_dcszo (.gtdout(vcc_out),.a(pwren_in),.vccin(vcc_in),.o(pwren_out));  \

////module power_switch_wrapper_dual had not been tested out yet
//module power_switch_wrapper_dual (gtdout,a,b,vccinlv,aout,bout);
//input vccinlv, a, b;
//output gtdout, aout, bout;
//`ifdef SYNTH_D04
//    assign aout = a;
//    assign bout = b;
//    // TODO: Find the real p1273 power switch
//    // b12pwb1wfx10 dual_power_switch(.aout(aout),.a(a),.bout(bout),.b(b));
//`elsif SYNTH_B12
//   b12pwb1wfx10 dual_power_switch(.aout(aout),.a(a),.bout(bout),.b(b));
//`elsif SYNTH_B11
//   b11pwb1wfx10 dual_power_switch(.aout(aout),.a(a),.bout(bout),.b(b));
//`endif
//endmodule


//`define LIB_POWERSWITCH_DUAL(pwren1_out,pwren2_out,vcc_out,pwren1_in,pwren2_in,vcc_in,vss_in)            \
//    power_switch_wrapper_dual \``vcc_out``_dcszo (.gtdout(vcc_out),.a(pwren1_in),.b(pwren2_in),.vccinlv(vcc_in),.aout(pwren1_out),.bout(pwren2_out));



//`define LIB_LV_BUF(o,a)                                              \
//`ifdef SYNTH_D04                                                     \
// `ifdef IEEE_COMPLIANT                                               \
//    d04bfn00wn0a5  \``o``_dcszo [$bits(o)-1:0] (.o(o), .a(a));       \
// `else                                                               \
//    d04bfn00wn0a5  \``o``_dcszo <$typeof(o)> (.o(<(o)>), .a(<(a)>)); \
// `endif                                                              \
//`elsif SYNTH_B12                                                     \
//    b12bf00wnx05  \``o``_dcszo <$typeof(o)> (.o(<(o)>), .a(<(a)>));  \
//`elsif SYNTH_B11                                                     \
//    b11bf00wnx05  \``o``_dcszo <$typeof(o)> (.o(<(o)>), .a(<(a)>));  \
//`endif


//`define LIB_FIREWALL_AND(out,data,enable)                                               \
//`ifdef SYNTH_D04                                                                        \
// `ifdef IEEE_COMPLIANT                                                                  \
//    d04swa00wd0d0 \``out``_dcszo [$bits(out)-1:0] (.o(out),.en(enable),.a(data));       \
// `else                                                                                  \
//    d04swa00wd0d0 \``out``_dcszo <$typeof(out)> (.o(<(out)>),.en(enable),.a(<(data)>)); \
// `endif                                                                                 \
//`elsif SYNTH_B12                                                                        \
//    b12afw0wnx50 \``out``_dcszo <$typeof(out)> (.o(<(out)>),.en(enable),.a(<(data)>));  \
//`elsif SYNTH_B11                                                                        \
//    b11afw0wnx50 \``out``_dcszo <$typeof(out)> (.o(<(out)>),.en(enable),.a(<(data)>));  \
//`endif


//`define LIB_FIREWALL_OR(out,data,enable)                                                              \
//`ifdef SYNTH_D04                                                                                      \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                              \
//    d04swi00wd0d0 \``out``_pin_dcszo [$bits(out)-1:0] (.o1(\``tmp_``out ), .a(enable));               \
//    d04swo00wd0c0 \``out``_dcszo     [$bits(out)-1:0] (.o(out),.en(\``tmp_``out ),.a(data));          \
//`elsif SYNTH_B12                                                                                      \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                              \
//    b12siriwnx30 \``out``_pin_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>), .a(enable));               \
//    b12ofw0wnx30 \``out``_dcszo     <$typeof(out)> (.o(<(out)>),.en(<(\``tmp_``out )>),.a(<(data)>)); \
//`elsif SYNTH_B11                                                                                      \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                              \
//    b11siriwnx30 \``out``_pin_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>), .a(enable));               \
//    b11ofw0wnx30 \``out``_dcszo     <$typeof(out)> (.o(<(out)>),.en(<(\``tmp_``out )>),.a(<(data)>)); \
//`endif


//`define LIB_LS_LATCH_UP(outb,iwrite_en,ipro,ib)                                                 \
//`ifdef SYNTH_D04                                                                                \
// `ifdef IEEE_COMPLIANT                                                                          \
//    d04svb00wd0b0 \``outb``_dcszo [$bits(outb)-1:0] (.a(ib), .enb(iwrite_en), .o1(outb));       \
// `else                                                                                          \
//    d04svb00wd0b0 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .o1(<(outb)>)); \
// `endif                                                                                         \
//`elsif SYNTH_B12                                                                                \
//    b12bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));  \
//`elsif SYNTH_B11                                                                                \
//    b11bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));  \
//`endif


//`define LIB_LS_LATCH_DN(outb,iwrite_en,ipro,ib)                                                 \
//`ifdef SYNTH_D04                                                                                \
// `ifdef IEEE_COMPLIANT                                                                          \
//    d04svb00wd0b0 \``outb``_dcszo [$bits(outb)-1:0] (.a(ib), .enb(iwrite_en), .o1(outb));       \
// `else                                                                                          \
//    d04svb00wd0b0 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .o1(<(outb)>)); \
// `endif                                                                                         \
//`elsif SYNTH_B12                                                                                \
//    b12bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));  \
//`elsif SYNTH_B11                                                                                \
//    b11bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));  \
//`endif


//`define LIB_LS_WITH_AND_FW(mo, mpro, ma, mvccin, men)                                                \
//`ifdef SYNTH_D04                                                                                     \
// `ifdef IEEE_COMPLIANT                                                                               \
//    d04sva00wd0b0 \``mo``_ls_in_dcszo [$bits(mo)-1:0] (.a(ma), .en(men), .o(mo));                    \
// `else                                                                                               \
//    d04sva00wd0b0 \``mo``_ls_in_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));              \
// `endif                                                                                              \
//`elsif SYNTH_B12                                                                                     \
//    b12ba00wnx10 \``mo``_ls_in_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));               \
//`elsif SYNTH_TG											     \
//    b12svbilnx05tg \``mo``_ls_in_dcszo <$typeof(mo)> (.iehv(<(ma)>), .pwrokehv(men), .oehv(<(mo)>)); \
//`elsif SYNTH_B11                                                                                     \
//    b11ba00wnx10 \``mo``_ls_in_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));               \
//`endif

//`define LIB_LS_WITH_AND_FW_CLK(mo, mpro, ma, mvccin, men)                                            \
//`ifdef SYNTH_D04                                                                                     \
// `ifdef IEEE_COMPLIANT                                                                               \
//    d04svc00wd0c0 \``mo``_ls_in_dcszo [$bits(mo)-1:0] (.clk(ma), .en(men), .o(mo));                  \
// `else                                                                                               \
//    d04svc00wd0c0 \``mo``_ls_in_dcszo <$typeof(mo)> (.clk(<(ma)>), .en(men), .o(<(mo)>));            \
// `endif                                                                                              \
//`elsif SYNTH_B12                                                                                     \
//    b12bc00wnd1 \``mo``_ls_in_dcszo <$typeof(mo)> (.clk(<(ma)>), .en(men), .o(<(mo)>));              \
//`elsif SYNTH_TG                                                                                      \
//    b12svbilnx05tg \``mo``_ls_in_dcszo <$typeof(mo)> (.iehv(<(ma)>), .pwrokehv(men), .oehv(<(mo)>)); \
//`elsif SYNTH_B11                                                                                     \
//    b11ba00wnx10 \``mo``_ls_in_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));               \
//`endif

//`define LIB_LS_WITH_OR_FW(mo, mpro, ma, mvccin, men)                                  \
//`ifdef SYNTH_D04                                                                      \
// `ifdef IEEE_COMPLIANT                                                                \
//    d04svo00wd0b0 \``mo``_blo_dcszo [$bits(mo)-1:0] (.a(ma), .en(men), .o(mo));       \
// `else                                                                                \
//    d04svo00wd0b0 \``mo``_blo_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>)); \
// `endif                                                                               \
//`elsif SYNTH_B12                                                                      \
//    b12bo00wnx10 \``mo``_blo_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));  \
//`elsif SYNTH_B11                                                                      \
//    b11bo00wnx10 \``mo``_blo_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));  \
//`endif

//`define LIB_POWER_INVERTER_D(powerenout, powerenin, vcc_in)                                                  \
//`ifdef SYNTH_D04                                                                                             \
// `ifdef IEEE_COMPLIANT                                                                                       \
//    d04swi00wd0d0 \``powerenout``_pin_dcszo [$bits(powerenout)-1:0] (.o1(powerenout) , .a(powerenin));       \
// `else                                                                                                       \
//    d04swi00wd0d0 \``powerenout``_pin_dcszo <$typeof(powerenout)> (.o1(<(powerenout)>) , .a(<(powerenin)>)); \
// `endif                                                                                                      \
//`elsif SYNTH_B12                                                                                             \
//    b12siriwnx30 \``powerenout``_pin_dcszo <$typeof(powerenout)> (.o(<(powerenout)>) , .a(<(powerenin)>));   \
//`elsif SYNTH_B11                                                                                             \
//    b11siriwnx30 \``powerenout``_pin_dcszo <$typeof(powerenout)> (.o(<(powerenout)>) , .a(<(powerenin)>));   \
//`endif

//`define LIB_INV_PRSRV(outb,in)                                                             \
//`ifdef SYNTH_D04                                                                           \
// `ifdef IEEE_COMPLIANT                                                                     \
//    d04inn00wn0b0 \``outb``_tieoff_inv_dcszo [$bits(outb)-1:0] (.o1(outb) , .a(in));       \
// `else                                                                                     \
//    d04inn00wn0b0 \``outb``_tieoff_inv_dcszo <$typeof(outb)> (.o1(<(outb)>) , .a(<(in)>)); \
// `endif                                                                                    \
//`elsif SYNTH_B12                                                                           \
//    b12in00wnx10 \``outb``_tieoff_inv_dcszo <$typeof(outb)> (.o(<(outb)>) , .a(<(in)>));   \
//`elsif SYNTH_B11                                                                           \
//    b11in00wnx10 \``outb``_tieoff_inv_dcszo <$typeof(outb)> (.o(<(outb)>) , .a(<(in)>));   \
//`endif

//`define LIB_TIEOFF_0_PRSRV(out)                                                                                  \
//`ifdef SYNTH_D04                                                                                                 \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                                         \
//    d04inn00wn0b0 \``out``_tieoff_inv1_dcszo [$bits(out)-1:0] (.o1(\``tmp_``out ) , .a({$bits(out){1'b0}}));     \
//    d04inn00wn0b0 \``out``_tieoff_inv2_dcszo [$bits(out)-1:0] (.o1(out) , .a(\``tmp_``out ));                    \
//`elsif SYNTH_B12                                                                                                 \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                                         \
//    b12in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<({$bits(out){1'b0}})>)); \
//    b12in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(\``tmp_``out )>));                \
//`elsif SYNTH_B11                                                                                                 \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                                         \
//    b11in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<({$bits(out){1'b0}})>)); \
//    b11in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(\``tmp_``out )>));                \
//`endif

//`define LIB_TIEOFF_1_PRSRV(out)                                                                        \
//`ifdef SYNTH_D04                                                                                       \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                               \
//    d04inn00ln0a5  \``out``_tieoff_inv1_dcszo [$bits(out)-1:0] (.o1(out) , .a({$bits(out){1'b0}}));     \
//    d04inn00ln0a5  \``out``_tieoff_inv2_dcszo [$bits(out)-1:0] (.o1(\``tmp_``out ) , .a(out));          \
//`elsif SYNTH_B12                                                                                       \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                               \
//    b12in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(out)>) , .a(<({$bits(out){1'b0}})>)); \
//    b12in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<(out)>));      \
//`elsif SYNTH_B11                                                                                       \
//    wire [$bits(out)-1:0] \``tmp_``out ;                                                               \
//    b11in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(out)>) , .a(<({$bits(out){1'b0}})>)); \
//    b11in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<(out)>));      \
//`elsif SYNTH_B15                                                                                       \
//    b15inv000al1n02x5 \``out``_tieoff_inv_dcszo <$typeof(out)> (.o1(<(out)>) , .a(<({$bits(out){1'b0}})>)); \
//`endif

//`define LIB_BUF_1NS_DELAY_UNGATED(out,in,vcc_in)                                         \
//`ifdef SYNTH_D04                                                                         \
// `ifdef IEEE_COMPLIANT                                                                   \
//    d04dly00wd0b0 \``out``_buf_1ns_dly_dcszo [$bits(out)-1:0] (.o(out) , .a(in) );       \
// `else                                                                                   \
//    d04dly00wd0b0 \``out``_buf_1ns_dly_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(in)>) ); \
// `endif                                                                                  \
//`elsif SYNTH_B12                                                                         \
//    b12dly0wnx10 \``out``_buf_1ns_dly_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(in)>) );  \
//`elsif SYNTH_B11                                                                         \
//    b11dly0wnx10 \``out``_buf_1ns_dly_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(in)>) );  \
//`endif


//++++++++++++++++++++++++++++++`define LIB_lcp_dly_elmt(clklcpdlyout,clklcpdlyin,rsel0lcpdlyin,rsel1lcpdlyin,rsel2lcpdlyin)                                                            \
//`ifdef SYNTH_D04                                                                                                                                        \
//    d04cpk30wd0c0 clklcpdlyout_1_dcszo (.clkout(clklcpdlyout), .clk(clklcpdlyin), .rsel0(rsel0lcpdlyin), .rsel1(rsel1lcpdlyin), .rsel2(rsel2lcpdlyin)); \
//`elsif SYNTH_B12                                                                                                                                        \
//    b12lcp0wnd1 clklcpdlyout_1_dcszo (.ckout(clklcpdlyout), .ck(clklcpdlyin), .rsel0(rsel0lcpdlyin), .rsel1(rsel1lcpdlyin), .rsel2(rsel2lcpdlyin));     \
//`elsif SYNTH_B11                                                                                                                                        \
//    b11lcp0wnd1 clklcpdlyout_1_dcszo (.ckout(clklcpdlyout), .ck(clklcpdlyin), .rsel0(rsel0lcpdlyin), .rsel1(rsel1lcpdlyin), .rsel2(rsel2lcpdlyin));     \
//`endif

//++++++++++++++++++++++++++++++`define LIB_clockdivffreset(ffoutreset, ffinresetb, clockinreset,resetckdivff)                            \
//++++++++++++++++++++++++++++++//`ifdef SYNTH_D04                                                                                          \
//++++++++++++++++++++++++++++++//    d04cdc03ld0c0 ckdiv2ff1 (.clkout(ffoutreset), .d(ffinresetb), .clk(clockinreset), .rb(resetckdivff)); \
//++++++++++++++++++++++++++++++//`elsif SYNTH_B12                                                                                          \
//++++++++++++++++++++++++++++++//    b12ma12wnd3 ckdiv2ff1 (.o(ffoutreset), .db(ffinresetb), .ck(clockinreset), .rb(resetckdivff));        \
//++++++++++++++++++++++++++++++//`elsif SYNTH_B11                                                                                          \
//++++++++++++++++++++++++++++++//    b11ma12wnd3 ckdiv2ff1 (.o(ffoutreset), .db(ffinresetb), .ck(clockinreset), .rb(resetckdivff));        \
//++++++++++++++++++++++++++++++//`endif

//++++++++++++++++++++++++++++++`define LIB_clockdivff(ffout, ffin, clockin)                                      \
//++++++++++++++++++++++++++++++//`ifdef SYNTH_D04                                                                  \
//++++++++++++++++++++++++++++++//    d04cdc03ld0c0 ckdiv2ff1 (.clkout(ffout), .d(ffin), .clk(clockin), .rb(1'b1)); \
//++++++++++++++++++++++++++++++//`elsif SYNTH_B12                                                                  \
//++++++++++++++++++++++++++++++//    b12ma12wnd1 ckdiv2ff1 (.o(ffout), .db(ffin), .ck(clockin), .rb(1'b1));        \
//++++++++++++++++++++++++++++++//`elsif SYNTH_B11                                                                  \
//++++++++++++++++++++++++++++++//    b11ma12wnd1 ckdiv2ff1 (.o(ffout), .db(ffin), .ck(clockin), .rb(1'b1));        \
//++++++++++++++++++++++++++++++//`endif

//mapped -- ctech_lib_clk_inv
`define LIB_clkinv(clkout,clkin)                                 \
    b15cinv00as1n02x5 ctech_lib_clk_inv_dcszo (.clk(clkin), .clkout(clkout));
//`ifdef SYNTH_D04                                                 \
//    d04gin00ld0b0 clkinv1_dcszo (.c``lkout(clkout),.clk(clkin)); \
//`elsif SYNTH_D04_XN                                                 \
//    d04gin00xd0b0 clkinv1_dcszo (.c``lkout(clkout),.clk(clkin)); \
//`elsif SYNTH_B12                                                 \
//    b12ci00wnd0 clkinv1_dcszo (.o(clkout),.ck(clkin));           \
//`elsif SYNTH_TG                                                  \
//   b12in00lnx10tg clkinv1_dcszo (.oehv(clkout),.aehv(clkin));    \
//`elsif SYNTH_B11                                                 \
//    b11ci00wnd0 clkinv1_dcszo (.o(clkout),.ck(clkin));           \
//`elsif SYNTH_B15                                                 \
//    `ifndef B15_PITCH144                                         \
//    b15cinv00an1n16x5 clkinv1_dcszo (.clkout(clkout),.clk(clkin));           \
//    `else                                                        \
//    b15cinv00au1n08x5 clkinv1_dcszo (.clkout(clkout),.clk(clkin));           \
//    `endif                                                                                      \
//`endif

//mapped -- ctech_lib_clk_mux_2to1
`define LIB_clk2to1mux(ckmuxout,ckin1,ckin2,muxselect)                                          \
    b15cmbn22as1n03x5 ctech_lib_clk_mux_2to1_dcszo (.clkout(ckmuxout), .s(muxselect), .clk2(ckin2), .clk1(ckin1));
//`ifdef SYNTH_D04                                                                                \
//    d04gmx22ld0c0  \``ckmuxout``_mux_dcszo (.clkout(ckmuxout), .clk1(ckin1), .clk2(ckin2), .s(muxselect));  \
//`elsif SYNTH_D04_XN  \
//    d04gmx22xd0c0 \``out``_dcszo [$bits(outclk)-1:0] (.clkout(outclk), .clk1(in2), .clk2(in1), .s(sel));           \
//`elsif SYNTH_B12                                                                                \
//    b12cmx2wnd4 ckmux1_dcszo (.o(ckmuxout), .d1(ckin1), .d2(ckin2), .s(muxselect));             \
//`elsif SYNTH_TG                                                                                 \
// wire mux_inv;                                                                                  \
// b12mx12lnx05tg  ckmux1_dcszo (.oehv(mux_inv), .d1ehv(ckin1), .d2ehv(ckin2), .sehv(muxselect)); \
// b12in00lnx10tg  ckmux_inv_dcszo (.oehv(ckmuxout),.aehv(mux_inv));                              \
// `elsif SYNTH_B11                                                                               \
//    b11cmx2wnd4 ckmux1_dcszo (.o(ckmuxout), .d1(ckin1), .d2(ckin2), .s(muxselect));             \
// `elsif SYNTH_B15                                                                               \
//    `ifndef B15_PITCH144                                                                       \
//    b15cmbn22an1n16x5 ckmux1_dcszo (.clkout(ckmuxout), .clk1(ckin1), .clk2(ckin2), .s(muxselect));             \
//    `else                                                                                   \
//    b15cmbn22au1n08x5 ckmux1_dcszo (.clkout(ckmuxout), .clk1(ckin1), .clk2(ckin2), .s(muxselect));             \
//    `endif                                                                                      \
//`endif

//mapped -- ctech_lib_clk_or
`define LIB_clkor(ckoout, ckoin1,ckoin2)                                                    \
    b15corn02as1n02x5 ctech_lib_clk_nor_dcszo1  (.clkout(ckoout),.clk1(ckoin1),.clk2(ckoin2));
//`ifdef SYNTH_D04                                                                            \
//    wire ckooutbar;                                                                         \
//    d04gno02ld0b0 \``ckoout``_ckor1_dcszo (.clkout(ckooutbar),.clk1(ckoin1),.clk2(ckoin2)); \
//    d04gin00ld0b0 \``ckoout``_ckor2_dcszo (.clkout(ckoout), .clk(ckooutbar));               \
//`elsif SYNTH_B12                                                                            \
//    wire ckooutbar;                                                                         \
//    b12cno2wnd1   \``ckoout``_ckor1_dcszo (.o(ckooutbar),.ck1(ckoin1),.ck2(ckoin2));        \
//    b12ci00wnd2   \``ckoout``_ckor2_dcszo (.o(ckoout), .ck(ckooutbar));                     \
//`elsif SYNTH_TG										    \
//    wire ckooutbar;                                                                         \
//    b12no02lnx10tg  \``ckoout``_ckor1_dcszo (.oehv(ckooutbar),.aehv(ckoin1),.behv(ckoin2)); \
//    b12in00lnx10tg  \``ckoout``_i0_dcszo (.oehv(ckoout),.aehv(ckooutbar));                  \
//`elsif SYNTH_B11                                                                            \
//    wire ckooutbar;                                                                         \
//    b11cno2wnd1   \``ckoout``_ckor1_dcszo (.o(ckooutbar),.ck1(ckoin1),.ck2(ckoin2));        \
//    b11ci00wnd2   \``ckoout``_ckor2_dcszo (.o(ckoout), .ck(ckooutbar));                     \
//`endif

//mapped -- ctech_lib_clk_or_en
`define LIB_clkoren(clkorenout,clkorenckin,clkorenenin)                                      \
    b15clb0o2as1n02x5 ctech_lib_clk_or_en_dcszo (.clk(clkorenckin),.enb(clkorenenin),.clkout(clkorenout));
//`ifdef SYNTH_D04                                                                             \
//    wire ckooutbar;                                                                          \
//    d04gno00ld0c0 clkoren1_dcszo (.clkout(ckooutbar),.clk(clkorenckin),.en(clkorenenin));    \
//    d04gin00ld0b0 clkoren2_dcszo (.clkout(clkorenout),.clk(ckooutbar));                      \
//`elsif SYNTH_B12                                                                             \
//    wire ckooutbar;                                                                          \
//    b12cno0wnd1 clkoren1_dcszo (.o(ckooutbar),.ck(clkorenckin),.en(clkorenenin));            \
//    b12ci00wnd0   clkoren2_dcszo (.o(clkorenout),.ck(ckooutbar));                            \
//`elsif SYNTH_TG										     \
//    wire ckooutbar;                                                                          \
//    b12no02lnx10tg  clkoren1_dcszo (.oehv(ckooutbar),.aehv(clkorenckin),.behv(clkorenenin)); \
//    b12in00lnx10tg  clkoren2_dcszo (.oehv(clkorenout),.aehv(ckooutbar));		     \
//`elsif SYNTH_B11                                                                             \
//    wire ckooutbar;                                                                          \
//    b11cno0wnd1 clkoren1_dcszo (.o(ckooutbar),.ck(clkorenckin),.en(clkorenenin));            \
//    b11ci00wnd0   clkoren2_dcszo (.o(clkorenout),.ck(ckooutbar));                            \
//`elsif SYNTH_B15                                                                             \
//    `ifndef B15_PITCH144                                                                       \
//    b15clb0o2an1n16x5 clkoren_dcszo (.clkout(clkorenout),.clk(clkorenckin),.enb(clkorenenin));            \
//    `else                                                                                      \
//    b15clb0o2au1n08x5 clkoren_dcszo (.clkout(clkorenout),.clk(clkorenckin),.enb(clkorenenin));            \
//    `endif                                                                                      \
//`endif

//mapped -- ctech_lib_clk_nor
`define LIB_clknor(ckoout,ckoin1,ckoin2)                                                 \
    logic o1;                                                                               \
    b15corn02as1n02x5  ctech_lib_clk_nor_dcszo1  (.clkout(o1),.clk1(ckoin1),.clk2(ckoin2)); \
    b15cinv00as1n02x5 ctech_lib_clk_nor_dcszo (.clk(o1), .clkout(ckoout));
//`ifdef SYNTH_D04                                                                         \
//    d04gno02ld0b0 \``ckoout``_cknor_dcszo (.clkout(ckoout),.clk1(ckoin1),.clk2(ckoin2)); \
//`elsif SYNTH_D04_XN                                                                         \
//    d04gno02xd0b0 \``o``_cknor_dcszo (.clkout(o),.clk1(ck1),.clk2(ck2));                 \
//`elsif SYNTH_B12                                                                         \
//    b12cno2wnd1  \``ckoout``_cknor_dcszo (.o(ckoout),.ck1(ckoin1),.ck2(ckoin2));         \
//`elsif SYNTH_TG										 \
//   b12no02lnx10tg   \``ckoout``_cknor_dcszo (.oehv(ckoout),.aehv(ckoin1),.behv(ckoin2)); \
//`elsif SYNTH_B11                                                                         \
//    b11cno2wnd1  \``ckoout``_cknor_dcszo (.o(ckoout),.ck1(ckoin1),.ck2(ckoin2));         \
//`elsif SYNTH_B15                                                                         \
//    b15nor002an1n06x5 \``ckoout``_cknor_dcszo (.o1(ckoout),.a(ckoin1),.b(ckoin2)); \
//`endif

//`define LIB_clknoren(clknorenout,clknorenckin,clknorenenin)                                   \
//`ifdef SYNTH_D04                                                                              \
//    d04gno00ld0c0 clkoren1_dcszo (.clkout(clknorenout),.clk(clknorenckin),.en(clknorenenin)); \
//`elsif SYNTH_B12                                                                              \
//    b12cno0wnd1 clkoren1_dcszo (.o(clknorenout),.ck(clknorenckin),.en(clknorenenin));         \
//`elsif SYNTH_B11                                                                              \
//    b11cno0wnd1 clkoren1_dcszo (.o(clknorenout),.ck(clknorenckin),.en(clknorenenin));         \
//`endif

//`define LIB_clkanden(outclk,inclk,enable)                                                                              \
//`ifdef SYNTH_D04                                                                                                       \
// `ifdef IEEE_COMPLIANT                                                                                                 \
//    d04gan00ld0b0 \``clkand_dcszo_``outclk  [$bits(outclk)-1:0] (.clk(inclk), .en(enable), .clkout(outclk));           \
// `else                                                                                                                 \
//    d04gan00ld0b0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.clk(<(inclk)>), .en(<(enable)>), .clkout(<(outclk)>)); \
// `endif                                                                                                                \
//`elsif SYNTH_D04_XN  \
// d04gan00xd0b0 \``clkand_dcszo_``enclk   (.clk(clk), .en(en), .clkout(enclk)); \
//`elsif SYNTH_B12                                                                                                       \
//    b12can0wnd0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));         \
//`elsif SYNTH_B11                                                                                                       \
//    b11can0wnd0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));         \
//`elsif SYNTH_TG                                                                                                        \
// b12an02lnx05tg \``clkand_dcszo_``outclk  <$typeof(outclk)> (.oehv(<(outclk)>),.aehv(<(inclk)>),.behv(<(enable)>));    \
//`endif

//+++++++++++++++++++++++++++++`define LIB_clk16delay(clk16delayout,clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14) \
//+++++++++++++++++++++++++++++//`ifdef SYNTH_D04                                                                                                     \
//+++++++++++++++++++++++++++++//     d04cpkf0wd0c0 clk16delay_dcszo (.clkout(clk16delayout), .clk(clk16delayin),                                     \
//+++++++++++++++++++++++++++++//                                     .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),   .rsel3(clk16in3),   \
//+++++++++++++++++++++++++++++//                                     .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),   .rsel7(clk16in7),   \
//+++++++++++++++++++++++++++++//                                     .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10), .rsel11(clk16in11), \
//+++++++++++++++++++++++++++++//                                     .rsel12(clk16in12), .rsel13(clk16in13), .rsel14(clk16in14));                    \
//+++++++++++++++++++++++++++++//`elsif SYNTH_B12                                                                                                     \
//+++++++++++++++++++++++++++++//     b12dcc0wnd1 clk16delay_dcszo (.o(clk16delayout),  .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),     \
//+++++++++++++++++++++++++++++//                                     .rsel3(clk16in3),   .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),   \
//+++++++++++++++++++++++++++++//                                     .rsel7(clk16in7),   .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10), \
//+++++++++++++++++++++++++++++//                                     .rsel11(clk16in11), .rsel12(clk16in12), .rsel13(clk16in13),                     \
//+++++++++++++++++++++++++++++//                                     .rsel14(clk16in14), .ck(clk16delayin));                                         \
//+++++++++++++++++++++++++++++//`elsif SYNTH_B11                                                                                                     \
//+++++++++++++++++++++++++++++//     b11dcc0wnd1 clk16delay_dcszo (.o(clk16delayout),  .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),     \
//+++++++++++++++++++++++++++++//                                     .rsel3(clk16in3),   .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),   \
//+++++++++++++++++++++++++++++//                                     .rsel7(clk16in7),   .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10), \
//+++++++++++++++++++++++++++++//                                     .rsel11(clk16in11), .rsel12(clk16in12), .rsel13(clk16in13),                     \
//+++++++++++++++++++++++++++++//                                     .rsel14(clk16in14), .ck(clk16delayin));                                         \
//+++++++++++++++++++++++++++++//`endif

//mapped -- ctech_lib_clk_gate_and
`define LIB_soc_rbe_clk(ckrcbxpn,ckgridxpn,latrcben)                                             \
    b15cilb01as1n02x5 ctech_lib_clk_gate_and_dcszo (.clkout(ckrcbxpn), .clk(ckgridxpn), .en(latrcben), .te(1'b0));
//`ifdef SYNTH_D04                                                                                 \
//    //d04cgc01ld0b0 ckrbexpnrcb_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0)); \
//    d04cgc01ld0d0 ckrbexpnrcb_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0)); \
//`elsif SYNTH_B12                                                                                 \
//    b12gb01wcd1 ckrbexpnrcb_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
//`elsif SYNTH_B11                                                                                 \
//    b11gb01wcd1 ckrbexpnrcb_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
//`elsif SYNTH_B15                                                                                 \
//    `ifndef B15_PITCH144                                                                       \
//    b15cilb01an1n16x5 ckrbexpnrcb_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0));     \
//    `else                                                                                      \
//    b15cilb01au1n12x5 ckrbexpnrcb_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0));     \
//    `endif                                                                                      \
// `endif

//`define LIB_soc_rbe_clk_hf(ckrcbxpn,ckgridxpn,latrcben)                                             \
//`ifdef SYNTH_D04                                                                                    \
//    d04cgc01ld0f0 ckrbexpnrcb_hf_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0)); \
//`elsif SYNTH_B12                                                                                    \
//    b12gb01wcd1 ckrbexpnrcb_hf_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
//`elsif SYNTH_B11                                                                                    \
//    b11gb01wcd1 ckrbexpnrcb_hf_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
//`elsif SYNTH_B15                                                                                 \
//    `ifndef B15_PITCH144                                                                       \
//        b15cilb01an1n16x5 ckrbexpnrcb_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0));     \
//    `else                                                                                      \
//        b15cilb01au1n12x5 ckrbexpnrcb_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0));     \
//    `endif                                                                                      \
//`endif

//mapped -- ctech_lib_clk_and_en
`define LIB_SOC_CLKAND(outclk,inclk,enable)                                                                              \
    b15clb0a2as1n02x5 ctech_lib_clk_and_en_dcszo (.clkout(outclk), .clk(inclk), .en(enable));
//`ifdef SYNTH_D04                                                                                                         \
//    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                           \
//    d04gna00ld0b0 \``clknand_dcszo_``outclk [$bits(outclk)-1:0] (.clk(inclk), .en(enable), .clkout(\``tmp_``outclk ));   \
//    d04gin00ld0b0 \``clkinv_dcszo_``outclk [$bits(outclk)-1:0] (.clk(\``tmp_``outclk ), .clkout(outclk));                \
//`elsif SYNTH_D04_XN                                                                                                     \
//    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                   \
//    d04gna00xd0b0 \``clknand_dcszo_``outclk  (.clk(inclk), .en(enable), .clkout(\``tmp_``outclk )); \
//    d04gin00xd0b0 \``clkinv_dcszo_``outclk  (.clk(\``tmp_``outclk ), .clkout(outclk));                  \
//`elsif SYNTH_B12                                                                                                         \
//    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                           \
//    b12cna0wnd0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>)); \
//    b12ci00wnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                  \
//`elsif SYNTH_B11                                                                                                         \
//    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                           \
//    b11cna0wnd0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>)); \
//    b11ci00wnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                  \
//`elsif SYNTH_B15                                                                                 \
//    `ifndef B15_PITCH144                                                                       \
//    b15clb0a2an1n16x5  \``clkand_dcszo_``outclk <$typeof(outclk)> (.clk(<(inclk)>), .en(<(enable)>), .clkout(<(outclk)>)); \
//    `else                                                                                      \
//    b15clb0a2au1n08x5  \``clkand_dcszo_``outclk <$typeof(outclk)> (.clk(<(inclk)>), .en(<(enable)>), .clkout(<(outclk)>)); \
//    `endif                                                                                      \
//`endif

//mapped -- ctech_lib_and
`define LIB_SOC_NONCLKAND(outd,ind1,ind2)                           \
    b15and002as1n02x5 ctech_lib_and_dcszo (.a(ind1), .b(ind2), .o(outd));
//`ifdef SYNTH_D04                                                    \
//    d04ann02wn0a5 \``and_dcszo_``outd (.o(outd),.a(ind1),.b(ind2)); \
//`elsif SYNTH_B12                                                    \
//    b12an02wnx05 \``and_dcszo_``outd (.o(outd),.a(ind1),.b(ind2));  \
//`elsif SYNTH_B11                                                    \
//    b11an02wnx05 \``and_dcszo_``outd (.o(outd),.a(ind1),.b(ind2));  \
//`elsif SYNTH_B15                                                                                 \
//    `ifndef B15_PITCH144                                                                       \
//    b15and002an1n16x5 \``and_dcszo_``outd (.o(outd),.a(ind1),.b(ind2));  \
//    `else                                                                                      \
//    b15and002au1n08x5 \``and_dcszo_``outd (.o(outd),.a(ind1),.b(ind2));  \
//    `endif                                                                                      \
//`endif


//`define LIB_clk_gate_kin(ckrcbxpn1,ckgridxpn1,latrcben1,testen1)                                                \
//`ifdef SYNTH_D04                                                                                                \
//    d04cgc01ld0b0 \``ckrcbxpn1``_rcb_dcszo  (.clkout(ckrcbxpn1),.clk(ckgridxpn1),.en(latrcben1),.te(testen1)); \
//`elsif SYNTH_B12                                                                                                \
//    b12gb01wcd1 \ckrcbcell_ckrcbxpn1_dcszo (.enclk(ckrcbxpn1),.ck(ckgridxpn1),.en(latrcben1),.te(testen1));     \
//`elsif SYNTH_B11                                                                                                \
//    b11gb01wcd1 \ckrcbcell_ckrcbxpn1_dcszo (.enclk(ckrcbxpn1),.ck(ckgridxpn1),.en(latrcben1),.te(testen1));     \
//`endif

////redefine p1273.1 ICG here:
//`define LIB_clk_gate_kin(ckrcbxpn1,ckgridxpn1,latrcben1,testen1)                                                \
//    b15cilb01an1n16x5 \``ckrcbxpn1``_rcb_dcszo (.clkout(ckrcbxpn),.clk(ckgridxpn),.en(latrcben),.te(1'b0));     
////    d04cgc01ld0f0 \``ckrcbxpn1``_rcb_dcszo  (.clkout(ckrcbxpn1),.clk(ckgridxpn1),.en(latrcben1),.te(testen1)); 


`define LIB_CLKBF_SOC(clkbufout,clkbufin)                                      \
    b15cbf000as1n02x5 \``clkbufout``_i0_dcszo (.clk(clkbufin), .clkout(clkbufout));
//`ifdef SYNTH_D04                                                               \
//    d04gbc00ld0e0 \``clkbufout``_i0_dcszo (.clkout(clkbufout),.clk(clkbufin)); \
//`elsif SYNTH_D04_XN                                                               \
//    d04gbc00xd0e0 \``clkbufout``_i0_dcszo (.clkout(clkbufout),.clk(clkbufin)); \
//`elsif SYNTH_B12                                                               \
//    b12cb00wnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));         \
//`elsif SYNTH_B11                                                               \
//    b11cb00wnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));         \
//`elsif SYNTH_B15                                                               \
//    `ifndef B15_PITCH144                                                                       \
//    b15cbf000an1n16x5 \``clkbufout``_i0_dcszo (.clkout(clkbufout),.clk(clkbufin));         \
//    `else                                                                                      \
//    b15cbf000au1n08x5 \``clkbufout``_i0_dcszo (.clkout(clkbufout),.clk(clkbufin));         \
//    `endif                                                                                      \
//`endif


//`define LIB_CLKBF_GLITCH_GLOB(clkout, clkin)                            \
//`ifdef SYNTH_D04                                                        \
//    /* TODO: Find a glitch suppression buffer in d04 library */         \
//    d04cgg00wd0c0 \``clkout``_i0_dcszo (.c``lkout(clkout),.clk(clkin)); \
//`elsif SYNTH_B12                                                        \
//    b12dwcbwnd1 \``clkout``_i0_dcszo (.o(clkout),.ck(clkin));           \
//`elsif SYNTH_B11                                                        \
//    b11dwcbwnd1 \``clkout``_i0_dcszo (.o(clkout),.ck(clkin));           \
//`endif

//mapped -- ctech_lib_clk_inv
`define LIB_CLKINV_SOC(clkinvout,clkinvin)                                     \
    b15cinv00as1n02x5 ctech_lib_clk_inv_dcszo (.clk(clkinvin), .clkout(clkinvout));
//`ifdef SYNTH_D04                                                               \
//    d04gin00ld0b0 \``clkinvout``_i0_dcszo (.clkout(clkinvout),.clk(clkinvin)); \
//`elsif SYNTH_B12                                                               \
//    b12ci00wnd0 \``clkinvout``_i0_dcszo (.o(clkinvout),.ck(clkinvin));         \
//`elsif SYNTH_TG    								                                             \
//   b12in00lnx10tg\``clkinvout``_i0_dcszo (.oehv(clkinvout),.aehv(clkinvin));   \
//`elsif SYNTH_B11                                                               \
//    b11ci00wnd0 \``clkinvout``_i0_dcszo (.o(clkinvout),.ck(clkinvin));         \
//`elsif SYNTH_B15                                                               \
//    `ifndef B15_PITCH144                                                                       \
//        b15cinv00an1n16x5 \``clkinvout``_i0_dcszo (.clkout(clkinvout),.clk(clkinvin));         \
//    `else                                                                                      \
//        b15cinv00au1n08x5 \``clkinvout``_i0_dcszo (.clkout(clkinvout),.clk(clkinvin));         \
//    `endif                                                                                      \
//`endif

//`define LIB_MSFF_NONSCAN(q,i,clock)                                                                        \
//`ifdef SYNTH_D04                                                                                           \
// `ifdef IEEE_COMPLIANT                                                                                     \
//    d04fkn00wd0a5 \``q``_reg_dcszo_nonscan [$bits(q)-1:0] (.o(\``q``_nonscan ), .d(i), .clk(clock));       \
// `else                                                                                                     \
//    d04fkn00wd0a5 \``q``_reg_dcszo_nonscan <$typeof(q)> (.o(<(\``q``_nonscan )>), .d(<(i)>), .clk(clock)); \
// `endif                                                                                                    \
//`elsif SYNTH_B12                                                                                           \
//    b12ms00wnx05 \``q``_reg_dcszo_nonscan <$typeof(q)> (.o(<(\``q``_nonscan )>), .d(<(i)>), .ck(clock));   \
//`elsif SYNTH_B11                                                                                           \
//    b11ms00wnx05 \``q``_reg_dcszo_nonscan <$typeof(q)> (.o(<(\``q``_nonscan )>), .d(<(i)>), .ck(clock));   \
//`endif

//mapped -- ctech_lib_doublesync_rstb
//`define LIB_ASYNC_RST_2MSFF_META(q, i, clk, rstb)                                                                         
`define LIB_ASYNC_RST_2MSFF_META(q, i, clkin, rstb)                                                                         \
    b15fmm203as1n04x5 \``q``_dcszo [$bits(q)-1:0] (.o(q), .d(i), .clk(clkin), .rb(rstb), .ssb(1'b1), .si(1'b0));
//`ifdef SYNTH_D04                                                                                                          \
// `ifdef IEEE_COMPLIANT                                                                                                    \
//    d04hiy23ld0b0  \``q``_dcszo [$bits(q)-1:0] (.o(q), .d(i), .c``lk(clk), .rb(rstb), .so(), .si(1'b0), .ss(1'b0));       \
// `else                                                                                                                    \
//    d04hiy23ld0b0  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .c``lk(clk), .rb(rstb), .so(), .si(1'b0), .ss(1'b0)); \
// `endif                                                                                                                   \
//`elsif SYNTH_B12                                                                                                          \
//    b12mas2wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .rb(rstb), .so(), .si(1'b0), .ss(1'b0));     \
//`elsif SYNTH_B11                                                                                                          \
//    b11mas2wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .rb(rstb), .so(), .si(1'b0), .ss(1'b0));     \
//`elsif SYNTH_B15                                                                                                          \
//    `ifndef B15_PITCH144                                                                       \
//    b15fmy203an1n04x5  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .c``lk(clk), .rb(rstb), .si(1'b0), .ssb(1'b1));     \
//    `else                                                                                      \
//    b15fmy203au1n04x5  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .c``lk(clk), .rb(rstb), .si(1'b0), .ssb(1'b1));     \
//    `endif                                                                                      \
//`endif

//mapped -- ctech_lib_doublesync_setb
`define LIB_ASYNC_SET_2MSFF_META(q, i, clk, ipsb)                                                                          \
    b15fmm20cas1n04x5 ctech_lib_doublesync_setb_dcszo [$bits(q)-1:0] (.o(q), .d(i), .clk(clk), .psb(ipsb), .ssb(1'b1), .si(1'b0));
//`ifdef SYNTH_D04                                                                                                           \
// `ifdef IEEE_COMPLIANT                                                                                                     \
//    d04hiy2cld0c0  \``q``_dcszo [$bits(q)-1:0] (.o(q), .d(i), .c``lk(clk), .psb(ipsb), .so(), .si(1'b0), .ss(1'b0));       \
// `else                                                                                                                     \
//    d04hiy2cld0c0  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .c``lk(clk), .psb(ipsb), .so(), .si(1'b0), .ss(1'b0)); \
// `endif                                                                                                                    \
//`elsif SYNTH_B12                                                                                                           \
//    b12mas1wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .psb(ipsb), .so(), .si(1'b0), .ss(1'b0));     \
//`elsif SYNTH_B11                                                                                                           \
//    b11mas1wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .psb(ipsb), .so(), .si(1'b0), .ss(1'b0));     \
//`elsif SYNTH_B15                                                                                                           \
//    `ifndef B15_PITCH144                                                                       \
//    b15fmy20can1n04x5  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .c``lk(clk), .psb(ipsb), .si(1'b0), .ssb(1'b1));     \
//    `else                                                                                      \
//    b15fmy20cau1n04x5  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .c``lk(clk), .psb(ipsb), .si(1'b0), .ssb(1'b1));     \
//    `endif                                                                                      \
//`endif


//`define LIB_SOC_MSFF_META(q,i,clock)                                                                   \
//`ifdef SYNTH_D04                                                                                       \
//  /* TODO: Find a metastability hardened DFF in D04 library. */                                        \
// `ifdef IEEE_COMPLIANT                                                                                 \
//      //d04fyf03wd0a5 \``q``meta_flop_dcszo [$bits(q)-1:0] (.clk(clock), .d(i), .rb(1'b1), .o(q));       \
//      d04fyn03wd0c0 \``q``meta_flop_dcszo [$bits(q)-1:0] (.clk(clock), .d(i), .rb(1'b1), .o(q));       \
// `else                                                                                                 \
//      //d04fyf03wd0a5 \``q``meta_flop_dcszo <$typeof(q)> (.clk(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>)); \
//      d04fyn03wd0c0 \``q``meta_flop_dcszo <$typeof(q)> (.clk(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>)); \
// `endif                                                                                                \
//`elsif SYNTH_B12                                                                                       \
//    b12fa62wnx10 \``q``meta_flop_dcszo <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>));     \
//`elsif SYNTH_B11                                                                                       \
//    b11fa62wnx10 \``q``meta_flop_dcszo <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>));     \
//`endif

//`define LIB_ASYNC_RST_MSFF_META(q, i, clk, rstb)                                            \
//`ifdef SYNTH_D04                                                                            \
//  /* TODO: Find a metastability hardened DFF in D04 library. */                             \
// `ifdef IEEE_COMPLIANT                                                                      \
//    //d04fyf03wd0a5 \``q``_dcszo [$bits(q)-1:0] (.c``lk(clk), .d(i), .rb(rstb), .o(q));       \
//    d04fyn03wd0c0 \``q``_dcszo [$bits(q)-1:0] (.c``lk(clk), .d(i), .rb(rstb), .o(q));       \
// `else                                                                                      \
//    //d04fyf03wd0a5 \``q``_dcszo <$typeof(q)> (.c``lk(clk), .d(<(i)>), .rb(rstb), .o(<(q)>)); \
//    d04fyn03wd0c0 \``q``_dcszo <$typeof(q)> (.c``lk(clk), .d(<(i)>), .rb(rstb), .o(<(q)>)); \
// `endif                                                                                     \
//`elsif SYNTH_B12                                                                            \
//    b12fa62wnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));     \
//`elsif SYNTH_B11                                                                            \
//    b11fa62wnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));     \
//`elsif SYNTH_B15                                                                            \
//    `ifndef B15_PITCH144                                                                       \
//    b15fqn003an1n06x5 \``q``_dcszo <$typeof(q)> (.clk(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));     \
//    `else                                                                                      \
//    b15fqn003au1n04x5 \``q``_dcszo <$typeof(q)> (.clk(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));     \
//    `endif                                                                                      \
//`endif

//`define LIB_ASYNC_SET_MSFF_META(q, i, clk, set)                                            \
//`ifdef SYNTH_D04                                                                            \
//  /* TODO: Find a metastability hardened DFF in D04 library. */                             \
// `ifdef IEEE_COMPLIANT                                                                      \
//    //d04fyf03wd0a5 \``q``_dcszo [$bits(q)-1:0] (.c``lk(clk), .d(i), .rb(rstb), .o(q));       \
//    d04fyn0cld0e0 \``q``_dcszo [$bits(q)-1:0] (.c``lk(clk), .d(i), .psb(set), .o(q));       \
// `else                                                                                      \
//    //d04fyf03wd0a5 \``q``_dcszo <$typeof(q)> (.c``lk(clk), .d(<(i)>), .psb(rstb), .o(<(q)>)); \
//    d04fyn0cld0e0 \``q``_dcszo [$bits(q)-1:0] (.c``lk(clk), .d(i), .psb(set), .o(q));       \
// `endif                                                                                     \
//`elsif SYNTH_B12                                                                            \
//    b12fa62wnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .psb(set), .o(<(q)>));     \
//`elsif SYNTH_B11                                                                            \
//    b11fa62wnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .psb(set), .o(<(q)>));     \
//`elsif SYNTH_B15                                                                            \
//    `ifndef B15_PITCH144                                                                       \
//    b15fqn00can1n06x5 \``q``_dcszo <$typeof(q)> (.clk(clk), .d(<(i)>), .psb(set), .o(<(q)>));     \
//    `else                                                                                      \
//    b15fqn00cau1n04x5 \``q``_dcszo <$typeof(q)> (.clk(clk), .d(<(i)>), .psb(set), .o(<(q)>));     \
//    `endif                                                                                      \
//`endif

//`define LIB_ASYNC_SET_MSFF_META(q, i, clk, set)                                            \
//`ifdef SYNTH_D04                                                                            \
//  /* TODO: Find a metastability hardened DFF in D04 library. */                             \
// `ifdef IEEE_COMPLIANT                                                                      \
//    //d04fyf03wd0a5 \``q``_dcszo [$bits(q)-1:0] (.c``lk(clk), .d(i), .rb(set), .o(q));       \
//    d04fyn0cld0e0 \``q``_dcszo [$bits(q)-1:0] (.c``lk(clk), .d(i), .psb(set), .o(q));       \
//`endif
//`endif

//`define LIB_NAND_3TO1MUX(out,in1,in2,in3,sel1,sel2,sel3)            \
//`ifdef SYNTH_D04                                                    \
//    wire n1, n2, n3;                                                \
//    d04nan02wn0a5 \``i1_dcszo_``out (.o(n1),.a(in1),.b(sel1));      \
//    d04nan02wn0a5 \``i2_dcszo_``out (.o(n2),.a(in2),.b(sel2));      \
//    d04nan02wn0a5 \``i3_dcszo_``out (.o(n3),.a(in3),.b(sel3));      \
//    d04nan03wn0a3 \``i4_dcszo_``out (.o(out),.a(n1),.b(n2),.c(n3)); \
//`elsif SYNTH_B12                                                    \
//    wire n1;                                                        \
//    wire n2;                                                        \
//    wire n3;                                                        \
//    b12na02wnx05 \``i1_dcszo_``out (.o(n1),.a(in1),.b(sel1));       \
//    b12na02wnx05 \``i2_dcszo_``out (.o(n2),.a(in2),.b(sel2));       \
//    b12na02wnx05 \``i3_dcszo_``out (.o(n3),.a(in3),.b(sel3));       \
//    b12na03wnx05 \``i4_dcszo_``out (.o(out),.a(n1),.b(n2),.c(n3));  \
//`elsif SYNTH_B11                                                    \
//    wire n1;                                                        \
//    wire n2;                                                        \
//    wire n3;                                                        \
//    b11na02wnx05 \``i1_dcszo_``out (.o(n1),.a(in1),.b(sel1));       \
//    b11na02wnx05 \``i2_dcszo_``out (.o(n2),.a(in2),.b(sel2));       \
//    b11na02wnx05 \``i3_dcszo_``out (.o(n3),.a(in3),.b(sel3));       \
//    b11na03wnx05 \``i4_dcszo_``out (.o(out),.a(n1),.b(n2),.c(n3));  \
//`endif

//++++++++++++++++++++++`define LIB_CLK_NAND_3TO1MUX(out,in1,in2,in3,sel1,sel2,sel3)                 \
//++++++++++++++++++++++//`ifdef SYNTH_D04                                                             \
//++++++++++++++++++++++//    wire sel3b, sel2b, sel1b, nor1, nor2, nor3, x1, x2, x3, x4, x4x;         \
//++++++++++++++++++++++//    d04inn00wn0b0 \``i1_dcszo_``out (.o1(sel3b),.a(sel3));                   \
//++++++++++++++++++++++//    d04inn00wn0b0 \``i2_dcszo_``out (.o1(sel2b),.a(sel2));                   \
//++++++++++++++++++++++//    d04inn00wn0b0 \``i3_dcszo_``out (.o1(sel1b),.a(sel1));                   \
//++++++++++++++++++++++//    d04non03wn0a3 \``i4_dcszo_``out (.o1(nor1),.a(sel3b),.b(sel2),.c(sel1)); \
//++++++++++++++++++++++//    d04non03wn0a3 \``i5_dcszo_``out (.o1(nor2),.a(sel3),.b(sel2b),.c(sel1)); \
//++++++++++++++++++++++//    d04non03wn0a3 \``i6_dcszo_``out (.o1(nor3),.a(sel3),.b(sel2),.c(sel1b)); \
//++++++++++++++++++++++//    d04gna00ld0b0 \``i7_dcszo_``out (.clk(in3),.en(nor1),.clkout(x1));       \
//++++++++++++++++++++++//    d04gna00ld0b0 \``i8_dcszo_``out (.clk(in2),.en(nor2),.clkout(x2));       \
//++++++++++++++++++++++//    d04gna00ld0b0 \``i9_dcszo_``out (.clk(in1),.en(nor3),.clkout(x3));       \
//++++++++++++++++++++++//    d04gna02ld0b0 \``i10_dcszo_``out (.clkout(x4x),.clk1(x1),.clk2(x2));     \
//++++++++++++++++++++++//    d04inn00wn0b0 \``i11_dcszo_``out (.o1(x4),.a(x4x));                      \
//++++++++++++++++++++++//    d04gna02ld0b0 \``i12_dcszo_``out (.clkout(out),.clk1(x4),.clk2(x3));     \
//++++++++++++++++++++++//`elsif SYNTH_B12                                                             \
//++++++++++++++++++++++//    wire sel3b;                                                              \
//++++++++++++++++++++++//    wire sel2b;                                                              \
//++++++++++++++++++++++//    wire sel1b;                                                              \
//++++++++++++++++++++++//    wire nor1;                                                               \
//++++++++++++++++++++++//    wire nor2;                                                               \
//++++++++++++++++++++++//    wire nor3;                                                               \
//++++++++++++++++++++++//    wire x1;                                                                 \
//++++++++++++++++++++++//    wire x2;                                                                 \
//++++++++++++++++++++++//    wire x3;                                                                 \
//++++++++++++++++++++++//    wire x4;                                                                 \
//++++++++++++++++++++++//    wire x4x;                                                                \
//++++++++++++++++++++++//    b12in00wnx10 \``i1_dcszo_``out (.o(sel3b),.a(sel3));                     \
//++++++++++++++++++++++//    b12in00wnx10 \``i2_dcszo_``out (.o(sel2b),.a(sel2));                     \
//++++++++++++++++++++++//    b12in00wnx10 \``i3_dcszo_``out (.o(sel1b),.a(sel1));                     \
//++++++++++++++++++++++//    b12no03wnx05 \``i4_dcszo_``out (.o(nor1),.a(sel3b),.b(sel2),.c(sel1));   \
//++++++++++++++++++++++//    b12no03wnx05 \``i5_dcszo_``out (.o(nor2),.a(sel3),.b(sel2b),.c(sel1));   \
//++++++++++++++++++++++//    b12no03wnx05 \``i6_dcszo_``out (.o(nor3),.a(sel3),.b(sel2),.c(sel1b));   \
//++++++++++++++++++++++//    b12cna0wnd0 \``i7_dcszo_``out (.ck(in3),.en(nor1),.o(x1));               \
//++++++++++++++++++++++//    b12cna0wnd0 \``i8_dcszo_``out (.ck(in2),.en(nor2),.o(x2));               \
//++++++++++++++++++++++//    b12cna0wnd0 \``i9_dcszo_``out (.ck(in1),.en(nor3),.o(x3));               \
//++++++++++++++++++++++//    b12cna2wnd2 \``i10_dcszo_``out (.o(x4x),.ck1(x1),.ck2(x2));              \
//++++++++++++++++++++++//    b12in00wnx10 \``i11_dcszo_``out (.o(x4),.a(x4x));                        \
//++++++++++++++++++++++//    b12cna2wnd2 \``i12_dcszo_``out (.o(out),.ck1(x4),.ck2(x3));              \
//++++++++++++++++++++++//`elsif SYNTH_B11                                                             \
//++++++++++++++++++++++//    wire sel3b;                                                              \
//++++++++++++++++++++++//    wire sel2b;                                                              \
//++++++++++++++++++++++//    wire sel1b;                                                              \
//++++++++++++++++++++++//    wire nor1;                                                               \
//++++++++++++++++++++++//    wire nor2;                                                               \
//++++++++++++++++++++++//    wire nor3;                                                               \
//++++++++++++++++++++++//    wire x1;                                                                 \
//++++++++++++++++++++++//    wire x2;                                                                 \
//++++++++++++++++++++++//    wire x3;                                                                 \
//++++++++++++++++++++++//    wire x4;                                                                 \
//++++++++++++++++++++++//    wire x4x;                                                                \
//++++++++++++++++++++++//    b11in00wnx10 \``i1_dcszo_``out (.o(sel3b),.a(sel3));                     \
//++++++++++++++++++++++//    b11in00wnx10 \``i2_dcszo_``out (.o(sel2b),.a(sel2));                     \
//++++++++++++++++++++++//    b11in00wnx10 \``i3_dcszo_``out (.o(sel1b),.a(sel1));                     \
//++++++++++++++++++++++//    b11no03wnx05 \``i4_dcszo_``out (.o(nor1),.a(sel3b),.b(sel2),.c(sel1));   \
//++++++++++++++++++++++//    b11no03wnx05 \``i5_dcszo_``out (.o(nor2),.a(sel3),.b(sel2b),.c(sel1));   \
//++++++++++++++++++++++//    b11no03wnx05 \``i6_dcszo_``out (.o(nor3),.a(sel3),.b(sel2),.c(sel1b));   \
//++++++++++++++++++++++//    b11cna0wnd0 \``i7_dcszo_``out (.ck(in3),.en(nor1),.o(x1));               \
//++++++++++++++++++++++//    b11cna0wnd0 \``i8_dcszo_``out (.ck(in2),.en(nor2),.o(x2));               \
//++++++++++++++++++++++//    b11cna0wnd0 \``i9_dcszo_``out (.ck(in1),.en(nor3),.o(x3));               \
//++++++++++++++++++++++//    b11cna2wnd2 \``i10_dcszo_``out (.o(x4x),.ck1(x1),.ck2(x2));              \
//++++++++++++++++++++++//    b11in00wnx10 \``i11_dcszo_``out (.o(x4),.a(x4x));                        \
//++++++++++++++++++++++//    b11cna2wnd2 \``i12_dcszo_``out (.o(out),.ck1(x4),.ck2(x3));              \
//++++++++++++++++++++++//`endif

//++++++++++++++++++++++`define LIB_GCLATCHEN(gcenclkout,gcenin,gctein,gcclrbin,gcckin)                                                          \
//++++++++++++++++++++++//`ifdef SYNTH_D04                                                                                                         \
//++++++++++++++++++++++//    //d04cgc02wd0d0 \ckgclatchen_dcszo (.clkout(gcenclkout),.clk(gcckin),.en(gcenin),.te(gctein),.rb(gcclrbin),.ss(1'b0)); \
//++++++++++++++++++++++//    d04cgc02ld0d0 \ckgclatchen_dcszo (.clkout(gcenclkout),.clk(gcckin),.en(gcenin),.te(gctein),.rb(gcclrbin),.ss(1'b0)); \
//++++++++++++++++++++++//`elsif SYNTH_B12                                                                                                         \
//++++++++++++++++++++++//    b12db02wnd2 \ckgclatchen_dcszo (.enclk(gcenclkout),.ck(gcckin),.en(gcenin),.te(gctein),.rb(gcclrbin),.ss(1'b0));     \
//++++++++++++++++++++++//`elsif SYNTH_B11                                                                                                         \
//++++++++++++++++++++++    b11db02wnd2 \ckgclatchen_dcszo (.enclk(gcenclkout),.ck(gcckin),.en(gcenin),.te(gctein),.rb(gcclrbin),.ss(1'b0));     \
//++++++++++++++++++++++//`endif

//mapped -- ctech_lib_mux_2to1
`define LIB_MUX_2TO1_HF(out,in1,in2,sel)                                                            \
    b15mbn022as1n03x5 ctech_lib_mux_2to1_dcszo (.a(in1), .b(in2), .sa(sel), .o(out));
//`ifdef SYNTH_D04                                                                                    \
// `ifdef IEEE_COMPLIANT                                                                              \
//    d04mbn22wn0c0 \``out``_dcszo [$bits(out)-1:0] (.o(out), .d1(in1), .d2(in2), .s(sel));           \
// `else                                                                                              \
//    d04mbn22wn0c0 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel)); \
// `endif                                                                                             \
//`elsif SYNTH_B12                                                                                    \
//    b12mx22wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));  \
//`elsif SYNTH_B11                                                                                    \
//    b11mx22wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));  \
//`elsif SYNTH_B15                                                                                    \
//    `ifndef B15_PITCH144                                                                       \
//    b15mbn022an1n06x5 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .a(<(in1)>), .b(<(in2)>), .sa(sel));  \
//    `else                                                                                      \
//    b15mbn022au1n08x5 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .a(<(in1)>), .b(<(in2)>), .sa(sel));  \
//    `endif                                                                                      \
//`endif

//`define LIB_MUX_2TO1_INV_HF(out,in1,in2,sel)                                                        \
//`ifdef SYNTH_D04                                                                                    \
// `ifdef IEEE_COMPLIANT                                                                              \
//    d04mdn22wn0c0 \``out``_dcszo [$bits(out)-1:0] (.o1(out), .a(in1), .b(in2), .sa(sel));           \
// `else                                                                                              \
//    d04mdn22wn0c0 \``out``_dcszo <$typeof(out)> (.o1(<(out)>), .a(<(in1)>), .b(<(in2)>), .sa(sel)); \
// `endif                                                                                             \
//`elsif SYNTH_B12                                                                                    \
//    b12mx12wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));  \
//`elsif SYNTH_B11                                                                                    \
//    b11mx12wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));  \
//`elsif SYNTH_B15                                                                                    \
//    `ifndef B15_PITCH144                                                                       \
//    b15mdn022an1n08x5 \``out``_dcszo <$typeof(out)> (.o1(<(out)>), .a(<(in1)>), .b(<(in2)>), .sa(sel));  \
//    `else                                                                                      \
//    b15mdn022au1n08x5 \``out``_dcszo <$typeof(out)> (.o1(<(out)>), .a(<(in1)>), .b(<(in2)>), .sa(sel));  \
//    `endif                                                                                      \
//`endif

//++++++++++++++++++++++++++////Using CLKGATE, CLKOREN for implementation of clk_glitchfree_mux
//++++++++++++++++++++++++++//`define LIB_clk_glitchfree_mux_part(clk_out, clk_a, clk_b, sel_a, sel_b)                                   \
//++++++++++++++++++++++++++//`ifdef SYNTH_D04                                                                                   \
//++++++++++++++++++++++++++//      d04cgm22ld0b0 \``out``_dcszo (.clk1(clk_a), .clk2(clk_b), .sa(sel_a), .sb(sel_b), .clkout(clk_out)); \
//++++++++++++++++++++++++++//`elsif SYNTH_B12                                                                                   \
//++++++++++++++++++++++++++//      b12gm22wnd0 \``out``_dcszo (.cka(clk_a), .ckb(clk_b), .sa(sel_a), .sb(sel_b), .o(clk_out));          \
//++++++++++++++++++++++++++//`elsif SYNTH_B11                                                                                   \
//++++++++++++++++++++++++++//      b11gm22wnd0 \``out``_dcszo (.cka(clk_a), .ckb(clk_b), .sa(sel_a), .sb(sel_b), .o(clk_out));          \
//++++++++++++++++++++++++++//`elsif SYNTH_B15                                                                                   \
//++++++++++++++++++++++++++//    `ifndef B15_PITCH144                                                                       \
//++++++++++++++++++++++++++//      wire clka_sela ;                                                                           \
//++++++++++++++++++++++++++//      wire clkb_selb ;                                                                           \
//++++++++++++++++++++++++++//      b15cilb01an1n16x5 \``clk_a``_rcb_dcszo (.clkout(clka_sela),.clk(clk_a),.en(sel_a),.te(1'b0)); \
//++++++++++++++++++++++++++//      b15cilb01an1n16x5 \``clk_b``_rcb_dcszo (.clkout(clkb_selb),.clk(clk_b),.en(sel_b),.te(1'b0)); \
//++++++++++++++++++++++++++//      b15orn002an1n16x5 \``clkor1``_dcszo (.o(clk_out),.a(clka_sela),.b(clkb_selb));            \
//++++++++++++++++++++++++++//    `else                                                                                      \
//++++++++++++++++++++++++++//      wire clka_sela ;                                                                           \
//++++++++++++++++++++++++++//      wire clkb_selb ;                                                                           \
//++++++++++++++++++++++++++//      b15cilb01au1n12x5 \``clk_a``_rcb_dcszo (.clkout(clka_sela),.clk(clk_a),.en(sel_a),.te(1'b0)); \
//++++++++++++++++++++++++++//      b15cilb01au1n12x5 \``clk_b``_rcb_dcszo (.clkout(clkb_selb),.clk(clk_b),.en(sel_b),.te(1'b0)); \
//++++++++++++++++++++++++++//      b15clb0o2au1n08x5 \``clkor1``_dcszo (.clkout(clk_out),.clk(clka_sela),.enb(clkb_selb));            \
//++++++++++++++++++++++++++//    `endif                                                                                      \
//++++++++++++++++++++++++++//`endif

//`define LIB_compare_6_bit(out, in1, in2)                                                         \
//`ifdef SYNTH_D04                                                                                 \
//   wire [5:0] comp1 ;                                                                            \
//   wire [1:0] comp2 ;                                                                            \
// `ifdef IEEE_COMPLIANT                                                                           \
//   d04xnn02wn0a5 \``comp_dcszo_``out [$bits(comp1)-1:0] (.o(comp1), .a(in1), .b(in2));           \
// `else                                                                                           \
//   d04xnn02wn0a5 \``comp_dcszo_``out <$typeof(comp1)> (.o(<(comp1)>), .a(<(in1)>), .b(<(in2)>)); \
// `endif                                                                                          \
//   d04nan03wn0d0 \``comp1_dcszo_``out (.o(comp2[0]), .a(comp1[0]), .b(comp1[1]), .c(comp1[2]));  \
//   d04nan03wn0d0 \``comp2_dcszo_``out (.o(comp2[1]), .a(comp1[3]), .b(comp1[4]), .c(comp1[5]));  \
//   d04non02wn0c0 \``comp3_dcszo_``out (.o(out), .a(comp2[0]), .b(comp2[1]));                     \
//`elsif SYNTH_B12                                                                                 \
//   wire [5:0] comp1 ;                                                                            \
//   wire [1:0] comp2 ;                                                                            \
//   b12xn00wnx05 \``comp_dcszo_``out <$typeof(comp1)> (.o(<(comp1)>), .a(<(in1)>), .b(<(in2)>));  \
//   b12na03wnx50 \``comp1_dcszo_``out (.o(comp2[0]), .a(comp1[0]), .b(comp1[1]), .c(comp1[2]));   \
//   b12na03wnx50 \``comp2_dcszo_``out (.o(comp2[1]), .a(comp1[3]), .b(comp1[4]), .c(comp1[5]));   \
//   b12no02wnx30 \``comp3_dcszo_``out (.o(out), .a(comp2[0]), .b(comp2[1]));                      \
//`elsif SYNTH_B11                                                                                 \
//   wire [5:0] comp1 ;                                                                            \
//   wire [1:0] comp2 ;                                                                            \
//   b11xn00wnx05 \``comp_dcszo_``out <$typeof(comp1)> (.o(<(comp1)>), .a(<(in1)>), .b(<(in2)>));  \
//   b11na03wnx50 \``comp1_dcszo_``out (.o(comp2[0]), .a(comp1[0]), .b(comp1[1]), .c(comp1[2]));   \
//   b11na03wnx50 \``comp2_dcszo_``out (.o(comp2[1]), .a(comp1[3]), .b(comp1[4]), .c(comp1[5]));   \
//   b11no02wnx30 \``comp3_dcszo_``out (.o(out), .a(comp2[0]), .b(comp2[1]));                      \
//`endif

//mapped -- ctech_lib_clk_nand_en
`define LIB_clknanen(outclk,inclk,enable)                                                                                \
    logic o1;                                                                                                            \
    b15clb0a2as1n02x5 ctech_lib_clk_nand_en_dcszo1 (.clk(inclk),.en(enable),.clkout(o1));                                \
    b15cinv00as1n02x5 ctech_lib_clk_nand_en_dcszo2 (.clk(o1), .clkout(outclk));
//`ifdef SYNTH_D04                                                                                                         \
// `ifdef IEEE_COMPLIANT                                                                                                   \
//    d04gna00ld0b0 \``clknand_dcszo_``outclk  [$bits(outclk)-1:0] (.clk(inclk), .en(enable), .clkout(outclk));            \
// `else                                                                                                                   \
//    d04gna00ld0b0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.clk(<(inclk)>), .en(<(enable)>), .clkout(<(outclk)>));  \
// `endif                                                                                                                  \
//`elsif SYNTH_B12                                                                                                         \
//    b12cna0wnd0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));          \
//`elsif SYNTH_TG														 \
//   b12na02lnx10tg \``clknand_dcszo_``outclk  <$typeof(outclk)> (.aehv(<(inclk)>), .behv(<(enable)>), .oehv(<(outclk)>)); \
//`elsif SYNTH_B11                                                                                                         \
//    b11cna0wnd0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));          \
//`elsif SYNTH_B15                                                                                                         \
//    `ifndef B15_PITCH144                                                                       \
//    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                           \
//    b15clb0a2an1n08x5 \``clkand_dcszo_``outclk [$bits(outclk)-1:0] (.clk(inclk), .en(enable), .clkout(\``tmp_``outclk ));   \
//    b15cinv00an1n08x5 \``clkinv_dcszo_``outclk [$bits(outclk)-1:0] (.clk(\``tmp_``outclk ), .clkout(outclk));                \
//    `else                                                                                      \
//    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                           \
//    b15clb0a2au1n08x5 \``clkand_dcszo_``outclk [$bits(outclk)-1:0] (.clk(inclk), .en(enable), .clkout(\``tmp_``outclk ));   \
//    b15cinv00au1n08x5 \``clkinv_dcszo_``outclk [$bits(outclk)-1:0] (.clk(\``tmp_``outclk ), .clkout(outclk));                \
//    `endif                                                                                      \
//`endif

//mapped -- ctech_lib_clk_nand
`define LIB_clknan(outclk,inclk,inclk2)                                                                                    \
    logic o1;                                                                                                              \
    b15cand02as1n02x5 ctech_lib_clk_nand_dcszo1 (.clkout(o1),.clk1(inclk),.clk2(inclk2));                                  \
    b15cinv00as1n02x5 ctech_lib_clk_nand_dcszo (.clk(o1), .clkout(outclk));
//`ifdef SYNTH_D04                                                                                                           \
// `ifdef IEEE_COMPLIANT                                                                                                     \
//    d04gna02ld0b0 \``clknand_dcszo_``outclk  [$bits(outclk)-1:0] (.clk1(inclk), .clk2(inclk2), .clkout(outclk));           \
// `else                                                                                                                     \
//    d04gna02ld0b0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.clk1(<(inclk)>), .clk2(<(inclk2)>), .clkout(<(outclk)>)); \
// `endif                                                                                                                    \
//`elsif SYNTH_B12                                                                                                           \
//    b12cna2wnd2 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck1(<(inclk)>), .ck2(<(inclk2)>), .o(<(outclk)>));          \
//`elsif SYNTH_B11                                                                                                           \
//    b11cna2wnd2 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck1(<(inclk)>), .ck2(<(inclk2)>), .o(<(outclk)>));          \
//`endif


//Adding this macro after approval from Raboul. 
//Email notes from Quddus, Wasim: We need a MACRO to instantiate LS going from rtc_well to sus_well.
//I talked with Rabiul, he suggested to use a different name, i.e. LS_WITH_NO_FW_TG.
//We want the b12sirblnx20tg cell to implement the LS from TG library.

//`define LIB_LS_WITH_NO_FW_TG(mo, mpro, ma, mvccin)                                                    \
//`ifdef SYNTH_TG                                                                                       \
//    b12siamlnx05tg \``mo``_ls_out_dcszo <$typeof(mo)> (.aehv(<(ma)>), .enehv(<(ma)>), .oehv(<(mo)>)); \
//`endif

//`define LIB_TG_CLKBF_SOC(clkbufout,clkbufin)                                   \
//`ifdef SYNTH_TG                                                                \
//  b12cb00lnd1tg   \``clkbufout``_i0_dcszo (.oehv(clkbufout),.ckehv(clkbufin)); \
//`endif

//mapped -- ctech_lib_inv
`define LIB_INV_SOC(o1,a)                                   \
    b15inv000as1n02x5 ctech_lib_inv_dcszo (.a(a), .o1(o1));

`endif // ifndef __vlv_macro_tech_map__vh
