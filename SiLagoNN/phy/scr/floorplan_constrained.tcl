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
# Area from falt syn 450_000, bottom-up syn 480_000 (select bottom-up),utilization use 0.69
set dim 210;# sqaure root (480_000/16/0.69)

# 2*8 layout
#create_floorplan -site SC8T_104CPP_CMOS22FDX -core_size [expr {2*$margin + 8*$dim}] [expr {2*$margin + 2*$dim}] $margin $margin $margin $margin -no_snap_to_grid
create_floorplan -site SC8T_104CPP_CMOS22FDX -core_size [expr {8*$dim}] [expr {2*$dim}] $margin $margin $margin $margin -no_snap_to_grid


for {set i 0} {$i < 16} {incr i} {
    if {$i < 8} {
        set x1 [expr {double($margin + $dim * $i)}]
        set y1 [expr {double($margin + $dim)}]
        set x2 [expr {double($x1 + $dim)}]
        set y2 [expr {double($y1 + $dim)}]
    } else {
        set x1 [expr {double($margin + $dim * ($i - 8))}]
        set y1 [expr {double($margin)}]
        set x2 [expr {double($x1 + $dim)}]
        set y2 [expr {double($y1 + $dim)}]
    }

    set cell [lindex ${partition_hinst_list} $i ]
    puts $cell
    create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]
}
