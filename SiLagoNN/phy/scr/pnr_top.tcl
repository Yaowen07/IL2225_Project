#source ../phy/scr/global_variables.tcl
set TOP_NAME drra_wrapper
source ../phy/scr/design_variables.tcl

cd ../phy/db/part
read_db ${TOP_NAME}

foreach module $partition_module_list {
	#1. read ilm master partitions
    read_ilm -cell $module -dir ${module}/ilm    
}
#2. flatten ilms

#3. place 
#4. ccopt
#5. route
flatten_ilm

place_design

ccopt_design
route_design

write_db ${TOP_NAME}/pnr
#6. write the place and routed db
