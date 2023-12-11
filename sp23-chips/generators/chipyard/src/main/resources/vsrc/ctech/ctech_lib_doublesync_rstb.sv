//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2014 2015 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (?Material?) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
// ctech_lib_doublesync_rstb flop with metastability modeling active low clear 
// Date:   11/30/14
//
// Waiveing two lintra rules:
// 50514 - Waived becuase new UDR not available for updated copyright notice
// 68000 - This is a ctech component , so it does not need a fuse puller 
// 70607 - This is a ctech component, so it does not have visa 
//lintra push -50514, -68000, -70607
`include "hs_chv_macro_tech_map.vh"
module ctech_lib_doublesync_rstb # (  

// Parameters: 
//     Non Override Parameters
//             WIDTH (int)               Defines the number of bits that are syncronized 
//             MIN_PERIOD (int)          When non-zero, input data delays are used rather than random N/N+1 flop delays.
//                                       MIN_PERIOD (based on timescale) specifies the minimure period used by either the source or
//                                       destination clock domain.
//             SINGLE_BUS_META           This is forces all the bit of the  meta flop to use randomize based on a singal bit
//
// Parameter/Define/Plusarg decision tree :
//      Parameter (default ==1)                             Parameter (default ==0)        
//         !  /            \                                   !  /            \
//        disable         Define                              Define         Enable  
//                       !/    \                             !/    \ 
//                   Plusarg  Enable                     Plusarg  Enable  
//                   !/    \                             !/    \ 
//               disable  Enable                     disable  Enable        
// 
//    Override Parameters These have define and plusarg overrides
//             METASTABILITY_EN          When set to zero, metastability modeling is disabled on a per-instance basis.
//             PULSE_WIDTH_CHECK         When set to zero, input pulse width assertions are disabled on a per-instance basis.
//             WIDTH                     Sets the width of the data bus
//             PLUS1_ONLY                Disable the Minus 1 RX flop Mode, The meta flop will only provide 2 or 3 clock of delay
//             MINUS1_ONLY               Disable the PLus  1 RX flop Mode, The meta flop will only provide 2 or 1 clock of delay
//             ENABLE_3TO1               Enables the meta flop to make 3 clock delays to 1 clock delays and possible loss of some pulses
//                                      
// Define/Plusargs:   
//             CTECH_LIB_META_DISPLAY    Display metaflop module name, full instance path, parameter and plusarg values. (Plusarg Only)
//             CTECH_LIB_META_ON         When set it will globaly enable meta-stablity modeling expect on those instnace with the paratemer override, defaults METASTABILTY_EN to 1
//             CTECH_LIB_PULSE_ON        When set input pulse width assertions are enabled
//             CTECH_LIB_PLUS1_ONLY      Disable the Minus 1 RX flop Mode, The meta flop will only provide 2 or 3 clock of delay
//             CTECH_LIB_MINUS1_ONLY     Disable the Minus 1 RX flop Mode, The meta flop will only provide 2 or 1 clock of delay
//             CTECH_LIB_ENABLE_3TO1     Enables the meta flop to make 3 clock delays to 1 clock delays and possible loss of some pulses
//

//     Non Override Parameters
           parameter integer  WIDTH=1,
           parameter integer  MIN_PERIOD=0,
           parameter bit      SINGLE_BUS_META=0,
//    Override Parameters These have define and plusarg overrides
//    Defines reverse the default value for a parameter
           parameter bit      METASTABILITY_EN=1,
           parameter bit      PULSE_WIDTH_CHECK=1,
           parameter bit      ENABLE_3TO1=1,
           parameter bit      PLUS1_ONLY=0,
           parameter bit      MINUS1_ONLY=0
 )  (
   input  logic            rstb,
   input  logic            clk,
`ifdef VCS_SIMULATION 
   input  logic [WIDTH-1:0]  d,
   output logic [WIDTH-1:0]  o
`else
   input  logic            d,
   output logic            o
 `endif
 );

`ifdef VCS_SIMULATION 
    logic [1:0] [WIDTH-1:0] sync;  // Basic sync cell elements
`else
    logic [1:0] sync;  // Basic sync cell elements
 `endif

//// Assign the last flop to the output
//    assign o = sync[1];

// -----------------------------------------------------------------------------
//  Need to ensure that the model is not used for DC synth 
// -----------------------------------------------------------------------------
`ifdef DC 
`LIB_ASYNC_RST_2MSFF_META(o,d,clk,rstb);
`endif
// -----------------------------------------------------------------------------
//  Provide a basic physical veiw of the RTL if not in VCS, This should make it 
//  compatible with all other tools include FPGA synth, lintra and LEC 
// -----------------------------------------------------------------------------
`ifndef DC
`ifndef VCS_SIMULATION 
    // Assign the last flop to the output
    assign o = sync[1];
    always_ff @(posedge clk or negedge rstb)
     if (!rstb) begin
         sync <= '0;
     end else begin
         sync <={sync[0], d};
     end
`else
    // Assign the last flop to the output
    assign o = sync[1];
   `ifdef CTECH_LIB_META_ON
      localparam bit DEFINE_META_ON=1;
   `else
      localparam bit DEFINE_META_ON=0;
   `endif
   `ifdef CTECH_LIB_PULSE_ON
      localparam bit DEFINE_PULSE_WIDTH=1;
   `else
      localparam bit DEFINE_PULSE_WIDTH=0;
   `endif
   `ifdef CTECH_LIB_PLUS1_ONLY
       localparam bit DEFINE_PLUS1_ONLY=1;
   `else
       localparam bit DEFINE_PLUS1_ONLY=0;
   `endif
   `ifdef CTECH_LIB_MINUS1_ONLY
       localparam bit DEFINE_MINUS1_ONLY=1;
   `else
       localparam bit DEFINE_MINUS1_ONLY=0;
   `endif
   `ifdef CTECH_LIB_ENABLE_3TO1
       localparam bit DEFINE_ENABLE_3TO1=1;
   `else
       localparam bit DEFINE_ENABLE_3TO1=0;
   `endif
    // Signals used to capture +args and final values for featres
    logic display_metaflop_info; 
    logic ctech_lib_meta_on;
    logic meta_disable;
    logic ctech_lib_check_on;
    logic pulse_width_check_disable;
    logic ctech_lib_plus1;
    logic plus1_only_mode;
    logic ctech_lib_minus1;
    logic minus1_only_mode;
    logic ctech_lib_3to1_on;
    logic three2one_disable;

    logic [WIDTH-1:0]     dd_ff; // Delay flops used for +1 mode
    logic [(WIDTH*2)-1:0] past_delay={WIDTH{2'b10}}; 
    logic [(WIDTH*2)-1:0] dly={WIDTH{2'b10}}; 
// Seems you can do conditaional sizes here will need to look at generates?
//                if(SINGLE_BUS_META && ( plus1_only_mode || minus1_only_mode))begin
//                   logic dly='0;
//                end
//                else if (SINGLE_BUS_META)begin
//                   logic [2:1] dly=2'b10;
//                end
//                else if ( plus1_only_mode || minus1_only_mode )begin
//                   logic [WIDTH:1] dly=2'b10; 
//                end
//                else begin
//                   logic [WIDTH*2:1] dly={WIDTH{2'b10}}; 
//                end
//                if((MIN_PERIOD!=0) && ~(three2one_disable || plus1_only_mode || minus1_only_mode)) begin
//                   logic [WIDTH*2] past_delay=2'b10;
//                end

    initial begin
        // Query for the plusargs
        display_metaflop_info     = $test$plusargs("CTECH_LIB_META_DISPLAY");
        ctech_lib_meta_on         = $test$plusargs("CTECH_LIB_META_ON");
        ctech_lib_check_on        = $test$plusargs("CTECH_LIB_CHECK_ON");
        ctech_lib_plus1           = $test$plusargs("CTECH_LIB_PLUS1_ONLY");
        ctech_lib_minus1          = $test$plusargs("CTECH_LIB_MINUS1_ONLY");
        ctech_lib_3to1_on         = $test$plusargs("CTECH_LIB_ENABLE_3TO1");

        // Check plusargs and parameters to determine if input pulse width checking or metastbility modeling should be disabled
        // Paramater default = 1 
        meta_disable              = ~((ctech_lib_meta_on  || DEFINE_META_ON ) && METASTABILITY_EN);
        pulse_width_check_disable = ~((ctech_lib_check_on || DEFINE_PULSE_WIDTH) && PULSE_WIDTH_CHECK);
        three2one_disable         = ~((ctech_lib_3to1_on || DEFINE_ENABLE_3TO1 ) && ENABLE_3TO1);
      
        // Paramater default = 0 
        plus1_only_mode           = ctech_lib_plus1   || PLUS1_ONLY || DEFINE_PLUS1_ONLY;
        minus1_only_mode          = ctech_lib_minus1  || MINUS1_ONLY || DEFINE_MINUS1_ONLY;
       

        // Display metaflop instance info when plusarg CTECH_META_DISPLAY exists
        if (display_metaflop_info!=0) begin
            $display("CTECH_METAFLOP %0m: ctech_doublesync_rst WIDTH=%0d, SINGLE_BUS_META=%0d, METASTABILITY_EN=(%0d/%0d/%0d), PULSE_WIDTH_CHECK=(%0d/%0d/%0d), MIN_PERIOD=%0dps, PLUS1_ONLY=(%0d/%0d/%0d), MINUS1_ONLY=(%0d/%0d/%0d), ENABLE_3TO1=(%0d/%0d/%0d),",WIDTH, SINGLE_BUS_META, METASTABILITY_EN, ctech_lib_meta_on, ~meta_disable, PULSE_WIDTH_CHECK, ctech_lib_check_on, ~pulse_width_check_disable, MIN_PERIOD, PLUS1_ONLY,ctech_lib_plus1, plus1_only_mode, MINUS1_ONLY,ctech_lib_minus1,minus1_only_mode, ENABLE_3TO1,ctech_lib_3to1_on, ~three2one_disable );
        end



        if (meta_disable) begin
            // -----------------------------------------------------------------------------
            // model for a doublesync flop without metastability modeling (two back-to-back flip flops)
            // -----------------------------------------------------------------------------
            forever begin
                @(posedge clk or negedge rstb);
                if (!rstb) begin
                    sync <= '0;
                end else begin
                    sync ={sync[0], d};
                end
            end
        end else begin
            // -----------------------------------------------------------------------------
            // SystemVerilog uses the same inital seed for each instance of every module in the system.
            // Create a unique seed for this module instance based on a hash of the initial seed and
            // the string containing the full hierarchical path of this instance.
            // -----------------------------------------------------------------------------
                int seed = $get_initial_random_seed();
                string inst;
                $sformat(inst,"%0m"); // get the full instance path
                for (int i=0; i<inst.len(); i++) begin
                    logic [31:0] ch;
                    ch = inst.getc(i);
                    seed = 37*seed + ch;
                end

                // Seed this initial block's random number generator with the new random, instance-based seed
                //$display("%0m: ctech_doublesync_rst initial random number seed is %x", seed);
                $srandom(seed);
            // -----------------------------------------------------------------------------
            // The following code must be in this initial block.  If it is moved to an always
            // block, the random seed that was created won't be used and all instances of this
            // module will start with the same seed.
            // -----------------------------------------------------------------------------

            if (MIN_PERIOD!=0) begin
                // -----------------------------------------------------------------------------
                // doublesync flop with random input delay modeling
                // -----------------------------------------------------------------------------
                integer dly;
                logic [WIDTH-1:0] d_dly;
                integer unsigned delay_clock_period;
                fork
                    if(SINGLE_BUS_META)
                       forever begin
                        @(d) begin
                               dly = $urandom_range(10,0);
                               delay_clock_period = MIN_PERIOD * (dly * 0.1);
                               d_dly <= #delay_clock_period d;
                        end
                       end
                    else
                       forever begin
                        @(d) begin
                             for( int l=0; l < WIDTH; l++) begin
                                dly = $urandom_range(10,0);
                                delay_clock_period = MIN_PERIOD * (dly * 0.1);
                                d_dly[l] <= #delay_clock_period d[l];
                             end
                        end
                       end

                    forever begin
                        @(posedge clk or negedge rstb);
                        if (!rstb) begin
                            {sync}<= '0;
                        end else begin
                            {sync}  <= {sync[0],d_dly};
                        end
                    end
                join_none

            end else begin
                // -----------------------------------------------------------------------------
                fork
                   case({SINGLE_BUS_META, three2one_disable,plus1_only_mode, minus1_only_mode})
                      4'b1110,
                      4'b1111,
                      4'b1101,
                      4'b1010,
                      4'b1011,
                      4'b1001: begin // Single and only +1 or -1 (3->1 is NOP)
                          forever begin
                              @(d) begin  // only update the random delay when the input data changes
                                dly = $urandom_range(1,0);
                              end
                          end
                      end
                      4'b1000:begin // Single and 3->1 is ok 
                         forever begin
                             @(d) begin  // only update the random delay when the input data changes
                                  dly = $urandom_range(3,1);
                             end
                         end
                      end
                      4'b1100 :begin  // Single and no 3->1
                         forever begin
                             @(d) begin  // only update the random delay when the input data changes
                                  case(past_delay[1:0])
                                    2'b01,2'b10: dly = $urandom_range(3,1);
                                    2'b11:       dly = $urandom_range(3,2);
                                    default : dly = 2'b10;
                                 endcase
                             end
                         end
                      end
                      4'b0110,
                      4'b0111,
                      4'b0101,
                      4'b0010,
                      4'b0011,
                      4'b0001: begin // NOT Single and only +1 or -1 (3->1 is NOP)
                          forever begin
                              @(d) begin  // only update the random delay when the input data changes
                                 // Could optimize to be bits based but need to handle greater then 32 bits
                                 for( int loop=1; loop <= WIDTH; loop++) begin
                                     dly[loop] = $urandom_range(1,0);
                                 end
                              end
                          end
                      end
                      4'b0000:begin // NOT Single and 3->1 is ok 
                         forever begin
                             @(d) begin  // only update the random delay when the input data changes
                                 for( int loop=0; loop < WIDTH; loop++) begin
                                    dly[(loop*2)+:2] = $urandom_range(3,1);
                                 end
                             end
                         end
                      end
                      4'b0100 :begin  // NOT Single and no 3->1
                         logic [2:1] temp;
                         forever begin
                             @(d) begin  // only update the random delay when the input data changes
                                 for( int loop=0; loop < WIDTH; loop++) begin
                                    case(past_delay[(loop*2)+:2])
                                      2'b01,2'b10: dly[(loop*2)+:2] = $urandom_range(3,1);
                                      2'b11: dly[(loop*2)+:2] = $urandom_range(3,2);
                                      default : dly[(loop*2)+:2] = 2'b10;
                                    endcase
                                 end
                             end
                         end
                     end
                   endcase // End of Randization calculations

                // doublesync flp with random N-1/N/N+1 delay modeling
                // The flop that is modle base is : 
                // d                                                       
                // +-+-------------+------------------+                     
                //   |             |                  |                     
                //   |          1|2|  +-+             |1 +-+                
                //   |   +------+  +--+ |   +------+  +--+ |   +------+    o
                //   +---+      |     | +---+      |     | +---+      +----+
                //       |dd_ff +-----+ |   |sync0 +---+-+ |   |sync1 |     
                //       |      |   3 +-+   |      |  3|2+-+   |      |     
                //       +------+           +------+           +------+     
                // The dly signal for plus1 and minus one modes only need to be single bit per sync 
                // The dly signal is encoded for three state mode. 
                //         0 is not used and not generated to avoid issue 
                //         1 - N-1 value 
                //         2 - N value 
                //         3 - N+1 value 
                //         When three2one_disable is true the randomizer ensures that eligal values are not generated
                     
                   case({SINGLE_BUS_META, three2one_disable,plus1_only_mode, minus1_only_mode})
                      4'b1010, 
                      4'b1011, 
                      4'b1110,
                      4'b1111: begin // plus1 mode with single random
                          if(minus1_only_mode) begin
                             $display("WARNING: %0m has both plus1_only and minus1_only set"); // Print warning with instance path
                          end
                          forever begin
                             
                             @(posedge clk or negedge rstb) begin
                                 if (!rstb) 
                                     {sync, dd_ff}<= '0;
                                 else
                                     {sync,dd_ff}  <= {sync[0], dly ? dd_ff : d, d};
                             end
                          end
                      end

                      4'b1101,
                      4'b1001: begin // minus1 mode with Single randmom
                          forever begin
                             @(posedge clk or negedge rstb)begin
                                 if (!rstb) 
                                     {sync}<= '0;
                                 else
                                     {sync}  <= {dly ? sync[0] : d, d};
                             end
                          end
                      end
                      4'b1000 ,       
                      4'b1100 :begin  // Single random with 3-1 options
                         forever begin
                            @(posedge clk or negedge rstb) begin
                                if (!rstb) 
                                     {sync, dd_ff}<= '0;
                                else 
                                 case(dly[1:0]) 
                                   2'b01: {sync,dd_ff}  <= { d, d, d};
                                   2'b10: {sync,dd_ff}  <= { sync[0], d, d};
                                   2'b11: {sync,dd_ff}  <= { sync[0], dd_ff, d};
                                 endcase
                                 past_delay<=dly;
                             end
                         end
                      end
                      4'b0010,
                      4'b0011,
                      4'b0110,
                      4'b0111:begin// NOT Single and only plus1 (3->1 is NOP)
                          if(minus1_only_mode) begin
                             $display("WARNING: %0m has both plus1_only and minus1_only set"); // Print warning with instance path
                          end
                          forever begin
                             @(posedge clk or negedge rstb) begin
                                if (!rstb) 
                                    {sync, dd_ff}<= '0;
                                else 
                                    for( int loop=0; loop <= WIDTH; loop++) begin
                                        {sync[1][loop],sync[0][loop],dd_ff[loop]}  <= {sync[0][loop], dly[loop] ? dd_ff[loop] : d[loop], d[loop]};
                                    end
                            end
                          end
                      end

                      4'b0101,
                      4'b0001: begin // NOT Single and only minus1 (3->1 is NOP)
                          forever begin
                             @(posedge clk or negedge rstb)begin
                                if (!rstb) 
                                    {sync,dd_ff}<= '0;
                                else 
                                    for( int loop=0; loop < WIDTH; loop++) begin
                                        {sync[1][loop],sync[0][loop]}  <= {dly[loop] ? sync[0][loop] : d[loop], d[loop]};
                                    end
                             end
                          end
                      end
                      4'b0000,
                      4'b0100:begin  // NOT Single and 3->1 is handeled by the random function
                         forever begin
                            @(posedge clk or negedge rstb) begin
                                if (!rstb) 
                                    {sync,dd_ff}<= '0;
                                else 
                                 for( int loop=0; loop < WIDTH; loop++) begin
                                     case(dly[loop*2+:2]) 
                                       2'b01: {sync[1][loop],sync[0][loop],dd_ff[loop]}  <= { d[loop], d[loop], d[loop]};
                                       2'b10: {sync[1][loop],sync[0][loop],dd_ff[loop]}  <= { sync[0][loop], d[loop], d[loop]};
                                       2'b11: {sync[1][loop],sync[0][loop],dd_ff[loop]}  <= { sync[0][loop], dd_ff[loop], d[loop]};
                                       default: {sync[1][loop],sync[0][loop],dd_ff[loop]}  <= { sync[0][loop], d[loop], d[loop]};
                                     endcase
                                  end
                                  past_delay<=dly;
                             end
                         end
                     end
                   endcase

                join_none
            end
        end
    end
    // -----------------------------------------------------------------------------
    // Properties and assertions to check for glitch-free inputs that are stable long
    // enough to guarantee that they will be correctly captured by the doublesync flop.

    // Verify input is stable for three clock edges (posedge and negedge)
    property p_stability (clk, rstb, logic d_in);
        @(clk) disable iff (!rstb | (pulse_width_check_disable!=0))
               !$stable(d_in) |=> $stable(d_in) [*2];
    endproperty

    // Check for glitches
    property p_no_glitch (clk, rstb, logic d_in);
        logic data;
        @(d_in) disable iff (!rstb)
                (1, data = !d_in) |=> @(posedge clk) (pulse_width_check_disable ? 1 : d_in == data);
    endproperty

//    generate
//            CDCAsyncRstInputStableCheck : assert property(p_stability(clk, rstb, d)) else $error("%m failed.");
//            CDCAsyncRstInputGlitchCheck : assert property(p_no_glitch(clk, rstb, d)) else $error("%m failed.");
//    endgenerate
`endif
`endif
endmodule // ctech_doublesync_rst

//lintra pop
