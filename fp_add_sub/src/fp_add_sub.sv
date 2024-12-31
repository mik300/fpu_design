module fp_add_sub(
    input logic [31:0] opd1, opd2,
    input logic op, // 0 for addition, 1 for subtraction
    output logic exp_overflow_flag,
    output logic exp_underflow_flag,
    output logic nan_flag,
    output logic [31:0] res
);


logic sign_opd1, sign_opd2, sign_exp_diff, sticky_bit, EOP, add_ovf, ovf_rnd, left_right, all_zeros, sign_res;

logic exp_ovf_flag, exp_undf_flag, nan;

logic [7:0] exp_opd1, exp_opd2, greater_exp;
logic [8:0] exp_diff, exp_res, adjusted_exp1, adjusted_exp2; // 9 bits instead of 8 for overflow detection

logic [22:0] mant_opd1, mant_opd2, mant_final, mant_res;
logic [23:0] sig_greater, sig_lower, sig_lower_shifted, sig_res, sig_res_shifted; // 1 extra bit to accomodate the hidden bit
logic [24:0] sig_res_rounded, sig_res_normalized;
logic [4:0] shift_amount, nb_leading_zeros;

logic [7:0] right_shifter_output, left_r1_shifter_output; // Signals holding the lower 8 bits of the shifters

// unpack
assign sign_opd1 = opd1[31];
assign sign_opd2 = opd2[31];

assign exp_opd1 = opd1[30:23];
assign exp_opd2 = opd2[30:23];

assign mant_opd1 = opd1[22:0];
assign mant_opd2 = opd2[22:0];

assign exp_diff = {0'b0, exp_opd1} - {0'b0, exp_opd2};

assign sign_exp_diff = exp_diff[8];

// EOP = 1 for sub, EOP = 0 for add
assign EOP = ~op & ~sign_opd1 & sign_opd2  |  ~op & sign_opd1 & ~sign_opd2  |  op & ~sign_opd1 & ~sign_opd2 |  op & sign_opd1 & sign_opd2;

mux_2x1 #(.N(8)) mux(.x0(exp_opd1), .x1(exp_opd2), .s(sign_exp_diff), .f(greater_exp));

barrel_shifter right_shifter(.a({sig_lower, 8'b0}), .shift_amount(exp_diff[4:0]), .left(1'b0), .res({sig_lower_shifted, right_shifter_output}));

adder_sub #(.N(24)) adder_sub(.a(sig_greater), .b(sig_lower_shifted), .cin(EOP), .sum(sig_res), .cout(add_ovf));

LZC_32_bit LZC(.a({sig_res, 8'b0}), .Z(nb_leading_zeros), .V(all_zeros));

barrel_shifter left_r1_shifter(.a({sig_res, 8'b0}), .shift_amount(shift_amount), .left(left_right), .res({sig_res_shifted, left_r1_shifter_output}));

always_comb begin: swap
    if (sign_exp_diff == 1'b0) begin
        sig_greater = {1'b1, mant_opd1};
        sig_lower = {1'b1, mant_opd2};
        sign_res = sign_opd1;
    end else begin
        sig_greater = {1'b1, mant_opd2};
        sig_lower = {1'b1, mant_opd1};
        sign_res = sign_opd2;
    end
end

always_comb begin: exponent_update
    if (add_ovf == 1'b1 && EOP == 1'b0) begin
        adjusted_exp1 = greater_exp + {8'b0, 1'b1};
    end else begin
        if (greater_exp > {4'b0, nb_leading_zeros}) begin // check for exponent underflow
            exp_undf_flag = 1'b0;
            adjusted_exp1 = greater_exp - {3'b0, nb_leading_zeros};
        end else begin
            exp_undf_flag = 1'b1;
            adjusted_exp1 = 9'b000000000;
        end
    end
end

assign adjusted_exp2 = (ovf_rnd == 1'b1) ? adjusted_exp1 + {8'b0, 1'b1} : adjusted_exp1;

always_comb begin: shift_control
    if (EOP == 1'b0) begin
        shift_amount = {4'b0, add_ovf};
        left_right = 1'b0;
    end else begin
        shift_amount = nb_leading_zeros;
        left_right = 1'b1;
    end
end

assign ovf_rnd = sig_res_rounded[24];

always_comb begin: rounding_logic
    if (op == 1'b0) begin // If op is add
        sticky_bit = |left_r1_shifter_output[6:0];
        if (sticky_bit == 1'b1) begin // round to nearest even number
            sig_res_rounded = {1'b0, sig_res_shifted} + {24'b0, left_r1_shifter_output[7]};
        end else begin
            sig_res_rounded = {1'b0, sig_res_shifted};
        end
    end else begin
        sticky_bit = |left_r1_shifter_output[6:0];
        if (sticky_bit == 1'b1) begin // round to nearest even number
            sig_res_rounded = {1'b0, sig_res_shifted} + {23'b0, left_r1_shifter_output[7]};
        end else begin
            sig_res_rounded = {1'b0, sig_res_shifted};
        end
    end


    if (ovf_rnd == 1'b1) begin
        sig_res_normalized = (sig_res_rounded >> 1);
        mant_final = sig_res_normalized[22:0];
    end else begin 
        sig_res_normalized = sig_res_rounded;
        mant_final = sig_res_normalized[22:0];
    end

end


assign nan = ((exp_opd1 == 8'b11111111 && mant_opd1 != 23'b0) || (exp_opd2 == 8'b11111111 && mant_opd2 != 23'b0)) ? 1'b1 : 1'b0;

assign exp_ovf_flag = (greater_exp >= 9'b011111111 || adjusted_exp1 >= 9'b011111111 || adjusted_exp2 >= 9'b011111111) ? 1'b1 : 1'b0;


always_comb begin: exceptions

    if (nan == 1'b1) begin 
        res[31] = 1'b0;
        res[30:23] = 8'b11111111;
        res[22:0] = 23'b1;
        exp_overflow_flag = 1'b0;
        exp_underflow_flag = 1'b0;
        nan_flag = 1'b1;
    end else if (exp_ovf_flag == 1'b1) begin
        res[31] = 1'b0;
        res[30:23] = 8'b11111111;
        res[22:0] = 23'b0;
        exp_overflow_flag = 1'b1;
        exp_underflow_flag = 1'b0;
        nan_flag = 1'b0;
    end else if (exp_undf_flag == 1'b1) begin
        res[31] = sign_res;
        res[30:23] = 8'b00000000;
        res[22:0] = mant_final;
        exp_overflow_flag = 1'b0;
        exp_underflow_flag = 1'b1;
        nan_flag = 1'b0;
    end else begin // no exceptions case
        res[31] = sign_res;
        res[30:23] = adjusted_exp2[7:0];
        res[22:0] = mant_final;
        exp_overflow_flag = 1'b0;
        exp_underflow_flag = 1'b0;
        nan_flag = 1'b0;
    end
end

endmodule