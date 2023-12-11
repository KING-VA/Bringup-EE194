#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
# CLOCK
create_clock -period 10 [get_ports CLK_100_B2A]
create_clock -period "30.72MHz" [get_ports CLK_30M72]
create_clock -period 20 [get_ports CLK_50_B2A]
create_clock -period 20 [get_ports CLK_50_B2D]
create_clock -period 20 [get_ports CLK_50_B3A]
create_clock -period 20 [get_ports CLK_50_B3C]
# DDR4A
create_clock -period 30 [get_ports DDR4A_REFCLK_p]
# DDR4B
create_clock -period 30 [get_ports DDR4B_REFCLK_p]
# FMC
create_clock -period "156.25MHz" [get_ports FMC_REFCLK0_p]
create_clock -period "184.32MHz" [get_ports FMC_REFCLK1_p]
# FMCP PCIe clock
create_clock -period "100.0MHz" [get_ports FMCP_GBTCLK_M2C_p[0]]
create_clock -period "100.0MHz" [get_ports FMCP_GBTCLK_M2C_p[1]]
# QSFP28
create_clock -period "156.25MHz" [get_ports QSFP28_REFCLK_p]
# QSFP28RSV
create_clock -period "184.32MHz" [get_ports QSFP28RSV_REFCLK_p]


# serial-tl
create_clock -period "100MHz" [get_ports FMCP_LA_p[2]]


#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



