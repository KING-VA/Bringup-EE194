// ================================================================
// NVDLA Open Source Project
//
// Copyright(c) 2016 - 2017 NVIDIA Corporation. Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with
// this distribution for more information.
// ================================================================
// File Name: NV_NVDLA_SDP_cmux.v
`include "simulate_x_tick.vh"
// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================
// File Name: NV_NVDLA_SDP_define.h
module NV_NVDLA_SDP_cmux (
   nvdla_core_clk //|< i
  ,nvdla_core_rstn //|< i
  ,cacc2sdp_pd //|< i
  ,cacc2sdp_valid //|< i
  ,op_en_load //|< i
  ,reg2dp_flying_mode //|< i
  ,reg2dp_nan_to_zero //|< i
  ,reg2dp_proc_precision //|< i
  ,sdp_cmux2dp_ready //|< i
  ,sdp_mrdma2cmux_pd //|< i
  ,sdp_mrdma2cmux_valid //|< i
  ,cacc2sdp_ready //|> o
  ,sdp_cmux2dp_pd //|> o
  ,sdp_cmux2dp_valid //|> o
  ,sdp_mrdma2cmux_ready //|> o
  );
//
// NV_NVDLA_SDP_cmux_ports.v
//
input nvdla_core_clk;
input nvdla_core_rstn;
input cacc2sdp_valid; /* data valid */
output cacc2sdp_ready; /* data return handshake */
input [32*16 +1:0] cacc2sdp_pd;
input sdp_mrdma2cmux_valid; /* data valid */
output sdp_mrdma2cmux_ready; /* data return handshake */
input [32*16 +1:0] sdp_mrdma2cmux_pd;
output sdp_cmux2dp_valid;
input sdp_cmux2dp_ready;
output [32*16 -1:0] sdp_cmux2dp_pd;
input reg2dp_flying_mode;
input reg2dp_nan_to_zero;
input [1:0] reg2dp_proc_precision;
input op_en_load;
reg cfg_flying_mode_on;
reg cfg_proc_precision;
reg cmux_in_en;
wire cacc_rdy;
wire cacc_vld;
wire [32*16 +1:0] cacc_pd;
wire [32*16 +1:0] cmux_pd;
wire cmux_pd_batch_end;
wire cmux_pd_layer_end;
wire cmux_pd_flush_batch_end_NC;
wire [32*16 -1:0] cmux_pd_flush_data;
wire cmux2dp_prdy;
wire cmux2dp_pvld;
wire [32*16 -1:0] cmux2dp_pd;
//=======================
// CFG
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_flying_mode_on <= 1'b0;
  end else begin
  cfg_flying_mode_on <= reg2dp_flying_mode == 1'h1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_proc_precision <= 1'b0;
  end else begin
  cfg_proc_precision <= reg2dp_proc_precision == 2'h2;
  end
end
NV_NVDLA_SDP_CMUX_pipe_p1 pipe_p1 (
   .nvdla_core_clk (nvdla_core_clk) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn) //|< i
  ,.cacc2sdp_pd (cacc2sdp_pd[32*16 +1:0]) //|< i
  ,.cacc2sdp_valid (cacc2sdp_valid) //|< i
  ,.cacc_rdy (cacc_rdy) //|< w
  ,.cacc2sdp_ready (cacc2sdp_ready) //|> o
  ,.cacc_pd (cacc_pd[32*16 +1:0]) //|> w
  ,.cacc_vld (cacc_vld) //|> w
  );
assign cmux2dp_pvld = cmux_in_en & ((cfg_flying_mode_on) ? cacc_vld : sdp_mrdma2cmux_valid);
assign cacc_rdy = cmux_in_en & cfg_flying_mode_on & cmux2dp_prdy;
assign sdp_mrdma2cmux_ready = cmux_in_en & (!cfg_flying_mode_on) & cmux2dp_prdy;
//===========================================
// Layer Switch
//===========================================
assign cmux_pd = (cfg_flying_mode_on) ? cacc_pd : sdp_mrdma2cmux_pd;
assign cmux_pd_batch_end = cmux_pd[32*16];
assign cmux_pd_layer_end = cmux_pd[32*16 +1];
assign cmux_pd_flush_batch_end_NC = cmux_pd_batch_end;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmux_in_en <= 1'b0;
  end else begin
    if (op_en_load) begin
       cmux_in_en <= 1'b1;
    end else if (cmux_pd_layer_end && cmux2dp_pvld && cmux2dp_prdy) begin
       cmux_in_en <= 1'b0;
    end
  end
end
assign cmux2dp_pd[32*16 -1:0] = cmux_pd[32*16 -1:0];
NV_NVDLA_SDP_CMUX_pipe_p2 pipe_p2 (
   .nvdla_core_clk (nvdla_core_clk) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn) //|< i
  ,.cmux2dp_pd (cmux2dp_pd[32*16 -1:0]) //|< w
  ,.cmux2dp_pvld (cmux2dp_pvld) //|< w
  ,.sdp_cmux2dp_ready (sdp_cmux2dp_ready) //|< i
  ,.cmux2dp_prdy (cmux2dp_prdy) //|> w
  ,.sdp_cmux2dp_pd (sdp_cmux2dp_pd[32*16 -1:0]) //|> o
  ,.sdp_cmux2dp_valid (sdp_cmux2dp_valid) //|> o
  );
endmodule // NV_NVDLA_SDP_cmux
// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cacc_pd (cacc_vld, cacc_rdy) <= cacc2sdp_pd (cacc2sdp_valid, cacc2sdp_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CMUX_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cacc2sdp_pd
  ,cacc2sdp_valid
  ,cacc2sdp_ready
  ,cacc_rdy
  ,cacc_pd
  ,cacc_vld
  );
input nvdla_core_clk;
input nvdla_core_rstn;
input [32*16 +1:0] cacc2sdp_pd;
input cacc2sdp_valid;
output cacc2sdp_ready;
input cacc_rdy;
output cacc_vld;
output [32*16 +1:0] cacc_pd;
//: my $dw = 32*16 +2;
//: &eperl::pipe("-is -wid $dw -do cacc_pd -vo cacc_vld -ri cacc_rdy -di cacc2sdp_pd -vi cacc2sdp_valid -ro cacc2sdp_ready");
//| eperl: generated_beg (DO NOT EDIT BELOW)
// Reg
reg cacc2sdp_ready;
reg skid_flop_cacc2sdp_ready;
reg skid_flop_cacc2sdp_valid;
reg [514-1:0] skid_flop_cacc2sdp_pd;
reg pipe_skid_cacc2sdp_valid;
reg [514-1:0] pipe_skid_cacc2sdp_pd;
// Wire
wire skid_cacc2sdp_valid;
wire [514-1:0] skid_cacc2sdp_pd;
wire skid_cacc2sdp_ready;
wire pipe_skid_cacc2sdp_ready;
wire cacc_vld;
wire [514-1:0] cacc_pd;
// Code
// SKID READY
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
       cacc2sdp_ready <= 1'b1;
       skid_flop_cacc2sdp_ready <= 1'b1;
   end else begin
       cacc2sdp_ready <= skid_cacc2sdp_ready;
       skid_flop_cacc2sdp_ready <= skid_cacc2sdp_ready;
   end
end

// SKID VALID
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        skid_flop_cacc2sdp_valid <= 1'b0;
    end else begin
        if (skid_flop_cacc2sdp_ready) begin
            skid_flop_cacc2sdp_valid <= cacc2sdp_valid;
        end
   end
end
assign skid_cacc2sdp_valid = (skid_flop_cacc2sdp_ready) ? cacc2sdp_valid : skid_flop_cacc2sdp_valid;

// SKID DATA
always @(posedge nvdla_core_clk) begin
    if (skid_flop_cacc2sdp_ready & cacc2sdp_valid) begin
        skid_flop_cacc2sdp_pd[514-1:0] <= cacc2sdp_pd[514-1:0];
    end
end
assign skid_cacc2sdp_pd[514-1:0] = (skid_flop_cacc2sdp_ready) ? cacc2sdp_pd[514-1:0] : skid_flop_cacc2sdp_pd[514-1:0];


// PIPE READY
assign skid_cacc2sdp_ready = pipe_skid_cacc2sdp_ready || !pipe_skid_cacc2sdp_valid;

// PIPE VALID
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        pipe_skid_cacc2sdp_valid <= 1'b0;
    end else begin
        if (skid_cacc2sdp_ready) begin
            pipe_skid_cacc2sdp_valid <= skid_cacc2sdp_valid;
        end
    end
end

// PIPE DATA
always @(posedge nvdla_core_clk) begin
    if (skid_cacc2sdp_ready && skid_cacc2sdp_valid) begin
        pipe_skid_cacc2sdp_pd[514-1:0] <= skid_cacc2sdp_pd[514-1:0];
    end
end


// PIPE OUTPUT
assign pipe_skid_cacc2sdp_ready = cacc_rdy;
assign cacc_vld = pipe_skid_cacc2sdp_valid;
assign cacc_pd = pipe_skid_cacc2sdp_pd;

//| eperl: generated_end (DO NOT EDIT ABOVE)
endmodule // NV_NVDLA_SDP_CMUX_pipe_p1
// **************************************************************************************************************
// Generated by ::pipe -m -bc -is sdp_cmux2dp_pd (sdp_cmux2dp_valid,sdp_cmux2dp_ready) <= cmux2dp_pd[511:0] (cmux2dp_pvld,cmux2dp_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CMUX_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cmux2dp_pd
  ,cmux2dp_pvld
  ,cmux2dp_prdy
  ,sdp_cmux2dp_ready
  ,sdp_cmux2dp_pd
  ,sdp_cmux2dp_valid
  );
input nvdla_core_clk;
input nvdla_core_rstn;
input [32*16 -1:0] cmux2dp_pd;
input cmux2dp_pvld;
output cmux2dp_prdy;
output [32*16 -1:0] sdp_cmux2dp_pd;
output sdp_cmux2dp_valid;
input sdp_cmux2dp_ready;
//: my $dw = 32*16;
//: &eperl::pipe("-is -wid $dw -do sdp_cmux2dp_pd -vo sdp_cmux2dp_valid -ri sdp_cmux2dp_ready -di cmux2dp_pd -vi cmux2dp_pvld -ro cmux2dp_prdy");
//| eperl: generated_beg (DO NOT EDIT BELOW)
// Reg
reg cmux2dp_prdy;
reg skid_flop_cmux2dp_prdy;
reg skid_flop_cmux2dp_pvld;
reg [512-1:0] skid_flop_cmux2dp_pd;
reg pipe_skid_cmux2dp_pvld;
reg [512-1:0] pipe_skid_cmux2dp_pd;
// Wire
wire skid_cmux2dp_pvld;
wire [512-1:0] skid_cmux2dp_pd;
wire skid_cmux2dp_prdy;
wire pipe_skid_cmux2dp_prdy;
wire sdp_cmux2dp_valid;
wire [512-1:0] sdp_cmux2dp_pd;
// Code
// SKID READY
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
       cmux2dp_prdy <= 1'b1;
       skid_flop_cmux2dp_prdy <= 1'b1;
   end else begin
       cmux2dp_prdy <= skid_cmux2dp_prdy;
       skid_flop_cmux2dp_prdy <= skid_cmux2dp_prdy;
   end
end

// SKID VALID
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        skid_flop_cmux2dp_pvld <= 1'b0;
    end else begin
        if (skid_flop_cmux2dp_prdy) begin
            skid_flop_cmux2dp_pvld <= cmux2dp_pvld;
        end
   end
end
assign skid_cmux2dp_pvld = (skid_flop_cmux2dp_prdy) ? cmux2dp_pvld : skid_flop_cmux2dp_pvld;

// SKID DATA
always @(posedge nvdla_core_clk) begin
    if (skid_flop_cmux2dp_prdy & cmux2dp_pvld) begin
        skid_flop_cmux2dp_pd[512-1:0] <= cmux2dp_pd[512-1:0];
    end
end
assign skid_cmux2dp_pd[512-1:0] = (skid_flop_cmux2dp_prdy) ? cmux2dp_pd[512-1:0] : skid_flop_cmux2dp_pd[512-1:0];


// PIPE READY
assign skid_cmux2dp_prdy = pipe_skid_cmux2dp_prdy || !pipe_skid_cmux2dp_pvld;

// PIPE VALID
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        pipe_skid_cmux2dp_pvld <= 1'b0;
    end else begin
        if (skid_cmux2dp_prdy) begin
            pipe_skid_cmux2dp_pvld <= skid_cmux2dp_pvld;
        end
    end
end

// PIPE DATA
always @(posedge nvdla_core_clk) begin
    if (skid_cmux2dp_prdy && skid_cmux2dp_pvld) begin
        pipe_skid_cmux2dp_pd[512-1:0] <= skid_cmux2dp_pd[512-1:0];
    end
end


// PIPE OUTPUT
assign pipe_skid_cmux2dp_prdy = sdp_cmux2dp_ready;
assign sdp_cmux2dp_valid = pipe_skid_cmux2dp_pvld;
assign sdp_cmux2dp_pd = pipe_skid_cmux2dp_pd;

//| eperl: generated_end (DO NOT EDIT ABOVE)
endmodule // NV_NVDLA_SDP_CMUX_pipe_p2
