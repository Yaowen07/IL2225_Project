################################################################################
# Flat logic synthesis script
################################################################################
#
# This script is meant to be executed with the following directory structure
#
# project_top_folder
# |
# |- db: store output data like mapped designs or physical files like GDSII
# |
# |- phy: physical synthesis material (scripts, pins, etc)
# |
# |- rtl: contains rtl code for the design, it should also contain a
# |       hierarchy.txt file with the all the files that compose the design
# |
# |- syn: logic synthesis material (this script, SDC constraints, etc)
# |
# |- sim: simulation stuff like waveforms, reports, coverage etc.
# |
# |- tb: testbenches for the rtl code
# |
# |- exe: the directory where it should be executed. This keeps all the temp files
#         created by DC in that directory
#
#
# The standard way of executing the is from the project_top_folder
# with the following command
#
# $ dc_shell -f ../syn/dc_flat.tcl
################################################################################

# set global libraries
source ../syn/setup.tcl

set SOURCE_DIR          ../rtl;                # rtl code that should be synthesised
set SYN_DIR                 ../syn;                   # synthesis directory
set OUT_DIR                ${SYN_DIR}/db;           # output files: netlist, sdf sdc etc.
set REPORT_DIR          ${SYN_DIR}/rpt;      # synthesis reports: timing, area, etc.

# Design specific variables
set TOP_NAME drra_wrapper

# Read files
set hierarchy_files [split [read [open ${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt r]] "\n"]

# read design files
foreach filename [lrange ${hierarchy_files} 0 end-1] {
    puts "${filename}"
    analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
}
elaborate ${TOP_NAME}
link

source ${SYN_DIR}/${TOP_NAME}_constraints.sdc

compile -map_effort medium

report_area > ${REPORT_DIR}/${TOP_NAME}_area.txt
report_cell > ${REPORT_DIR}/${TOP_NAME}_cells.txt
report_timing > ${REPORT_DIR}/${TOP_NAME}_timing.txt
report_power > ${REPORT_DIR}/${TOP_NAME}_power.txt
report_constraints > ${REPORT_DIR}/${TOP_NAME}_constratints.sdc

# Export netlist
write -hierarchy -format ddc -output ${OUT_DIR}/${TOP_NAME}.ddc
write -hierarchy -format verilog -output ${OUT_DIR}/${TOP_NAME}.v

