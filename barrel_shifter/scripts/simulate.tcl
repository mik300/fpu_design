file delete -force work
vlib work

vlog -work ./work src/mux_2x1.sv
vlog -work ./work src/barrel_shifter.sv
vlog -work ./work tb/tb_barrel_shifter.sv

vsim work.tb_barrel_shifter -voptargs=+acc
add wave *
run 250 ns