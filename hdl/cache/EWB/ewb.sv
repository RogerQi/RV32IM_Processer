import rv32i_types::*;

module ewb(
    input logic clk,
    mem_rw_itf.server upper,
    mem_rw_itf.requestor lower
);

logic hit, valid, load, dec_counter, reset_counter, set_valid, clear_valid;
logic [3:0] counter;

ewb_control control(
    .clk,
    .u_read(upper.read),
    .u_write(upper.write),
    .l_resp(lower.resp),
    .hit,
    .valid,
    .counter,
    .dec_counter,
    .reset_counter,
    .load,
    .set_valid,
    .clear_valid,
    .l_read(lower.read),
    .l_write(lower.write),
    .u_resp(upper.resp)
);

ewb_datapath datapath(
    .clk,
    .u_addr(upper.addr),
    .u_wdata(upper.wdata),
    .l_rdata(lower.rdata),
    .l_wdata(lower.wdata),
    .u_rdata(upper.rdata),
    .l_addr(lower.addr),
    .l_write(lower.write),
    .load,
    .set_valid,
    .clear_valid,
    .dec_counter,
    .reset_counter,
    .hit,
    .valid,
    .counter
);

endmodule : ewb