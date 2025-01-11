`timescale 1ns / 1ns

module tb_barrel_shifter();
    
    // Declare a file descriptor
    integer file, output_file, tmp;

    // signal declaration
    localparam T = 20; //clock period

    logic [31:0] a, result, golden_result;
    logic [4:0] b;
    logic left;
    logic clk;
    
    // instantiate uut
    barrel_shifter uut(.a(a), .shift_amount(b), .left(left), .res(result));
    
    // generate test vectors
    initial begin
        clk = 1'b0;
        #T;
        // Open the file for reading
        file = $fopen("./tb/inputs.txt", "r");
        if (file)  $display("File was opened successfully");
        else     $display("File was NOT opened successfully : %0d", file);

        output_file = $fopen("./tb/outputs.txt", "r");
        if (output_file)  $display("File was opened successfully");
        else     $display("File was NOT opened successfully : %0d", output_file);
    
        while (!$feof(file)) begin
            #(T/2);
            // Read a 32-bit inputs from file and assign them to a and b
            tmp = $fscanf(file, "%b\n", a);  
            tmp = $fscanf(file, "%b\n", b);
            tmp = $fscanf(file, "%b\n", left);
            #(T/50); // Add small delay between reading input and checking for correct output, otherwise assert would fail
            tmp = $fscanf(output_file, "%b\n", golden_result);
            clk = ~clk;
        end
        // Close the file after reading
        $fclose(file);
        $fclose(output_file);

    end

    always @(edge clk) begin
        if (^result !== 1'bx) begin
            assert (golden_result === result) // A difference in the LSB is tolerated, as a small loss in FP operations is expected. It may arise from different rounding methods.
            else $error("Results don't match. result = %b, expected result = %b", result, golden_result);
        end
    end

endmodule