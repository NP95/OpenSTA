define_cmd_args "report_tns" {[-min] [-max] [-digits digits] [-path_group path_group_name] [-by_path_group]}

proc report_tns { args } {
  puts "DEBUG: Entered sta::report_tns. Args: $args"
  global sta_report_default_digits
  
  parse_key_args "report_tns" args keys {-digits -path_group} flags {-min -max -by_path_group}
  set min_max "max"
  if { [info exists flags(-min)] } {
    set min_max "min"
  }
  if { [info exists flags(-max)] } {
    set min_max "max"
  }
  if [info exists keys(-digits)] {
    set digits $keys(-digits)
    check_positive_integer "-digits" $digits
  } else {
    set digits $sta_report_default_digits
  }
  
  # Handle path group reporting
  if { [info exists flags(-by_path_group)] } {
    # Report TNS for all path groups
    set path_groups [get_path_groups]
    report_line "Total Negative Slack ($min_max) by Path Group:"
    foreach group $path_groups {
      set tns [total_negative_slack_path_group_cmd $group $min_max]
      report_line "  $group: [format_time $tns $digits]"
    }
  } elseif { [info exists keys(-path_group)] } {
    # Report TNS for specified path group
    set group_name $keys(-path_group)
    if { [is_path_group_name $group_name] } {
      set tns [total_negative_slack_path_group_cmd $group_name $min_max]
      report_line "tns $min_max path_group $group_name [format_time $tns $digits]"
    } else {
      sta_warn "unknown path group '$group_name'."
    }
  } else {
    # Original behavior - report TNS for all paths
    report_line "tns $min_max [format_time [total_negative_slack $min_max] $digits]"
  }
}

# Helper functions
proc get_path_groups {} {
  return [get_path_groups_cmd]
}

proc is_path_group_name { group_name } {
  set path_groups [get_path_groups]
  return [expr [lsearch -exact $path_groups $group_name] >= 0]
} 