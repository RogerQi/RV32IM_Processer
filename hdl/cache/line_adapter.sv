// Read/Write bus adapter
module line_adapter_rw
(
    output [255:0] mem_wdata256,
    input [255:0] mem_rdata256,
    input [31:0] mem_wdata,
    output [31:0] mem_rdata,
    input [3:0] mem_byte_enable,
    output logic [31:0] mem_byte_enable256,
    input [31:0] address
);

assign mem_wdata256 = {8{mem_wdata}};
assign mem_rdata = mem_rdata256[(32*address[4:2]) +: 32];
assign mem_byte_enable256 = {28'h0, mem_byte_enable} << (address[4:2]*4);

endmodule : line_adapter_rw

// Read Only bus adapter
module line_adapter_ro
(
    input [255:0] mem_rdata256,
    output [31:0] mem_rdata,
    input [31:0] address
);

    assign mem_rdata = mem_rdata256[(32*address[4:2]) +: 32];

endmodule : line_adapter_ro
