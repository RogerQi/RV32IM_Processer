
module regfile (
    input clk,
    input load,
    input [31:0] in,
    input [4:0] src_a, src_b, dest,
    output logic [31:0] reg_a, reg_b
);

logic [31:0] data [32] /* synthesis ramstyle = "logic" */ = '{default:'0};

always_ff @(posedge clk) begin
    if (load == 1'b1 && dest != 5'b0) begin
        data[dest] <= in;
    end
end

always_comb begin
    reg_a = src_a ? data[src_a] : 0;
    reg_b = src_b ? data[src_b] : 0;
end

endmodule : regfile
