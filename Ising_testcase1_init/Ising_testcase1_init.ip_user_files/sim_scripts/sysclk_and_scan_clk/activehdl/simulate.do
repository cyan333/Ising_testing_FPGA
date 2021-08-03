onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+sysclk_and_scan_clk -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.sysclk_and_scan_clk xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {sysclk_and_scan_clk.udo}

run -all

endsim

quit -force
