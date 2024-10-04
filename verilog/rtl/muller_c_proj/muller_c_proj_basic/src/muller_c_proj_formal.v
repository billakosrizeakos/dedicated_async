`include "muller_c_proj.v"

module muller_c_proj_formal #(
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


`ifdef FORMAL
    genvar i;
    input_zeros: cover property (io_in == {N{1'b0}});
    // Cover all intermediate combinations where inputs are not all equal
    generate
        for (i = 0; i < 2**N; i++) begin
            cover property (io_in == i); 
        end
    endgenerate
    input_ones: cover property (io_in == {N{1'b1}});

    always @(io_in) begin
        transition_0_to_0: assert property (!(|io_in == 1'b0) | (!(!out_prev) | (!io_out)));
        transition_0_to_1: assert property (!(&io_in == 1'b1) | (!(!out_prev) | (io_out)));
        transition_1_to_0: assert property (!(|io_in == 1'b0) | (!(out_prev) | (!io_out)));
        transition_1_to_1: assert property (!(&io_in == 1'b1) | (!(out_prev) | (io_out)));
        transition_stay: assert property (((|io_in == 1'b0) | (&io_in == 1'b1)) | (out_prev == io_out));
    end



`endif // FORMAL
endmodule
