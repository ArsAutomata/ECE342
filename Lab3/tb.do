quit -sim
vlog *.sv
vsim tb
log *
add wave *
run -all 