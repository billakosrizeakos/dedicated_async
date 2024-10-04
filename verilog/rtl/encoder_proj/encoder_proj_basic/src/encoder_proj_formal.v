`include "encoder_proj.v"

module encoder_proj_formal #(
    parameter N = 64
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input [N-1:0] io_in,
    output [N-1:0] io_out
);

    localparam k = $clog2(N);
    // CUSTOM SIGNALS
    wire [k:0] encoded_out;

    assign io_out = {{(N-k-1){1'b0}}, encoded_out};

    onehot2bin #(.N(N)) encoder (
        .in(io_in),
        .out(encoded_out[k-1:0]),
        .valid(encoded_out[k])
    );


    // FORMAL
    integer int_i;
    // Observers
    wire [N-1:0] diff;
    reg [N-1:0] decoded_out;
    integer signal_count;

    // Initial conditions
    initial begin
        signal_count = 0;
    end

    always @(io_out) begin
        decoded_out = 0;
        if (io_out[k] != 0)
            decoded_out[io_out[k-1:0]] = 1'b1;
    end

    assign diff = io_in - decoded_out;

    diff_positive: assert property (diff >= 0);
    count_uv: assert property (signal_count >= 0);
    count_ov: assert property (signal_count <= N);
    always @(io_in) begin
        // Cover situation when input is all zeros
        input_empty: cover property (io_in == 0);
        // Cover situations of only one signal at the input
        for (int_i = 0; int_i < N; int_i++) begin
            cover property (io_in[int_i] == 1); 
        end
        // Cover situations of multiple signals at the input
        for (int_i = 0; int_i < N - 2; int_i++) begin
            cover property (io_in[int_i] == 1 && io_in[int_i+2] == 1);
        end
        for (int_i = 0; int_i < N - 4; int_i++) begin
            cover property (io_in[int_i] == 1 && io_in[int_i+4] == 1);
        end
        // Cover situations of epilepsy
        input_full: cover property (io_in == {N{1'b1}});

        signal_count = 0;
        for (int_i = 0; int_i < N; int_i++) begin
            if (io_in[int_i]) begin
                signal_count = signal_count + 1;
            end
        end
        if (signal_count == 0)          // In case no input is given: I=0
            op_noop: assert property (io_in == 0 && decoded_out == 0 && diff == 0 && io_out[k] == 0);
        else if (signal_count == 1 )    // In case input has only one bit high
            op_normal: assert property (io_in == decoded_out && diff == 0 && io_out[k] == 1);
        else                            // In case input has multiple bits high
            op_multiple: assert property (io_in > decoded_out && diff > 0 && diff < decoded_out && io_out[k] == 1);
    end

endmodule
