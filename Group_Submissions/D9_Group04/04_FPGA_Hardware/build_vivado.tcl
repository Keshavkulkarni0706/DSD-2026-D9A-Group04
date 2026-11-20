set here [file dirname [file normalize [info script]]]
set root [file normalize "$here/.."]
create_project Game_Score_Categorizer "$here/vivado_project" -part xc7s50csga324-1 -force
add_files -norecurse [list "$root/03_Verilog_Implementation/RTL/Game_Score_Categorizer.v" "$here/Game_Score_Top.v"]
add_files -fileset constrs_1 -norecurse "$here/Boolean_Game_Score.xdc"
add_files -fileset sim_1 -norecurse "$root/03_Verilog_Implementation/Testbench/tb_Game_Score_Categorizer.v"
set_property top Game_Score_Top [current_fileset]
set_property top tb_Game_Score_Categorizer [get_filesets sim_1]
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
open_run impl_1
file mkdir "$here/reports"
report_utilization -file "$here/reports/utilization.txt"
report_timing_summary -file "$here/reports/timing_summary.txt"
report_power -file "$here/reports/power.txt"
file copy -force "$here/vivado_project/Game_Score_Categorizer.runs/impl_1/Game_Score_Top.bit" "$here/Game_Score_Top.bit"
