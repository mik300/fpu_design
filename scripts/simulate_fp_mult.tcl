file delete -force work
vlib work

vlog -work ./work ./fp_mult/src/fp_mult.sv
vlog -work ./work ./fp_mult/tb/tb_fp_mult.sv

vsim work.tb_fp_mult -voptargs=+acc
add wave *
run 200 ns