`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * muller_c_proj
 *
 *-------------------------------------------------------------
 */

module muller_c #(
    parameter N = 6
)(
    input wire [N-1:0] in,  // Parameterizable amount of inputs
    output reg out,
    output reg out_prev
);

    wire andGate;
    wire orGate;

    assign andGate = &in;
    assign orGate  = |in;

    initial out <= 0;
    initial out_prev <= 0;

    always @(in) begin
        if (andGate)
            out <= 1'b1;
        else if (!orGate)
            out <= 1'b0;
        else
            out_prev <= out;

    end
endmodule

module muller_c_proj #(
    parameter N = 6
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input [N-1:0] io_in,
    output reg io_out,
    output reg out_prev
);

    muller_c #(.N(N)) c_element (
        .in(io_in),
        .out(io_out),
        .out_prev(out_prev)

    );
    
endmodule

`default_nettype wire
