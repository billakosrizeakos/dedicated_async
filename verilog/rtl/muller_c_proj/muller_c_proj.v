`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * muller_c_proj
 *
 *-------------------------------------------------------------
 */

module muller_c_proj #(
    parameter N = 6
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input logic [N-1:0] io_in,
    output reg io_out
    // ,output reg out_prev
);

    muller_c #(.N(N)) c_element (
        .in(io_in),
        .y(io_out)
        // ,.out_prev(out_prev)

    );
    
endmodule

module muller_c #(
    parameter N = 6
)(
    input  logic [N-1:0] in,  // Parameterizable amount of inputs
    output reg y
    // ,output logic out_prev // ONLY FOR VERIFICATION
);

    reg y_s;
    wire andGate;
    wire orGate;

    assign andGate = &in;
    assign orGate  = |in;

    always @(in) begin
        // out_prev <= out;
        y_s <= (!orGate) ? 1'b0 : ((!y_s) ? andGate : y_s);
    end

    assign y = y_s;

endmodule

`default_nettype wire
