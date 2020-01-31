/* 
 * This testbench tests the CPU datapath with the magic memory
 */

import rv32i_types::*;

module cp2_tb;

timeunit 1ns;
timeprecision 1ns;

/*********************** Variable/Interface Declarations *********************/
tb_itf itf();
int timeout = 10000;   // Feel Free to adjust the timeout value
assign itf.halt = dut.cpu.load_pc & (dut.cpu.EX_in.pc == dut.cpu.pcmux_out);
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
logic clk;
logic pmem_read, pmem_write;
physical_mem_wmask pmem_wmask;
rv32i_word pmem_addr;
physical_mem_word pmem_wdata;
logic pmem_resp;
physical_mem_word pmem_rdata;
assign clk = itf.clk;

mp3 dut(
    .clk,
    // CPU to Data Memory
    .pmem_read,
    .pmem_write,
    .pmem_wmask,
    .pmem_addr,
    .pmem_wdata,
    // Data Memory to CPU
    .pmem_resp,
    .pmem_rdata
);

/********************************** END DUT ***********************************/

/**************************** PREFORMANCE COUNTERS ****************************/
int bp_num_hit;
int bp_num_miss;
int total_branch_num;
real bp_accuracy;

branch_predictor_performance_counter bp_perf_counter(
    .clk(clk),
    .EX_opcode(dut.cpu.EX_in.ctrl_word.opcode),
    .cpu_flush(dut.cpu.flush),
    .cpu_stall(dut.cpu.stall),
    .halt(itf.halt)
);

assign bp_num_hit = bp_perf_counter.num_hit;
assign bp_num_miss = bp_perf_counter.num_miss;
assign total_branch_num = bp_num_hit + bp_num_miss;
assign bp_accuracy = bp_perf_counter.accuracy;

/************************** END PREFORMANCE COUNTERS **************************/

memory physical_memory (
    .clk        (clk),
    .read       (pmem_read),
    .write      (pmem_write),
    .address    (pmem_addr),
    .wdata      (pmem_wdata),
    .resp       (pmem_resp),
    .error      (itf.pmem_error),
    .rdata      (pmem_rdata)
);

assign itf.registers = dut.cpu.regfile.data;

endmodule : cp2_tb
