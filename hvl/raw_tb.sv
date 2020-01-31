module mp3_tb;

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
mp3 dut (
    .clk(itf.clk),
    // CPU to Instruction Memory
    .imem_read(itf.read_a),
    .imem_addr(itf.address_a),
    // Instuction Memory to CPU
    .imem_resp(itf.resp_a),
    .imem_rdata(itf.rdata_a),
    // CPU to Data Memory
    .dmem_read(itf.read_b),
    .dmem_write(itf.write),
    .dmem_wmask(itf.wmask),
    .dmem_addr(itf.address_b),
    .dmem_wdata(itf.wdata),
    // Data Memory to CPU
    .dmem_resp(itf.resp_b),
    .dmem_rdata(itf.rdata_b)
);

magic_memory_dp magic_memory(
    .clk(itf.clk),
    /* Inst Mem */
    .read_a(itf.read_a),
    .address_a(itf.address_a),
    .resp_a(itf.resp_a),
    .rdata_a(itf.rdata_a),
    /* Data Mem */
    .read_b(itf.read_b),
    .write(itf.write),
    .wmask(itf.wmask),
    .address_b(itf.address_b),
    .wdata(itf.wdata),
    .resp_b(itf.resp_b),
    .rdata_b(itf.rdata_b)
);

assign itf.registers = dut.cpu.regfile.data;

endmodule : mp3_tb
