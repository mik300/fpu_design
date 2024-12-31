file delete -force work
vlib work

vlog -work ./work src/fa.sv
vlog -work ./work src/adder_sub.sv
vlog -work ./work tb/add_sub/tb_add_sub.sv

vsim work.tb_add_sub -voptargs=+acc
add wave *
run 250 ns