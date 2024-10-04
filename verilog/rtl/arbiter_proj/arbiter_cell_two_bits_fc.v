// sch_path: /home/vasilis/Internship/dedicated_async/../aVLSI-SkyWater130-2024/xschem/arbiter_cell_two_bits_fc.sch
module arbiter_cell_two_bits_fc
(
  output wire g0,
  output wire g1,
  output wire rc,
  inout wire GND,
  inout wire VDD,
  input wire r1,
  input wire r0,
  input wire gc
);
wire net1 ;
wire net2 ;
wire net3 ;
wire net4 ;
wire net5 ;
wire net6 ;
wire net7 ;
wire net8 ;
wire net9 ;

sky130_fd_sc_hd__nand2_1 x1 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net6 ),
 .B( net5 ),
 .Y( net7 )
);


sky130_fd_sc_hd__or2_1 x2 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( r0 ),
 .B( gc ),
 .X( net4 )
);


sky130_fd_sc_hd__nor2_1 x3 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net3 ),
 .B( net1 ),
 .Y( g0 )
);


sky130_fd_sc_hd__or4_1 x4 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net6 ),
 .B( net6 ),
 .C( net6 ),
 .D( net6 ),
 .X( net3 )
);


sky130_fd_sc_hd__inv_1 x5 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( gc ),
 .Y( net1 )
);


sky130_fd_sc_hd__or2_1 x6 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( gc ),
 .B( r1 ),
 .X( net5 )
);


sky130_fd_sc_hd__nand2_1 x7 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net4 ),
 .B( net7 ),
 .Y( net6 )
);


sky130_fd_sc_hd__or4_1 x8 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net7 ),
 .B( net7 ),
 .C( net7 ),
 .D( net7 ),
 .X( net2 )
);


sky130_fd_sc_hd__nor2_1 x9 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net1 ),
 .B( net2 ),
 .Y( g1 )
);


sky130_fd_sc_hd__nand2_1 x10 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net2 ),
 .B( r0 ),
 .Y( net8 )
);


sky130_fd_sc_hd__nand2_1 x11 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net3 ),
 .B( r1 ),
 .Y( net9 )
);


sky130_fd_sc_hd__nand2_1 x12 (
 .VGND( GND ),
 .VNB( GND ),
 .VPB( VDD ),
 .VPWR( VDD ),  
 .A( net8 ),
 .B( net9 ),
 .Y( rc )
);

endmodule
