#1. set margin
#2. set width for Silago design blocks
#3. set height for Silago design blocks
#4. create floorplan area
#5. Creating boundary constraints for Silago design blocks
#for {set i 0} {$i < 8} {incr i} {
#Top row	
    #set x1 
    #set y1 
    #set x2 
    #set y2 
    #set the cell 
    #create_boundary_constraint for the cell
#Bottom row
    #set x1 
    #set y1 
    #set x2 
    #set y2 
    #set the cell 
    #create_boundary_constraint for the cell
#}

set margin 20
# Area from syn 450_000, utilization use 0.69
set dim 330

# 2*3 layout
create_floorplan -site SC8T_104CPP_CMOS22FDX -core_size [expr {2*$margin + 3*$dim}] [expr {2*$margin + 2*$dim}] $margin $margin $margin $margin -no_snap_to_grid


for {set i 0} {$i < 6} {incr i} {
    if {$i < 3} {
        set x1 [expr {double($margin + $dim * $i)}]
        set y1 [expr {double($margin + $dim)}]
        set x2 [expr {double($x1 + $dim)}]
        set y2 [expr {double($y1 + $dim)}]
    } else {
        set x1 [expr {double($margin + $dim * $i)}]
        set y1 [expr {double($margin)}]
        set x2 [expr {double($x1 + $dim)}]
        set y2 [expr {double($y1 + $dim)}]
    }

    set cell [lindex ${partition_hinst_list} $i ]
    puts $cell
    create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]
}
