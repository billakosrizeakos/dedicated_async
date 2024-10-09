// sch_path: /home/vasilis/Internship/dedicated_async/xschem/arbiter_proj_tb.sch
module arbiter_proj_tb
(

);
wire aVDD ;
wire 0 ;
wire [2:0] io_in ;
wire [2:0] io_out ;

vsource
#(
.value ( {aVDD} )
)
pwr_s0 ( 
 .p( aVDD ),
 .m( 0 )
);


arbiter_proj
m_arbiter_proj ( 
 .io_in( io_in[0] ),
 .io_in( io_in[1] ),
 .io_in( io_in[2] ),
 .io_out( io_out[0] ),
 .io_out( io_out[1] ),
 .io_out( io_out[2] ),
 .vccd1( aVDD ),
 .vssd1( 0 )
);


vsource
#(
.value ( "pulse(1.8 )
)
io_in_0_s0 ( 
 .p( io_in[0] ),
 .m( 0 )
);


vsource
#(
.value ( "pulse(1.8 )
)
io_in_1_s1 ( 
 .p( io_in[1] ),
 .m( 0 )
);


vsource
#(
.value ( "pulse(1.8 )
)
io_in_2_s2 ( 
 .p( io_in[2] ),
 .m( 0 )
);

.TRAN 0.01us 2ms
.PRINT TRAN format=raw file=arbiter_proj.raw v(*) i(*)
.param aVDD = 1.8V
.options timeint reltol=5e-3 abstol=1e-3 nonlin continuation=gmin

.include /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice

endmodule
