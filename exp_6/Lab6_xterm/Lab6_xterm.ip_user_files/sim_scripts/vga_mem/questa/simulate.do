onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib vga_mem_opt

do {wave.do}

view wave
view structure
view signals

do {vga_mem.udo}

run -all

quit -force
