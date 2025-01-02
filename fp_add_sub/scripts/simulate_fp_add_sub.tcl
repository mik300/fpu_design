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
add wave -position insertpoint  \
sim:/tb_fp_add_sub/uut/sig_greater \
sim:/tb_fp_add_sub/uut/sig_lower \
sim:/tb_fp_add_sub/uut/sig_lower_shifted \
sim:/tb_fp_add_sub/uut/shifted_output_low \
sim:/tb_fp_add_sub/uut/sig_res \
sim:/tb_fp_add_sub/uut/left_right  \
sim:/tb_fp_add_sub/uut/nb_leading_zeros  \
sim:/tb_fp_add_sub/uut/sig_res_shifted \
sim:/tb_fp_add_sub/uut/left_r1_shifted_output_low \
sim:/tb_fp_add_sub/uut/sig_res_rounded \
sim:/tb_fp_add_sub/uut/sig_res_normalized \
sim:/tb_fp_add_sub/uut/EOP  \
sim:/tb_fp_add_sub/uut/sign_opd1  \
sim:/tb_fp_add_sub/uut/sign_opd2 \
sim:/tb_fp_add_sub/uut/add_ovf \
sim:/tb_fp_add_sub/uut/greater_exp \
sim:/tb_fp_add_sub/uut/adjusted_exp1 \
sim:/tb_fp_add_sub/uut/adjusted_exp2
run 300 ns