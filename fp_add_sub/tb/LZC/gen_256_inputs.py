import re

def generate_inputs(input_file, output_file):
    """Generates 256 32-bit integers and their number of leading zeros."""
    with open(input_file, 'w') as infile, open(output_file, 'w') as outfile:
        infile.write("")
        outfile.write("")
    
    for i in range(256):  # Iterate over all possible 8-bit values (0 to 255)
        
        binary_value = f"{i:08b}"  # Convert to 8-bit binary
        expanded_binary = ''.join('1111' if bit == '1' else '0000' for bit in binary_value)
        if i == 0:
            V = '1'
            leading_zeros = '00000'  # Force leading zeros to all zeros if input is all zeros
        else:
            V = '0'
            leading_zeros = f"{len(expanded_binary) - len(expanded_binary.lstrip('0')):05b}"
        with open(input_file, 'a') as infile, open(output_file, 'a') as outfile:
            infile.write(expanded_binary + '\n')
            outfile.write(V + '\n')
            outfile.write(leading_zeros + '\n')
        
def edit_tcl_script(tcl_script):
    pattern = r"run \d+ ns"
    with open(tcl_script, 'r') as file:
        content = file.read()
        updated_content = re.sub(pattern, "run 2600 ns", content, count=1)
    with open(tcl_script, 'w') as file:
        file.write(updated_content)

# File names
input_file_name = "./tb/LZC/LZC_32_bit_inputs.txt"
output_file_name = "./tb/LZC/LZC_32_bit_outputs.txt"

tcl_script = "./scripts/simulate_LZC_32_bit.tcl"
edit_tcl_script(tcl_script)

# Generate and write inputs and outputs
generate_inputs(input_file_name, output_file_name)
print(f"Generated 256 unique random 32-bit inputs and written to {input_file_name} and {output_file_name}.")
