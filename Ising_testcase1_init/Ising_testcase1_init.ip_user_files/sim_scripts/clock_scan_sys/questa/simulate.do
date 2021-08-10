onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib clock_scan_sys_opt

do {wave.do}

view wave
view structure
view signals

do {clock_scan_sys.udo}

run -all

quit -force
