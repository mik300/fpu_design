file delete -force work
vlib work

vlog -work ./work src/fp_div.sv
vlog -work ./work tb/tb_fp_div.sv

vsim work.tb_fp_div -voptargs=+acc
add wave *
run 100 ns