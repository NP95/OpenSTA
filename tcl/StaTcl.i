%inline %{

Slack
total_negative_slack_path_group_cmd(const char *path_group_name,
                                   const char *min_max)
{
  return sta->totalNegativeSlackPathGroup(path_group_name, 
                                         MinMax::find(min_max));
}

StringSeq *
get_path_groups_cmd()
{
  return sta->pathGroupNames();
}

%} 