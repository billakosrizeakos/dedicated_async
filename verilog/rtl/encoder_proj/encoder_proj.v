`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * encoder_proj
 *
 *-------------------------------------------------------------
 */

module encoder_proj #(
    parameter N = 64
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input  logic [N-1:0] io_in,
    output logic [$clog2(N)-1:0] io_out,
    output logic valid
);

    onehot2bin #(.N(N)) encoder (
        .in(io_in),
        .out(io_out),
        .valid(valid)
    );
    
endmodule

module onehot2bin #(
    parameter N = 64
)(
    input  logic [N-1:0] in,
    output logic [$clog2(N)-1:0] out,
    output logic valid
);

    integer i;
    parameter k = $clog2(N);
    assign valid = |in;

    always @(in) begin
        out = 0;
        for (i = 0; i < N; i++) begin
            if (in[i[k-1:0]]) begin
                out = i[k-1:0];
            end
        end
    end
    

endmodule

`default_nettype wire
