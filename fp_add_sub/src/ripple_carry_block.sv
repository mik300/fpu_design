module ripple_carry_block
    (
        input logic [3:0] a, b,
        input logic cin,
        output logic p,
        output logic [3:0] sum,
        output logic cout
    );

    logic [4:0] cout_signal;
    logic [3:0] p_signals;

    assign cout_signal[0] = cin;
    assign cout = cout_signal[4];

    generate
        genvar i;
        for (i=0; i<4; i=i+1)
            fa_p fa(.a(a[i]), .b(b[i]), .cin(cout_signal[i]), .p(p_signals[i]), .sum(sum[i]), .cout(cout_signal[i+1]));
    endgenerate

    assign p = &p_signals;
endmodule