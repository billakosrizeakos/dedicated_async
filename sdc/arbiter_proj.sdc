###############################################################################
# Created by write_sdc
# Wed Oct  9 09:21:53 2024
###############################################################################
current_design arbiter_proj
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name wb_clk_i -period 25.0000 
set_clock_uncertainty 0.2500 wb_clk_i
set_input_delay 5.0000 -clock [get_clocks {wb_clk_i}] -add_delay [get_ports {io_in[0]}]
set_input_delay 5.0000 -clock [get_clocks {wb_clk_i}] -add_delay [get_ports {io_in[1]}]
set_input_delay 5.0000 -clock [get_clocks {wb_clk_i}] -add_delay [get_ports {io_in[2]}]
set_output_delay 5.0000 -clock [get_clocks {wb_clk_i}] -add_delay [get_ports {io_out[0]}]
set_output_delay 5.0000 -clock [get_clocks {wb_clk_i}] -add_delay [get_ports {io_out[1]}]
set_output_delay 5.0000 -clock [get_clocks {wb_clk_i}] -add_delay [get_ports {io_out[2]}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {io_out[2]}]
set_load -pin_load 0.0334 [get_ports {io_out[1]}]
set_load -pin_load 0.0334 [get_ports {io_out[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 1.0000 [current_design]
set_max_fanout 16.0000 [current_design]
