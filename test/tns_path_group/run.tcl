puts "DEBUG: Starting run.tcl"
# Test TNS path group reporting

# source [file join [file dirname [info script]] .. helpers.tcl]
read_liberty [file join [file dirname [info script]] .. nangate45.lib]
read_verilog [file join [file dirname [info script]] .. reg_to_reg.v]
link_design top

create_clock -name clk1 -period 10 {clk1}
create_clock -name clk2 -period 8 {clk2}

# Set constraints that will create negative slack
set_input_delay -clock clk1 8 {in1}
set_output_delay -clock clk2 6 {out1}

# Create path groups
group_path -name Reg2Reg -from [all_registers] -to [all_registers]
group_path -name In2Reg -from [all_inputs] -to [all_registers]
group_path -name Reg2Out -from [all_registers] -to [all_outputs]

# Test standard TNS reporting
report_tns -max
report_tns -min

# Test path group specific reporting
puts "Testing path group specific reporting..."
puts "DEBUG: Is sta::report_tns a command? [info commands sta::report_tns]"
puts "DEBUG: About to call report_tns -path_group Reg2Reg"
sta::report_tns -path_group Reg2Reg
sta::report_tns -path_group In2Reg
sta::report_tns -path_group Reg2Out

# Test all path groups reporting
puts "Testing reporting for all path groups..."
sta::report_tns -by_path_group

# Verify path groups are preserved after other commands
report_checks -path_group Reg2Reg
puts "Verifying path groups are preserved..."
sta::report_tns -path_group Reg2Reg

puts "All tests completed." 