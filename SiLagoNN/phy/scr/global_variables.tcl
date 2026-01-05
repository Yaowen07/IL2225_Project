set NUM_CPUS 8
#set the top name of the design
set TOP_NAME drra_wrapper

# Directories
set OUTPUT_DIR "../phy/db"
set RPT_DIR    "../phy/rpt"
set SCR_DIR    "../phy/scr"
#we need a part directory where partitions are created
set PART_DIR   "../phy/db/part/"
set SRC_DIR    "../syn/db/"


set STDC_CCS_DIR "/opt/pdk/gfip/22FDX-EXT/GF22FDX_SC8T_104CPP_BASE_CSC28L_FDK_RELV06R60/model/timing/ccs"
set TECH_LEF_DIR  "/opt/pdk/gf22/V1.0_4.1/PlaceRoute/Innovus/Techfiles/10M_2Mx_4Cx_2Bx_2Jx_LB"
set STDC_LEF_DIR  "/opt/pdk/gfip/22FDX-EXT/GF22FDX_SC8T_104CPP_BASE_CSC28L_FDK_RELV06R60/lef"

set LEF_FILE "${TECH_LEF_DIR}/22FDSOI_10M_2Mx_4Cx_2Bx_2Jx_LB_104cpp_tech.lef \
        ${STDC_LEF_DIR}/GF22FDX_SC8T_104CPP_BASE_CSC28L.lef"

set STDC_QRC_DIR  "/opt/pdk/gf22/V1.0_4.1/PEX/QRC/10M_2Mx_4Cx_2Bx_2Jx_LBthick"
          
set OP_COD_LIB_BC "GF22FDX_SC8T_104CPP_BASE_CSC28L_FFG_0P72V_0P00V_0P00V_0P00V_M40C"
set OP_COD_LIB_TC "GF22FDX_SC8T_104CPP_BASE_CSC28L_TT_0P80V_0P00V_0P00V_0P00V_25C"
set OP_COD_LIB_WC "GF22FDX_SC8T_104CPP_BASE_CSC28L_SSG_0P72V_0P00V_0P00V_0P00V_125C"
set OP_COD_LIB_SRAM_BC "IN22FDX_S1DV_NFVG_W00064B256M04C128_116cpp_TT_0P800V_0P800V_0P000V_0P000V_025C"
set OP_COD_LIB_SRAM_TC "IN22FDX_S1DV_NFVG_W00064B256M04C128_116cpp_TT_0P800V_0P800V_0P000V_0P000V_025C"
set OP_COD_LIB_SRAM_WC "IN22FDX_S1DV_NFVG_W00064B256M04C128_116cpp_SSG_0P720V_0P720V_0P000V_0P000V_125C"
set OP_COD_LIB_IO_BC "dwc_io_gf22fdx_1p8v_gpio_i_ull_ffg0p945v1p320vm40c_funccmin"
set OP_COD_LIB_IO_TC "dwc_io_gf22fdx_1p8v_gpio_i_ull_tt0p800v1p500v25c"
set OP_COD_LIB_IO_WC "dwc_io_gf22fdx_1p8v_gpio_i_ull_ssg0p720v1p620v125c_funccmax"
set LIB_FILES_BC "${STDC_CCS_DIR}/${OP_COD_LIB_BC}_ccs.lib.gz"
set LIB_FILES_TC "${STDC_CCS_DIR}/${OP_COD_LIB_TC}_ccs.lib.gz"
set LIB_FILES_WC "${STDC_CCS_DIR}/${OP_COD_LIB_WC}_ccs.lib.gz"
set OP_COD_BC "FFG_0P72V_0P00V_0P00V_0P00V_M40C"
set OP_COD_TC "TT_0P80V_0P00V_0P00V_0P00V_25C"
set OP_COD_WC "SSG_0P72V_0P00V_0P00V_0P00V_125C"
set OP_COD_SRAM_BC "TT_0P800V_0P800V_0P000V_0P000V_025C"
set OP_COD_SRAM_TC "TT_0P800V_0P800V_0P000V_0P000V_025C"
set OP_COD_SRAM_WC "SSG_0P720V_0P720V_0P000V_0P000V_125C"
set OP_COD_IO_BC "ffg0p945v1p320vm40c"
set OP_COD_IO_TC "TT_0P8_1P5_25"
set OP_COD_IO_WC "SSG_0P59_1P08_125"
set QRC_FILE_BC "${STDC_QRC_DIR}/FuncRCminDP/qrcTechFile"
set QRC_FILE_TC "${STDC_QRC_DIR}/nominal/qrcTechFile"
set QRC_FILE_WC "${STDC_QRC_DIR}/FuncRCmaxDP/qrcTechFile"

# set LEF_FILE "/opt/pdk/tsmc90/tcbn90g_110a/digital/Back_End/lef/tcbn90g_110a/lef/tcbn90g_9lm.lef"


set MMMC_FILE         "${SCR_DIR}/mmmc.tcl"
set NETLIST_FILE       "${SRC_DIR}/${TOP_NAME}.v"
set SDC_FILES          "../syn/constraints.sdc" ; # ? constraint file is not iniside db
