v {xschem version=3.4.6RC file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 1855 -910 2655 -510 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=0.002
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="io_in[2]
io_in[1]
io_in[0]
io_out[2]
io_out[1]
io_out[0]"
color="19 4 7 12 10 4"
dataset=-1
unitx=1
logx=0
logy=0
}
N 678.75 -600.625 678.75 -570.625 {
lab=aVDD}
N 1350 -700 1390 -700 {
lab=io_in[2]}
N 1350 -660 1390 -660 {
lab=io_in[1]}
N 1350 -620 1390 -620 {
lab=io_in[0]}
N 1690 -820 1730 -820 {
lab=io_out[2]}
N 1690 -780 1730 -780 {
lab=io_out[1]}
N 1690 -740 1730 -740 {
lab=io_out[0]}
N 1690 -700 1730 -700 {
lab=io_oeb[2]}
N 1690 -660 1730 -660 {
lab=io_oeb[1]}
N 1690 -620 1730 -620 {
lab=io_oeb[0]}
N 770 -510 990 -510 {
lab=0}
N 770 -510 770 -490 {
lab=0}
N 770 -600 770 -570 {
lab=io_in[2]}
N 990 -600 990 -570 {
lab=io_in[1]}
N 990 -510 1200 -510 {
lab=0}
N 1200 -600 1200 -570 {
lab=io_in[0]}
N 680 -510 770 -510 {
lab=0}
C {devices/vsource.sym} 678.75 -540.625 0 0 {name=V2 value=\{aVDD\}}
C {devices/lab_pin.sym} 678.75 -600.625 0 0 {name=p35 sig_type=std_logic lab=aVDD}
C {devices/code_shown.sym} 1529.375 -1096.875 0 0 {name=SPICE only_toplevel=false value="

.TRAN 0.01us 2ms 
.PRINT TRAN format=raw file=arbiter_proj_cell_xyce.raw v(*) i(*)

.param aVDD = 1.8V
.options timeint reltol=5e-3 abstol=1e-3
* Continuation Options
.options nonlin continuation=gmin

"}
C {devices/code.sym} 1559.375 -542.5 0 0 {name=stdcell_lib only_toplevel=true value="tcleval(
* Standard cell simulation files
.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice
)"}
C {sky130_fd_pr/corner.sym} 1399.375 -542.5 0 0 {name=CORNER only_toplevel=true corner=tt}
C {xschem/arbiter_proj.sym} 1540 -720 0 0 {name=x1


}
C {devices/lab_pin.sym} 1390 -740 2 1 {name=p21 sig_type=std_logic lab=aVDD}
C {devices/lab_pin.sym} 1390 -780 2 1 {name=p36 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 1350 -700 2 1 {name=p4 sig_type=std_logic lab=io_in[2]}
C {devices/lab_pin.sym} 1350 -660 2 1 {name=p5 sig_type=std_logic lab=io_in[1]
}
C {devices/lab_pin.sym} 1350 -620 2 1 {name=p6 sig_type=std_logic lab=io_in[0]}
C {devices/lab_pin.sym} 1730 -820 2 0 {name=p7 sig_type=std_logic lab=io_out[2]}
C {devices/lab_pin.sym} 1730 -780 2 0 {name=p8 sig_type=std_logic lab=io_out[1]}
C {devices/lab_pin.sym} 1730 -740 2 0 {name=p9 sig_type=std_logic lab=io_out[0]}
C {devices/lab_pin.sym} 1730 -700 2 0 {name=p1 sig_type=std_logic lab=io_oeb[2]}
C {devices/lab_pin.sym} 1730 -660 2 0 {name=p2 sig_type=std_logic lab=io_oeb[1]}
C {devices/lab_pin.sym} 1730 -620 2 0 {name=p3 sig_type=std_logic lab=io_oeb[0]}
C {devices/vsource.sym} 770 -540 0 0 {name=V26 value="pulse(1.8 0 1ns 1us 1us 1us 10ms 1)"}
C {devices/vsource.sym} 990 -540 0 0 {name=V1 value="pulse(1.8 0 1ns 1us 1us 1us 10ms 1)"}
C {devices/lab_pin.sym} 770 -490 2 1 {name=p10 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1200 -540 0 0 {name=V3 value="pulse(1.8 0 1ns 1us 1us 1us 10ms 1)"}
C {devices/lab_pin.sym} 770 -600 2 1 {name=p11 sig_type=std_logic lab=io_in[2]}
C {devices/lab_pin.sym} 990 -600 2 1 {name=p12 sig_type=std_logic lab=io_in[1]
}
C {devices/lab_pin.sym} 1200 -600 2 1 {name=p13 sig_type=std_logic lab=io_in[0]}
