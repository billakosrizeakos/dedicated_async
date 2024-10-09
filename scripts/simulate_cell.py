import argparse
import os
import re

def read_pins_from_spice(spice_file, module_name):
    pins = {"inputs": [], "outputs": [], "power": [], "ground": []}
    
    with open(spice_file, 'r') as f:
        capturing = False
        pin_names = []
        
        for line in f:
            if line.lower().startswith(f".subckt {module_name.lower()}"):
                capturing = True
                pin_names += re.findall(r'\S+', line.strip())[2:]
            elif capturing:
                line = line.strip()
                if line.endswith('+'):
                    pin_names += re.findall(r'\S+', line[:-1])
                else:
                    pin_names += re.findall(r'\S+', line)
                    break

    for pin in pin_names:
        if not bool(re.search(r'[a-zA-Z]', pin)):
            continue
        if "vcc" in pin.lower() or "vdd" in pin.lower() or "vpwr" in pin.lower():
            pins["power"].append(pin)
        elif "gnd" in pin.lower() or "vss" in pin.lower() or "vgnd" in pin.lower():
            pins["ground"].append(pin)
        elif "in" in pin.lower():
            pins["inputs"].append(pin)
        else:
            pins["outputs"].append(pin)

    return pins

def read_sym_file(sym_file):
    pin_coordinates = {}
    edges = []

    with open(sym_file, 'r') as f:
        for line in f:
            # Check for pin definitions
            match = re.match(r'^B\s+\d+\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+{name=(\S+)\s+dir=(\S+)}', line)
            if match:
                x1, y1, x2, y2, pin_name, pin_dir_str = match.groups()
                if pin_dir_str == 'in': pin_dir = 1
                elif pin_dir_str == 'out': pin_dir = -1
                pin_coordinates[pin_name] = ((float(x1)+float(x2))/2, (float(y1)+float(y2))/2, pin_dir)

            # Check for lines that define the edges of the module
            match_line = re.match(r'^L\s+\d+\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s*{}', line)
            if match_line:
                x1, y1, x2, y2 = map(float, match_line.groups())
                edges.append((x1, y1, x2, y2))

    # Now determine the module's position from the edges
    if edges:
        x_coords = []
        y_coords = []

        for edge in edges:
            x_coords.append(edge[0])
            x_coords.append(edge[2])
            y_coords.append(edge[1])
            y_coords.append(edge[3])

        # Calculate the bounding box for the module
        module_x_min = min(x_coords)
        module_x_max = max(x_coords)
        module_y_min = min(y_coords)
        module_y_max = max(y_coords)

        # Module center coordinates
        module_position = ((module_x_min + module_x_max) / 2, (module_y_min + module_y_max) / 2)

    else:
        module_position = None  # In case no edges were found

    return pin_coordinates, module_position


def generate_xschem_sch_from_spice(spice_file, module, output_file):
    module_name = os.path.splitext(os.path.basename(module))[0]
    
    # Read pins and coordinates
    pins = read_pins_from_spice(spice_file, module_name)
    pin_coordinates, module_position = read_sym_file(module)
    aVDD_voltage = 1.8
    if module_position is None:
        print("Module position not found in the .sym file.")
        return

    # Start generating the schematic content
    sch_data = f"v {{xschem version=3.4.6RC file_version=1.2}}\n"
    sch_data += "G {}\nK {}\nV {}\nS {}\nE {}\n"

    # Waveform graphs
    input_num  = len(pins["inputs"])
    output_num = len(pins["outputs"])
    color_start = 1
    color_stop  = 30
    step = (color_stop - color_start) / (input_num + output_num - 1)
    color_values = [str(round(color_start + i * step)) for i in range(input_num + output_num)]

    sch_data += f"B 2 400 -400 1200 0 {'{'} flags=graph y1=0 y2= {1.2*aVDD_voltage} ypos1=0 ypos2={1.2*aVDD_voltage}\n"
    sch_data += f"divy=5 subdivy=1 unity=1 x1=0 x2=0.002 divx=5 subdivx=1 xlabmag=1.0 ylabmag=1.0\n"
    sch_data += f"dataset=-1 unitx=1 logx=0 logy=0\n"
    sch_data += f'node="{" ".join(pins["inputs"])} {" ".join(pins["outputs"])}\n'
    sch_data += f'color="{" ".join(color_values)}{'" }'}\n'

    pin_counter    = 1
    module_counter  = 1
    source_counter = 1

    # Add voltage source and ground, connect to the aVDD net
    source_pos = [250, 250]
    for i, power_pin in enumerate(pins["power"]):
        x, y, pin_dir = pin_coordinates[power_pin]
        # Create source
        sch_data += f"C {{devices/vsource.sym}} {source_pos[0] + 40*i} {source_pos[1]} 0 0 {{name=V{source_counter} value={aVDD_voltage}V}}\n"
        source_counter+=1
        sch_data += f"C {{devices/lab_pin.sym}} {source_pos[0] + 40*i} {source_pos[1] + 30} 0 0 {{name=p{pin_counter} sig_type=std_logic lab=0}}\n"
        pin_counter+=1
        sch_data += f"N {source_pos[0] + 40*i} {source_pos[1] - 30} {source_pos[0] + 40*i} {source_pos[1] - 70} {{lab=aVDD}}\n"
        sch_data += f"C {{devices/lab_pin.sym}} {source_pos[0] + 40*i} {source_pos[1] - 70} 0 0 {{name=p{pin_counter} sig_type=std_logic lab=aVDD}}\n"
        pin_counter+=1
        # Net label for the power pin (connected to aVDD)
        sch_data += f"C {{devices/lab_pin.sym}} {x + module_position[0]} {y + module_position[1]} 0 0 {{name=p{pin_counter} sig_type=std_logic lab=aVDD}}\n"
        pin_counter+=1
        
    for ground_pin in pins["ground"]:
        x, y, pin_dir = pin_coordinates[ground_pin]
        sch_data += f"C {{devices/lab_pin.sym}} {x + module_position[0]} {y + module_position[1]} 0 0 {{name=p{pin_counter} sig_type=std_logic lab=0}}\n"
        pin_counter+=1

    # Add the module symbol
    sch_data += f"C {{{module}}} {module_position[0]} {module_position[1]} 0 0 {{name=x{module_counter}}}\n"
    module_counter+=1
    
    # Dynamically generate input and output pins based on arbiter_size
    for i, input_pin in enumerate(pins["inputs"]):

        # Create source
        #TODO: CREATE FUCTION TO CREATE DIFFERENT SOURCE CONFIGURATIONS
        sch_data += f"C {{devices/vsource.sym}} {source_pos[0] + 200*i} {source_pos[1] + 50*i + 200} 0 0 {{name=V{source_counter} value=\"pulse({aVDD_voltage}V 0 1ns 1us 1us 1us 10ms 1)\"}}\n"
        source_counter+=1
        sch_data += f"C {{devices/lab_pin.sym}} {source_pos[0] + 200*i} {source_pos[1] + 50*i + 230} 0 0 {{name=p{pin_counter} sig_type=std_logic lab=0}}\n"
        pin_counter+=1
        sch_data += f"N {source_pos[0] + 200*i} {source_pos[1] + 50*i + 170} {source_pos[0] + 200*i} {source_pos[1] + 50*i + 130} {{lab={input_pin}}}\n"
        sch_data += f"C {{devices/lab_pin.sym}} {source_pos[0] + 200*i} {source_pos[1] + 50*i + 130} 0 0 {{name=p{pin_counter} sig_type=std_logic lab={input_pin}}}\n"
        pin_counter+=1

        # Connect to module
        x, y, pin_dir = pin_coordinates[input_pin]
        sch_data += f"N {x + module_position[0]} {y + module_position[1]} {x + module_position[0] - pin_dir * 40} {y + module_position[1]} {{lab={input_pin}}}\n"
        sch_data += f"C {{devices/lab_pin.sym}} {x + module_position[0] - pin_dir * 40} {y + module_position[1]} 2 1 {{name=p{pin_counter} sig_type=std_logic lab={input_pin}}}\n"
        pin_counter+=1
    
    for i, output_pin in enumerate(pins["outputs"]):
        x, y, pin_dir = pin_coordinates[output_pin]
        sch_data += f"N {x + module_position[0]} {y + module_position[1]} {x + module_position[0] - pin_dir * 40} {y + module_position[1]} {{lab={output_pin}}}\n"
        sch_data += f"C {{devices/lab_pin.sym}} {x + module_position[0] - pin_dir * 40} {y + module_position[1]} 2 0 {{name=p{pin_counter} sig_type=std_logic lab={output_pin}}}\n"
        pin_counter+=1

    # Simulation control options
    sch_data += 'C {devices/code_shown.sym} 0 -500 0 0 {name=SPICE only_toplevel=false value="'
    sch_data += ".TRAN 0.01us 2ms\n.PRINT TRAN format=raw file=$::netlist_dir/arbiter_proj.raw v(*) i(*)\n"
    sch_data += f".param aVDD = {aVDD_voltage}V\n"
    sch_data += ".options timeint reltol=5e-3 abstol=1e-3 nonlin continuation=gmin\n\"}\n"

    # Add SPICE directive to include the SPICE model
    sch_data += "C {devices/code.sym} 0 -750 0 0 {name=stdcell_lib only_toplevel=true value=\"tcleval("
    sch_data += ".include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice)\"}\n"

    # Corner case options
    sch_data += "C {sky130_fd_pr/corner.sym} 250 -750 0 0 {name=CORNER only_toplevel=true corner=tt}\n"

    # Write the schematic data to the output file
    with open(output_file, 'w') as f:
        f.write(sch_data)
    
    print(f"Schematic generated and saved to {output_file}")



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process some arguments.")
    parser.add_argument('spice_netlist', type=str, help="Path to the SPICE netlist")
    parser.add_argument('sym_file', type=str, help="Path to the module .sym file")
    parser.add_argument('sch_location', type=str, help="Output schematic location")
    args = parser.parse_args()

    module_name = os.path.splitext(os.path.basename(args.spice_netlist))[0]
    # Save the symbol to a file
    curr_dir = os.getcwd()
    xschem_dir = os.path.join(curr_dir, 'xschem')


    generate_xschem_sch_from_spice(args.spice_netlist, args.sym_file, args.sch_location)
