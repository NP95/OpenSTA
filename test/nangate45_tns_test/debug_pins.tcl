# Simple debug script for finding pins in Nangate45 design

# Define the path to your liberty file
set liberty_file "test/nangate45.lib"
set verilog_file "test/nangate45_tns_test/design_nangate.v"
set output_file "test/nangate45_tns_test/debug_output.txt"

# Open the output file
set fout [open $output_file w]

puts $fout "DEBUG: Starting pin inspection"

# Read the library
if { [catch {read_liberty $liberty_file} result] } {
    puts $fout "Error: Failed to read liberty file: $result"
    close $fout
    exit 1
}
puts $fout "DEBUG: Liberty file read successfully."

# Read the Verilog design
if { [catch {read_verilog $verilog_file} result] } {
    puts $fout "Error: Failed to read Verilog file: $result"
    close $fout
    exit 1
}
puts $fout "DEBUG: Verilog file read successfully."

# Link the design
if { [catch {link_design top} result] } {
    puts $fout "Error: Failed to link design: $result"
    close $fout
    exit 1
}
puts $fout "DEBUG: Design linked successfully."

# List all instances in the design
puts $fout "\nDEBUG: Listing all instances in the design:"
set all_insts [get_cells *]
foreach inst $all_insts {
    puts $fout "  Instance: $inst"
}

# List all pins for each instance
puts $fout "\nDEBUG: Listing pins for each instance:"
foreach inst $all_insts {
    puts $fout "\n  Instance: $inst"
    set pins [get_pins -of_objects $inst]
    foreach pin $pins {
        puts $fout "    Pin: $pin"
    }
}

# List all clocks
puts $fout "\nDEBUG: Listing all clocks:"
set all_clocks [get_clocks *]
foreach clk $all_clocks {
    puts $fout "  Clock: $clk"
}

# List all ports
puts $fout "\nDEBUG: Listing all ports:"
set all_ports [get_ports *]
foreach port $all_ports {
    puts $fout "  Port: $port"
}

# Close the file
close $fout
puts "DEBUG: Pin inspection completed. Results in $output_file" 