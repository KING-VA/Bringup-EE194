// -------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2014) (2015) Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to the source code ("Material") are owned by 
// Intel Corporation or its suppliers or licensors. Title to the Material remains with Intel Corporation or its suppliers // and licensors. The Material contains trade secrets and proprietary and confidential information of Intel or its
// suppliers and licensors. The Material is protected by worldwide copyright and trade secret laws and treaty provisions. // No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted, transmitted,
// distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is granted to or conferred 
// upon you by disclosure or delivery of the Materials, either expressly, by implication, inducement, estoppel or 
// otherwise. Any license under such intellectual property rights must be express and approved by Intel in writing.
// -------------------------------------------------------------------
`include "hs_chv_macro_tech_map.vh"

module ctech_lib_msff_async_rst_meta (
   input logic clk,
   input logic d, 
   input logic rst,
   output logic o
);
   `ifndef DC
   logic o1;
   always_ff  @ (posedge rst or posedge clk)
      if (rst)
         o1 <= 1'b0;
      else
         o1 <= d;
   always_ff  @ (posedge rst  or posedge clk)
      if (rst)
         o <= 1'b0;
      else
         o <= o1;
   `else
   logic rstb;
   `LIB_CLKINV_SOC(rstb,rst) 
   `LIB_ASYNC_RST_2MSFF_META(o,d,clk,rstb)
   `endif
endmodule
