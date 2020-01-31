module lru_tb;
    timeunit 1ns;
    timeprecision 1ns;

    parameter SET = 8;
    parameter ASSOCIATIVITY = 4;

    parameter LRU_WIDTH = $clog2(ASSOCIATIVITY);
    parameter IDX_WIDTH = $clog2(SET);

    parameter CLK_PERIOD = 10_000_000; // 100MHz

    bit clk;
    initial begin : clk_generation 
        clk = 1'b1;
        forever
            #(CLK_PERIOD/2.0) clk = ~clk;
    end : clk_generation
    default clocking tb_clk @ (negedge clk); endclocking

    logic [LRU_WIDTH-1:0] lru_in;
    logic [SET-1:0] index_in;
    logic load_lru;
    logic [LRU_WIDTH-1:0] lru_out;

    lru #(SET, ASSOCIATIVITY) lru_new (
        .clk     (clk),
        .mru_in  (lru_in),
        .index_in(index_in),
        .load_in (load_lru),
        .lru_out (lru_out)
    );

    // logic lru_way;

    // array #(IDX_WIDTH, 1) old_lru (
    //     .clk        (clk),
    //     .read       ('1),
    //     .load       (load_lru),
    //     .index      (index_in),
    //     .datain     (~lru_in),
    //     .dataout    (lru_way)
    // );

    initial begin
        ##1     index_in = 0;
                lru_in = 2'd3;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 0;
                lru_in = 2'd1;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 0;
                lru_in = 2'd2;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 0;
                lru_in = 2'd3;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 1;
                lru_in = 2'd0;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 1;
                lru_in = 2'd1;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 1;
                lru_in = 2'd2;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 1;
                lru_in = 2'd3;
        ##1     load_lru = 1'b1;
        ##1     load_lru = 1'b0;

        ##1     index_in = 0;
                $finish;
    end


endmodule