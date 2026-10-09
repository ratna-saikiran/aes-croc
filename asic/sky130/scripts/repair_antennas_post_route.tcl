# Antenna repair on an already detail-routed design, resumable.
#
# Loads 5_2_route.odb (routed with SKIP_ANTENNA_REPAIR_POST_DRT=1), then
# repeats: insert diodes, incremental detail route, save a checkpoint, until
# check_antennas is clean or ANT_MAX_ITERS is reached. The result replaces
# 5_2_route.odb so the rest of the flow (fill, final) can continue.
#
#   make DESIGN_CONFIG=... run RUN_SCRIPT=/work/asic/sky130/scripts/repair_antennas_post_route.tcl \
#        RUN_LOG_NAME_STEM=5_2_antenna
source $::env(SCRIPTS_DIR)/load.tcl
utl::set_metrics_stage "detailedroute__{}"

set max_iters [expr {[info exists ::env(ANT_MAX_ITERS)] ? $::env(ANT_MAX_ITERS) : 5}]
set start_db 5_2_route.odb
set start_iter 1
# Resume from the newest checkpoint if one exists.
for {set i $max_iters} {$i >= 1} {incr i -1} {
  if { [file exists $::env(RESULTS_DIR)/5_2_route_ant$i.odb] } {
    set start_db 5_2_route_ant$i.odb
    set start_iter [expr {$i + 1}]
    break
  }
}
puts "antenna repair: starting from $start_db"
load_design $start_db 5_1_grt.sdc
set_propagated_clock [all_clocks]

set drt_args [list -output_drc $::env(REPORTS_DIR)/5_route_drc_ant.rpt \
  -droute_end_iter 64 -verbose 1]

set violators [check_antennas]
puts "antenna repair: [expr {$violators ? {violations remain} : {clean}}] at start"
for {set i $start_iter} {$violators && $i <= $max_iters} {incr i} {
  puts "antenna repair: iteration $i"
  repair_antennas
  detailed_route {*}$drt_args
  orfs_write_db $::env(RESULTS_DIR)/5_2_route_ant$i.odb
  set violators [check_antennas]
}

check_antennas -report_file $::env(REPORTS_DIR)/drt_antennas.log
if { ![design_is_routed] } {
  error "Design has unrouted nets."
}
if { $violators } {
  puts "antenna repair: violations remain after $max_iters iterations"
} else {
  puts "antenna repair: clean"
}
if { ![file exists $::env(RESULTS_DIR)/5_2_route_pre_antenna.odb] } {
  file copy $::env(RESULTS_DIR)/5_2_route.odb $::env(RESULTS_DIR)/5_2_route_pre_antenna.odb
}
orfs_write_db $::env(RESULTS_DIR)/5_2_route.odb
