import re
import argparse

def modify_verilog(file_path, output_path):
    with open(file_path, 'r') as file:
        content = file.read()  # Read the entire file as a single string

    # Regular expression to match instantiations across lines
    pin_pattern  = re.compile(r'inout')
    cell_pattern = re.compile(r'(sky130_fd_sc_hd__\w+_\d+)\s*(\w+\s*\()')

    inout_to_input_pins = "input"
    vdd_gnd_pins = "\n .VGND( GND ),\n .VNB( GND ),\n .VPB( VDD ),\n .VPWR( VDD ),"

    # Modify the content by adding the power/ground pins
    modified_content = re.sub(pin_pattern, inout_to_input_pins, content)
    modified_content = re.sub(cell_pattern, r'\1 \2' + vdd_gnd_pins, modified_content)

    with open(output_path, 'w') as file:
        file.write(modified_content)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Modify Verilog file by adding power/ground pins.")
    parser.add_argument("input_file", help="Path to the original Verilog file")
    parser.add_argument("output_file", help="Path to the modified Verilog file")

    args = parser.parse_args()

    # Call the modify function with the provided file paths
    modify_verilog(args.input_file, args.output_file)
