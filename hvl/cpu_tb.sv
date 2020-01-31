/* 
 * This testbench tests the CPU datapath with the magic memory
 */

module cpu_tb;

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
always @(posedge itf.clk iff (itf.read_b && itf.write))
    $error("@%0t TOP: Simultaneous memory read and write detected", $time);

/*****************************************************************************/

mem_ro_itf #(32, 32) cpu_imem();
mem_rw_itf #(32, 32) cpu_dmem();

cpu_datapath dut (
    .clk(itf.clk),
    .I(cpu_imem.requestor),
    .D(cpu_dmem.requestor)
);

magic_memory_dp magic_memory(
    .clk(itf.clk),
    /* Inst Mem */
    .read_a(cpu_imem.read),
    .address_a(cpu_imem.addr),
    .resp_a(cpu_imem.resp),
    .rdata_a(cpu_imem.rdata),
    /* Data Mem */
    .read_b(cpu_dmem.read),
    .write(cpu_dmem.write),
    .wmask(cpu_dmem.wmask),
    .address_b(cpu_dmem.addr),
    .wdata(cpu_dmem.wdata),
    .resp_b(cpu_dmem.resp),
    .rdata_b(cpu_dmem.rdata)
);

assign itf.registers = dut.regfile.data;

endmodule : cpu_tb
