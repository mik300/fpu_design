module fp_mult(
    input logic [31:0] opd1, opd2,
    output logic exp_overflow,
    output logic nan,
    output logic zero,
    output logic [31:0] res
);


logic sign_opd1, sign_opd2, sign_res, sticky_bit, zero_times_infinity, exp_overflow_flag, nan_flag, zero_flag;

logic [7:0] exp_opd1, exp_opd2;
logic [8:0] exp_res, adjusted_exp1, adjusted_exp2; // 9 bits instead of 8 for overflow detection

logic [22:0] mant_opd1, mant_opd2, mant_final;
logic [47:0] mant_inter, mant_rounded, mant_normalized; 

// unpack
assign sign_opd1 = opd1[31];
assign sign_opd2 = opd2[31];

assign exp_opd1 = opd1[30:23];
assign exp_opd2 = opd2[30:23];

assign mant_opd1 = opd1[22:0];
assign mant_opd2 = opd2[22:0];

assign sign_res = sign_opd1 ^ sign_opd2;


assign exp_res = exp_opd1 + exp_opd2 - 127;


assign opd1_infinity = (exp_opd1 == 8'b11111111 && mant_opd1 == 23'b0) ? 1'b1 : 1'b0;
assign opd2_infinity = (exp_opd2 == 8'b11111111 && mant_opd2 == 23'b0) ? 1'b1 : 1'b0;

assign opd1_zero = (exp_opd1 == 8'b0 && mant_opd1 == 23'b0) ? 1'b1 : 1'b0;
assign opd2_zero = (exp_opd2 == 8'b0 && mant_opd2 == 23'b0) ? 1'b1 : 1'b0;

assign exp_overflow_flag = ((exp_res >= 9'b100000000) || (adjusted_exp1 >= 9'b100000000) || (adjusted_exp2 >= 9'b100000000) || (opd1_infinity == 1'b1) || (opd2_infinity == 1'b1)) ? 1'b1 : 1'b0;

assign zero_times_infinity = ((exp_opd1 == 8'b0 && mant_opd1 == 23'b0 && opd2_infinity == 1'b1) || (opd1_infinity == 1'b1 && exp_opd2 == 8'b0 && mant_opd2 == 23'b0)) ? 1'b1 : 1'b0;
assign nan_flag = ((exp_opd1 == 8'b11111111 && mant_opd1 != 23'b0) || (exp_opd2 == 8'b11111111 && mant_opd2 != 23'b0) || (zero_times_infinity == 1'b1)) ? 1'b1 : 1'b0;

assign zero_flag = ((opd1_zero == 1'b1) || (opd2_zero == 1'b1)) ? 1'b1 : 1'b0; 


always_comb begin
    mant_inter = {1'b1, mant_opd1} * {1'b1, mant_opd2};

    if (mant_inter[47] == 1'b1) begin 
        mant_normalized = mant_inter >> 1; 
        adjusted_exp1 = exp_res + 1'b1;
    end else begin
        mant_normalized = mant_inter;
        adjusted_exp1 = exp_res;
    end

    sticky_bit = |mant_normalized[21:0];
    if (sticky_bit == 1'b1) begin // round to nearest even number
        mant_rounded = mant_normalized + {25'b0, mant_normalized[22], 22'b0};
    end else begin
        mant_rounded = mant_normalized;
    end

    if (mant_rounded[47] == 1'b1) begin 
        mant_final = mant_rounded[45:23] >> 1;
        adjusted_exp2 = adjusted_exp1 + 1'b1;
    end else begin
        mant_final = mant_rounded[45:23];
        adjusted_exp2 = adjusted_exp1;
    end

end


always_comb begin: pack_and_handle_exceptions
    if (nan_flag == 1'b1) begin 
        res[31] = 1'b0;
        res[30:23] = 8'b11111111;
        res[22:0] = 23'b1;
        exp_overflow = 1'b0;
        nan = 1'b1;
        zero = 1'b0;
    end else if (zero_flag == 1'b1) begin
        res[31] = 1'b0;
        res[30:23] = 8'b00000000;
        res[22:0] = 23'b0;
        exp_overflow = 1'b0;
        nan = 1'b0;
        zero = 1'b1;
    end else if (exp_overflow_flag == 1'b1) begin
        res[31] = sign_res;
        res[30:23] = 8'b11111111;
        res[22:0] = 23'b0;
        exp_overflow = 1'b1;
        nan = 1'b0;
        zero = 1'b0;
    end else begin // no exceptions case
        res[31] = sign_res;
        res[30:23] = adjusted_exp2[7:0];
        res[22:0] = mant_final;
        exp_overflow = 1'b0;
        nan = 1'b0;
        zero = 1'b0;
    end
end

endmodule