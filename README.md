# IL2225_Project
## Task 1
Change the work directory to `./SiLagoNN/tb/vec_add` 
Then Run Questasim with :  
```
vsim -do simulation.tcl
```
## Task 2
Change the work directory to `./SiLagoNN/exe` 
Change the clock period in the constraint `./SiLagoNN/syn/constraints.sdc` 
Then Run DC Shell with :  
```
dc_shell -f ../syn/scr/dc_flat.tcl
```
## Task 3
Change the work directory to `./SiLagoNN/exe` 
Change the clock period in the constraint `./SiLagoNN/syn/constraints.sdc` 
***Clean and move results ../syn/db and rpt from Task 2.***  
Then Run DC Shell with :  
```
dc_shell -f ../syn/scr/dc_bottomup.tcl
```
## Task 4
1. Open Terminal and change the work directory to `./SiLagoNN/exe` 
2. Launch Innovus
```
innovus -stylus
```
3. Call script in innovus bash :  
```
source ../phy/scr/flat_imp.tcl
```
## Task 5
1. Open Terminal and change the work directory to `./SiLagoNN/exe` 
2. Launch Innovus
```
innovus -stylus
```
3. Call script in innovus bash :  
```
    source ../phy/scr/partition.tcl
```
## Task 6
### Sub Partition
1. Open Terminal and change the work directory to `./SiLagoNN/exe` 
2. In the Terminal bash :  
```
    bash  ../phy/scr/pnr_partition.sh
```
3. Check backgroud cpu threads for the progress.
```
    top
```
### Top  Partition
1. Open Terminal and change the work directory to `./SiLagoNN/exe` 
2. Launch Innovus
```
innovus -stylus
```
3. Call script in innovus bash :  
```
    source ../phy/scr/pnr_top.tcl
```
**Blocked here**


