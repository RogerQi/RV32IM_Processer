module restoring_divider #(parameter width = 32) (
    input clk,
    input [width-1:0] numerator,
    input [width-1:0] denominator,
    input logic start_i,
    output logic [width-1:0] result_o,
    output logic [width-1:0] remainder_o,
    output logic done_o
);

enum int unsigned {
    IDLE, LOOPING, DONE
} state, next_state;

int unsigned looping_counter;
int unsigned next_looping_counter;

// These notations are consistent with those on the Wikipedia
logic [2*width-1:0] R, D;
logic [2*width-1:0] next_R, next_D;
logic [2*width-1:0] temp_R;

logic [width-1:0] Q;
logic [width-1:0] next_Q;

// assign result_o = numerator / denominator;
// assign remainder_o = numerator % denominator;
assign result_o = Q;
assign remainder_o = R[2*width-1:width];
assign temp_R = {R[2*width-1:1], 1'b0} - D;

always_comb begin : mealy_machine
    // default
    next_state = state;
    next_looping_counter = '0;
    next_R = R;
    next_D = D;
    next_Q = Q;
    done_o = 1'b0;
    unique case (state)
        IDLE: begin
            if (start_i) begin
                next_state = LOOPING;
                next_looping_counter = width - 1;
                next_R = {{width{1'b0}}, numerator};
                next_D = {denominator, {width{1'b0}}};
                next_Q = '0;
            end else begin
                done_o = 1'b1;
            end
        end
        LOOPING: begin
            // computation
            if (temp_R[2*width-1] == 1'b1) begin
                next_Q[looping_counter] = 1'b0;
                next_R = temp_R + D;
            end else begin
                next_Q[looping_counter] = 1'b1;
                next_R = temp_R;
            end
            // holds D
            // state transition
            if (looping_counter == 0) begin
                // Looping is finished
                next_state = DONE;
            end else begin
                next_state = LOOPING;
                next_looping_counter = looping_counter - 1;
            end
        end
        DONE: begin
            done_o = 1'b1;
            next_state = IDLE;
        end
        default: begin next_state = IDLE; end
    endcase
end

always_ff @ (posedge clk) begin : next_state_assignment
    state <= next_state;
    looping_counter <= next_looping_counter;
    R <= next_R;
    D <= next_D;
    Q <= next_Q;
end

endmodule : restoring_divider
