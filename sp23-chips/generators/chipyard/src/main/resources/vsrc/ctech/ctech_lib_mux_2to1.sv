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
module ctech_lib_mux_2to1 (
   input logic d1,
   input logic d2,
   input logic s,
   output logic o
);
   `ifndef DC
   assign o = (d1&s)|(d2&~s);
   `else
  `LIB_MUX_2TO1_HF(o,d1,d2,s)
   `endif
endmodule
