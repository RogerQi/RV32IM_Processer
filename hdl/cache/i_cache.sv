`include "cache_parameter.sv"

module i_cache #(
    parameter SETS = `I_SETS,
    parameter ASSOCIATIVITY = `I_ASSOCIATIVITY,
    parameter WIDTH = 256,
    parameter W_INDEX = $clog2(SETS),
    parameter W_OFFSET = $clog2(WIDTH/8),
    parameter W_TAG = 32-W_INDEX-W_OFFSET
)(
    input logic             clk,
    mem_ro_itf.server       cpu,
    mem_ro_itf.requestor    arb
);

    logic [WIDTH-1:0] cache_rdata256;
    logic set_valid, load_data, read_data, load_tag, load_lru, hit;

    line_adapter_ro line_adapter(
        .mem_rdata256   (cache_rdata256),
        .mem_rdata      (cpu.rdata),
        .address        (arb.addr)
    );

    assign arb.addr = cpu.addr;

    i_cache_ctrl ctrl (
        .clk            (clk),
        .mem_read       (cpu.read),
        .cache_resp     (cpu.resp),
        .pmem_read      (arb.read),
        .pmem_resp      (arb.resp),
        // Ctrl - Data
        .set_valid      (set_valid),
        .load_data      (load_data),
        .read_data      (read_data),
        .load_tag       (load_tag),
        .load_lru       (load_lru),
        // Data - Ctrl
        .hit            (hit)
    );

    i_cache_datapath #(
        SETS, ASSOCIATIVITY, WIDTH
    ) datapath (
        .clk        (clk),
        .cpu_addr   (arb.addr),
        .cpu_rdata  (cache_rdata256),
        .arb_rdata  (arb.rdata),
        // Ctrl - Data
        .set_valid_in(set_valid),
        .load_data_in(load_data),
        // .read_data  (read_data),
        .load_tag_in(load_tag),
        .load_lru_in(load_lru),
        // Data - Ctrl
        .hit_out    (hit)
    );

endmodule : i_cache
