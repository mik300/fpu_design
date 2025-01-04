file delete -force work
vlib work

# Compile the barrel shifter with its submodules
vlog -work ./work fp_add_sub/src/fa.sv
vlog -work ./work fp_add_sub/src/adder_sub.sv
vlog -work ./work barrel_shifter/src/mux_2x1.sv
vlog -work ./work barrel_shifter/src/barrel_shifter.sv

# Compile carry skip adder with its submodules
vlog -work ./work fp_add_sub/src/fa_p.sv
vlog -work ./work fp_add_sub/src/ripple_carry_block.sv
vlog -work ./work fp_add_sub/src/carry_skip_adder.sv

# Compile the Leading Zero Counter (LZC) with its submodules
vlog -work ./work fp_add_sub/src/and_nor.sv
vlog -work ./work fp_add_sub/src/or_nand.sv
vlog -work ./work fp_add_sub/src/LZC_8_bit.sv
vlog -work ./work fp_add_sub/src/LZC_8_bit.sv
vlog -work ./work fp_add_sub/src/LZC_32_bit.sv

# Compile fp adder/sub
vlog -work ./work fp_add_sub/src/fp_add_sub.sv

# Compile fp mul
vlog -work ./work fp_mult/src/fp_mult.sv

# Compile fp div
vlog -work ./work fp_div/src/fp_div.sv

# Compile fpu
vlog -work ./work src/fpu.sv
vlog -work ./work tb/tb_fpu.sv

vsim work.tb_fpu -voptargs=+acc
add wave *
run 1000 ns