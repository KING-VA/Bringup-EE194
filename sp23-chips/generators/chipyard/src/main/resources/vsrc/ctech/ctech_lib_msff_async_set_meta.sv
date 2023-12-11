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
module ctech_lib_msff_async_set_meta (
   output logic o,
   input logic d,
   input logic clk,
   input logic set
); 
   `ifndef DC
   logic o1,o2;
   always_ff  @ (posedge set or posedge clk)
      if (set)
         o1 <= 1'b1;
      else
         o1 <= d;
   always_ff  @ ( posedge set or posedge clk)
      if (set)
         o2 <= 1'b1;
      else
         o2 <= o1;
   assign  o = o2;
   `else
   logic setb;
   //`LIB_CLKINV_SOC(setb,set) 
   `LIB_INV_SOC(setb,set) 
   `LIB_ASYNC_SET_2MSFF_META(o,d,clk,setb)
   `endif
endmodule
