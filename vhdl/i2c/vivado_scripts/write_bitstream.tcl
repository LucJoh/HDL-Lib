# Add source files

read_vhdl [glob src/*.vhdl]
read_xdc [glob constraints/*.xdc]

# Specify number of CPU threads

set_param general.maxThreads 8

# Synthesis and Implementation

set outputDir vivado_output
file mkdir $outputDir

synth_design -top tdm_rx -part xc7a100tcsg324-1
write_checkpoint -force  $outputDir/post_synth
report_utilization -file $outputDir/post_synth_util.rpt
report_timing -sort_by group -max_paths 5 -path_type summary -file $outputDir/post_synth_timing.rpt
opt_design
power_opt_design
place_design
write_checkpoint -force $outputDir/post_place
phys_opt_design
route_design
write_checkpoint -force $outputDir/post_route

# Generate Reports

report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/post_route_timing.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/cpu_imp_netlist.v
write_xdc -no_fixed_only -force $outputDir/cpu_imp.xdc

# Generate Bitstream

write_bitstream -file $outputDir/bitstream.bit
