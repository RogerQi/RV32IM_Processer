import rv32i_types::*;

module ewb_datapath(
    input logic clk,

    // signals from/to other memories
    input rv32i_word u_addr,
    input physical_mem_word u_wdata,
    input physical_mem_word l_rdata,
    output physical_mem_word l_wdata,
    output physical_mem_word u_rdata,
    output rv32i_word l_addr,
    input logic l_write,

    // signals from/to controller
    input logic load,
    input logic set_valid,
    input logic clear_valid,
    input logic dec_counter,
    input logic reset_counter,
    output logic hit,
    output logic valid,
    output logic [3:0] counter
);

logic [26:0] tag_out;
physical_mem_word data_out;

register #(27) tag(
    .clk,
    .load,
    .in(u_addr[31:5]),
    .out(tag_out)
);

register #(256) data(
    .clk,
    .load,
    .in(u_wdata),
    .out(data_out)
);

register #(1) is_valid(
    .clk,
    .load(set_valid | clear_valid),
    .in(set_valid),
    .out(valid)
);

// counter
always_ff @ (posedge clk) begin : COUNTER_LOGIC
    if (reset_counter)
        counter <= 4'b1010;
    else if (dec_counter)
        if (|counter)   // prevent overflow (which should never happen)
            counter <= counter - 1;
end

// datapath logic
assign hit = valid & (u_addr[31:5] == tag_out);
assign l_wdata = data_out;
assign u_rdata = hit ? l_wdata : l_rdata;
assign l_addr = l_write ? {tag_out, 5'b0} : u_addr;

endmodule : ewb_datapath