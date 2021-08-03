-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../Ising_testcase1_init.gen/sources_1/ip/sysclk_and_scan_clk/sysclk_and_scan_clk_clk_wiz.v" \
  "../../../../Ising_testcase1_init.gen/sources_1/ip/sysclk_and_scan_clk/sysclk_and_scan_clk.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

