file delete -force work
vlib work

vlog -work ./work src/LZC_8_bit.sv
vlog -work ./work tb/LZC/tb_LZC_8_bit.sv

vsim work.tb_LZC_8_bit -voptargs=+acc
add wave *
run 250 ns