-makelib ies_lib/xpm -sv \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Ising_testcase1_init.gen/sources_1/ip/clock_scan_sys/clock_scan_sys_clk_wiz.v" \
  "../../../../Ising_testcase1_init.gen/sources_1/ip/clock_scan_sys/clock_scan_sys.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

