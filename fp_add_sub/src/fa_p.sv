module fa_p
    (
        input logic a, b, cin,
        output logic p,
        output logic sum,
        output logic cout
    );

    logic p_signal;

    assign p = p_signal;

    always_comb begin
        p_signal = a ^ b;
        sum = p_signal ^ cin;
        cout = (a & b) | (b & cin) | (a & cin);
    end

endmodule