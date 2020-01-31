import rv32i_types::*;

`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

// 24-bit local BHT; 128-byte PHT
module branch_predictor #(
    parameter PC_INDEX_WIDTH = 5,                   // bits taken from PC as table index
    parameter GBHR_WIDTH = 3,                       // GBHR width
    parameter PHT_WIDTH = 2,                        // PHY entry width
    parameter PHT_COLUMNS = 2**GBHR_WIDTH,          // PHT # of ways (columns)
    parameter PHT_ROWS = 2**PC_INDEX_WIDTH          // PHT # of rows
)
(
    input logic clk,
    
    input logic stall,

    // input from IF stage
    input rv32i_word IF_pc,
    input rv32i_word IF_instruction,
    
    // input from EX stage
    input rv32i_word EX_pc,
    input logic EX_br_en,
    input rv32i_opcode EX_opcode,
    
    output logic br_taken
);

// assign br_taken = 1'b0;

logic load_gbhr;
logic load_pht;

logic [PC_INDEX_WIDTH-1:0] pc_idx;      // as PHT read row index
logic [GBHR_WIDTH-1:0] gbhr_out;        // as PHT column index
logic [PC_INDEX_WIDTH-1:0] EX_pc_idx;   // as PHT write row index

// pick some bits from PC as PHT index
assign pc_idx = {IF_pc[7:6], IF_pc[4:2]}; // IF_pc[1+PC_INDEX_WIDTH:2];
assign EX_pc_idx = {EX_pc[7:6], EX_pc[4:2]}; // EX_pc[1+PC_INDEX_WIDTH:2];

// GBHR load logic
assign load_gbhr = EX_opcode == op_br & ~stall;

// PHT load logic
assign load_pht = EX_opcode == op_br & ~stall;

shift_register #(GBHR_WIDTH) GBHR(
    .clk(clk),
    .shift(load_gbhr),
    .serial_in(EX_br_en),
    .parallel_out(gbhr_out)
);

pattern_history_table #(
    PHT_WIDTH,
    PHT_ROWS,
    PHT_COLUMNS
) PHT (
    .clk(clk),
    .br_en_in(EX_br_en),
    .load_pht(load_pht),
    .read_row_idx(pc_idx),
    .read_col_idx(gbhr_out),
    .write_row_idx(EX_pc_idx),
    .write_col_idx(gbhr_out),
    .br_taken(br_taken)
);

endmodule : branch_predictor