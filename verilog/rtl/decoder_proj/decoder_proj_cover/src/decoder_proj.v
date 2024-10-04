`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * decoder_proj
 *
 *-------------------------------------------------------------
 */

module decoder_proj #(
    parameter k = 6
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input enable,
    input [k-1:0] io_in,
    output [(2**k)-1:0] io_out
);

    bin2onehot #(.k(k)) decoder (
        .enable(enable),
        .in(io_in),
        .out(io_out)
    );

endmodule

module bin2onehot #(
    parameter k = 6
)(
    input  logic enable,
    input  logic [k-1:0] in,
    output logic [(2**k)-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            assign out[i] = enable & (in == i);
        end
    endgenerate

endmodule

`default_nettype wire
