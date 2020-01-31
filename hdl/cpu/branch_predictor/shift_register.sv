// a shift register that always shift left

module shift_register #(parameter width = 3) (
    input logic clk,

    input logic shift,
    input logic serial_in,

    output logic [width-1:0] parallel_out
);

logic [width-1:0] data = '0;

always_ff @ (posedge clk) begin
    if (shift)
        data <= {data[width-1:1], serial_in};
end

assign parallel_out = data;

endmodule : shift_register