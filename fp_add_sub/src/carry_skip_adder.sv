module carry_skip_adder
    #( parameter N = 32)
    (
        input logic [N-1:0] a, b,
        input logic cin,
        output logic [N-1:0] sum,
        output logic cout
    );

    logic [N/4:0] cout_signal;
    logic [N/4:0] mux_out_signal;
    logic [(N/4)-1:0] p_inter;
    logic [N-1:0] b_complement;

    assign cout_signal[0] = cin;
    assign mux_out_signal[0] = cin;
    assign cout = cout_signal[N/4];
    assign b_complement = b ^ {N{cin}};

    

    generate
        genvar i;
        for (i=0; i<N; i=i+4) begin
            //ripple_carry_block RPB(.a(a[i+3:i]), .b(b[i+3:i]), .cin(cout_signal[i/4]), .p(p_inter[i/4]), .sum(sum[i+3:i]), .cout(cout_signal[i/4+1]));
            //mux_2x1 #(.N(1)) mux(.x0(cout_signal[i/4+1]), .x1(mux_out_signal[i/4]), .s(p_inter[i/4]), .f(mux_out_signal[i/4+1]));
            ripple_carry_block RPB0(.a(a[i+3:i]), .b(b_complement[i+3:i]), .cin(mux_out_signal[i/4]), .p(p_inter[i/4]), .sum(sum[i+3:i]), .cout(cout_signal[i/4+1]));
            mux_2x1 #(.N(1)) mux0(.x0(cout_signal[i/4+1]), .x1(mux_out_signal[i/4]), .s(p_inter[i/4]), .f(mux_out_signal[i/4+1]));
        end
    endgenerate

    // // // i = 0
    // ripple_carry_block RPB0(.a(a[3:0]), .b(b_complement[3:0]), .cin(mux_out_signal[0]), .p(p_inter[0]), .sum(sum[3:0]), .cout(cout_signal[1]));
    // mux_2x1 #(.N(1)) mux0(.x0(cout_signal[1]), .x1(mux_out_signal[0]), .s(p_inter[0]), .f(mux_out_signal[1]));

    // // i = 4
    // ripple_carry_block RPB1(.a(a[7:4]), .b(b_complement[7:4]), .cin(mux_out_signal[1]), .p(p_inter[1]), .sum(sum[7:4]), .cout(cout_signal[2]));
    // mux_2x1 #(.N(1)) mux1(.x0(cout_signal[2]), .x1(mux_out_signal[1]), .s(p_inter[1]), .f(mux_out_signal[2]));

    // // i = 8
    // ripple_carry_block RPB2(.a(a[11:8]), .b(b_complement[11:8]), .cin(mux_out_signal[2]), .p(p_inter[2]), .sum(sum[11:8]), .cout(cout_signal[3]));
    // mux_2x1 #(.N(1)) mux2(.x0(cout_signal[3]), .x1(mux_out_signal[2]), .s(p_inter[2]), .f(mux_out_signal[3]));

    // // i = 12
    // ripple_carry_block RPB3(.a(a[15:12]), .b(b_complement[15:12]), .cin(mux_out_signal[3]), .p(p_inter[3]), .sum(sum[15:12]), .cout(cout_signal[4]));
    // mux_2x1 #(.N(1)) mux3(.x0(cout_signal[4]), .x1(mux_out_signal[3]), .s(p_inter[3]), .f(mux_out_signal[4]));

    // // i = 16
    // ripple_carry_block RPB4(.a(a[19:16]), .b(b_complement[19:16]), .cin(mux_out_signal[4]), .p(p_inter[4]), .sum(sum[19:16]), .cout(cout_signal[5]));
    // mux_2x1 #(.N(1)) mux4(.x0(cout_signal[5]), .x1(mux_out_signal[4]), .s(p_inter[4]), .f(mux_out_signal[5]));

    // // i = 20
    // ripple_carry_block RPB5(.a(a[23:20]), .b(b_complement[23:20]), .cin(mux_out_signal[5]), .p(p_inter[5]), .sum(sum[23:20]), .cout(cout_signal[6]));
    // mux_2x1 #(.N(1)) mux5(.x0(cout_signal[6]), .x1(mux_out_signal[5]), .s(p_inter[5]), .f(mux_out_signal[6]));

    // // i = 24
    // ripple_carry_block RPB6(.a(a[27:24]), .b(b_complement[27:24]), .cin(mux_out_signal[6]), .p(p_inter[6]), .sum(sum[27:24]), .cout(cout_signal[7]));
    // mux_2x1 #(.N(1)) mux6(.x0(cout_signal[7]), .x1(mux_out_signal[6]), .s(p_inter[6]), .f(mux_out_signal[7]));

    // // i = 28
    // ripple_carry_block RPB7(.a(a[31:28]), .b(b_complement[31:28]), .cin(mux_out_signal[7]), .p(p_inter[7]), .sum(sum[31:28]), .cout(cout_signal[8]));
    // mux_2x1 #(.N(1)) mux7(.x0(cout_signal[8]), .x1(mux_out_signal[7]), .s(p_inter[7]), .f(mux_out_signal[8]));

    

endmodule