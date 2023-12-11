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
      output   [ 1: 0]   DDR4B_CK,
      output   [ 1: 0]   DDR4B_CK_n,
      output   [ 1: 0]   DDR4B_CKE,
      inout    [ 8: 0]   DDR4B_DQS,
      inout    [ 8: 0]   DDR4B_DQS_n,
      inout    [71: 0]   DDR4B_DQ,
      inout    [ 8: 0]   DDR4B_DBI_n,
      output   [ 1: 0]   DDR4B_CS_n,
      output             DDR4B_RESET_n,
      output   [ 1: 0]   DDR4B_ODT,
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

      ///////// GPIO_D /////////
      inout    [ 7: 0]   GPIO_D,

`ifdef ENABLE_FMC
      ///////// FMC /////////
      inout              FMC_CLK2_BIDIR_p,
      inout              FMC_CLK2_BIDIR_n,
      inout              FMC_CLK3_BIDIR_p,
      inout              FMC_CLK3_BIDIR_n,
      output   [ 9: 0]   FMC_DP_C2M_p,
      output   [ 9: 0]   FMC_DP_C2M_n,
      input    [ 9: 0]   FMC_DP_M2C_p,
      input    [ 9: 0]   FMC_DP_M2C_n,
      inout    [23: 0]   FMC_HA_p,
      inout    [23: 0]   FMC_HA_n,
      inout    [21: 0]   FMC_HB_p,
      inout    [21: 0]   FMC_HB_n,
      inout    [33: 0]   FMC_LA_p,
      inout    [33: 0]   FMC_LA_n,
      input    [ 1: 0]   FMC_CLK_M2C_p,
      input    [ 1: 0]   FMC_GBTCLK_M2C_p,
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
      output   [15: 0]   FMCP_DP_C2M_p,
      output   [15: 0]   FMCP_DP_C2M_n,
      input    [15: 0]   FMCP_DP_M2C_p,
      input    [15: 0]   FMCP_DP_M2C_n,
      inout    [23: 0]   FMCP_HA_p,
      inout    [23: 0]   FMCP_HA_n,
      inout    [21: 0]   FMCP_HB_p,
      inout    [21: 0]   FMCP_HB_n,
      inout    [33: 0]   FMCP_LA_p,
      inout    [33: 0]   FMCP_LA_n,
      input    [ 1: 0]   FMCP_CLK_M2C_p,
      input    [ 1: 0]   FMCP_GBTCLK_M2C_p,
      output             FMCP_REFCLK_C2M_p,
      input              FMCP_REFCLK_M2C_p,
      inout    [ 1: 0]   FMCP_GA,
      input              FMCP_RES0,
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




//=======================================================
//  Structural coding
//=======================================================

assign SI5340A_RST_n = 1'b1;
assign SI5340A_OE_n = 1'b0;

endmodule
