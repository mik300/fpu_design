file delete -force work
vlib work

vlog -work ./work src/fp_mult.sv
vlog -work ./work tb/tb_fp_mult.sv

vsim work.tb_fp_mult -voptargs=+acc
add wave *
run 200 ns