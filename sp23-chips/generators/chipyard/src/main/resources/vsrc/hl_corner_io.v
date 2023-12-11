module hl_corner_io (
   dq, drv0, drv1, drv2, enabq, enq, outi, pad, pd, ppen, prg_slew, puq, pwrup_pull_en, pwrupzhl);
   input [9:0] dq;
   input [9:0] drv0;
   input [9:0] drv1;
   input [9:0] drv2;
   input [9:0] enabq;
   input [9:0] enq;
   output [9:0] outi;
   inout [9:0] pad;
   input [9:0] pd;
   input [9:0] ppen;
   input [9:0] prg_slew;
   input [9:0] puq;
   input [9:0] pwrup_pull_en;
   input [9:0] pwrupzhl;
   hl_corner_io_family i11 (.b_ana_io_1v2_signal1(b_ana_io_1v2_signal1), .b_ana_io_1v2_signal10(b_ana_io_1v2_signal10), .b_ana_io_1v2_signal2(b_ana_io_1v2_signal2), .b_ana_io_1v2_signal3(b_ana_io_1v2_signal3), .b_ana_io_1v2_signal4(b_ana_io_1v2_signal4), .b_ana_io_1v2_signal5(b_ana_io_1v2_signal5), .b_ana_io_1v2_signal6(b_ana_io_1v2_signal6), .b_ana_io_1v2_signal7(b_ana_io_1v2_signal7), .b_ana_io_1v2_signal8(b_ana_io_1v2_signal8), .b_ana_io_1v2_signal9(b_ana_io_1v2_signal9), .b_pad_signal1(pad[0]), .b_pad_signal10(pad[9]), .b_pad_signal2(pad[1]), .b_pad_signal3(pad[2]), .b_pad_signal4(pad[3]), .b_pad_signal5(pad[4]), .b_pad_signal6(pad[5]), .b_pad_signal7(pad[6]), .b_pad_signal8(pad[7]), .b_pad_signal9(pad[8]), .i_dq_signal1(dq[0]), .i_dq_signal10(dq[9]), .i_dq_signal2(dq[1]), .i_dq_signal3(dq[2]), .i_dq_signal4(dq[3]), .i_dq_signal5(dq[4]), .i_dq_signal6(dq[5]), .i_dq_signal7(dq[6]), .i_dq_signal8(dq[7]), .i_dq_signal9(dq[8]), .i_drv0_signal1(drv0[0]), .i_drv0_signal10(drv0[9]), .i_drv0_signal2(drv0[1]), .i_drv0_signal3(drv0[2]), .i_drv0_signal4(drv0[3]), .i_drv0_signal5(drv0[4]), .i_drv0_signal6(drv0[5]), .i_drv0_signal7(drv0[6]), .i_drv0_signal8(drv0[7]), .i_drv0_signal9(drv0[8]), .i_drv1_signal1(drv1[0]), .i_drv1_signal10(drv1[9]), .i_drv1_signal2(drv1[1]), .i_drv1_signal3(drv1[2]), .i_drv1_signal4(drv1[3]), .i_drv1_signal5(drv1[4]), .i_drv1_signal6(drv1[5]), .i_drv1_signal7(drv1[6]), .i_drv1_signal8(drv1[7]), .i_drv1_signal9(drv1[8]), .i_drv2_signal1(drv2[0]), .i_drv2_signal10(drv2[9]), .i_drv2_signal2(drv2[1]), .i_drv2_signal3(drv2[2]), .i_drv2_signal4(drv2[3]), .i_drv2_signal5(drv2[4]), .i_drv2_signal6(drv2[5]), .i_drv2_signal7(drv2[6]), .i_drv2_signal8(drv2[7]), .i_drv2_signal9(drv2[8]), .i_enabq_signal1(enabq[0]), .i_enabq_signal10(enabq[9]), .i_enabq_signal2(enabq[1]), .i_enabq_signal3(enabq[2]), .i_enabq_signal4(enabq[3]), .i_enabq_signal5(enabq[4]), .i_enabq_signal6(enabq[5]), .i_enabq_signal7(enabq[6]), .i_enabq_signal8(enabq[7]), .i_enabq_signal9(enabq[8]), .i_enq_signal1(enq[0]), .i_enq_signal10(enq[9]), .i_enq_signal2(enq[1]), .i_enq_signal3(enq[2]), .i_enq_signal4(enq[3]), .i_enq_signal5(enq[4]), .i_enq_signal6(enq[5]), .i_enq_signal7(enq[6]), .i_enq_signal8(enq[7]), .i_enq_signal9(enq[8]), .i_pd_signal1(pd[0]), .i_pd_signal10(pd[9]), .i_pd_signal2(pd[1]), .i_pd_signal3(pd[2]), .i_pd_signal4(pd[3]), .i_pd_signal5(pd[4]), .i_pd_signal6(pd[5]), .i_pd_signal7(pd[6]), .i_pd_signal8(pd[7]), .i_pd_signal9(pd[8]), .i_ppen_signal1(ppen[0]), .i_ppen_signal10(ppen[9]), .i_ppen_signal2(ppen[1]), .i_ppen_signal3(ppen[2]), .i_ppen_signal4(ppen[3]), .i_ppen_signal5(ppen[4]), .i_ppen_signal6(ppen[5]), .i_ppen_signal7(ppen[6]), .i_ppen_signal8(ppen[7]), .i_ppen_signal9(ppen[8]), .i_prg_slew_signal1(prg_slew[0]), .i_prg_slew_signal10(prg_slew[9]), .i_prg_slew_signal2(prg_slew[1]), .i_prg_slew_signal3(prg_slew[2]), .i_prg_slew_signal4(prg_slew[3]), .i_prg_slew_signal5(prg_slew[4]), .i_prg_slew_signal6(prg_slew[5]), .i_prg_slew_signal7(prg_slew[6]), .i_prg_slew_signal8(prg_slew[7]), .i_prg_slew_signal9(prg_slew[8]), .i_puq_signal1(puq[0]), .i_puq_signal10(puq[9]), .i_puq_signal2(puq[1]), .i_puq_signal3(puq[2]), .i_puq_signal4(puq[3]), .i_puq_signal5(puq[4]), .i_puq_signal6(puq[5]), .i_puq_signal7(puq[6]), .i_puq_signal8(puq[7]), .i_puq_signal9(puq[8]), .i_pwrup_pull_en_signal1(pwrup_pull_en[0]), .i_pwrup_pull_en_signal10(pwrup_pull_en[9]), .i_pwrup_pull_en_signal2(pwrup_pull_en[1]), .i_pwrup_pull_en_signal3(pwrup_pull_en[2]), .i_pwrup_pull_en_signal4(pwrup_pull_en[3]), .i_pwrup_pull_en_signal5(pwrup_pull_en[4]), .i_pwrup_pull_en_signal6(pwrup_pull_en[5]), .i_pwrup_pull_en_signal7(pwrup_pull_en[6]), .i_pwrup_pull_en_signal8(pwrup_pull_en[7]), .i_pwrup_pull_en_signal9(pwrup_pull_en[8]), .i_pwrupzhl_signal1(pwrupzhl[0]), .i_pwrupzhl_signal10(pwrupzhl[9]), .i_pwrupzhl_signal2(pwrupzhl[1]), .i_pwrupzhl_signal3(pwrupzhl[2]), .i_pwrupzhl_signal4(pwrupzhl[3]), .i_pwrupzhl_signal5(pwrupzhl[4]), .i_pwrupzhl_signal6(pwrupzhl[5]), .i_pwrupzhl_signal7(pwrupzhl[6]), .i_pwrupzhl_signal8(pwrupzhl[7]), .i_pwrupzhl_signal9(pwrupzhl[8]), .o_outi_1v2_signal1(o_outi_1v2_signal1), .o_outi_1v2_signal10(o_outi_1v2_signal10), .o_outi_1v2_signal2(o_outi_1v2_signal2), .o_outi_1v2_signal3(o_outi_1v2_signal3), .o_outi_1v2_signal4(o_outi_1v2_signal4), .o_outi_1v2_signal5(o_outi_1v2_signal5), .o_outi_1v2_signal6(o_outi_1v2_signal6), .o_outi_1v2_signal7(o_outi_1v2_signal7), .o_outi_1v2_signal8(o_outi_1v2_signal8), .o_outi_1v2_signal9(o_outi_1v2_signal9), .o_outi_signal1(outi[0]), .o_outi_signal10(outi[9]), .o_outi_signal2(outi[1]), .o_outi_signal3(outi[2]), .o_outi_signal4(outi[3]), .o_outi_signal5(outi[4]), .o_outi_signal6(outi[5]), .o_outi_signal7(outi[6]), .o_outi_signal8(outi[7]), .o_outi_signal9(outi[8]));
   //b15inv000an1n02x5 inn0 (.a(1'b0), .o1(tieh));
   //b15bfn000an1n02x5 inn1 (.a(1'b0), .o(tiel));
endmodule
//#################################################################
//# Cell           : hl_corner_io_family
//# Generated by   : IIA : A Family Level Netlister 
//# Configuration  : generated  based on config file : /nfs/pdx/disks/or_lhdk22_disk0033/w133/wc2ctrx/srkale/htl_fp/run_preroute/hl_corner_io_icc2.cfg
//# Netlisted on   : Tue Nov 29 13:58:42 PST 2022
//# Netlisted by   : srkale
//#################################################################

 module hl_corner_io_family (
  b_ana_io_1v2_signal1,
  b_ana_io_1v2_signal10,
  b_ana_io_1v2_signal2,
  b_ana_io_1v2_signal3,
  b_ana_io_1v2_signal4,
  b_ana_io_1v2_signal5,
  b_ana_io_1v2_signal6,
  b_ana_io_1v2_signal7,
  b_ana_io_1v2_signal8,
  b_ana_io_1v2_signal9,
  b_pad_signal1,
  b_pad_signal10,
  b_pad_signal2,
  b_pad_signal3,
  b_pad_signal4,
  b_pad_signal5,
  b_pad_signal6,
  b_pad_signal7,
  b_pad_signal8,
  b_pad_signal9,
  i_dq_signal1,
  i_dq_signal10,
  i_dq_signal2,
  i_dq_signal3,
  i_dq_signal4,
  i_dq_signal5,
  i_dq_signal6,
  i_dq_signal7,
  i_dq_signal8,
  i_dq_signal9,
  i_drv0_signal1,
  i_drv0_signal10,
  i_drv0_signal2,
  i_drv0_signal3,
  i_drv0_signal4,
  i_drv0_signal5,
  i_drv0_signal6,
  i_drv0_signal7,
  i_drv0_signal8,
  i_drv0_signal9,
  i_drv1_signal1,
  i_drv1_signal10,
  i_drv1_signal2,
  i_drv1_signal3,
  i_drv1_signal4,
  i_drv1_signal5,
  i_drv1_signal6,
  i_drv1_signal7,
  i_drv1_signal8,
  i_drv1_signal9,
  i_drv2_signal1,
  i_drv2_signal10,
  i_drv2_signal2,
  i_drv2_signal3,
  i_drv2_signal4,
  i_drv2_signal5,
  i_drv2_signal6,
  i_drv2_signal7,
  i_drv2_signal8,
  i_drv2_signal9,
  i_enabq_signal1,
  i_enabq_signal10,
  i_enabq_signal2,
  i_enabq_signal3,
  i_enabq_signal4,
  i_enabq_signal5,
  i_enabq_signal6,
  i_enabq_signal7,
  i_enabq_signal8,
  i_enabq_signal9,
  i_enq_signal1,
  i_enq_signal10,
  i_enq_signal2,
  i_enq_signal3,
  i_enq_signal4,
  i_enq_signal5,
  i_enq_signal6,
  i_enq_signal7,
  i_enq_signal8,
  i_enq_signal9,
  i_pd_signal1,
  i_pd_signal10,
  i_pd_signal2,
  i_pd_signal3,
  i_pd_signal4,
  i_pd_signal5,
  i_pd_signal6,
  i_pd_signal7,
  i_pd_signal8,
  i_pd_signal9,
  i_ppen_signal1,
  i_ppen_signal10,
  i_ppen_signal2,
  i_ppen_signal3,
  i_ppen_signal4,
  i_ppen_signal5,
  i_ppen_signal6,
  i_ppen_signal7,
  i_ppen_signal8,
  i_ppen_signal9,
  i_prg_slew_signal1,
  i_prg_slew_signal10,
  i_prg_slew_signal2,
  i_prg_slew_signal3,
  i_prg_slew_signal4,
  i_prg_slew_signal5,
  i_prg_slew_signal6,
  i_prg_slew_signal7,
  i_prg_slew_signal8,
  i_prg_slew_signal9,
  i_puq_signal1,
  i_puq_signal10,
  i_puq_signal2,
  i_puq_signal3,
  i_puq_signal4,
  i_puq_signal5,
  i_puq_signal6,
  i_puq_signal7,
  i_puq_signal8,
  i_puq_signal9,
  i_pwrup_pull_en_signal1,
  i_pwrup_pull_en_signal10,
  i_pwrup_pull_en_signal2,
  i_pwrup_pull_en_signal3,
  i_pwrup_pull_en_signal4,
  i_pwrup_pull_en_signal5,
  i_pwrup_pull_en_signal6,
  i_pwrup_pull_en_signal7,
  i_pwrup_pull_en_signal8,
  i_pwrup_pull_en_signal9,
  i_pwrupzhl_signal1,
  i_pwrupzhl_signal10,
  i_pwrupzhl_signal2,
  i_pwrupzhl_signal3,
  i_pwrupzhl_signal4,
  i_pwrupzhl_signal5,
  i_pwrupzhl_signal6,
  i_pwrupzhl_signal7,
  i_pwrupzhl_signal8,
  i_pwrupzhl_signal9,
  o_outi_1v2_signal1,
  o_outi_1v2_signal10,
  o_outi_1v2_signal2,
  o_outi_1v2_signal3,
  o_outi_1v2_signal4,
  o_outi_1v2_signal5,
  o_outi_1v2_signal6,
  o_outi_1v2_signal7,
  o_outi_1v2_signal8,
  o_outi_1v2_signal9,
  o_outi_signal1,
  o_outi_signal10,
  o_outi_signal2,
  o_outi_signal3,
  o_outi_signal4,
  o_outi_signal5,
  o_outi_signal6,
  o_outi_signal7,
  o_outi_signal8,
  o_outi_signal9
 );

  inout b_ana_io_1v2_signal1;
  inout b_ana_io_1v2_signal10;
  inout b_ana_io_1v2_signal2;
  inout b_ana_io_1v2_signal3;
  inout b_ana_io_1v2_signal4;
  inout b_ana_io_1v2_signal5;
  inout b_ana_io_1v2_signal6;
  inout b_ana_io_1v2_signal7;
  inout b_ana_io_1v2_signal8;
  inout b_ana_io_1v2_signal9;
  inout b_pad_signal1;
  inout b_pad_signal10;
  inout b_pad_signal2;
  inout b_pad_signal3;
  inout b_pad_signal4;
  inout b_pad_signal5;
  inout b_pad_signal6;
  inout b_pad_signal7;
  inout b_pad_signal8;
  inout b_pad_signal9;
  input i_dq_signal1;
  input i_dq_signal10;
  input i_dq_signal2;
  input i_dq_signal3;
  input i_dq_signal4;
  input i_dq_signal5;
  input i_dq_signal6;
  input i_dq_signal7;
  input i_dq_signal8;
  input i_dq_signal9;
  input i_drv0_signal1;
  input i_drv0_signal10;
  input i_drv0_signal2;
  input i_drv0_signal3;
  input i_drv0_signal4;
  input i_drv0_signal5;
  input i_drv0_signal6;
  input i_drv0_signal7;
  input i_drv0_signal8;
  input i_drv0_signal9;
  input i_drv1_signal1;
  input i_drv1_signal10;
  input i_drv1_signal2;
  input i_drv1_signal3;
  input i_drv1_signal4;
  input i_drv1_signal5;
  input i_drv1_signal6;
  input i_drv1_signal7;
  input i_drv1_signal8;
  input i_drv1_signal9;
  input i_drv2_signal1;
  input i_drv2_signal10;
  input i_drv2_signal2;
  input i_drv2_signal3;
  input i_drv2_signal4;
  input i_drv2_signal5;
  input i_drv2_signal6;
  input i_drv2_signal7;
  input i_drv2_signal8;
  input i_drv2_signal9;
  input i_enabq_signal1;
  input i_enabq_signal10;
  input i_enabq_signal2;
  input i_enabq_signal3;
  input i_enabq_signal4;
  input i_enabq_signal5;
  input i_enabq_signal6;
  input i_enabq_signal7;
  input i_enabq_signal8;
  input i_enabq_signal9;
  input i_enq_signal1;
  input i_enq_signal10;
  input i_enq_signal2;
  input i_enq_signal3;
  input i_enq_signal4;
  input i_enq_signal5;
  input i_enq_signal6;
  input i_enq_signal7;
  input i_enq_signal8;
  input i_enq_signal9;
  input i_pd_signal1;
  input i_pd_signal10;
  input i_pd_signal2;
  input i_pd_signal3;
  input i_pd_signal4;
  input i_pd_signal5;
  input i_pd_signal6;
  input i_pd_signal7;
  input i_pd_signal8;
  input i_pd_signal9;
  input i_ppen_signal1;
  input i_ppen_signal10;
  input i_ppen_signal2;
  input i_ppen_signal3;
  input i_ppen_signal4;
  input i_ppen_signal5;
  input i_ppen_signal6;
  input i_ppen_signal7;
  input i_ppen_signal8;
  input i_ppen_signal9;
  input i_prg_slew_signal1;
  input i_prg_slew_signal10;
  input i_prg_slew_signal2;
  input i_prg_slew_signal3;
  input i_prg_slew_signal4;
  input i_prg_slew_signal5;
  input i_prg_slew_signal6;
  input i_prg_slew_signal7;
  input i_prg_slew_signal8;
  input i_prg_slew_signal9;
  input i_puq_signal1;
  input i_puq_signal10;
  input i_puq_signal2;
  input i_puq_signal3;
  input i_puq_signal4;
  input i_puq_signal5;
  input i_puq_signal6;
  input i_puq_signal7;
  input i_puq_signal8;
  input i_puq_signal9;
  input i_pwrup_pull_en_signal1;
  input i_pwrup_pull_en_signal10;
  input i_pwrup_pull_en_signal2;
  input i_pwrup_pull_en_signal3;
  input i_pwrup_pull_en_signal4;
  input i_pwrup_pull_en_signal5;
  input i_pwrup_pull_en_signal6;
  input i_pwrup_pull_en_signal7;
  input i_pwrup_pull_en_signal8;
  input i_pwrup_pull_en_signal9;
  input i_pwrupzhl_signal1;
  input i_pwrupzhl_signal10;
  input i_pwrupzhl_signal2;
  input i_pwrupzhl_signal3;
  input i_pwrupzhl_signal4;
  input i_pwrupzhl_signal5;
  input i_pwrupzhl_signal6;
  input i_pwrupzhl_signal7;
  input i_pwrupzhl_signal8;
  input i_pwrupzhl_signal9;
  output o_outi_1v2_signal1;
  output o_outi_1v2_signal10;
  output o_outi_1v2_signal2;
  output o_outi_1v2_signal3;
  output o_outi_1v2_signal4;
  output o_outi_1v2_signal5;
  output o_outi_1v2_signal6;
  output o_outi_1v2_signal7;
  output o_outi_1v2_signal8;
  output o_outi_1v2_signal9;
  output o_outi_signal1;
  output o_outi_signal10;
  output o_outi_signal2;
  output o_outi_signal3;
  output o_outi_signal4;
  output o_outi_signal5;
  output o_outi_signal6;
  output o_outi_signal7;
  output o_outi_signal8;
  output o_outi_signal9;
  
  gpio_1v2_n1 signal1 (
    .ana_io_1v2(b_ana_io_1v2_signal1),
    .dq(i_dq_signal1),
    .drv0(i_drv0_signal1),
    .drv1(i_drv1_signal1),
    .drv2(i_drv2_signal1),
    .enabq(i_enabq_signal1),
    .enq(i_enq_signal1),
    .outi(o_outi_signal1),
    .outi_1v2(o_outi_1v2_signal1),
    .pad(b_pad_signal1),
    .pd(i_pd_signal1),
    .ppen(i_ppen_signal1),
    .prg_slew(i_prg_slew_signal1),
    .puq(i_puq_signal1),
    .pwrup_pull_en(i_pwrup_pull_en_signal1),
    .pwrupzhl(i_pwrupzhl_signal1)
   );
  gpio_1v2_n1 signal2 (
    .ana_io_1v2(b_ana_io_1v2_signal2),
    .dq(i_dq_signal2),
    .drv0(i_drv0_signal2),
    .drv1(i_drv1_signal2),
    .drv2(i_drv2_signal2),
    .enabq(i_enabq_signal2),
    .enq(i_enq_signal2),
    .outi(o_outi_signal2),
    .outi_1v2(o_outi_1v2_signal2),
    .pad(b_pad_signal2),
    .pd(i_pd_signal2),
    .ppen(i_ppen_signal2),
    .prg_slew(i_prg_slew_signal2),
    .puq(i_puq_signal2),
    .pwrup_pull_en(i_pwrup_pull_en_signal2),
    .pwrupzhl(i_pwrupzhl_signal2)
   );
  gpio_1v2_n1 signal3 (
    .ana_io_1v2(b_ana_io_1v2_signal3),
    .dq(i_dq_signal3),
    .drv0(i_drv0_signal3),
    .drv1(i_drv1_signal3),
    .drv2(i_drv2_signal3),
    .enabq(i_enabq_signal3),
    .enq(i_enq_signal3),
    .outi(o_outi_signal3),
    .outi_1v2(o_outi_1v2_signal3),
    .pad(b_pad_signal3),
    .pd(i_pd_signal3),
    .ppen(i_ppen_signal3),
    .prg_slew(i_prg_slew_signal3),
    .puq(i_puq_signal3),
    .pwrup_pull_en(i_pwrup_pull_en_signal3),
    .pwrupzhl(i_pwrupzhl_signal3)
   );
  gpio_1v2_n1 signal4 (
    .ana_io_1v2(b_ana_io_1v2_signal4),
    .dq(i_dq_signal4),
    .drv0(i_drv0_signal4),
    .drv1(i_drv1_signal4),
    .drv2(i_drv2_signal4),
    .enabq(i_enabq_signal4),
    .enq(i_enq_signal4),
    .outi(o_outi_signal4),
    .outi_1v2(o_outi_1v2_signal4),
    .pad(b_pad_signal4),
    .pd(i_pd_signal4),
    .ppen(i_ppen_signal4),
    .prg_slew(i_prg_slew_signal4),
    .puq(i_puq_signal4),
    .pwrup_pull_en(i_pwrup_pull_en_signal4),
    .pwrupzhl(i_pwrupzhl_signal4)
   );
  gpio_1v2_n1 signal5 (
    .ana_io_1v2(b_ana_io_1v2_signal5),
    .dq(i_dq_signal5),
    .drv0(i_drv0_signal5),
    .drv1(i_drv1_signal5),
    .drv2(i_drv2_signal5),
    .enabq(i_enabq_signal5),
    .enq(i_enq_signal5),
    .outi(o_outi_signal5),
    .outi_1v2(o_outi_1v2_signal5),
    .pad(b_pad_signal5),
    .pd(i_pd_signal5),
    .ppen(i_ppen_signal5),
    .prg_slew(i_prg_slew_signal5),
    .puq(i_puq_signal5),
    .pwrup_pull_en(i_pwrup_pull_en_signal5),
    .pwrupzhl(i_pwrupzhl_signal5)
   );
  gpio_1v2_n1 signal6 (
    .ana_io_1v2(b_ana_io_1v2_signal6),
    .dq(i_dq_signal6),
    .drv0(i_drv0_signal6),
    .drv1(i_drv1_signal6),
    .drv2(i_drv2_signal6),
    .enabq(i_enabq_signal6),
    .enq(i_enq_signal6),
    .outi(o_outi_signal6),
    .outi_1v2(o_outi_1v2_signal6),
    .pad(b_pad_signal6),
    .pd(i_pd_signal6),
    .ppen(i_ppen_signal6),
    .prg_slew(i_prg_slew_signal6),
    .puq(i_puq_signal6),
    .pwrup_pull_en(i_pwrup_pull_en_signal6),
    .pwrupzhl(i_pwrupzhl_signal6)
   );
  gpio_1v2_n1 signal7 (
    .ana_io_1v2(b_ana_io_1v2_signal7),
    .dq(i_dq_signal7),
    .drv0(i_drv0_signal7),
    .drv1(i_drv1_signal7),
    .drv2(i_drv2_signal7),
    .enabq(i_enabq_signal7),
    .enq(i_enq_signal7),
    .outi(o_outi_signal7),
    .outi_1v2(o_outi_1v2_signal7),
    .pad(b_pad_signal7),
    .pd(i_pd_signal7),
    .ppen(i_ppen_signal7),
    .prg_slew(i_prg_slew_signal7),
    .puq(i_puq_signal7),
    .pwrup_pull_en(i_pwrup_pull_en_signal7),
    .pwrupzhl(i_pwrupzhl_signal7)
   );
  gpio_1v2_n1 signal8 (
    .ana_io_1v2(b_ana_io_1v2_signal8),
    .dq(i_dq_signal8),
    .drv0(i_drv0_signal8),
    .drv1(i_drv1_signal8),
    .drv2(i_drv2_signal8),
    .enabq(i_enabq_signal8),
    .enq(i_enq_signal8),
    .outi(o_outi_signal8),
    .outi_1v2(o_outi_1v2_signal8),
    .pad(b_pad_signal8),
    .pd(i_pd_signal8),
    .ppen(i_ppen_signal8),
    .prg_slew(i_prg_slew_signal8),
    .puq(i_puq_signal8),
    .pwrup_pull_en(i_pwrup_pull_en_signal8),
    .pwrupzhl(i_pwrupzhl_signal8)
   );
  gpio_1v2_n1 signal9 (
    .ana_io_1v2(b_ana_io_1v2_signal9),
    .dq(i_dq_signal9),
    .drv0(i_drv0_signal9),
    .drv1(i_drv1_signal9),
    .drv2(i_drv2_signal9),
    .enabq(i_enabq_signal9),
    .enq(i_enq_signal9),
    .outi(o_outi_signal9),
    .outi_1v2(o_outi_1v2_signal9),
    .pad(b_pad_signal9),
    .pd(i_pd_signal9),
    .ppen(i_ppen_signal9),
    .prg_slew(i_prg_slew_signal9),
    .puq(i_puq_signal9),
    .pwrup_pull_en(i_pwrup_pull_en_signal9),
    .pwrupzhl(i_pwrupzhl_signal9)
   );
  gpio_1v2_n1 signal10 (
    .ana_io_1v2(b_ana_io_1v2_signal10),
    .dq(i_dq_signal10),
    .drv0(i_drv0_signal10),
    .drv1(i_drv1_signal10),
    .drv2(i_drv2_signal10),
    .enabq(i_enabq_signal10),
    .enq(i_enq_signal10),
    .outi(o_outi_signal10),
    .outi_1v2(o_outi_1v2_signal10),
    .pad(b_pad_signal10),
    .pd(i_pd_signal10),
    .ppen(i_ppen_signal10),
    .prg_slew(i_prg_slew_signal10),
    .puq(i_puq_signal10),
    .pwrup_pull_en(i_pwrup_pull_en_signal10),
    .pwrupzhl(i_pwrupzhl_signal10)
   );
   
   
  ring_terminator_n1 left_0 (
   );
  ring_terminator_n1 left_1 (
   );
  ring_terminator_n1 left_2 (
   );
  ring_terminator_n1 left_3 (
   );
  ring_terminator_n1 right_0 (
   );
  ring_terminator_n1 right_1 (
   );
  ring_terminator_n1 right_2 (
   );
  ring_terminator_n1 right_3 (
   );
   
   
  sup1v8_n1 sup1 (
   );
  sup1v8_n1 sup2 (
   );
  sup1v8_n1 sup3 (
   );
  sup1v8_n1 sup4 (
   );
   
endmodule
