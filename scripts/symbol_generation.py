import argparse
import os

def parse_spice_netlist(spice_file, module_name):
    """
    Parse the SPICE netlist and extract the pin order for the given module.
    """
    pin_order = []
    found_module = False

    with open(spice_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith(f'.subckt {module_name}'):
                # Extract pin order from the subckt definition
                found_module = True
                pin_order = line.split()[2:]  # Skip ".subckt module_name"
            elif found_module:
                # End of subckt definition
                if line.startswith('+'):
                    # Continue pin definition in the next line
                    pin_order.extend(line.split()[1:])
                else:
                    break
    
    if not pin_order:
        raise ValueError(f"Module '{module_name}' not found in the SPICE netlist.")
    
    return pin_order

def generate_xschem_sym(ports, module):
    """
    Generate a Xschem symbol (.sym file) with customizable ports and dimensions.
    """
    sym_data = f"v {{xschem version=3.4.5 file_version=1.2}}\n"
    sym_data += f"K {{type=subcircuit\n"
    sym_data += f'format="@name @pinlist @symname"\n'
    sym_data += f'template="name=x1"\n'
    sym_data += f'spice_sym_def=".include {module}"\n}}\n'
    sym_data += f'T {{@symname}} -20 -0 0 0 0.3 0.3 {{}}\n'
    sym_data += f'T {{@name}} 140 -130 0 0 0.2 0.2 {{}}\n'

    num_in_ports = len([p for p in ports if p['dir'] == 'in'])
    num_out_ports = len([p for p in ports if p['dir'] == 'out'])
    
    rect_height = max(num_in_ports, num_out_ports) * 40
    rect_top = rect_height // 2
    rect_bottom = -rect_height // 2
    
    sym_data += f"L 4 -130 {rect_bottom} 130 {rect_bottom} {{}}\n"
    sym_data += f"L 4 -130 {rect_top} 130 {rect_top} {{}}\n"
    sym_data += f"L 4 -130 {rect_bottom} -130 {rect_top} {{}}\n"
    sym_data += f"L 4 130 {rect_bottom} 130 {rect_top} {{}}\n"

    input_offset_y = rect_top - 20
    output_offset_y = rect_top - 20
    input_spacing = (rect_height // max(1, num_in_ports) // 10) * 10
    output_spacing = (rect_height // max(1, num_out_ports) // 10) * 10


    for port in ports:
        port_name = port['name']
        direction = port['dir']
        
        if direction == 'in':
            port_pos_x = -150
            text_pos_x = -125
            offset_y = input_offset_y
            input_offset_y -= input_spacing
            port_dir_flag = 0
        else:
            port_pos_x = 150
            text_pos_x = 125
            offset_y = output_offset_y
            output_offset_y -= output_spacing
            port_dir_flag = 1
        
        sym_data += f"B 5 {port_pos_x - 2.5} {offset_y - 2.5} {port_pos_x + 2.5} {offset_y + 2.5} {{name={port_name} dir={direction}}}\n"
        sym_data += f"L 4 {port_pos_x} {offset_y} {port_pos_x + (20 if direction == 'in' else -20)} {offset_y} {{}}\n"
        sym_data += f"T {{{port_name}}} {text_pos_x} {offset_y - 4} 0 {port_dir_flag} 0.2 0.2 {{}}\n"
    
    return sym_data


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Process some arguments.")
    parser.add_argument('spice_netlist', type=str, help="Path to the SPICE netlist")
    parser.add_argument('symbol_location', type=str, help="Output path")
    args = parser.parse_args()

    module = os.path.splitext(os.path.basename(args.spice_netlist))[0]

    # Parse the netlist to extract the pin order for the module
    pin_order = parse_spice_netlist(args.spice_netlist, module)

    # Define ports based on the parsed pin order
    ports = []
    for pin in pin_order:
        # Example logic: Treat the first few pins as inputs, and the rest as outputs
        # Modify this logic according to your specific module's pin types
        direction = 'in' if 'in' in pin or 'vccd' in pin or 'vssd' in pin else 'out'
        ports.append({'name': pin, 'dir': direction})
    
    # Generate the symbol
    sym_content = generate_xschem_sym(ports, args.spice_netlist)
    xschem_dir = os.path.dirname(args.symbol_location)
    if not os.path.exists(xschem_dir):
        os.makedirs(xschem_dir)
    # Save the symbol to a file
    with open(args.symbol_location, 'w') as f:
        f.write(sym_content)

    print(f"Xschem symbol for '{module}' generated successfully!")
