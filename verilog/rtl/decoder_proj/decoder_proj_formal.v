`include "arbiter_cell_two_bits_fc.v"

module decoder_proj_formal #(
    parameter k = 6
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input [k:0] io_in,
    output [(2**k)-1:0] io_out
);

    wire enable;
    assign enable = io_in[k];

    bin2onehot #(.k(k)) decoder (
        .enable(enable),
        .in(io_in[k-1:0]),
        .out(io_out)
    );


    // FORMAL
    localparam N = 2**k;
    reg [k-1:0] i;
    // Observers
    wire [N-1:0] diff;
    reg [N-1:0] encoded_out;

    always @(io_out) begin
        encoded_out = 0;
        for (i = 0; i < N; i++) begin
            if (io_out[i]) begin
                encoded_out = i;
            end
        end
    end

    assign diff = io_in[k-1:0] - encoded_out;

    always @(io_in) begin
        for (i = 0; i < N; i++) begin
            cover property (io_in[k-1:0] == i); 
        end

        enable_on: cover property (io_in[k] == 1'b1);
        enable_off: cover property (io_in[k] == 1'b0);
    end

    diff_zero: assert property (io_in[k] == 1'b0 || diff == 0); // p -> q = ~p V q
    op_normal: assert property (io_in[k] == 1'b0 || (io_in[k-1:0] == encoded_out));


endmodule
