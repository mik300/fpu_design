module AND_NOR
    (
        input logic a, b, c,
        output logic res
    );

    assign res = ~(a | (b & c));

endmodule