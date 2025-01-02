`timescale 1ns / 1ns

module tb_fpu();
    
    integer input_file, op_file, output_file, tmp;


    localparam T = 20; //clock period

    // signal declaration
    logic [31:0] a, b, result, golden_result;
    logic [1:0] op;
    logic exp_overflow_flag, exp_underflow_flag, nan_flag, zero_flag;
    logic clk; // Used to drive the monitor

    // instantiate uut
    fpu uut(.opd1(a), .opd2(b), .op(op), .exp_overflow(exp_overflow_flag), .exp_underflow(exp_underflow_flag), .nan(nan_flag), .zero(zero_flag), .res(result));
    
    // generate test vectors
    initial begin
        clk = 1'b0;
        #T;
        // Open the file for reading
        input_file = $fopen("./tb/inputs.txt", "r");
        if (input_file)  $display("Input file was opened successfully");
        else     $error("Input file was NOT opened successfully : %0d", input_file);

        op_file = $fopen("./tb/op.txt", "r");
        if (!op_file) $error("Input file was NOT opened successfully : %0d", op_file);

        output_file = $fopen("./tb/outputs.txt", "r");
        if (output_file)  $display("Output file was opened successfully");
        else     $error("Output file was NOT opened successfully : %0d", output_file);


    

        while (!$feof(input_file)) begin
            #(T/2);
            // Read a 32-bit inputs from file and assign them to a and b
            tmp = $fscanf(input_file, "%b\n", a);  
            tmp = $fscanf(input_file, "%b\n", b);
            tmp = $fscanf(op_file, "%b\n", op);
            #(T/50); 
            tmp = $fscanf(output_file, "%b\n", golden_result);
            clk = ~clk;
        end
        // Close the file after reading
        $fclose(input_file);

    end

    always @(edge clk) begin
        if (^result !== 1'bx) begin
            assert (golden_result === result)
            else $error("Results don't match. result = %b, expected result = %b", result, golden_result);
        end
    end

endmodule