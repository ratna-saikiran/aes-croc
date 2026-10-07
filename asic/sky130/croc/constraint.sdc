# Croc SoC (croc_soc, core only, no pads) on sky130hd.
# Adapted from openroad/src/constraints.sdc; clocks relaxed for a first Sky130 run.

set TCK_SYS 40.0
set TCK_JTG 100.0
set TCK_RTC 100.0

create_clock -name clk_sys -period $TCK_SYS [get_ports clk_i]
create_clock -name clk_jtg -period $TCK_JTG [get_ports jtag_tck_i]
create_clock -name clk_rtc -period $TCK_RTC [get_ports ref_clk_i]

set_clock_groups -asynchronous -name clk_groups_async \
  -group {clk_rtc} -group {clk_jtg} -group {clk_sys}

set_clock_uncertainty 0.25 [all_clocks]
set_clock_transition  0.5  [all_clocks]

# Reset and test mode: quasi-static
set_input_delay -max [expr $TCK_SYS * 0.10] [get_ports {rst_ni testmode_i}]
set_false_path -hold -from [get_ports {rst_ni testmode_i}]

# JTAG
set_input_delay  -clock clk_jtg [expr $TCK_JTG * 0.30] [get_ports {jtag_tdi_i jtag_tms_i jtag_trst_ni}]
set_output_delay -clock clk_jtg [expr $TCK_JTG * 0.20] [get_ports jtag_tdo_o]
set_false_path -hold -from [get_ports jtag_trst_ni]

# GPIO, UART, status
set_input_delay  -clock clk_sys [expr $TCK_SYS * 0.30] [get_ports {gpio_i* uart_rx_i}]
set_output_delay -clock clk_sys [expr $TCK_SYS * 0.30] [get_ports {gpio_o* gpio_out_en_o* uart_tx_o status_o}]
