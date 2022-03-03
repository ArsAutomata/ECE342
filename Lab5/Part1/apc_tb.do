vlog apc_kit.sv apc_tb_updated.sv fp_mult.v
vsim -L altera_mf_ver -L lpm_ver apc_tb
log *
add wave *
run -all