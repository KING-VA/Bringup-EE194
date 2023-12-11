// ============================================================================
// Copyright (c) 2021 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  No.80, Fenggong Rd., Hukou Township, Hsinchu County 303035 Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Wed Dec 22 14:16:44 2021
// ============================================================================

//`define ENABLE_DDR4A
//`define ENABLE_DDR4B
//`define ENABLE_QSFP28
//`define ENABLE_QSFP28RSV
//`define ENABLE_FMC
//`define ENABLE_FMCP
//`define ENABLE_HPS

module Agilex_SOM(

      ///////// CLOCK /////////
      input              CLK_100_B2A,
      input              CLK_30M72,
      input              CLK_50_B2A,
      input              CLK_50_B2D,
      input              CLK_50_B3A,
      input              CLK_50_B3C,

      ///////// Buttons /////////
      input              CPU_RESET_n,
      input    [ 1: 0]   BUTTON, //BUTTON is Low-Active

      ///////// Swtiches /////////
      input    [ 1: 0]   SW,

      ///////// LED /////////
      output   [ 1: 0]   LED, //LED is Low-Active

`ifdef ENABLE_DDR4A
      ///////// DDR4A /////////
      input              DDR4A_REFCLK_p,
      output   [16: 0]   DDR4A_A,
      output   [ 1: 0]   DDR4A_BA,
      output   [ 1: 0]   DDR4A_BG,
      output             DDR4A_CK,
      output             DDR4A_CK_n,
      output             DDR4A_CKE,
      inout    [ 8: 0]   DDR4A_DQS,
      inout    [ 8: 0]   DDR4A_DQS_n,
      inout    [71: 0]   DDR4A_DQ,
      inout    [ 8: 0]   DDR4A_DBI_n,
      output             DDR4A_CS_n,
      output             DDR4A_RESET_n,
      output             DDR4A_ODT,
      output             DDR4A_PAR,
      input              DDR4A_ALERT_n,
      output             DDR4A_ACT_n,
      input              DDR4A_EVENT_n,
      inout              DDR4A_SCL,
      inout              DDR4A_SDA,
      input              DDR4A_RZQ,
`endif /*ENABLE_DDR4A*/

`ifdef ENABLE_DDR4B
      ///////// DDR4B /////////
      input              DDR4B_REFCLK_p,
      output   [16: 0]   DDR4B_A,
      output   [ 1: 0]   DDR4B_BA,
      output   [ 1: 0]   DDR4B_BG,
      output             DDR4B_CK,
      output             DDR4B_CK_n,
      output             DDR4B_CKE,
      inout    [ 8: 0]   DDR4B_DQS,
      inout    [ 8: 0]   DDR4B_DQS_n,
      inout    [71: 0]   DDR4B_DQ,
      inout    [ 8: 0]   DDR4B_DBI_n,
      output             DDR4B_CS_n,
      output             DDR4B_RESET_n,
      output             DDR4B_ODT,
      output             DDR4B_PAR,
      input              DDR4B_ALERT_n,
      output             DDR4B_ACT_n,
      input              DDR4B_EVENT_n,
      inout              DDR4B_SCL,
      inout              DDR4B_SDA,
      input              DDR4B_RZQ,
`endif /*ENABLE_DDR4B*/

      ///////// SI5340A /////////
      inout              SI5340A_I2C_SCL,
      inout              SI5340A_I2C_SDA,
      input              SI5340A_LOL,
      input              SI5340A_LOS_XAXB,
      output             SI5340A_OE_n,
      output             SI5340A_RST_n,

      ///////// 2x6 GPIO /////////
      inout    [ 7: 0]   GPIO_D,

`ifdef ENABLE_FMC
      ///////// FMC /////////
      inout              FMC_CLK2_BIDIR_p,
      inout              FMC_CLK2_BIDIR_n,
      inout              FMC_CLK3_BIDIR_p,
      inout              FMC_CLK3_BIDIR_n,
      //output   [ 9: 0]   FMC_DP_C2M_p,
      //output   [ 9: 0]   FMC_DP_C2M_n,
      //input    [ 9: 0]   FMC_DP_M2C_p,
      //input    [ 9: 0]   FMC_DP_M2C_n,
      inout    [23: 0]   FMC_HA_p,
      inout    [23: 0]   FMC_HA_n,
      inout    [21: 0]   FMC_HB_p,
      inout    [21: 0]   FMC_HB_n,
      inout    [33: 0]   FMC_LA_p,
      inout    [33: 0]   FMC_LA_n,
      //input    [ 1: 0]   FMC_CLK_M2C_p,
      //input    [ 1: 0]   FMC_GBTCLK_M2C_p,
      input              FMC_REFCLK0_p,
      input              FMC_REFCLK1_p,
      inout    [ 1: 0]   FMC_GA,
      inout    [ 0: 0]   FMC_RES,
      inout              FMC_SCL,
      inout              FMC_SDA,
`endif /*ENABLE_FMC*/

`ifdef ENABLE_FMCP
      ///////// FMCP /////////
      inout              FMCP_CLK2_BIDIR_p,
      inout              FMCP_CLK2_BIDIR_n,
      inout              FMCP_CLK3_BIDIR_p,
      inout              FMCP_CLK3_BIDIR_n,
      //output   [15: 0]   FMCP_DP_C2M_p,
      //output   [15: 0]   FMCP_DP_C2M_n,
      //input    [15: 0]   FMCP_DP_M2C_p,
      //input    [15: 0]   FMCP_DP_M2C_n,
      inout    [23: 0]   FMCP_HA_p,
      inout    [23: 0]   FMCP_HA_n,
      inout    [21: 0]   FMCP_HB_p,
      inout    [21: 0]   FMCP_HB_n,
      inout    [33: 0]   FMCP_LA_p,
      inout    [33: 0]   FMCP_LA_n,
      //input    [ 1: 0]   FMCP_CLK_M2C_p,
      //input    [ 1: 0]   FMCP_GBTCLK_M2C_p,
      output             FMCP_REFCLK_C2M_p,
      input              FMCP_REFCLK_M2C_p,
      inout    [ 1: 0]   FMCP_GA,
      //input              FMCP_RES0,
      inout              FMCP_RES1,
      inout              FMCP_SCL,
      inout              FMCP_SDA,
      output             FMCP_SYNC_C2M_p,
      input              FMCP_SYNC_M2C_p,
`endif /*ENABLE_FMCP*/

`ifdef ENABLE_QSFP28
      ///////// QSFP28 /////////
      output   [ 3: 0]   QSFP28_TX_p,
      output   [ 3: 0]   QSFP28_TX_n,
      input    [ 3: 0]   QSFP28_RX_p,
      input    [ 3: 0]   QSFP28_RX_n,
      input              QSFP28_REFCLK_p,
      input              QSFP28_INTERRUPT_n,
      output             QSFP28_LP_MODE,
      input              QSFP28_MOD_PRS_n,
      output             QSFP28_MOD_SEL_n,
      output             QSFP28_RST_n,
      inout              QSFP28_SCL,
      inout              QSFP28_SDA,
`else
      input              QSFP28_REFCLK_p,
`endif /*ENABLE_QSFP28*/

`ifdef ENABLE_QSFP28RSV
      ///////// QSFP28RSV /////////
      input              QSFP28RSV_REFCLK_p,
`endif /*ENABLE_QSFP28RSV*/

      ///////// AG /////////
      output             AG_UART_TX,
      input              AG_UART_RX,
      input              AG_UART_CTS,
      output             AG_UART_RTS,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input              HPS_ENET_RX_CTL,
      input    [ 3: 0]   HPS_ENET_RX_DATA,
      output             HPS_ENET_TX_CLK,
      output             HPS_ENET_TX_CTL,
      output   [ 3: 0]   HPS_ENET_TX_DATA,
      inout    [ 4: 0]   HPS_GPIO,
      inout              HPS_I2C_SCL,
      inout              HPS_I2C_SDA,
      input              HPS_JTAG_TCK,
      input              HPS_JTAG_TDI,
      output             HPS_JTAG_TDO,
      input              HPS_JTAG_TMS,
      inout              HPS_KEY,
      inout              HPS_LED,
      input              HPS_OSC_CLK,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout    [ 3: 0]   HPS_SD_DATA,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLK,
      inout    [ 7: 0]   HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// INFO /////////
      output             INFO_SPI_SCLK,
      input              INFO_SPI_MISO,
      output             INFO_SPI_MOSI,
      output             INFO_SPI_CS_n 

);


//=======================================================
//  REG/WIRE declarations
//=======================================================

wire clock;
wire reset;

wire gpio_pc0;
wire gpio_pc1;
wire gpio_pc2;
wire gpio_pc3;
wire gpio_pc4;
wire gpio_pc5;
wire gpio_pc6;
wire gpio_pc7;
wire gpio_pa0;
wire gpio_pa1;
wire gpio_pa2;
wire gpio_pa3;
wire gpio_pa4;
wire gpio_pa5;
wire gpio_pa6;
wire gpio_pa7;
wire gpio_pa8;
wire gpio_pa9;
wire gpio_pa10;
wire gpio_pa11;
wire gpio_pa12;
wire gpio_pa13;
wire gpio_pa14;
wire gpio_pa15;
wire gpio_pa16;
wire gpio_pa17;
wire pwm0_ch0;
wire pwm0_ch1;
wire pwm0_ch2;
wire pwm0_ch3;
wire spi2_sclk;
wire spi2_csn;
wire spi2_mosi;
wire spi2_miso;
wire uart1_rx;
wire uart1_tx;
wire uart2_rx;
wire uart2_tx;
wire qspi0_sclk;
wire qspi0_csn ;
wire qspi0_dq0;
wire qspi0_dq1;
wire qspi0_dq2;
wire qspi0_dq3;
wire qspi1_sclk;
wire qspi1_csn;
wire qspi1_dq0;
wire qspi1_dq1;
wire qspi1_dq2;
wire qspi1_dq3;


/* synthesis keep */
wire uart_rx, uart_tx;

wire serial_tl_clock;
wire serial_tl_in_valid;
wire serial_tl_in_bits;
wire serial_tl_in_ready;
wire serial_tl_out_valid;
wire serial_tl_out_bits;
wire serial_tl_out_ready;

wire tsi_dropped /* synthesis keep */;
(* keep *)
wire [3:0] tsi_state;

(* preserve *) logic qspi0_sclk, qspi0_csn;
(* preserve *) logic [3:0] qspi0_dq;

wire reset_release;
reset_release u0 (
  .ninit_done (reset_release)  //  output,  width = 1, ninit_done.reset
);

wire reset_button;
assign reset_button = !CPU_RESET_n;

wire axi4_mem_0_clock;
wire axi4_mem_0_reset;
wire axi4_mem_0_bits_aw_ready;
wire axi4_mem_0_bits_w_ready;
wire axi4_mem_0_bits_b_valid;
wire axi4_mem_0_bits_b_bits_id;
wire axi4_mem_0_bits_b_bits_resp;
wire axi4_mem_0_bits_ar_ready;
wire axi4_mem_0_bits_r_valid;
wire axi4_mem_0_bits_r_bits_id;
wire axi4_mem_0_bits_r_bits_data;
wire axi4_mem_0_bits_r_bits_resp;
wire axi4_mem_0_bits_r_bits_last;
wire axi4_mem_0_bits_aw_valid;
wire axi4_mem_0_bits_aw_bits_id;
wire axi4_mem_0_bits_aw_bits_addr;
wire axi4_mem_0_bits_aw_bits_len;
wire axi4_mem_0_bits_aw_bits_size;
wire axi4_mem_0_bits_aw_bits_burst;
wire axi4_mem_0_bits_aw_bits_lock;
wire axi4_mem_0_bits_aw_bits_cache;
wire axi4_mem_0_bits_aw_bits_prot;
wire axi4_mem_0_bits_aw_bits_qos;
wire axi4_mem_0_bits_w_valid;
wire axi4_mem_0_bits_w_bits_data;
wire axi4_mem_0_bits_w_bits_strb;
wire axi4_mem_0_bits_w_bits_last;
wire axi4_mem_0_bits_b_ready;
wire axi4_mem_0_bits_ar_valid;
wire axi4_mem_0_bits_ar_bits_id;
wire axi4_mem_0_bits_ar_bits_addr;
wire axi4_mem_0_bits_ar_bits_len;
wire axi4_mem_0_bits_ar_bits_size;
wire axi4_mem_0_bits_ar_bits_burst;
wire axi4_mem_0_bits_ar_bits_lock;
wire axi4_mem_0_bits_ar_bits_cache;
wire axi4_mem_0_bits_ar_bits_prot;
wire axi4_mem_0_bits_ar_bits_qos;
wire axi4_mem_0_bits_r_ready;

ChipTop chiptop(
	.port_clock(serial_tl_clock),	// @[generators/chipyard/src/main/scala/IOBinders.scala:310:18]
	.port_bits_in_valid(serial_tl_in_valid),	// @[generators/chipyard/src/main/scala/IOBinders.scala:310:18]
	.port_bits_in_bits(serial_tl_in_bits),	// @[generators/chipyard/src/main/scala/IOBinders.scala:310:18]
	.port_bits_out_ready(serial_tl_out_ready),	// @[generators/chipyard/src/main/scala/IOBinders.scala:310:18]
	.reset_io(reset),	// @[generators/chipyard/src/main/scala/clocking/ClockBinders.scala:109:24]
	.clock_uncore_clock(clock),	// @[generators/chipyard/src/main/scala/clocking/ClockBinders.scala:117:26]
	.axi4_mem_0_bits_aw_ready(axi4_mem_0_bits_aw_ready),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_w_ready(axi4_mem_0_bits_w_ready),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_b_valid(axi4_mem_0_bits_b_valid),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_b_bits_id(axi4_mem_0_bits_b_bits_id),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_b_bits_resp(axi4_mem_0_bits_b_bits_resp),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_ready(axi4_mem_0_bits_ar_ready),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_r_valid(axi4_mem_0_bits_r_valid),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_r_bits_id(axi4_mem_0_bits_r_bits_id),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_r_bits_data(axi4_mem_0_bits_r_bits_data),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_r_bits_resp(axi4_mem_0_bits_r_bits_resp),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_r_bits_last(axi4_mem_0_bits_r_bits_last),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.uart_tsi_uart_rxd(uart_rx),	// @[generators/chipyard/src/main/scala/IOBinders.scala:427:22]

	.port_bits_in_ready(serial_tl_in_ready),	// @[generators/chipyard/src/main/scala/IOBinders.scala:310:18]
	.port_bits_out_valid(serial_tl_out_valid),	// @[generators/chipyard/src/main/scala/IOBinders.scala:310:18]
	.port_bits_out_bits(serial_tl_out_bits),	// @[generators/chipyard/src/main/scala/IOBinders.scala:310:18]
	.axi4_mem_0_clock(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_reset(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_valid(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_id(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_addr(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_len(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_size(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_burst(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_lock(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_cache(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_prot(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_aw_bits_qos(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_w_valid(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_w_bits_data(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_w_bits_strb(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_w_bits_last(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_b_ready(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_valid(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_id(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_addr(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_len(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_size(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_burst(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_lock(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_cache(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_prot(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_ar_bits_qos(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.axi4_mem_0_bits_r_ready(),	// @[generators/chipyard/src/main/scala/IOBinders.scala:325:19]
	.uart_tsi_uart_txd(uart_tx),	// @[generators/chipyard/src/main/scala/IOBinders.scala:427:22]
	.uart_tsi_dropped(tsi_dropped),	// @[generators/chipyard/src/main/scala/IOBinders.scala:427:22]
	.uart_tsi_tsi2tl_state(tsi_state)	// @[generators/chipyard/src/main/scala/IOBinders.scala:427:22]
);

assign clock = CLK_50_B2A;
assign reset = reset_release || reset_button;

assign AG_UART_TX = uart_tx;
assign uart_rx = AG_UART_RX;

assign FMCP_LA_p[12] = serial_tl_out_bits;
assign FMCP_LA_n[9]  = serial_tl_out_valid;
assign serial_tl_out_ready = FMCP_LA_p[4];
assign serial_tl_in_bits   = FMCP_LA_n[3];
assign serial_tl_in_valid  = FMCP_LA_p[7];
assign FMCP_LA_n[8]  = serial_tl_in_ready;
assign serial_tl_clock     = FMCP_LA_p[2];

assign gpio_pc0 = FMCP_LA_p[9];
assign gpio_pc1 = FMCP_LA_n[7];
assign gpio_pc2 = FMCP_LA_p[6];
assign gpio_pc3 = FMCP_LA_p[3];
assign gpio_pc4 = FMCP_LA_p[10];
assign gpio_pc5 = FMCP_LA_p[8];
assign gpio_pc6 = FMCP_LA_p[1];
assign gpio_pc7 = FMCP_HA_n[10];

assign gpio_pa0 = FMCP_LA_n[14];
assign gpio_pa1 = FMCP_LA_n[20];
assign gpio_pa2 = FMCP_LA_n[10];
assign gpio_pa3 = FMCP_LA_n[12];
assign gpio_pa4 = FMCP_LA_n[11];
assign gpio_pa5 = FMCP_LA_p[11];
assign gpio_pa6 = FMCP_LA_p[17];
assign gpio_pa7 = FMCP_LA_p[14];
assign gpio_pa8 = FMCP_LA_p[19];
assign gpio_pa9 = FMCP_LA_p[20];
assign gpio_pa10 = FMCP_LA_n[6];
assign gpio_pa11 = FMCP_LA_p[5];
assign gpio_pa12 = FMCP_LA_n[5];
assign gpio_pa13 = FMCP_LA_n[4];
assign gpio_pa14 = FMCP_LA_n[13];
assign gpio_pa15 = FMCP_LA_p[0];
assign gpio_pa16 = FMCP_LA_n[15];
assign gpio_pa17 = FMCP_HB_p[1];

assign pwm0_ch0 = FMCP_HA_p[19];
assign pwm0_ch1 = FMCP_HA_n[20];
assign pwm0_ch2 = FMCP_HA_p[23];
assign pwm0_ch3 = FMCP_HA_n[23];

assign spi2_sclk = FMCP_LA_n[2];
assign spi2_csn = FMCP_LA_n[1];
assign spi2_mosi = FMCP_HA_n[12];
assign spi2_miso = FMCP_HA_p[12];

assign uart1_rx = FMCP_LA_p[15];
assign uart1_tx = FMCP_LA_n[17];
assign uart2_rx = FMCP_LA_n[16];
assign uart2_tx = FMCP_LA_n[18];

assign qspi0_sclk = FMCP_HA_n[6];
assign qspi0_csn  = FMCP_HA_n[8];
assign qspi0_dq[0] = FMCP_HA_p[10];
assign qspi0_dq[1] = FMCP_HA_p[4];
assign qspi0_dq[2] = FMCP_HA_p[3];
assign qspi0_dq[3] = FMCP_HA_n[9];


assign qspi0_dq0 = FMCP_HA_p[10];
assign FMCP_HA_p[4] = qspi0_dq1;
assign qspi0_dq2 = FMCP_HA_p[3];
assign qspi0_dq3 = FMCP_HA_n[9];

assign qspi1_sclk = FMCP_HA_n[13];
assign qspi1_csn = FMCP_HA_p[13];
assign qspi1_dq0 = FMCP_HA_n[2];
assign qspi1_dq1 = FMCP_HA_p[2];
assign qspi1_dq2 = FMCP_HA_n[4];
assign qspi1_dq3 = FMCP_HA_n[3];

// So that the signals don't get optimized out
assign FMC_LA_p[0] = gpio_pc0 & gpio_pc1 & gpio_pc2 & gpio_pc3 & gpio_pc4 & gpio_pc5 & gpio_pc6 & gpio_pc7 & gpio_pa0 & gpio_pa1 & gpio_pa2 & gpio_pa3 & gpio_pa4 & gpio_pa5 & gpio_pa6 & gpio_pa7 & gpio_pa8 & gpio_pa9 & gpio_pa10 & gpio_pa11 & gpio_pa12 & gpio_pa13 & gpio_pa14 & gpio_pa15 & gpio_pa16 & gpio_pa17 & pwm0_ch0 & pwm0_ch1 & pwm0_ch2 & pwm0_ch3 & spi2_sclk & spi2_csn & spi2_mosi & spi2_miso & uart1_rx & uart1_tx & uart2_rx & uart2_tx & qspi0_sclk & qspi0_csn & qspi0_dq0 & qspi0_dq1 & qspi0_dq2 & qspi0_dq3 & qspi1_sclk & qspi1_csn & qspi1_dq0 & qspi1_dq1 & qspi1_dq2 & qspi1_dq3;

spiflash #(
    .ADDRL(20)
) spiflash (
    .clk(qspi0_sclk),
    .cs(!qspi0_csn),
    .mosi(qspi0_dq0),
    .miso(qspi0_dq1),
    .reset(reset)
);

//=======================================================
//  Structural coding
//=======================================================

assign SI5340A_RST_n = 1'b1;
assign SI5340A_OE_n = 1'b0;

// Assign the QSPI outputs to the FMC pins
assign FMC_HA_p[10] = qspi0_dq[0];
assign FMC_HA_p[4]  = qspi0_dq[1];
assign FMC_HA_p[3]  = qspi0_dq[2];
assign FMC_HA_n[9]  = qspi0_dq[3];
// assign FMC_HA_n[6]  = qspi0_sclk_reg;
// assign FMC_HA_n[8]  = qspi0_csn_reg;

// Assign the register outputs to the FMC pins
// assign FMC_HA_p[0] = qspi0_dq_reg[0];
// assign FMC_HA_p[1] = qspi0_dq_reg[1];
// assign FMC_HA_p[2] = qspi0_dq_reg[2];
// assign FMC_HA_p[3] = qspi0_dq_reg[3];
// assign FMC_HA_p[5] = qspi0_sclk_reg;
// assign FMC_HA_p[6] = qspi0_csn_reg;

endmodule
