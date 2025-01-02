file delete -force work
vlib work

# Compile the barrel shifter with its submodules
vlog -work ./work fp_add_sub/src/fa.sv
vlog -work ./work fp_add_sub/src/adder_sub.sv
vlog -work ./work barrel_shifter/src/mux_2x1.sv
vlog -work ./work barrel_shifter/src/barrel_shifter.sv

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
add wave -position insertpoint  \
sim:/tb_fpu/uut/res_add_sub \
sim:/tb_fpu/uut/exp_overflow_add_sub \
sim:/tb_fpu/uut/exp_underflow_add_sub \
sim:/tb_fpu/uut/nan_add_sub \
sim:/tb_fpu/uut/zero_add_sub \
sim:/tb_fpu/uut/fp_add_sub/opd1 \
sim:/tb_fpu/uut/fp_add_sub/opd2 \
sim:/tb_fpu/uut/fp_add_sub/op \
sim:/tb_fpu/uut/fp_add_sub/exp_overflow \
sim:/tb_fpu/uut/fp_add_sub/exp_underflow \
sim:/tb_fpu/uut/fp_add_sub/nan \
sim:/tb_fpu/uut/fp_add_sub/zero \
sim:/tb_fpu/uut/fp_add_sub/res
run 1000 ns