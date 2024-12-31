module LZC_8_bit
    (
        input logic [7:0] a,
        output logic [2:0] Z,
        output logic V
    );

    logic [2:0] Z_complement;
    logic V_complement;

    assign Z_complement[0] = ~(~(a[7] | (~a[6]&a[5])) & ((a[6] | a[4]) | ~(a[3] | (~a[2] & a[1]))));
    assign Z_complement[1] = ~(~(a[7] | a[6]) & ((a[5] | a[4]) | ~(a[3] | a[2])));
    assign Z_complement[2] = ~(~(a[7] | a[6]) & ~(a[5] | a[4]));
    assign V_complement = ~(~(a[7] | a[6]) & ~(a[5] | a[4])) | ~(~(a[3] | a[2]) & ~(a[1] | a[0]));

    assign V = ~V_complement;

    always_comb begin
        if (V == 1'b1) begin
            Z = 3'b0;
        end else begin
            Z = ~Z_complement;
        end 
    end

endmodule