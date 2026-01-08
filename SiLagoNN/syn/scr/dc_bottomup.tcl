################################################################################
# Design Compiler bottom-up logic synthesis script
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

# Clean temp files inside exe folder
set exe_dir ./

foreach item [glob -nocomplain -directory $exe_dir * .*] {
    set name [file tail $item]

    # Skip current/parent dir and .gitkeep
    if {$name in {. .. .gitkeep}} {
        continue
    }

    file delete -force $item
}

remove_design -all

# load synopsys config
source ../syn/synopsys_dc.setup

# Design specific variables
set TOP_NAME drra_wrapper
set SOURCE_DIR          ../rtl;                # rtl code that should be synthesised
set SYN_DIR                 ../syn;                   # synthesis directory
set OUT_DIR                ${SYN_DIR}/db;           # output files: netlist, sdf sdc etc.
set REPORT_DIR          ${SYN_DIR}/rpt;      # synthesis reports: timing, area, etc.

#EXECUTE N PASSES. DECIDE ON A REASONABLE N.
proc nth_pass {n} {
	#Hint: Write constraints for some reasonably big modules. E.g: divider_pipe and silego.
	
	#Hint: Compile only the unique tiles
    
    set prev_n [expr {$n - 1}]

    # Packages
    analyze -format vhdl -lib WORK {"../rtl/hw_setting.vhd"}	

    analyze -format vhdl -lib WORK {"../rtl/mtrf/isa.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/mtrf/misc.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/mtrf/top_consts_types_package.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/mtrf/util_package.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/functions.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/mtrf/tb_instructions.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/dimarch/noc_types_n_constants.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/dimarch/crossbar_types_n_constants.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/DPU_pkg.vhd"}
    analyze -format vhdl -lib WORK {"../rtl/mtrf/seq_functions_package.vhd"}

    # Compile REGISTER_F
    analyze -format vhdl -lib WORK {"../rtl/mtrf/AGU_RFblock.vhd"}
    elaborate AGU_RFblock
    analyze -format vhdl -lib WORK {"../rtl/mtrf/shadowReg_AGU.vhd"}
    elaborate shadowReg_AGU
    analyze -format vhdl -lib WORK {"../rtl/mtrf/AGU.vhd"}
    elaborate AGU
    analyze -format vhdl -lib WORK {"../rtl/mtrf/register_row.vhd"}
    elaborate register_row
    analyze -format vhdl -lib WORK {"../rtl/mtrf/register_file.vhd"}
    elaborate register_file

    analyze -format vhdl -lib WORK {"../rtl/mtrf/register_file_top.vhd"}
    elaborate register_file_top
    current_design register_file_top
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/register_file_top_${prev_n}.wscr
    }
    compile


    # Compile Sequencer
    analyze -format vhdl -lib WORK {"../rtl/mtrf/priorityComponent.vhd"}
    elaborate priorityComponent
    analyze -format vhdl -lib WORK {"../rtl/mtrf/priorityMux.vhd"}
    elaborate priorityMux
    analyze -format vhdl -lib WORK {"../rtl/mtrf/autoloop.vhd"}
    elaborate autoloop
    analyze -format vhdl -lib WORK {"../rtl/mtrf/RACCU.vhd"}
    elaborate RACCU
    analyze -format vhdl -lib WORK {"../rtl/mtrf/RaccuRF.vhd"}
    elaborate RaccuRF
    analyze -format vhdl -lib WORK {"../rtl/mtrf/RaccuAndLoop.vhd"}
    elaborate RaccuAndLoop

    analyze -format vhdl -lib WORK {"../rtl/mtrf/sequencer.vhd"}
    elaborate sequencer
    current_design sequencer
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/sequencer_${prev_n}.wscr
    }
    compile

    # Compile DPU
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/conf_mul_Beh.vhd"}
    elaborate conf_mul_Beh
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/Q_format_n_to_one.vhd"}
    elaborate Q_format_n_to_one
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/Q_format_one_to_n.vhd"}
    elaborate Q_format_one_to_n
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/offset_gen.vhd"}
    elaborate offset_gen
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/Squash_Unit.vhd"}
    elaborate Squash_Unit
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/divider_pipe.vhd"}
    elaborate divider_pipe
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/adder_nbits.vhd"}
    elaborate adder_nbits
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/Saturation_Unit.vhd"}
    elaborate Saturation_Unit
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/Maxmin_Unit.vhd"}
    elaborate Maxmin_Unit
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/scaler.vhd"}
    elaborate scaler
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/Shift_Unit.vhd"}
    elaborate Shift_Unit
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/twos_compl.vhd"}
    elaborate twos_compl
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/Sat_n_round.vhd"}
    elaborate Sat_n_round
    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/nacu.vhd"}
    elaborate nacu

    analyze -format vhdl -lib WORK {"../rtl/mtrf/DPU/DPU.vhd"}
    elaborate DPU
    current_design DPU
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/DPU_${prev_n}.wscr
    }
    compile

    # Compile MTRF
    analyze -format vhdl -lib WORK {"../rtl/mtrf/shadowReg.vhd"}
    elaborate shadowReg

    analyze -format vhdl -lib WORK {"../rtl/mtrf/MTRF_cell.vhd"}
    elaborate MTRF_cell
    current_design MTRF_cell
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/MTRF_cell_${prev_n}.wscr
    }
    dont_touch register_file_top true
    dont_touch sequencer true
    dont_touch DPU true
    compile

    # Compile cell_config_swb
    analyze -format vhdl -lib WORK {"../rtl/mtrf/cell_config_swb.vhd"}
    elaborate cell_config_swb
    current_design cell_config_swb
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/cell_config_swb_${prev_n}.wscr
    }
    compile

    # Compile switchbox
    analyze -format vhdl -lib WORK {"../rtl/mtrf/InputMux.vhd"}
    elaborate InputMux
    analyze -format vhdl -lib WORK {"../rtl/mtrf/switchbox.vhd"}
    elaborate switchbox
    current_design switchbox
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/switchbox_${prev_n}.wscr
    }
    compile

    # Compile silego
    analyze -format vhdl -lib WORK {"../rtl/mtrf/silego.vhd"}
    elaborate silego
    current_design silego
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/silego_${prev_n}.wscr
    }
    dont_touch MTRF_cell true
    dont_touch cell_config_swb true
    dont_touch switchbox true
    compile

    # Compile data_selector
    analyze -format vhdl -lib WORK {"../rtl/mtrf/data_selector.vhd"}
    elaborate data_selector
    current_design data_selector
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/data_selector_${prev_n}.wscr
    }
    compile

    # Compile bus_selector
    analyze -format vhdl -lib WORK {"../rtl/mtrf/bus_selector.vhd"}
    elaborate bus_selector
    current_design bus_selector
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/bus_selector_${prev_n}.wscr
    }
    compile

    # Compile addr_assign
    analyze -format vhdl -lib WORK {"../rtl/mtrf/addr_assign.vhd"}
    elaborate addr_assign
    current_design addr_assign
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/addr_assign_${prev_n}.wscr
    }
    compile

    # Compile Silago_top_left_corner
    analyze -format vhdl -lib WORK {"../rtl/mtrf/addr_assign_drra_top_l_corner.vhd"}
    elaborate addr_assign_drra_top_l_corner
    analyze -format vhdl -lib WORK {"../rtl/mtrf/Silago_top_left_corner.vhd"}
    elaborate Silago_top_left_corner
    current_design Silago_top_left_corner
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/Silago_top_left_corner_${prev_n}.wscr
    }
    dont_touch silego true
    dont_touch data_selector true
    dont_touch bus_selector true
    dont_touch addr_assign true
    compile

    # Compile Silago_top
    analyze -format vhdl -lib WORK {"../rtl/mtrf/Silago_top.vhd"}
    elaborate Silago_top
    current_design Silago_top
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/Silago_top_${prev_n}.wscr
    }
    dont_touch silego true
    dont_touch data_selector true
    dont_touch bus_selector true
    dont_touch addr_assign true
    compile

    # Compile Silago_top_right_corner
    analyze -format vhdl -lib WORK {"../rtl/mtrf/Silago_top_right_corner.vhd"}
    elaborate Silago_top_right_corner
    current_design Silago_top_right_corner
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/Silago_top_right_corner_${prev_n}.wscr
    }
    dont_touch silego true
    dont_touch data_selector true
    dont_touch bus_selector true
    dont_touch addr_assign true
    compile

    # Compile Silago_bot_left_corner
    analyze -format vhdl -lib WORK {"../rtl/mtrf/Silago_bot_left_corner.vhd"}
    elaborate Silago_bot_left_corner
    current_design Silago_bot_left_corner
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/Silago_bot_left_corner_${prev_n}.wscr
    }
    dont_touch silego true
    dont_touch data_selector true
    dont_touch bus_selector true
    dont_touch addr_assign true
    compile

    # Compile Silago_bot
    analyze -format vhdl -lib WORK {"../rtl/mtrf/Silago_bot.vhd"}
    elaborate Silago_bot
    current_design Silago_bot
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/Silago_bot_${prev_n}.wscr
    }
    dont_touch silego true
    dont_touch data_selector true
    dont_touch bus_selector true
    dont_touch addr_assign true
    compile

    # Compile Silago_bot_right_corner
    analyze -format vhdl -lib WORK {"../rtl/mtrf/Silago_bot_right_corner.vhd"}
    elaborate Silago_bot_right_corner
    current_design Silago_bot_right_corner
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/Silago_bot_right_corner_${prev_n}.wscr
    }
    dont_touch silego true
    dont_touch data_selector true
    dont_touch bus_selector true
    dont_touch addr_assign true
    compile


    # Compile drra_wrapper
    analyze -format vhdl -lib WORK {"../rtl/mtrf/drra_wrapper.vhd"}
    elaborate drra_wrapper
    current_design drra_wrapper
    link
    source ../syn/constraints.sdc

    #check if the constraints are met
    report_constraint
    report_area
    report_power
    report_timing
    report_constraint
    characterize -constraint {
         REGISTER_FILE_TOP_1
         SEQUENCER_1
         DPU_1
         MTRF_CELL_1
         CELL_CONFIG_SWB_1
         SWITCHBOX_1
         SILEGO_1
         DATA_SELECTOR_1
         BUS_SELECTOR_1
         ADDR_ASSIGN_1
         SILAGO_TOP_LEFT_CORNER_1
         SILAGO_TOP_1
         SILAGO_TOP_RIGHT_CORNER_1
         SILAGO_BOT_LEFT_CORNER_1
         SILAGO_BOT_1
         SILAGO_BOT_RIGHT_CORNER_1
        }

    current_design register_file_top
    write_script > ../syn/db/register_file_top_${n}.wscr
    current_design sequencer
    write_script > ../syn/db/sequencer_${n}.wscr
    current_design DPU
    write_script > ../syn/db/DPU_${n}.wscr
    current_design MTRF_cell
    write_script > ../syn/db/MTRF_cell_${n}.wscr
    current_design cell_config_swb
    write_script > ../syn/db/cell_config_swb_${n}.wscr
    current_design switchbox
    write_script > ../syn/db/switchbox_${n}.wscr
    current_design silego
    write_script > ../syn/db/silego_${n}.wscr
    current_design data_selector
    write_script > ../syn/db/data_selector_${n}.wscr
    current_design bus_selector
    write_script > ../syn/db/bus_selector_${n}.wscr
    current_design addr_assign
    write_script > ../syn/db/addr_assign_${n}.wscr
    current_design Silago_top_left_corner
    write_script > ../syn/db/Silago_top_left_corner_${n}.wscr
    current_design Silago_top
    write_script > ../syn/db/Silago_top_${n}.wscr
    current_design Silago_top_right_corner
    write_script > ../syn/db/Silago_top_right_corner_${n}.wscr
    current_design Silago_bot_left_corner
    write_script > ../syn/db/Silago_bot_left_corner_${n}.wscr
    current_design Silago_bot
    write_script > ../syn/db/Silago_bot_${n}.wscr
    current_design Silago_bot_right_corner
    write_script > ../syn/db/Silago_bot_right_corner_${n}.wscr

}

puts "First pass"
nth_pass 1
nth_pass 2
current_design drra_wrapper

# Report
report_area > ${REPORT_DIR}/${TOP_NAME}_area.txt
report_cell > ${REPORT_DIR}/${TOP_NAME}_cells.txt
report_timing > ${REPORT_DIR}/${TOP_NAME}_timing.txt
report_power > ${REPORT_DIR}/${TOP_NAME}_power.txt
report_constraints > ${REPORT_DIR}/${TOP_NAME}_constratints.sdc


# Export netlist
write -hierarchy -format ddc -output ${OUT_DIR}/${TOP_NAME}.ddc
write -hierarchy -format verilog -output ${OUT_DIR}/${TOP_NAME}.v
#report_power > ../syn/rpt/area.txt
#report_power > ../syn/rpt/power.txt
#report_timing > ../syn/rpt/timing.txt
#write_file -format verilog -hier -output ../syn/db/drra_wrapper.v
