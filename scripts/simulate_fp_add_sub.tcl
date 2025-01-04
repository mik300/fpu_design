file delete -force work
vlib work

# Compile the barrel shifter with its submodules
vlog -work ./work ./barrel_shifter/src/mux_2x1.sv
vlog -work ./work ./barrel_shifter/src/barrel_shifter.sv

# Compile carry skip adder with its submodules
vlog -work ./work ./fp_add_sub/src/fa_p.sv
vlog -work ./work ./fp_add_sub/src/ripple_carry_block.sv
vlog -work ./work ./fp_add_sub/src/carry_skip_adder.sv
vlog -work ./work ./fp_add_sub/src/fa.sv
vlog -work ./work ./fp_add_sub/src/adder_sub.sv

# Compile the Leading Zero Counter (LZC) with its submodules
vlog -work ./work ./fp_add_sub/src/and_nor.sv
vlog -work ./work ./fp_add_sub/src/or_nand.sv
vlog -work ./work ./fp_add_sub/src/LZC_8_bit.sv
vlog -work ./work ./fp_add_sub/src/LZC_8_bit.sv
vlog -work ./work ./fp_add_sub/src/LZC_32_bit.sv

vlog -work ./work ./fp_add_sub/src/fp_add_sub.sv
vlog -work ./work ./fp_add_sub/tb/fp_add_sub/tb_fp_add_sub.sv

vsim work.tb_fp_add_sub -voptargs=+acc
add wave *
run 300 ns