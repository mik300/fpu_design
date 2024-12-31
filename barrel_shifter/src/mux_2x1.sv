module mux_2x1
#(
    parameter N = 1
)(
    input logic [N-1 : 0] x0,
    input logic [N-1 : 0] x1,
    input logic s,
    output logic [N-1 : 0] f
);

    logic p0, p1;

    always_comb
    begin 
       if (s == 1'b1) begin
        f = x1;
       end else begin
        f = x0;
       end
    end

endmodule