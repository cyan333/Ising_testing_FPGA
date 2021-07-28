onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+clk_core -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.clk_core xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {clk_core.udo}

run -all

endsim

quit -force
