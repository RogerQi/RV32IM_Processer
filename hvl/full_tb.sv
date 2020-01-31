/*
 * This testbench tests the CPU datapath with the magic memory
 */

`include "../hdl/cache/cache_parameter.sv"

import rv32i_types::*;

module full_tb;

timeunit 100ps;
timeprecision 100ps;

// frequency in MHz
localparam real real_freq = 100;

/*********************** Variable/Interface Declarations *********************/
tb_itf #(real_freq) itf();
int unsigned timeout = 0;   // Feel Free to adjust the timeout value
assign itf.halt = dut.cpu.load_pc & (dut.cpu.EX_in.pc == dut.cpu.pcmux_out);
/*****************************************************************************/

/************************* Error Halting Conditions **************************/
// Stop simulation on timeout (stall detection), halt
always @(posedge itf.clk) begin
    if (itf.halt) begin
        repeat (30) @(posedge itf.clk);
        $display("Dumping register file...");
        for (int i = 0; i < 32; i++)
            $display("[Reg %02d]: 0x%h", i, itf.registers[i]);
        $display("Gathering branching accuracy");
        $display("Total number of OP_BR: %d; MISSES: %d; HIT: %d", total_branch_num, bp_num_miss, bp_num_hit);
        $display("Branch predictor accuracy: %f", bp_accuracy);
        $display("Total cycles elapsed: %d", timeout);
        $display("L2 Cache total hit %0d, total miss %0d", l2_total_hit, l2_miss);
        for (int i = 0; i < `L2_ASSOCIATIVITY; i++)
            $display("L2_Hit[%0d] = %0d", i, l2_hit[i]);
        $display("D Cache total hit %0d, total miss %0d", d_total_hit, d_miss);
        for (int i = 0; i < `D_ASSOCIATIVITY; i++)
            $display("D_Hit[%0d] = %0d", i, d_hit[i]);
        $display("I Cache total hit %0d, total miss %0d", i_total_hit, i_miss);
        for (int i = 0; i < `I_ASSOCIATIVITY; i++)
            $display("I_Hit[%0d] = %0d", i, i_hit[i]);
        unique case(itf.registers[1])
            32'd666: begin
                $display("All tests passed! Good job!");
            end
            32'd777: begin
                $display("Test did not pass. Failed case: %d", itf.registers[31]);
                $display("Value in REG 14: %d", itf.registers[14]);
            end
            default: begin
                $display("Unpexected test case output. I was expecting full_tests.s. Was that competition code?");
            end
        endcase
        $finish;
    end
    if (timeout == 4200000000) begin
        $display("TOP: Timed out");
        $finish;
    end
    timeout <= timeout + 1;
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

cache_perf_cnt #(`L2_ASSOCIATIVITY) L2_counter (
    .clk    (clk),
    // .read   (dut.arb_L2.read),
    // .write  (dut.arb_L2.write),
    .state  (dut.L2_cache.control.state),
    .resp   (dut.L2_ewb.resp),
    .hit    (dut.L2_cache.datapath.hit)
);
int l2_hit [`L2_ASSOCIATIVITY-1:0];
int l2_miss;
int l2_total_hit;
real l2_hit_rate;
assign l2_hit = L2_counter.num_hit;
assign l2_total_hit = L2_counter.num_hit_total;
assign l2_miss = L2_counter.num_miss;
assign l2_hit_rate = l2_total_hit * 1.0 / (l2_total_hit + l2_miss + 1);

cache_perf_cnt #(`D_ASSOCIATIVITY) D_counter (
    .clk    (clk),
    // .read   (dut.cpu_dcache.read),
    // .write  (dut.cpu_dcache.write),
    .state  (dut.d_cache.control.state),
    .resp   (dut.dcache_arb.resp),
    .hit    (dut.d_cache.datapath.hit)
);
int d_hit [`D_ASSOCIATIVITY-1:0];
int d_miss;
int d_total_hit;
real d_hit_rate;
assign d_hit = D_counter.num_hit;
assign d_total_hit = D_counter.num_hit_total;
assign d_miss = D_counter.num_miss;
assign d_hit_rate = d_total_hit * 1.0 / (d_total_hit + d_miss + 1);

cache_perf_cnt #(`I_ASSOCIATIVITY) I_counter (
    .clk    (clk),
    // .read   (dut.cpu_icache.read),
    // .write  (),
    .state  (dut.i_cache.ctrl.state),
    .resp   (dut.icache_arb.resp),
    .hit    (dut.i_cache.datapath.hit)
);
int i_hit [`I_ASSOCIATIVITY-1:0];
int i_miss;
int i_total_hit;
real i_hit_rate;
assign i_hit = I_counter.num_hit;
assign i_total_hit = I_counter.num_hit_total;
assign i_miss = I_counter.num_miss;
assign i_hit_rate = i_total_hit * 1.0 / (i_total_hit + i_miss + 1);

/************************** END PREFORMANCE COUNTERS **************************/
physical_memory #(real_freq) physical_memory (
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

endmodule : full_tb
