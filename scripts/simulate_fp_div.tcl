file delete -force work
vlib work

vlog -work ./work ./fp_div/src/fp_div.sv
vlog -work ./work ./fp_div/tb/tb_fp_div.sv

vsim work.tb_fp_div -voptargs=+acc
add wave *
run 250 ns