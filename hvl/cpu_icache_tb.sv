/* 
 * This testbench tests the CPU datapath with the magic memory
 */

module cpu_icache_tb;

timeunit 1ns;
timeprecision 1ns;

/*********************** Variable/Interface Declarations *********************/
tb_itf itf();
int timeout = 10000;   // Feel Free to adjust the timeout value
assign itf.halt = dut.load_pc & (dut.EX_in.pc == dut.pcmux_out);
/*****************************************************************************/

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

// Simulataneous Memory Read and Write
always @(posedge itf.clk iff (arb_pmem.read && arb_pmem.write))
    $error("@%0t TOP: Simultaneous memory read and write detected", $time);

// Halt on pmem error
always @(posedge itf.clk iff (itf.pmem_error))
    $error("Physical Memory error.", $time);

/************************************ DUT *************************************/

logic clk;
assign clk = itf.clk;

mem_ro_itf #(32, 32) cpu_icache();
mem_rw_itf #(32, 32) cpu_dcache();
mem_rw_itf dcache_arb();
mem_ro_itf icache_arb();
mem_rw_itf arb_pmem();

cpu_datapath dut (
    .clk,
    .I(cpu_icache.requestor),
    .D(cpu_dcache.requestor)
);

i_cache i_cache (
    .clk,
    .cpu(cpu_icache.server),
    .arb(icache_arb.requestor)
);

// we connect MEM stage directly to the arbiter; hence a fake dcache
// there is no wmask support in physical memory, so don't write to dcache!
line_adapter_rw fack_dcache (
    .mem_wdata256(dcache_arb.wdata),
    .mem_rdata256(dcache_arb.rdata),
    .mem_wdata(cpu_dcache.wdata),
    .mem_rdata(cpu_dcache.rdata),
    .mem_byte_enable(cpu_dcache.wmask),
    .mem_byte_enable256(dcache_arb.wmask),
    .address(cpu_dcache.addr)
);

assign cpu_dcache.resp = dcache_arb.resp;
assign dcache_arb.read = cpu_dcache.read;
assign dcache_arb.write = 1'b0; // don't write
assign dcache_arb.addr = cpu_dcache.addr;

arbiter arbiter (
    .clk, 
    .I(icache_arb.server), 
    .D(dcache_arb.server), 
    .L2(arb_pmem.requestor)
);

/********************************** END DUT ***********************************/

memory physical_memory (
    .clk        (clk),
    .read       (arb_pmem.read),
    .write      (arb_pmem.write),
    .address    (arb_pmem.addr),
    .wdata      (arb_pmem.wdata),
    .resp       (arb_pmem.resp),
    .error      (itf.pmem_error),
    .rdata      (arb_pmem.rdata)
);

assign itf.registers = dut.regfile.data;

endmodule : cpu_icache_tb
