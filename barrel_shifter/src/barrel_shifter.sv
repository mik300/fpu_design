module barrel_shifter(
    input logic [31:0] a,
    input logic [4:0] shift_amount,
    input logic left,
    output logic [31:0] res
);

    logic [5:0][31:0] intermediate_signal; // matrix of signal used to connect each stage to the next
    logic signal_low;

    assign signal_low = 1'b0;

    genvar i, j;
    generate
        for (i = 0; i<7; i=i+1) begin // Loop 7 times: 5 shift stages + 2 extra for left rotation.
            for (j=0; j<32; j=j+1) begin
                if (i == 0) begin // first layer, used to rotate the input bits in case of shift left
                    mux_2x1 #(.N(1)) mux (.x0(a[j]), .x1(a[31-j]), .s(left), .f(intermediate_signal[i][j]));
                end else if (i == 6) begin // last layer, used to rotate back the input bits in case of shift left
                    mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(intermediate_signal[i-1][31-j]), .s(left), .f(res[j]));
                end else begin // layers used for the shift operation
                    case (i)
                        1:
                            if (j <= 15) begin  
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(intermediate_signal[i-1][16+j]), .s(shift_amount[4]), .f(intermediate_signal[i][j]));
                            end else begin
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(signal_low), .s(shift_amount[4]), .f(intermediate_signal[i][j]));
                            end
                        2:
                            if (j <= 23) begin  
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(intermediate_signal[i-1][8+j]), .s(shift_amount[3]), .f(intermediate_signal[i][j]));
                            end else begin
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(signal_low), .s(shift_amount[3]), .f(intermediate_signal[i][j]));
                            end
                        3:
                            if (j <= 27) begin  
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(intermediate_signal[i-1][4+j]), .s(shift_amount[2]), .f(intermediate_signal[i][j]));
                            end else begin
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(signal_low), .s(shift_amount[2]), .f(intermediate_signal[i][j]));
                            end
                        4:
                            if (j <= 29) begin  
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(intermediate_signal[i-1][2+j]), .s(shift_amount[1]), .f(intermediate_signal[i][j]));
                            end else begin
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(signal_low), .s(shift_amount[1]), .f(intermediate_signal[i][j]));
                            end
                        5:
                            if (j <= 30) begin  
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(intermediate_signal[i-1][1+j]), .s(shift_amount[0]), .f(intermediate_signal[i][j]));
                            end else begin
                                mux_2x1 #(.N(1)) mux (.x0(intermediate_signal[i-1][j]), .x1(signal_low), .s(shift_amount[0]), .f(intermediate_signal[i][j]));
                            end
                    endcase
                end
            end 
            
        end
    endgenerate


endmodule