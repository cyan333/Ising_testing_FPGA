# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: new/constrs_main.xdc

# IP: ip/clock_scan_sys/clock_scan_sys.xci
set_property KEEP_HIERARCHY SOFT [get_cells -hier -filter {REF_NAME==clock_scan_sys || ORIG_REF_NAME==clock_scan_sys} -quiet] -quiet

# XDC: e:/Shanshan_Xie/1-Ising_2021/1-Test/FPGA/codeFromHome/Ising_testcase1_init/Ising_testcase1_init.gen/sources_1/ip/clock_scan_sys/clock_scan_sys_board.xdc
set_property KEEP_HIERARCHY SOFT [get_cells [split [join [get_cells -hier -filter {REF_NAME==clock_scan_sys || ORIG_REF_NAME==clock_scan_sys} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: e:/Shanshan_Xie/1-Ising_2021/1-Test/FPGA/codeFromHome/Ising_testcase1_init/Ising_testcase1_init.gen/sources_1/ip/clock_scan_sys/clock_scan_sys.xdc
#dup# set_property KEEP_HIERARCHY SOFT [get_cells [split [join [get_cells -hier -filter {REF_NAME==clock_scan_sys || ORIG_REF_NAME==clock_scan_sys} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: e:/Shanshan_Xie/1-Ising_2021/1-Test/FPGA/codeFromHome/Ising_testcase1_init/Ising_testcase1_init.gen/sources_1/ip/clock_scan_sys/clock_scan_sys_ooc.xdc