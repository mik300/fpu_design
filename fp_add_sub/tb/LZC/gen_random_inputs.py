import random
import re

def generate_random_32bit_input(used_numbers):
    """Generates a unique random 32-bit integer and its number of leading zeros."""
    while True:
        num = random.randint(0, 2**32 - 1)  # Random 32-bit number
        if num not in used_numbers:
            used_numbers.add(num)
            break
    binary_representation = f"{num:032b}"  # Binary representation, padded to 32 bits
    if num == 0:
        V = '1'
        leading_zeros = '00000'  # Force leading zeros to all zeros if input is all zeros
    else:
        V = '0'
        leading_zeros = f"{len(binary_representation) - len(binary_representation.lstrip('0')):05b}"
    return binary_representation, V, leading_zeros

def write_to_files(num_inputs, input_file, output_file):
    """Generates inputs and writes them to files."""
    used_numbers = set()
    with open(input_file, 'w') as infile, open(output_file, 'w') as outfile:
        for _ in range(num_inputs):
            binary_input, V, binary_leading_zeros = generate_random_32bit_input(used_numbers)
            infile.write(binary_input + '\n')
            outfile.write(V + '\n')
            outfile.write(binary_leading_zeros + '\n')

def edit_tcl_script(tcl_script, runtime):
    pattern = r"run \d+ ns"
    with open(tcl_script, 'r') as file:
        content = file.read()
        updated_content = re.sub(pattern, f"run {runtime} ns", content, count=1)
    with open(tcl_script, 'w') as file:
        file.write(updated_content)

# File names
input_file_name = "./tb/LZC/LZC_32_bit_inputs.txt"
output_file_name = "./tb/LZC/LZC_32_bit_outputs.txt"

# Number of inputs to generate
num_inputs_to_generate = 5000

tcl_script = "./scripts/simulate_LZC_32_bit.tcl"
runtime = num_inputs_to_generate*10 + 100
edit_tcl_script(tcl_script, runtime)

# Generate and write inputs and outputs
write_to_files(num_inputs_to_generate, input_file_name, output_file_name)
print(f"Generated {num_inputs_to_generate} unique random 32-bit inputs and written to {input_file_name} and {output_file_name}.")
