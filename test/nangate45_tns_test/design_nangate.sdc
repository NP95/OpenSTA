# SDC for design_nangate.v using Nangate45
# Using OpenSTA's recommended approach for path group definition

# Clock definition - aggressive to create timing violations
create_clock -name core_clk -period 0.05 [get_ports clk]

# Input delays
set_input_delay -clock core_clk 0.02 [get_ports in1]

# Output delays
set_output_delay -clock core_clk 0.02 [get_ports out1]

# Clock uncertainty (jitter)
set_clock_uncertainty 0.01 [get_clocks core_clk]

# Clock latency
set_clock_latency 0.02 [get_clocks core_clk]

# Clock transitions
set_clock_transition 0.01 [get_clocks core_clk]

# Input transition
set_input_transition 0.02 [get_ports in1]

# Set driving cell
set_driving_cell -lib_cell INV_X1 [get_ports in1]

# Set load on outputs
set_load -pin_load 0.01 [get_ports out1]

# Define path groups using OpenSTA's standard approach
# These use built-in collections rather than specific instance names
group_path -name In2Reg -from [all_inputs] -to [all_registers -data_pins]
group_path -name Reg2Reg -from [all_registers -clock_pins] -to [all_registers -data_pins]
group_path -name Reg2Out -from [all_registers -clock_pins] -to [all_outputs]

# Note: We're not defining custom path groups as they're not needed for the TNS test.
# The default 'core_clk' path group is already showing timing violations with TNS = -0.26 