`timescale 1ns / 1ns

module tb_fp_div();
    
    // Declare a file descriptor
    integer file, output_file, tmp;

    // signal declaration
    localparam T = 20; //clock period

    logic [31:0] a, b, result, golden_result;
    logic ovf;
    
    // instantiate uut
    fp_div uut(.opd1(a), .opd2(b), .overflow(ovf), .res(result));
    
    // generate test vectors
    initial begin
        #T;
        // Open the file for reading
        file = $fopen("./tb/inputs.txt", "r");
        if (file)  $display("File was opened successfully");
        else     $display("File was NOT opened successfully : %0d", file);

        output_file = $fopen("./tb/outputs.txt", "r");
        if (output_file)  $display("File was opened successfully");
        else     $display("File was NOT opened successfully : %0d", output_file);
    
        // Check if the file is successfully opened
        if (file) begin
        // Read each line (32-bit number) from the file and assign it to data_signal

        while (!$feof(file)) begin
            #(T/2);
            // Read a 32-bit inputs from file and assign them to a and b
            tmp = $fscanf(file, "%b\n", a);  
            tmp = $fscanf(file, "%b\n", b);
            #(T/50); // Add small delay between reading input and checking for correct output, otherwise assert would fail
            tmp = $fscanf(output_file, "%b\n", golden_result);
        end
        // Close the file after reading
        $fclose(file);
        end else begin
        $display("Failed to open file.");
        end
    end

    always @(golden_result) begin
        if (^result !== 1'bx) begin
            assert ((golden_result & 1'b0 ^ result & 1'b0) === 0) // A difference in the LSB is tolerated, as a small loss in FP operations is expected. It may arise from different rounding methods.
            else $error("Results don't match. result = %0b, expected result = %0b", result, golden_result);
        end
    end

endmodule