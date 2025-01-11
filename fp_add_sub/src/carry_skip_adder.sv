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
            ripple_carry_block RPB0(.a(a[i+3:i]), .b(b_complement[i+3:i]), .cin(mux_out_signal[i/4]), .p(p_inter[i/4]), .sum(sum[i+3:i]), .cout(cout_signal[i/4+1]));
            mux_2x1 #(.N(1)) mux0(.x0(cout_signal[i/4+1]), .x1(mux_out_signal[i/4]), .s(p_inter[i/4]), .f(mux_out_signal[i/4+1]));
        end
    endgenerate

endmodule