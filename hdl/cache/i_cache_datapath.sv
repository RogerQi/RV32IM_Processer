// `include "../rv32i_types.sv"
// `define BAD_STATE $fatal("%0t %s %0d: Illegal control state", $time, `__FILE__, `__LINE__)

import rv32i_types::*;

module i_cache_datapath #(
    parameter SETS = 8,
    parameter ASSOCIATIVITY = 2,
    parameter WIDTH = 256,
    parameter W_INDEX = $clog2(SETS),
    parameter W_OFFSET = $clog2(WIDTH/8),
    parameter W_TAG = 32-W_INDEX-W_OFFSET
)(
    input logic clk,
    // I-cache to cpu interface
    input rv32i_word cpu_addr,
    output physical_mem_word cpu_rdata,
    // I-cache to arbiter interface
    input physical_mem_word arb_rdata,
    // Ctrl to Data interface
    input logic set_valid_in,
    input logic load_data_in,
    input logic load_tag_in,
    input logic load_lru_in,
    // Data to Ctrl interface
    output logic hit_out
);

    localparam integer W_LRU = $clog2(ASSOCIATIVITY);

    // internal control signals
    logic [W_LRU-1:0] way_lru;
    logic [W_LRU-1:0] way_hit;
    logic [ASSOCIATIVITY-1:0] way_en;
    logic [ASSOCIATIVITY-1:0] hit;
    logic [ASSOCIATIVITY-1:0] valid_out;
    logic [ASSOCIATIVITY-1:0] load_tag;
    logic [ASSOCIATIVITY-1:0] load_valid;

    logic [W_TAG-1:0]    tag_out  [ASSOCIATIVITY-1:0];
    logic [WIDTH-1:0]    data_out [ASSOCIATIVITY-1:0];
    logic [W_INDEX-1:0]  index;
    logic [W_TAG-1:0]    tag_in;
    logic [WIDTH/8-1:0]  write_en [ASSOCIATIVITY-1:0];

    lru #(SETS, ASSOCIATIVITY) lru (
        .clk        (clk),
        .mru_in     (way_hit),
        .index_in   (index),
        .load_in    (load_lru_in),
        .lru_out    (way_lru)
    );

    array #(W_INDEX, 1) valid [ASSOCIATIVITY-1:0] (
        .clk        (clk),
        .read       ('1),
        .load       (load_valid),
        .index      (index),
        .datain     (load_valid),
        .dataout    (valid_out)
    );

    array #(W_INDEX, W_TAG) tag [ASSOCIATIVITY-1:0] (
        .clk        (clk),
        .read       (1'b1),
        .load       (load_tag),
        .index      (index),
        .datain     (tag_in),
        .dataout    (tag_out)
    );

    data_array #(W_INDEX, W_OFFSET) data [ASSOCIATIVITY-1:0] (
        .clk        (clk),
        .read       (1'b1),
        .write_en   (write_en),
        .index      (index),
        .datain     (arb_rdata),
        .dataout    (data_out)
    );

    always_comb begin
        way_hit = 0;
        for (int i = 0; i < ASSOCIATIVITY; i++)
            if (hit[i])
                way_hit = i[W_LRU-1:0];
    end

    genvar i;
    generate
        for (i = 0; i < ASSOCIATIVITY; i++) begin : gen_way
            assign way_en[i] = (way_lru == i) | hit[i];
            assign hit[i] = valid_out[i] & (tag_in == tag_out[i]);
            assign write_en[i] = (load_data_in & way_en[i]) ? '1 : '0;
            assign load_tag[i] = load_tag_in & way_en[i];
            assign load_valid[i] = set_valid_in & way_en[i];
        end
    endgenerate

    // always_comb begin
    //     if (|hit)
    //         way_en = 1 << way_hit;
    //     else
    //         way_en = 1 << way_lru;
    // end

    assign hit_out = |hit;
    assign tag_in = cpu_addr[31:8];
    assign index = cpu_addr[7:5];
    assign cpu_rdata = data_out[way_hit];

endmodule : i_cache_datapath