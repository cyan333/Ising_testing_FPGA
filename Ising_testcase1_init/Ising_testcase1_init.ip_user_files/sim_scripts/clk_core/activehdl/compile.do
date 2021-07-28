vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../Ising_testcase1_init.gen/sources_1/ip/clk_core/clk_core_clk_wiz.v" \
"../../../../Ising_testcase1_init.gen/sources_1/ip/clk_core/clk_core.v" \


vlog -work xil_defaultlib \
"glbl.v"

