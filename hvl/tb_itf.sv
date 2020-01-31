/**
 * Interface used by testbenches to communicate with memory and
 * the DUT.
**/
interface tb_itf
#(
    parameter real freq = 100.0  // frequency in MHz
);

timeunit 100ps;
timeprecision 100ps;

bit clk;
bit halt;
/* Inst Mem */
logic read_a;
logic [31:0] address_a;
logic resp_a;
logic [31:0] rdata_a;
/* Data Mem */
logic read_b;
logic write;
logic [3:0] wmask;
logic [31:0] address_b;
logic [31:0] wdata;
logic resp_b;
logic [31:0] rdata_b;
/* Reg */
logic [31:0] registers [32];

logic pmem_error;

// The monitor has a reset signal, which it needs, but
// you use initial blocks in your DUT, so we generate two clocks
initial begin
    clk = '0;
    #40;
end

int clk_period;

assign clk_period = 10000 / freq;

always #(clk_period / 2)  clk = ~clk;


endinterface : tb_itf
