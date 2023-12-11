// Generated by CIRCT unknown git version
// Standard header to adapt well known macros to our needs.
`ifndef RANDOMIZE
  `ifdef RANDOMIZE_REG_INIT
    `define RANDOMIZE
  `endif // RANDOMIZE_REG_INIT
`endif // not def RANDOMIZE
`ifndef RANDOMIZE
  `ifdef RANDOMIZE_MEM_INIT
    `define RANDOMIZE
  `endif // RANDOMIZE_MEM_INIT
`endif // not def RANDOMIZE

// RANDOM may be set to an expression that produces a 32-bit random unsigned value.
`ifndef RANDOM
  `define RANDOM $random
`endif // not def RANDOM

// Users can define 'PRINTF_COND' to add an extra gate to prints.
`ifndef PRINTF_COND_
  `ifdef PRINTF_COND
    `define PRINTF_COND_ (`PRINTF_COND)
  `else  // PRINTF_COND
    `define PRINTF_COND_ 1
  `endif // PRINTF_COND
`endif // not def PRINTF_COND_

// Users can define 'ASSERT_VERBOSE_COND' to add an extra gate to assert error printing.
`ifndef ASSERT_VERBOSE_COND_
  `ifdef ASSERT_VERBOSE_COND
    `define ASSERT_VERBOSE_COND_ (`ASSERT_VERBOSE_COND)
  `else  // ASSERT_VERBOSE_COND
    `define ASSERT_VERBOSE_COND_ 1
  `endif // ASSERT_VERBOSE_COND
`endif // not def ASSERT_VERBOSE_COND_

// Users can define 'STOP_COND' to add an extra gate to stop conditions.
`ifndef STOP_COND_
  `ifdef STOP_COND
    `define STOP_COND_ (`STOP_COND)
  `else  // STOP_COND
    `define STOP_COND_ 1
  `endif // STOP_COND
`endif // not def STOP_COND_

// Users can define INIT_RANDOM as general code that gets injected into the
// initializer block for modules with registers.
`ifndef INIT_RANDOM
  `define INIT_RANDOM
`endif // not def INIT_RANDOM

// If using random initialization, you can also define RANDOMIZE_DELAY to
// customize the delay used, otherwise 0.002 is used.
`ifndef RANDOMIZE_DELAY
  `define RANDOMIZE_DELAY 0.002
`endif // not def RANDOMIZE_DELAY

// Define INIT_RANDOM_PROLOG_ for use in our modules below.
`ifndef INIT_RANDOM_PROLOG_
  `ifdef RANDOMIZE
    `ifdef VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM
    `else  // VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM #`RANDOMIZE_DELAY begin end
    `endif // VERILATOR
  `else  // RANDOMIZE
    `define INIT_RANDOM_PROLOG_
  `endif // RANDOMIZE
`endif // not def INIT_RANDOM_PROLOG_

module ClockSinkDomain_2(
  input         auto_routers_egress_nodes_out_1_flit_ready,
                auto_routers_egress_nodes_out_0_flit_ready,
                auto_routers_ingress_nodes_in_2_flit_valid,
                auto_routers_ingress_nodes_in_2_flit_bits_head,
  input  [72:0] auto_routers_ingress_nodes_in_2_flit_bits_payload,
  input  [4:0]  auto_routers_ingress_nodes_in_2_flit_bits_egress_id,
  input         auto_routers_ingress_nodes_in_1_flit_valid,
                auto_routers_ingress_nodes_in_1_flit_bits_head,
                auto_routers_ingress_nodes_in_1_flit_bits_tail,
  input  [72:0] auto_routers_ingress_nodes_in_1_flit_bits_payload,
  input  [4:0]  auto_routers_ingress_nodes_in_1_flit_bits_egress_id,
  input         auto_routers_ingress_nodes_in_0_flit_valid,
                auto_routers_ingress_nodes_in_0_flit_bits_head,
                auto_routers_ingress_nodes_in_0_flit_bits_tail,
  input  [72:0] auto_routers_ingress_nodes_in_0_flit_bits_payload,
  input  [4:0]  auto_routers_ingress_nodes_in_0_flit_bits_egress_id,
  input  [9:0]  auto_routers_source_nodes_out_credit_return,
                auto_routers_source_nodes_out_vc_free,
  input         auto_routers_dest_nodes_in_flit_0_valid,
                auto_routers_dest_nodes_in_flit_0_bits_head,
                auto_routers_dest_nodes_in_flit_0_bits_tail,
  input  [72:0] auto_routers_dest_nodes_in_flit_0_bits_payload,
  input  [2:0]  auto_routers_dest_nodes_in_flit_0_bits_flow_vnet_id,
  input  [3:0]  auto_routers_dest_nodes_in_flit_0_bits_flow_ingress_node,
  input  [2:0]  auto_routers_dest_nodes_in_flit_0_bits_flow_ingress_node_id,
  input  [3:0]  auto_routers_dest_nodes_in_flit_0_bits_flow_egress_node,
  input  [2:0]  auto_routers_dest_nodes_in_flit_0_bits_flow_egress_node_id,
  input  [3:0]  auto_routers_dest_nodes_in_flit_0_bits_virt_channel_id,
  input         auto_clock_in_clock,
                auto_clock_in_reset,
  output [3:0]  auto_routers_debug_out_va_stall_0,
                auto_routers_debug_out_va_stall_1,
                auto_routers_debug_out_va_stall_2,
                auto_routers_debug_out_va_stall_3,
                auto_routers_debug_out_sa_stall_0,
                auto_routers_debug_out_sa_stall_1,
                auto_routers_debug_out_sa_stall_2,
                auto_routers_debug_out_sa_stall_3,
  output        auto_routers_egress_nodes_out_1_flit_valid,
                auto_routers_egress_nodes_out_1_flit_bits_head,
                auto_routers_egress_nodes_out_1_flit_bits_tail,
  output [72:0] auto_routers_egress_nodes_out_1_flit_bits_payload,
  output        auto_routers_egress_nodes_out_0_flit_valid,
                auto_routers_egress_nodes_out_0_flit_bits_head,
                auto_routers_egress_nodes_out_0_flit_bits_tail,
  output [72:0] auto_routers_egress_nodes_out_0_flit_bits_payload,
  output        auto_routers_ingress_nodes_in_2_flit_ready,
                auto_routers_ingress_nodes_in_1_flit_ready,
                auto_routers_ingress_nodes_in_0_flit_ready,
                auto_routers_source_nodes_out_flit_0_valid,
                auto_routers_source_nodes_out_flit_0_bits_head,
                auto_routers_source_nodes_out_flit_0_bits_tail,
  output [72:0] auto_routers_source_nodes_out_flit_0_bits_payload,
  output [2:0]  auto_routers_source_nodes_out_flit_0_bits_flow_vnet_id,
  output [3:0]  auto_routers_source_nodes_out_flit_0_bits_flow_ingress_node,
  output [2:0]  auto_routers_source_nodes_out_flit_0_bits_flow_ingress_node_id,
  output [3:0]  auto_routers_source_nodes_out_flit_0_bits_flow_egress_node,
  output [2:0]  auto_routers_source_nodes_out_flit_0_bits_flow_egress_node_id,
  output [3:0]  auto_routers_source_nodes_out_flit_0_bits_virt_channel_id,
  output [9:0]  auto_routers_dest_nodes_in_credit_return,
                auto_routers_dest_nodes_in_vc_free
);

  Router_2 routers (	// @[NoC.scala:64:22]
    .clock                                                  (auto_clock_in_clock),
    .reset                                                  (auto_clock_in_reset),
    .auto_egress_nodes_out_1_flit_ready                     (auto_routers_egress_nodes_out_1_flit_ready),
    .auto_egress_nodes_out_0_flit_ready                     (auto_routers_egress_nodes_out_0_flit_ready),
    .auto_ingress_nodes_in_2_flit_valid                     (auto_routers_ingress_nodes_in_2_flit_valid),
    .auto_ingress_nodes_in_2_flit_bits_head                 (auto_routers_ingress_nodes_in_2_flit_bits_head),
    .auto_ingress_nodes_in_2_flit_bits_payload              (auto_routers_ingress_nodes_in_2_flit_bits_payload),
    .auto_ingress_nodes_in_2_flit_bits_egress_id            (auto_routers_ingress_nodes_in_2_flit_bits_egress_id),
    .auto_ingress_nodes_in_1_flit_valid                     (auto_routers_ingress_nodes_in_1_flit_valid),
    .auto_ingress_nodes_in_1_flit_bits_head                 (auto_routers_ingress_nodes_in_1_flit_bits_head),
    .auto_ingress_nodes_in_1_flit_bits_tail                 (auto_routers_ingress_nodes_in_1_flit_bits_tail),
    .auto_ingress_nodes_in_1_flit_bits_payload              (auto_routers_ingress_nodes_in_1_flit_bits_payload),
    .auto_ingress_nodes_in_1_flit_bits_egress_id            (auto_routers_ingress_nodes_in_1_flit_bits_egress_id),
    .auto_ingress_nodes_in_0_flit_valid                     (auto_routers_ingress_nodes_in_0_flit_valid),
    .auto_ingress_nodes_in_0_flit_bits_head                 (auto_routers_ingress_nodes_in_0_flit_bits_head),
    .auto_ingress_nodes_in_0_flit_bits_tail                 (auto_routers_ingress_nodes_in_0_flit_bits_tail),
    .auto_ingress_nodes_in_0_flit_bits_payload              (auto_routers_ingress_nodes_in_0_flit_bits_payload),
    .auto_ingress_nodes_in_0_flit_bits_egress_id            (auto_routers_ingress_nodes_in_0_flit_bits_egress_id),
    .auto_source_nodes_out_credit_return                    (auto_routers_source_nodes_out_credit_return),
    .auto_source_nodes_out_vc_free                          (auto_routers_source_nodes_out_vc_free),
    .auto_dest_nodes_in_flit_0_valid                        (auto_routers_dest_nodes_in_flit_0_valid),
    .auto_dest_nodes_in_flit_0_bits_head                    (auto_routers_dest_nodes_in_flit_0_bits_head),
    .auto_dest_nodes_in_flit_0_bits_tail                    (auto_routers_dest_nodes_in_flit_0_bits_tail),
    .auto_dest_nodes_in_flit_0_bits_payload                 (auto_routers_dest_nodes_in_flit_0_bits_payload),
    .auto_dest_nodes_in_flit_0_bits_flow_vnet_id            (auto_routers_dest_nodes_in_flit_0_bits_flow_vnet_id),
    .auto_dest_nodes_in_flit_0_bits_flow_ingress_node       (auto_routers_dest_nodes_in_flit_0_bits_flow_ingress_node),
    .auto_dest_nodes_in_flit_0_bits_flow_ingress_node_id    (auto_routers_dest_nodes_in_flit_0_bits_flow_ingress_node_id),
    .auto_dest_nodes_in_flit_0_bits_flow_egress_node        (auto_routers_dest_nodes_in_flit_0_bits_flow_egress_node),
    .auto_dest_nodes_in_flit_0_bits_flow_egress_node_id     (auto_routers_dest_nodes_in_flit_0_bits_flow_egress_node_id),
    .auto_dest_nodes_in_flit_0_bits_virt_channel_id         (auto_routers_dest_nodes_in_flit_0_bits_virt_channel_id),
    .auto_debug_out_va_stall_0                              (auto_routers_debug_out_va_stall_0),
    .auto_debug_out_va_stall_1                              (auto_routers_debug_out_va_stall_1),
    .auto_debug_out_va_stall_2                              (auto_routers_debug_out_va_stall_2),
    .auto_debug_out_va_stall_3                              (auto_routers_debug_out_va_stall_3),
    .auto_debug_out_sa_stall_0                              (auto_routers_debug_out_sa_stall_0),
    .auto_debug_out_sa_stall_1                              (auto_routers_debug_out_sa_stall_1),
    .auto_debug_out_sa_stall_2                              (auto_routers_debug_out_sa_stall_2),
    .auto_debug_out_sa_stall_3                              (auto_routers_debug_out_sa_stall_3),
    .auto_egress_nodes_out_1_flit_valid                     (auto_routers_egress_nodes_out_1_flit_valid),
    .auto_egress_nodes_out_1_flit_bits_head                 (auto_routers_egress_nodes_out_1_flit_bits_head),
    .auto_egress_nodes_out_1_flit_bits_tail                 (auto_routers_egress_nodes_out_1_flit_bits_tail),
    .auto_egress_nodes_out_1_flit_bits_payload              (auto_routers_egress_nodes_out_1_flit_bits_payload),
    .auto_egress_nodes_out_0_flit_valid                     (auto_routers_egress_nodes_out_0_flit_valid),
    .auto_egress_nodes_out_0_flit_bits_head                 (auto_routers_egress_nodes_out_0_flit_bits_head),
    .auto_egress_nodes_out_0_flit_bits_tail                 (auto_routers_egress_nodes_out_0_flit_bits_tail),
    .auto_egress_nodes_out_0_flit_bits_payload              (auto_routers_egress_nodes_out_0_flit_bits_payload),
    .auto_ingress_nodes_in_2_flit_ready                     (auto_routers_ingress_nodes_in_2_flit_ready),
    .auto_ingress_nodes_in_1_flit_ready                     (auto_routers_ingress_nodes_in_1_flit_ready),
    .auto_ingress_nodes_in_0_flit_ready                     (auto_routers_ingress_nodes_in_0_flit_ready),
    .auto_source_nodes_out_flit_0_valid                     (auto_routers_source_nodes_out_flit_0_valid),
    .auto_source_nodes_out_flit_0_bits_head                 (auto_routers_source_nodes_out_flit_0_bits_head),
    .auto_source_nodes_out_flit_0_bits_tail                 (auto_routers_source_nodes_out_flit_0_bits_tail),
    .auto_source_nodes_out_flit_0_bits_payload              (auto_routers_source_nodes_out_flit_0_bits_payload),
    .auto_source_nodes_out_flit_0_bits_flow_vnet_id         (auto_routers_source_nodes_out_flit_0_bits_flow_vnet_id),
    .auto_source_nodes_out_flit_0_bits_flow_ingress_node    (auto_routers_source_nodes_out_flit_0_bits_flow_ingress_node),
    .auto_source_nodes_out_flit_0_bits_flow_ingress_node_id (auto_routers_source_nodes_out_flit_0_bits_flow_ingress_node_id),
    .auto_source_nodes_out_flit_0_bits_flow_egress_node     (auto_routers_source_nodes_out_flit_0_bits_flow_egress_node),
    .auto_source_nodes_out_flit_0_bits_flow_egress_node_id  (auto_routers_source_nodes_out_flit_0_bits_flow_egress_node_id),
    .auto_source_nodes_out_flit_0_bits_virt_channel_id      (auto_routers_source_nodes_out_flit_0_bits_virt_channel_id),
    .auto_dest_nodes_in_credit_return                       (auto_routers_dest_nodes_in_credit_return),
    .auto_dest_nodes_in_vc_free                             (auto_routers_dest_nodes_in_vc_free)
  );
endmodule

