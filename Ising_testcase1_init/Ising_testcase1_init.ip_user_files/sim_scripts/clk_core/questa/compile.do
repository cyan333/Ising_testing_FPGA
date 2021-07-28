vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  "+incdir+../../../ipstatic" \
"../../../../Ising_testcase1_init.gen/sources_1/ip/clk_core/clk_core_clk_wiz.v" \
"../../../../Ising_testcase1_init.gen/sources_1/ip/clk_core/clk_core.v" \


vlog -work xil_defaultlib \
"glbl.v"

