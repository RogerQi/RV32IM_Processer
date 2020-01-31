`include "cache_parameter.sv"
//
// import rv32i_types::*;

module d_cache (
    input logic             clk,
    mem_rw_itf.server       cpu,
    mem_rw_itf.requestor    arb
);

// bus adapter signals
logic [255:0]   mem_wdata256;
logic [255:0]   mem_rdata256;
logic [31:0]    mem_byte_enable256;


line_adapter_rw adapter(
    .mem_wdata256(mem_wdata256),
    .mem_rdata256(mem_rdata256),
    .mem_wdata(cpu.wdata),
    .mem_rdata(cpu.rdata),
    .mem_byte_enable(cpu.wmask),
    .mem_byte_enable256(mem_byte_enable256),
    .address(cpu.addr)
);

// control unit signals
logic hit;
logic dirty;
logic cache_resp;
logic set_dirty;
logic clear_dirty;
logic set_valid;
logic load_data;
logic read_data;
logic load_tag;
logic load_lru;

assign cpu.resp = cache_resp;

dcache_control control(
    .clk,
    .pmem_resp(arb.resp),
    .mem_read(cpu.read),
    .mem_write(cpu.write),
    .hit,
    .dirty,
    .cache_resp,
    .set_dirty,
    .clear_dirty,
    .set_valid,
    .load_data,
    .read_data,
    .load_tag,
    .load_lru,
    .pmem_read(arb.read),
    .pmem_write(arb.write)
);

dcache_datapath # (
    `D_ASSOCIATIVITY,
    5,
    `D_W_INDEX
) datapath (
    .clk,
    .set_dirty,
    .clear_dirty,
    .set_valid,
    .load_data,
    .read_data,
    .load_tag_in(load_tag),
    .load_lru,
    .pmem_read(arb.read),
    .mem_address(cpu.addr),
    .mem_byte_enable256,
    .mem_wdata256,
    .pmem_rdata(arb.rdata),
    .mem_rdata256,
    .hit_out(hit),
    .dirty_out(dirty),
    .pmem_wdata(arb.wdata),
    .pmem_address(arb.addr)
);

endmodule : d_cache
