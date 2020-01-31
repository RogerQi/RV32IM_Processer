// performace counter that counts number of branch prediction hits and misses

import rv32i_types::*;

module branch_predictor_performance_counter(
    input logic clk,
    input rv32i_opcode EX_opcode,
    input logic cpu_flush,
    input logic cpu_stall,
    input logic halt
);

int num_hit;
int num_miss;
real accuracy;

initial begin
    num_hit = 0;
    num_miss = 0;
    accuracy = 0.0;
end

logic hit;
logic miss;

assign hit = EX_opcode == op_br && !cpu_flush;
assign miss = EX_opcode == op_br && cpu_flush;

always @ (posedge clk) begin
    if (~halt & ~cpu_stall) begin
        if (hit)
            num_hit++;
        if (miss)
            num_miss++;
        if ((num_hit + num_miss) != 0)
            accuracy = 1.0 * num_hit / (num_hit + num_miss);
    end
end

endmodule : branch_predictor_performance_counter