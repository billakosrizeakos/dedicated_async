`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * arbiter_proj
 *
 *-------------------------------------------------------------
 */

module arbiter_proj #(
    parameter BITS = 3
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // IOs
    input  wire [BITS-1:0] io_in,
    output wire [BITS-1:0] io_out,
    output wire [BITS-1:0] io_oeb
);

    wire r0, r1, gc;
    wire g0, g1, rc;

    assign gc = io_in[2];
    assign r1 = io_in[1];
    assign r0 = io_in[0];

    assign io_out[2] = rc;
    assign io_out[1] = g1;
    assign io_out[0] = g0;

    assign io_oeb = 0;

arbiter_cell_two_bits_fc arbiter (
`ifdef USE_POWER_PINS
    .VDD(vccd1),
    .GND(vssd1),
`endif
.g0(g0),
.g1(g1),
.rc(rc),
.r1(r1),
.r0(r0),
.gc(gc)
);
    
endmodule

`default_nettype wire
