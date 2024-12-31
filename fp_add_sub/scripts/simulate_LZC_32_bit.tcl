file delete -force work
vlib work

vlog -work ./work src/and_nor.sv
vlog -work ./work src/or_nand.sv
vlog -work ./work src/LZC_8_bit.sv
vlog -work ./work src/LZC_8_bit.sv
vlog -work ./work src/LZC_32_bit.sv
vlog -work ./work tb/LZC/tb_LZC_32_bit.sv

vsim work.tb_LZC_32_bit -voptargs=+acc
add wave *
add wave -position insertpoint  \
sim:/tb_LZC_32_bit/uut/V_inter  \
sim:/tb_LZC_32_bit/uut/j
run 655500 ns