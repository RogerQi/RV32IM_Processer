// `include "./rv32i_types.sv"

import rv32i_types::*;

module mp3 (
    input logic clk,
    // CPU to Data Memory
    output logic pmem_read,
    output logic pmem_write,
    output physical_mem_wmask pmem_wmask,
    output rv32i_word pmem_addr,
    output physical_mem_word pmem_wdata,
    // Data Memory to CPU
    input logic pmem_resp,
    input physical_mem_word pmem_rdata
);

    mem_ro_itf #(32, 32) cpu_icache();
    mem_rw_itf #(32, 32) cpu_dcache();
    mem_rw_itf dcache_arb();
    mem_ro_itf icache_arb();
    mem_rw_itf arb_L2();
    mem_rw_itf L2_ewb();
    mem_rw_itf ewb_mem();

    cpu_datapath cpu (
        .clk,
        .I(cpu_icache.requestor),
        .D(cpu_dcache.requestor)
    );

    i_cache i_cache (
        .clk,
        .cpu(cpu_icache.server),
        .arb(icache_arb.requestor)
    );

    d_cache d_cache (
        .clk,
        .cpu(cpu_dcache.server),
        .arb(dcache_arb.requestor)
    );

    arbiter arbiter (
        .clk,
        .I(icache_arb.server),
        .D(dcache_arb.server),
        .L2(arb_L2.requestor)
    );

    L2_cache L2_cache (
        .clk,
        .arb(arb_L2.server),
        .mem(ewb_mem.requestor)
    );

    // Any better way of doing this?
    assign pmem_read = ewb_mem.read;
    assign pmem_write = ewb_mem.write;
    assign pmem_wmask = ewb_mem.wmask;
    assign pmem_addr = ewb_mem.addr;
    assign pmem_wdata = ewb_mem.wdata;
    assign ewb_mem.resp = pmem_resp;
    assign ewb_mem.rdata = pmem_rdata;

endmodule : mp3
