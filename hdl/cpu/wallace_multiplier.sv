// 32bit unsigned wallace multiplier
module wallace_multiplier #(parameter width = 32) (
    input clk,
    input start,
    input [width - 1:0] fake_a, fake_b,
    output logic [2*width-1:0] fake_f,
    output logic done
);
    logic [width - 1:0] a, b;
    logic [2*width-1:0] f;
    /* Start combinational Wallace multiplier */
    logic [width:0] layer_output_vec[width]; // width + 1
    // Initial layer
    assign layer_output_vec[0] = {1'b0, a & {width{b[0]}}};
    assign f[0] = layer_output_vec[0][0];

    // Other layers
    genvar i;
    generate
        for (i = 1; i < width; i = i + 1) begin: layer_gen
            assign layer_output_vec[i] = {a & {width{b[i]}}} + layer_output_vec[i - 1][width:1];
            assign f[i] = layer_output_vec[i][0];
        end
    endgenerate
    // assign from width upto width - 1
    assign f[2 * width - 1:width] = layer_output_vec[width - 1][width : 1];

    /* Start control logic */
    /* Thank you Quartus Timing analyzer! */
    enum int unsigned {
        IDLE, CALCULATING, DONE
    } state, next_state;

    always_comb begin : state_assignment
        // default
        next_state = state;
        done = 1'b1;
        unique case (state)
            IDLE: begin
                if (start) begin
                    done = 1'b0;
                    next_state = CALCULATING;
                end
            end
            CALCULATING: begin
                done = 1'b0;
                next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

    always_ff @ (posedge clk) begin : register_assign
        state <= next_state;
        // input registers
        a <= fake_a;
        b <= fake_b;
        // output registers
        fake_f <= f;
    end

endmodule : wallace_multiplier
