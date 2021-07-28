vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr "+incdir+../../../ipstatic" \
"../../../../Ising_testcase1_init.gen/sources_1/ip/clk_core/clk_core_clk_wiz.v" \
"../../../../Ising_testcase1_init.gen/sources_1/ip/clk_core/clk_core.v" \


vlog -work xil_defaultlib \
"glbl.v"

