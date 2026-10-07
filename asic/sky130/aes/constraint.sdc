# 50 MHz to start; tighten once the first run closes timing.
set clk_name   core_clock
set clk_port   clk_i
set clk_period 20.0
set io_delay   [expr $clk_period * 0.2]

create_clock -name $clk_name -period $clk_period [get_ports $clk_port]

set non_clk_inputs [lsearch -inline -all -not -exact [all_inputs] [get_ports $clk_port]]
set_input_delay  $io_delay -clock $clk_name $non_clk_inputs
set_output_delay $io_delay -clock $clk_name [all_outputs]
