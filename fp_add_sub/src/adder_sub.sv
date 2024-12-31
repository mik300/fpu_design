module adder_sub
    #( parameter N = 32)
    (
        input logic [N-1:0] a, b,
        input logic cin,
        output logic [N-1:0] sum,
        output logic cout
    );

    logic [N:0] cout_signal;
    logic [N-1:0] b_complement;

    assign cout_signal[0] = cin;
    assign cout = cout_signal[N];
    assign b_complement = b ^ {N{cin}};

    generate
        genvar i;
        for (i=0; i<N; i=i+1)
            FA fa(.a(a[i]), .b(b_complement[i]), .cin(cout_signal[i]), .sum(sum[i]), .cout(cout_signal[i+1]));
    endgenerate

endmodule