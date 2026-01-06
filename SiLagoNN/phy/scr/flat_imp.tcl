#Reading the design
source ../phy/scr/read_design.tcl
#Floorplan
source ../phy/scr/floorplan.tcl
#Power planning, I did it manually in the tutorial, you can create your power_planning.tcl script by noting the commands appearing in the terminal based on gui actions.
source ../phy/scr/power_plan.tcl
#Place
place_design
assign_io_pins
#CTS
ccopt_design
#Route design
assign_io_pins
route_design
write_db ../phy/db/drra_wrapper_flat.dat
write_netlist ../phy/db/drra_wrapper_flat.v
report_power > ../phy/rpt/drra_wrapper_flat_power.txt
