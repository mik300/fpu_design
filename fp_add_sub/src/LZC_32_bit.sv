module LZC_32_bit
    (
        input logic [31:0] a,
        output logic [4:0] Z,
        output logic V
    );


    logic [11:0] i;
    logic [6:0] j;
    logic [3:0] V_inter;
    logic V_complement, j_6_complement;
    logic [3:0] Z_complement;

    // Instantiate 4 8-bit LZC 
    LZC_8_bit LZC_8_bit_3(.a(a[31:24]), .Z(i[11:9]), .V(V_inter[3]));
    LZC_8_bit LZC_8_bit_2(.a(a[23:16]), .Z(i[8:6]), .V(V_inter[2]));
    LZC_8_bit LZC_8_bit_1(.a(a[15:8]), .Z(i[5:3]), .V(V_inter[1]));
    LZC_8_bit LZC_8_bit_0(.a(a[7:0]), .Z(i[2:0]), .V(V_inter[0]));

    // Stage 1
    assign j[6] = (V_inter[3] & V_inter[2]);
    assign j_6_complement = ~j[6];

    AND_NOR AND_NOR_6(.a(i[11]), .b(V_inter[3]), .c(i[8]), .res(j[5]));
    AND_NOR AND_NOR_5(.a(i[10]), .b(V_inter[3]), .c(i[7]), .res(j[4]));
    AND_NOR AND_NOR_4(.a(i[9]), .b(V_inter[3]), .c(i[6]), .res(j[3]));

    assign Z_complement[3] = ~(V_inter[3]&(~V_inter[2]) | V_inter[3]&V_inter[2]&(V_inter[1]));

    AND_NOR AND_NOR_2(.a(i[5]), .b(V_inter[1]), .c(i[2]), .res(j[2]));
    AND_NOR AND_NOR_1(.a(i[4]), .b(V_inter[1]), .c(i[1]), .res(j[1]));
    AND_NOR AND_NOR_0(.a(i[3]), .b(V_inter[1]), .c(i[0]), .res(j[0]));

    assign V_complement = V_inter[3] & V_inter[2] & V_inter[1] & V_inter[0];


    //Stage 2
    OR_NAND OR_NAND_2(.a(j[5]), .b(j_6_complement), .c(j[2]), .res(Z_complement[2]));
    OR_NAND OR_NAND_1(.a(j[4]), .b(j_6_complement), .c(j[1]), .res(Z_complement[1]));
    OR_NAND OR_NAND_0(.a(j[3]), .b(j_6_complement), .c(j[0]), .res(Z_complement[0]));

    
    assign V = V_complement;
    
    always_comb begin
        if (V == 1'b1) begin
            Z = 5'b0;
        end else begin
            Z[4] = j[6];
            Z[3] = ~Z_complement[3];
            Z[2:0] = Z_complement;
        end 
    end
endmodule