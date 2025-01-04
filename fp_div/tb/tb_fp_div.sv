`timescale 1ns / 1ns

module tb_fp_div();
    
    // Declare a file descriptor
    integer file, output_file, tmp;

    // signal declaration
    localparam T = 20; //clock period

    logic [31:0] a, b, result, golden_result;
    logic exp_overflow, nan, zero;
    logic clk;
    
    // instantiate uut
    fp_div uut(.opd1(a), .opd2(b), .exp_overflow(exp_overflow), .nan(nan), .zero(zero), .res(result));
    
    // generate test vectors
    initial begin
        clk = 1'b0;
        #T;
        // Open the file for reading
        file = $fopen("./fp_div/tb/inputs.txt", "r");
        if (file)  $display("File was opened successfully");
        else     $display("File was NOT opened successfully : %0d", file);

        output_file = $fopen("./fp_div/tb/outputs.txt", "r");
        if (output_file)  $display("File was opened successfully");
        else     $display("File was NOT opened successfully : %0d", output_file);
    

        while (!$feof(file)) begin
            #(T/2);
            // Read a 32-bit inputs from file and assign them to a and b
            tmp = $fscanf(file, "%b\n", a);  
            tmp = $fscanf(file, "%b\n", b);
            #(T/50);
            tmp = $fscanf(output_file, "%b\n", golden_result);
            clk = ~clk;
        end
        // Close the file after reading
        $fclose(file);
        $fclose(output_file);

    end

    always @(edge clk) begin
        if (^result !== 1'bx) begin
            //assert ((golden_result & 1'b0 ^ result & 1'b0) === 0) // A difference in the LSB is tolerated, as a small loss in FP operations is expected. It may arise from different rounding methods.
            assert (golden_result === result)
            else $error("Results don't match. result = %0b, expected result = %0b", result, golden_result);
        end
    end

endmodule