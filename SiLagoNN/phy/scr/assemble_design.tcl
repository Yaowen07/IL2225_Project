#1. read the top place-and-routed top partition
#2. assemble the design from the constituent place and routed partitions
set TOP_NAME drra_wrapper
source ../phy/scr/design_variables.tcl

read_db ../phy/db/part/${TOP_NAME}.enc.dat/pnr

foreach module $partition_module_list {
    assemble_design -block_dir ../phy/db/part/${module}.enc.dat/pnr -encounter_format     
}

report_power > ../phy/rpt/drra_wrapper_pnr_power.txt
report_area > ../phy/rpt/drra_wrapper_pnr_area.txt
report_timing > ../phy/rpt/drra_wrapper_pnr_timing.txt
