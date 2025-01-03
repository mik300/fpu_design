file delete -force work
vlib work

# Compile the barrel shifter with its submodules
vlog -work ./work src/fa.sv
vlog -work ./work src/adder_sub.sv
vlog -work ./work ../barrel_shifter/src/mux_2x1.sv
vlog -work ./work ../barrel_shifter/src/barrel_shifter.sv

# Compile the Leading Zero Counter (LZC) with its submodules
vlog -work ./work src/and_nor.sv
vlog -work ./work src/or_nand.sv
vlog -work ./work src/LZC_8_bit.sv
vlog -work ./work src/LZC_8_bit.sv
vlog -work ./work src/LZC_32_bit.sv

vlog -work ./work src/fp_add_sub.sv
vlog -work ./work tb/fp_add_sub/tb_fp_add_sub.sv

vsim work.tb_fp_add_sub -voptargs=+acc
add wave *
run 300 ns