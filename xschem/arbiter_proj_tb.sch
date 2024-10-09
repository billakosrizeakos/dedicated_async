v {xschem version=3.4.6RC file_version=1.2}
G {}
K {}
V {}
S {}
E {}
B 2 400 -400 1200 0 { flags=graph y1=0 y2= 2.16 ypos1=0 ypos2=2.16
divy=5 subdivy=1 unity=1 x1=0 x2=0.002 divx=5 subdivx=1 xlabmag=1.0 ylabmag=1.0
dataset=-1 unitx=1 logx=0 logy=0
node="io_in[0] io_in[1] io_in[2] io_out[0] io_out[1] io_out[2]
color="1 7 13 18 24 30" }
C {devices/vsource.sym} 250 250 0 0 {name=V1 value=1.8V}
C {devices/lab_pin.sym} 250 280 0 0 {name=p1 sig_type=std_logic lab=0}
N 250 220 250 180 {lab=aVDD}
C {devices/lab_pin.sym} 250 180 0 0 {name=p2 sig_type=std_logic lab=aVDD}
C {devices/lab_pin.sym} -150.0 -40.0 0 0 {name=p3 sig_type=std_logic lab=aVDD}
C {devices/lab_pin.sym} -150.0 -80.0 0 0 {name=p4 sig_type=std_logic lab=0}
C {/home/vasilis/Internship/dedicated_async/xschem/arbiter_proj.sym} 0.0 0.0 0 0 {name=x1}
C {devices/vsource.sym} 250 450 0 0 {name=V2 value="pulse(1.8V 0 1ns 1us 1us 1us 10ms 1)"}
C {devices/lab_pin.sym} 250 480 0 0 {name=p5 sig_type=std_logic lab=0}
N 250 420 250 380 {lab=io_in[0]}
C {devices/lab_pin.sym} 250 380 0 0 {name=p6 sig_type=std_logic lab=io_in[0]}
N -150.0 80.0 -190.0 80.0 {lab=io_in[0]}
C {devices/lab_pin.sym} -190.0 80.0 2 1 {name=p7 sig_type=std_logic lab=io_in[0]}
C {devices/vsource.sym} 450 500 0 0 {name=V3 value="pulse(1.8V 0 1ns 1us 1us 1us 10ms 1)"}
C {devices/lab_pin.sym} 450 530 0 0 {name=p8 sig_type=std_logic lab=0}
N 450 470 450 430 {lab=io_in[1]}
C {devices/lab_pin.sym} 450 430 0 0 {name=p9 sig_type=std_logic lab=io_in[1]}
N -150.0 40.0 -190.0 40.0 {lab=io_in[1]}
C {devices/lab_pin.sym} -190.0 40.0 2 1 {name=p10 sig_type=std_logic lab=io_in[1]}
C {devices/vsource.sym} 650 550 0 0 {name=V4 value="pulse(1.8V 0 1ns 1us 1us 1us 10ms 1)"}
C {devices/lab_pin.sym} 650 580 0 0 {name=p11 sig_type=std_logic lab=0}
N 650 520 650 480 {lab=io_in[2]}
C {devices/lab_pin.sym} 650 480 0 0 {name=p12 sig_type=std_logic lab=io_in[2]}
N -150.0 0.0 -190.0 0.0 {lab=io_in[2]}
C {devices/lab_pin.sym} -190.0 0.0 2 1 {name=p13 sig_type=std_logic lab=io_in[2]}
N 150.0 80.0 190.0 80.0 {lab=io_out[0]}
C {devices/lab_pin.sym} 190.0 80.0 2 0 {name=p14 sig_type=std_logic lab=io_out[0]}
N 150.0 20.0 190.0 20.0 {lab=io_out[1]}
C {devices/lab_pin.sym} 190.0 20.0 2 0 {name=p15 sig_type=std_logic lab=io_out[1]}
N 150.0 -40.0 190.0 -40.0 {lab=io_out[2]}
C {devices/lab_pin.sym} 190.0 -40.0 2 0 {name=p16 sig_type=std_logic lab=io_out[2]}
C {devices/code_shown.sym} 0 -500 0 0 {name=SPICE only_toplevel=false value=".TRAN 0.01us 2ms
.PRINT TRAN format=raw file=arbiter_proj.raw v(*) i(*)
.param aVDD = 1.8V
.options timeint reltol=5e-3 abstol=1e-3 nonlin continuation=gmin
"}
C {devices/code.sym} 0 -750 0 0 {name=stdcell_lib only_toplevel=true value="tcleval(.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice)"}
C {sky130_fd_pr/corner.sym} 250 -750 0 0 {name=CORNER only_toplevel=true corner=tt}
