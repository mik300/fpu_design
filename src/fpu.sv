module fpu(
    input logic [31:0] opd1, opd2,
    input logic [1:0] op, // Add: 00, Sub: 01, Mul: 10, Div: 11
    output logic exp_overflow,
    output logic exp_underflow,
    output logic nan,
    output logic zero,
    output logic [31:0] res
);


logic [31:0] opd1_add_sub, opd2_add_sub, opd1_mul, opd2_mul, opd1_div, opd2_div;
logic [31:0] res_add_sub, res_mul, res_div;
logic [31:0] mux_to_mux_res;
logic mux_to_mux_ovf, mux_to_mux_nan, mux_to_mux_zero;
logic exp_overflow_add_sub, exp_underflow_add_sub, nan_add_sub, zero_add_sub;
logic exp_overflow_mul, nan_mul, zero_mul;
logic exp_overflow_div, nan_div, zero_div;

logic [31:0] low_signal;

logic add_sub, mul, div;

assign low_signal = 32'b0;

// Control signals for the MUXes
assign add_sub = (op == 2'b00 || op == 2'b01) ? 1'b1 : 1'b0;
assign mul = (op == 2'b10) ? 1'b1 : 1'b0;
assign div = (op == 2'b11) ? 1'b1 : 1'b0;

// MUXes selecting the input operands for each unit
mux_2x1 #(.N(32)) mux1(.x0(low_signal), .x1(opd1), .s(add_sub), .f(opd1_add_sub));
mux_2x1 #(.N(32)) mux2(.x0(low_signal), .x1(opd2), .s(add_sub), .f(opd2_add_sub));

mux_2x1 #(.N(32)) mux3(.x0(low_signal), .x1(opd1), .s(mul), .f(opd1_mul));
mux_2x1 #(.N(32)) mux4(.x0(low_signal), .x1(opd2), .s(mul), .f(opd2_mul));

mux_2x1 #(.N(32)) mux5(.x0(low_signal), .x1(opd1), .s(div), .f(opd1_div));
mux_2x1 #(.N(32)) mux6(.x0(low_signal), .x1(opd2), .s(div), .f(opd2_div));


// Instantiate the 3 submodules
fp_add_sub fp_add_sub(.opd1(opd1_add_sub), .opd2(opd2_add_sub), .op(op[0]), .exp_overflow(exp_overflow_add_sub), .exp_underflow(exp_underflow_add_sub), .nan(nan_add_sub), .zero(zero_add_sub), .res(res_add_sub));

fp_mult fp_mul(.opd1(opd1_mul), .opd2(opd2_mul), .exp_overflow(exp_overflow_mul), .nan(nan_mul), .zero(zero_mul), .res(res_mul));

fp_div fp_div(.opd1(opd1_div), .opd2(opd2_div), .exp_overflow(exp_overflow_div), .nan(nan_div), .zero(zero_div), .res(res_div));


// MUXes to select the correct output
mux_2x1 #(.N(32)) mux7(.x0(res_mul), .x1(res_div), .s(op[0]), .f(mux_to_mux_res));
mux_2x1 #(.N(32)) mux8(.x0(res_add_sub), .x1(mux_to_mux_res), .s(op[1]), .f(res));

mux_2x1 #(.N(1)) mux9(.x0(exp_overflow_mul), .x1(exp_overflow_div), .s(op[0]), .f(mux_to_mux_ovf));
mux_2x1 #(.N(1)) mux10(.x0(exp_overflow_add_sub), .x1(mux_to_mux_ovf), .s(op[1]), .f(exp_overflow));

mux_2x1 #(.N(1)) mux11(.x0(exp_underflow_add_sub), .x1(1'b0), .s(op[1]), .f(exp_underflow));

mux_2x1 #(.N(1)) mux12(.x0(nan_mul), .x1(nan_div), .s(op[0]), .f(mux_to_mux_nan));
mux_2x1 #(.N(1)) mux13(.x0(nan_add_sub), .x1(mux_to_mux_nan), .s(op[1]), .f(nan));

mux_2x1 #(.N(1)) mux14(.x0(zero_mul), .x1(zero_div), .s(op[0]), .f(mux_to_mux_zero));
mux_2x1 #(.N(1)) mux15(.x0(zero_add_sub), .x1(mux_to_mux_zero), .s(op[1]), .f(zero));

endmodule