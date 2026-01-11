#1. cd into the specific partition
#3. read the parition
#4. place
#5. ccopt
#6. route
#7. write the partition db
#8. write ilm
read_db .

place_design
ccopt_design
route_design

write_db ./pnr/

#cd into the partition directory and write the ilm
write_ilm 
