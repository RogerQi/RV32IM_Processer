module pattern_history_table #(
    parameter ENTRY_WIDTH = 2,
    parameter NUM_ROWS = 64,
    parameter NUM_COLUMNS = 8,
    parameter ROW_IDX_WIDTH = $clog2(NUM_ROWS),
    parameter COL_IDX_WIDTH = $clog2(NUM_COLUMNS)
)
(
    input logic clk,

    input logic br_en_in,
    input logic load_pht,
    input logic [ROW_IDX_WIDTH-1:0] read_row_idx,
    input logic [COL_IDX_WIDTH-1:0] read_col_idx,
    input logic [ROW_IDX_WIDTH-1:0] write_row_idx,
    input logic [COL_IDX_WIDTH-1:0] write_col_idx,

    output logic br_taken
);

logic [ENTRY_WIDTH-1:0] predict_state [NUM_ROWS * NUM_COLUMNS] /* synthesis ramstyle = "logic" */ = '{default: '0};

// read logic
logic [(ROW_IDX_WIDTH+COL_IDX_WIDTH)-1:0] read_idx;
assign read_idx = {read_row_idx, read_col_idx};
assign br_taken = predict_state[read_idx][ENTRY_WIDTH-1];

// write logic
logic [(ROW_IDX_WIDTH+COL_IDX_WIDTH)-1:0] write_idx;
assign write_idx = {write_row_idx, write_col_idx};

always_ff @ (posedge clk) begin : PHT_UPDATE_LOGIC
    if (load_pht) begin
        if (br_en_in) begin
            if (&predict_state[write_idx] != 1'b1)
                predict_state[write_idx] <= predict_state[write_idx] + 1;
        end else begin
            if (|predict_state[write_idx] != 1'b0)
                predict_state[write_idx] <= predict_state[write_idx] - 1;
        end
    end
end

endmodule : pattern_history_table