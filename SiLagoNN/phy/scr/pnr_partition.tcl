#1. cd into the specific partition
cd ../phy/db/part/drra_wrapper.enc.dat/
#3. read the parition
read_db .
#4. place
place_design
#5. ccopt
ccopt_design
#6. route
route_design
#7. write the partition db
write_db ./pnr/
#8. write ilm
write_ilm 
#cd into the partition directory and write the ilm


cd ../phy/db/part/Silago_bot.enc.dat/
read_db .
place_design
ccopt_design
route_design
write_db ./pnr/
write_ilm 

cd ../phy/db/part/Silago_bot_left_corner.enc.dat/
read_db .
place_design
ccopt_design
route_design
write_db ./pnr/
write_ilm 

cd ../phy/db/part/Silago_bot_right_corner.enc.dat/
read_db .
place_design
ccopt_design
route_design
write_db ./pnr/
write_ilm 

cd ../phy/db/part/Silago_top.enc.dat/
read_db .
place_design
ccopt_design
route_design
write_db ./pnr/
write_ilm 

cd ../phy/db/part/Silago_top_right_corner.enc.dat/
read_db .
place_design
ccopt_design
route_design
write_db ./pnr/
write_ilm 

cd ../phy/db/part/Silago_top_left_corner.enc.dat/
read_db .
place_design
ccopt_design
route_design
write_db ./pnr/
write_ilm 
