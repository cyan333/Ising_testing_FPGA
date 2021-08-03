onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib sysclk_and_scan_clk_opt

do {wave.do}

view wave
view structure
view signals

do {sysclk_and_scan_clk.udo}

run -all

quit -force
