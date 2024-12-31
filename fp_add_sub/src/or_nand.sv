module OR_NAND
    (
        input logic a, b, c,
        output logic res
    );

    assign res = ~(a & (b | c));

endmodule