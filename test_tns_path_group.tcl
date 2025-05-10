# Test script for TNS path group reporting
# This script creates a simple design with timing violations to test TNS reporting

# Create a simple design with timing violations
read_liberty test/asap7_small.lib
read_verilog simple_design.v
link_design top

# Create clock
create_clock -name clk -period 10 [get_ports clk]

# Set input/output delays to create timing violations
set_input_delay -clock clk 8 [get_ports in1]
set_input_delay -clock clk 8 [get_ports in2]
set_output_delay -clock clk 6 [get_ports out]

# Create path groups
group_path -name comb -from [all_inputs] -to [all_registers]
group_path -name reg2reg -from [all_registers] -to [all_registers]
group_path -name reg2out -from [all_registers] -to [all_outputs]

# Report timing
report_checks -path_group comb
report_checks -path_group reg2reg
report_checks -path_group reg2out

# Report TNS
report_tns

# Report TNS for specific path group
report_tns -path_group comb
report_tns -path_group reg2reg
report_tns -path_group reg2out

# Test with different options
puts "\n=== TNS Report with 3 Decimal Places ==="
report_tns -by_path_group -digits 3

puts "\n=== TNS Report for Min Paths ==="
report_tns -by_path_group -min 