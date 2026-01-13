#1. source global variables
source ../phy/scr/global_variables.tcl
#2. source design variables

set_multi_cpu_usage -local_cpu ${NUM_CPUS} -cpu_per_remote_host 1 -remote_host 0 -keep_license true
set_distributed_hosts -local
#3. set vdd net
#4. set vss net
set_db init_power_nets {VDD}
set_db init_ground_nets {VSS}
#5. read mmmc file
#6. read lef 
#7. read logic synthesis netlist
read_mmmc ${MMMC_FILE}
read_physical -lef ${LEF_FILE}
#Add bottom up syn netlist support
set_db init_design_uniquify true
read_netlist ${NETLIST_FILE}
init_design
