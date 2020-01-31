module dcache_tb;

timeunit 1ns;
timeprecision 1ns;

tb_itf itf(); // We need to clock from this interface
int timeout = 10000;

/************************* Error Halting Conditions **************************/
// Stop simulation on timeout (stall detection), halt
always @(posedge itf.clk) begin
    if (itf.halt) begin
        repeat (30) @(posedge itf.clk);
        $finish;
    end
    if (timeout == 0) begin
        $display("TOP: Timed out");
        $finish;
    end
    timeout <= timeout - 1;
end

// Stop simulation on memory error detection
always @(posedge itf.clk iff (itf.pmem_error)) begin
    $display("TOP: Halting on %s Memory Error", "Physical Memory Error");
end

// Simulataneous Memory Read and Write
always @(posedge itf.clk iff (itf.read_b && itf.write))
    $error("@%0t TOP: Simultaneous memory read and write detected", $time);

/*****************************************************************************/
mem_ro_itf #(32, 32) cpu_icache(); // needs manual control
mem_rw_itf #(32, 32) cpu_dcache(); // needs manual control
mem_rw_itf dcache_arb();
mem_ro_itf icache_arb();
mem_rw_itf arb_pmem();

i_cache i_cache (
    .clk(itf.clk),
    .cpu(cpu_icache.server),
    .arb(icache_arb.requestor)
);

d_cache d_cache (
    .clk(itf.clk),
    .cpu(cpu_dcache.server),
    .arb(dcache_arb.requestor)
);

arbiter arbiter (
    .clk(itf.clk),
    .I(icache_arb.server),
    .D(dcache_arb.server),
    .L2(arb_pmem.requestor)
);

memory pmem (
    .clk    (itf.clk),
    .read   (arb_pmem.read),
    .write  (arb_pmem.write),
    .address(arb_pmem.addr),
    .wdata  (arb_pmem.wdata),
    .resp   (arb_pmem.resp),
    .error  (itf.pmem_error),
    .rdata  (arb_pmem.rdata)
);

task wait_miss();
    @(itf.clk iff (cpu_dcache.resp == 1'b0));
    @(itf.clk iff (cpu_dcache.resp));
endtask : wait_miss

task wait_hit();
    #1;
    assert (cpu_dcache.resp == 1'b1) else $fatal("Should immediately resp");
endtask : wait_hit

initial begin
    /* Initialization */
    cpu_icache.read = 1'b0;
    cpu_icache.addr = 32'b0;
    //wait_miss(); // first dump 0x0 stall
    /* Test 1: Single Memory Read */
    cpu_dcache.addr = 32'h00000060; // first instruction for mp3-cp2a.S. Expected output: 0x02000063
    cpu_dcache.read = 1'b1;
    cpu_dcache.write = 1'b0;
    cpu_dcache.wmask = 4'b0;
    cpu_dcache.wdata = 32'b0;
    wait_miss();
    wait_miss();
    assert (cpu_dcache.rdata == 32'h02000063) else $fatal("%0t %s %0d: Fatal error; mismatched.", $time, `__FILE__, `__LINE__);
    @(posedge itf.clk); // hold the values
    assert (cpu_dcache.rdata == 32'h02000063) else $fatal("Failed to hold values");
    @(posedge itf.clk);
    assert (cpu_dcache.rdata == 32'h02000063) else $fatal("Failed to hold values");
    /* Test 2: Multiple Memory Reads and Fake CPU stalls */
    // We should have a set in cache after test 1...
    // Read from the same set...
    cpu_dcache.addr = 32'h0000007c;
    @(posedge itf.clk);
    cpu_dcache.addr = 32'h00000070;
    @(posedge itf.clk);
    assert (cpu_dcache.rdata == 32'h00000013) else $fatal("[TEST2] Same set Mismatched");
    cpu_dcache.addr = 32'h00000134; // read from a different set
    @(posedge itf.clk);
    cpu_dcache.addr = 32'h00000080; // read from another different set
    assert (cpu_dcache.rdata == 32'h00000013) else $fatal("[TEST2] Same set mismatched");
    @(posedge itf.clk);
    // should be a miss here...
    assert (cpu_dcache.resp == 1'b0) else $fatal("[TEST2] SHOULD NOT RESP");
    /* LRU TEST */
    cpu_dcache.addr = 32'h00000264;
    wait_miss();
    assert (cpu_dcache.rdata == 32'h26542023) else $fatal("[TEST2] Different Set mismatched");
    // Next memory access should be at the second stage of the pipeline
    assert (d_cache.datapath.OUT.prev_cpu_addr == 32'h00000264) else $fatal("[TEST2] Unexpected pipeline stage match.");
    cpu_dcache.addr = 32'h00000060; // access the original value
    wait_miss();
    // value at 0x264 should be ready now!
    assert (cpu_dcache.rdata == 32'h00000013) else $fatal("[TEST2] Rdata Mismatched");
    assert (d_cache.datapath.OUT.prev_cpu_addr == 32'h0000060) else $fatal("[TEST2] Unexpected pipelien stage value mismatched");
    @(posedge itf.clk);
    // should be a hit
    assert (cpu_dcache.resp == 1'b1) else $fatal("[TEST2] Cache should be ready");
    assert (cpu_dcache.rdata == 32'h02000063) else $fatal("Value should not be overwritten");
    /* Test 4: Read after single Write */
    /* Test 5: Single Writeback */
    /* Test 6: Multiple Reads after multiple writes and writebacks */
    /* TODO: add unaligned memory tests */
    /* No error; exit. */
    itf.halt = 1'b1;
end

endmodule : dcache_tb
