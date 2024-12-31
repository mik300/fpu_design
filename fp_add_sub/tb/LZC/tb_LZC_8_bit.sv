`timescale 1ns / 1ns

module tb_LZC_8_bit();
    
    // Declare a file descriptor
    integer input_file, output_file, tmp;

    // signal declaration
    localparam T = 20; //clock period

    logic [7:0] a;
    logic [2:0] z, z_golden;
    logic v, v_golden;
    
    // instantiate uut
    LZC_8_bit uut(.a(a), .Z(z), .V(v));
    
    // generate test vectors
    initial begin
        #T;
        // Open the file for reading
        input_file = $fopen("./tb/LZC/LZC_8_bit_inputs.txt", "r");
        if (input_file)  $display("Input file was opened successfully");
        else     $error("Input file was NOT opened successfully : %0d", input_file);

        output_file = $fopen("./tb/LZC/LZC_8_bit_outputs.txt", "r");
        if (output_file)  $display("Output file was opened successfully");
        else     $error("Output file was NOT opened successfully : %0d", output_file);
    
        // Check if the file is successfully opened
        if (input_file) begin
            // Read each line (32-bit number) from the file and assign it to data_signal

            while (!$feof(input_file)) begin
                #(T/2);
                // Read a 32-bit inputs from file and assign them to a and b
                tmp = $fscanf(input_file, "%b\n", a);  
                #(T/20); // Add small delay between reading input and checking for correct output, otherwise assert would fail
                tmp = $fscanf(output_file, "%b\n", v_golden);
                tmp = $fscanf(output_file, "%b\n", z_golden);
            end
            // Close the file after reading
            $fclose(input_file);
        end else begin
            $display("Failed to open file.");
        end
    end

    always @(z_golden) begin
        if (^z !== 1'bx) begin
            assert (z_golden === z)
            else $error("Z doesn't match. Z = %b, expected result = %b", z, z_golden);
        end
    end

    always @(v_golden) begin
        if (^v !== 1'bx) begin
            assert (v_golden === v)
            else $error("V doesn't match. V = %b, expected result = %b", v, v_golden);
        end
    end

endmodule