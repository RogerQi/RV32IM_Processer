`include "../cache_parameter.sv"
//
// import rv32i_types::*;

module L2_cache (
    input logic             clk,
    mem_rw_itf.server       arb,
    mem_rw_itf.requestor    mem
);

// control unit signals
logic hit;
logic dirty;
logic set_dirty;
logic clear_dirty;
logic set_valid;
logic load_data;
logic read_data;
logic load_tag;
logic load_lru;
logic pmem_read_address_hold;

L2_cache_control control (
    .clk,
    .pmem_resp(mem.resp),
    .mem_read(arb.read),
    .mem_write(arb.write),
    .hit,
    .dirty,
    .cache_resp(arb.resp),
    .set_dirty,
    .clear_dirty,
    .set_valid,
    .load_data,
    .read_data,
    .load_tag,
    .load_lru,
    .pmem_read_address_hold,
    .pmem_read(mem.read),
    .pmem_write(mem.write)
);

L2_cache_datapath # (
    `L2_ASSOCIATIVITY,
    5,
    `L2_W_INDEX
) datapath (
    .clk,
    .set_dirty,
    .clear_dirty,
    .set_valid,
    .load_data,
    .read_data,
    .load_tag_in(load_tag),
    .load_lru,
    .pmem_read_address_hold,
    .mem_read(arb.read),
    .pmem_read(mem.read),
    .mem_address(arb.addr),
    .mem_wdata256(arb.wdata),
    .pmem_rdata(mem.rdata),
    .mem_rdata256(arb.rdata),
    .hit_out(hit),
    .dirty_out(dirty),
    .pmem_wdata(mem.wdata),
    .pmem_address(mem.addr)
);

endmodule : L2_cache
