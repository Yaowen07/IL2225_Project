#vlib work
#vlib dware

#1. Compile dware libraries into "dware" and the design into "work"

set TOP_NAME silagonn
set RUN_TIME "5us"
  
set SOURCE_DIR ../../rtl;           # rtl code that should be synthesised
set TB_DIR .;                # testbench directory
#set TB_DIR ./tb/vec_add;                # testbench directory

#1.1 Dware
set dware_vhd [split [read [open ${SOURCE_DIR}/dware_hierarchy.txt r]] "\n"]
foreach filename [lrange ${dware_vhd} 0 end-1] {
    # puts "${filename}"
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work dware ${SOURCE_DIR}/${filename}
    } else {
        vlog -v2001 -work dware ${SOURCE_DIR}/${filename}
    }
}

set dware_verilog [split [read [open ${SOURCE_DIR}/dware_hierarchy_verilog.txt r]] "\n"]
foreach filename [lrange ${dware_verilog} 0 end-1] {
    # puts "${filename}"
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work dware ${SOURCE_DIR}/${filename}
    } else {
        vlog -vlog01compat -work dware ${SOURCE_DIR}/${filename}
    }
}

#1.2 Design
set hierarchy_files [split [read [open ${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt r]] "\n"]

foreach filename [lrange ${hierarchy_files} 0 end-1] {
    # puts "${filename}"
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work work ${SOURCE_DIR}/${filename}
    } else {
        vlog -v2001 -work work ${SOURCE_DIR}/${filename}
    }
}

#2. Compile testbench. 

vcom -2008 -work work ${TB_DIR}/const_package.vhd
vcom -2008 -work work ${TB_DIR}/testbench.vhd

#3. Run simulation. 

vsim -voptargs=+acc work.testbench
#add wave sim:/${TOP_NAME}_tb/*
do ${TB_DIR}/wave.do
wave zoom full

run ${RUN_TIME}
