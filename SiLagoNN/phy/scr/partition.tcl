source ../phy/scr/read_design.tcl
source ../phy/scr/design_variables.tcl
source ../phy/scr/floorplan_constrained.tcl
source ../phy/scr/power_plan.tcl


foreach part_hinst ${partition_hinst_list} {
# 1. create partitions for ALL design blocks
    create_partition -hinst ${part_hinst} -core_spacing 0.0 0.0 0.0 0.0 -rail_width 0.0 -min_pitch_left 2 \
                    -min_pitch_right 2 -min_pitch_top 2 -min_pitch_bottom 2 -reserved_layer {1 2 3 4 5 6 7 8 9} \
                     -pin_layer_top {3 5 7 9} -pin_layer_left {2 4 6 8} -pin_layer_bottom {3 5 7 9} \
                     -pin_layer_right {2 4 6 8} -place_halo 10.0 0.0 0.0 0.0 -route_halo 10.0 -route_halo_top_layer 9 \
                    -route_halo_bottom_layer 1
}

#2. align partitions
#3. assign partition pins
#4. assign io pins
align_partition_clones -snap_all_corners -update_user_grid -pg_horizontal_grid -pg_vertical_grid

assign_partition_pins
assign_io_pins
#
set_db budget_virtual_opt_engine none
set_db budget_constant_model true
set_db budget_include_latency true


#5. create timing budget for MASTER partitions. The rest are cloned.
#6. commit partitions
#7. write partitions
create_timing_budget -partitions ${partition_module_list}
commit_partitions
write_partitions -dir ${PART_DIR} -def
