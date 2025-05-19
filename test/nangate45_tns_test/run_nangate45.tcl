# Tcl script to test TNS reporting with Nangate45

puts "DEBUG: Starting Nangate45 TNS test (run_nangate45.tcl)"

# Define the path to your liberty file
# The path is relative to where OpenSTA is run (project root)
set liberty_file "test/nangate45.lib"

# Define paths to your design files (relative to project root)
set verilog_file "test/nangate45_tns_test/design_nangate.v"
set sdc_file "test/nangate45_tns_test/design_nangate.sdc"

# Read the liberty file
if { [catch {read_liberty $liberty_file} result] } {
    puts "Error: Failed to read liberty file $liberty_file: $result"
    exit 1
}
puts "DEBUG: Liberty file read successfully."

# Read the Verilog design
if { [catch {read_verilog $verilog_file} result] } {
    puts "Error: Failed to read Verilog file $verilog_file: $result"
    exit 1
}
puts "DEBUG: Verilog file read successfully."

# Link the design - replace 'top' if your top module name is different
if { [catch {link_design top} result] } {
    puts "Error: Failed to link design: $result"
    exit 1
}
puts "DEBUG: Design linked successfully."

# DEBUGGING - List all instances in the design
puts "DEBUG: Listing all instances in the design:"
set all_insts [get_cells *]
foreach inst $all_insts {
    puts "  Instance: $inst"
}

# DEBUGGING - List all pins in the design
puts "DEBUG: Listing all register output pins:"
set dff_q_pins [get_pins -of_objects [get_cells -filter "ref_name=~DFF*"] -filter "direction==output"]
foreach pin $dff_q_pins {
    puts "  DFF Output Pin: $pin"
}

# Read the SDC file
if { [catch {source $sdc_file} result] } {
    puts "Error: Failed to source SDC file $sdc_file: $result"
    exit 1
}
puts "DEBUG: SDC file sourced successfully."

# Do timing analysis
set_propagated_clock [get_clocks core_clk]

# Report setup violations to see if there are actual timing violations
puts "\nDEBUG: Looking for setup violations..."
if {[catch {report_checks -path_delay max -slack_max -0.001 -group_count 5} result]} {
    puts "No setup violations found or error in reporting: $result"
    puts "Try making the clock period more aggressive."
} else {
    puts $result
}

# Report hold violations 
puts "\nDEBUG: Looking for hold violations..."
if {[catch {report_checks -path_delay min -slack_max -0.001 -group_count 5} result]} {
    puts "No hold violations found or error in reporting: $result"
} else {
    puts $result
}

# Report TNS for all path groups
puts "\nOverall TNS (max): [report_tns -max]"
puts "Overall TNS (min): [report_tns -min]"

puts "\nTesting path group specific reporting with Nangate45..."
puts "TNS (In2Reg) max: [report_tns -max -path_group In2Reg]"
puts "TNS (Reg2Reg) max: [report_tns -max -path_group Reg2Reg]"
puts "TNS (Reg2Out) max: [report_tns -max -path_group Reg2Out]"

puts "\nTesting reporting for all path groups with Nangate45 (max)..."
report_tns -max -by_path_group

puts "\nTesting reporting for all path groups with Nangate45 (min)..."
report_tns -min -by_path_group

# Optional: Report a critical path to see slack values
# set endpoints [get_pins -of_objects [get_ports out1] -filter "is_endpoint==true"]
# if {[llength $endpoints] > 0} {
#     set last_endpoint [lindex $endpoints 0]
#     puts "Reporting path to endpoint: $last_endpoint"
#     report_path -to $last_endpoint
# } else {
#     puts "Could not find a suitable endpoint for detailed path report."
# }

puts "\nNangate45 TNS test script completed." 