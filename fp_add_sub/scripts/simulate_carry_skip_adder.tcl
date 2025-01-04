file delete -force work
vlib work

vlog -work ./work ../barrel_shifter/src/mux_2x1.sv
vlog -work ./work src/fa_p.sv
vlog -work ./work src/ripple_carry_block.sv
vlog -work ./work src/carry_skip_adder.sv
vlog -work ./work tb/add_sub/tb_carry_skip_adder.sv

vsim work.tb_carry_skip_adder -voptargs=+acc
add wave *
add wave -position insertpoint  \
sim:/tb_carry_skip_adder/uut/cout_signal \
sim:/tb_carry_skip_adder/uut/mux_out_signal \
sim:/tb_carry_skip_adder/uut/p_inter
run 250 ns