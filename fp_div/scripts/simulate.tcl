file delete -force work
vlib work

vlog -work ./work src/fp_div.sv
vlog -work ./work tb/tb_fp_div.sv

vsim work.tb_fp_div -voptargs=+acc
add wave *
add wave -position insertpoint  \
sim:/tb_fp_div/uut/opd1_infinity \
sim:/tb_fp_div/uut/opd2_infinity \
sim:/tb_fp_div/uut/opd1_zero \
sim:/tb_fp_div/uut/opd2_zero \
sim:/tb_fp_div/uut/zero_div_zero \
sim:/tb_fp_div/uut/infinity_div_infinity \
sim:/tb_fp_div/uut/exp_overflow_flag \
sim:/tb_fp_div/uut/nan_flag \
sim:/tb_fp_div/uut/zero_flag \
sim:/tb_fp_div/uut/adjusted_exp1 \
sim:/tb_fp_div/uut/adjusted_exp2 \
sim:/tb_fp_div/uut/exp_res \
sim:/tb_fp_div/uut/exp_opd1 \
sim:/tb_fp_div/uut/exp_opd2 
run 250 ns