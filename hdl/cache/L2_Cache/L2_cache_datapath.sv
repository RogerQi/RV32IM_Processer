// `include "../rv32i_types.sv"

import rv32i_types::*;

module L2_cache_datapath # (
    parameter ASSOCIATIVITY = 4,
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
    input logic                 clk,

    // From Control Unit
    input logic                 set_dirty,
    input logic                 clear_dirty,
    input logic                 set_valid,
    input logic                 load_data,
    input logic                 read_data,
    input logic                 load_tag_in,
    input logic                 load_lru,
    input logic                 pmem_read_address_hold,
    input logic                 pmem_read,

    // From CPU (through Bus Adapter)
    input rv32i_word            mem_address,        // directly from CPU
    input logic [s_line-1:0]    mem_wdata256,
    input logic                 mem_read,

    // From Memory
    input logic [s_line-1:0]    pmem_rdata,

    // To CPU
    output logic [s_line-1:0]   mem_rdata256,

    // To Control Unit
    output logic                hit_out,
    output logic                dirty_out,

    // To Memory
    output logic [s_line-1:0]   pmem_wdata,
    output rv32i_word           pmem_address
);

    localparam integer W_LRU = $clog2(ASSOCIATIVITY);

logic  [W_LRU-1:0]   way_lru;
logic  [W_LRU-1:0]   way_hit;
logic  [ASSOCIATIVITY-1:0]   way_en;
logic  [ASSOCIATIVITY-1:0]   dirty;
logic  [ASSOCIATIVITY-1:0]   hit;
logic  [ASSOCIATIVITY-1:0]   valid;
logic  [ASSOCIATIVITY-1:0]   load_tag;

logic [ASSOCIATIVITY-1:0]   dirty_out_temp;

logic [s_tag-1:0]    way_tag_out;
logic [s_tag-1:0]    tag_out [ASSOCIATIVITY-1:0];
logic [s_line-1:0]   data_out [ASSOCIATIVITY-1:0];
logic [s_line-1:0]   data_in;

logic [s_index-1:0]  index;
logic [s_tag-1:0]    tag_in;
logic [31:0]         write_en [ASSOCIATIVITY-1:0];

/***************************** Registers & Cache Ways *********************************/
lru #(num_sets, ASSOCIATIVITY) lru (
    .clk        (clk),
    .mru_in     (way_hit),
    .index_in   (index),
    .load_in    (load_lru),
    .lru_out    (way_lru)
);

cache_way #(s_offset, s_index, s_tag, s_mask, s_line, num_sets, ASSOCIATIVITY) way [ASSOCIATIVITY-1:0] (
    .clk(clk),
    .way_enable(way_en),
    .set_dirty,
    .clear_dirty,
    .set_valid,
    .index,
    .dirty(dirty),
    .valid(valid)
);

latched_array #(s_index, s_tag) tag [ASSOCIATIVITY-1:0](
    .clk(clk),
    .read(read_data),
    .load(load_tag),
    .index(index),
    .datain(tag_in),
    .dataout(tag_out)
);

latched_data_array #(s_offset, s_index, s_mask, s_line) line [ASSOCIATIVITY-1:0] (
    .clk(clk),
    .read(read_data),
    .write_en(write_en),
    .index(index),
    .datain(data_in),
    .dataout(data_out)
);

/**************************************************************************************/

/*********************************** Comb Logics **************************************/
always_comb begin
    way_hit = 0;
    for (int i = 0; i < ASSOCIATIVITY; i++)
        if (hit[i])
            way_hit = i[W_LRU-1:0];
end

genvar i;
generate
    for (i = 0; i < ASSOCIATIVITY; i++) begin : gen_way
        assign way_en[i] = (~set_dirty & (way_lru == i)) | (~mem_read & hit[i]);
        assign dirty_out_temp[i] = dirty[i] & (way_lru == i);
        assign load_tag[i] = load_tag_in & way_en[i];
        assign hit[i] = valid[i] & (tag_in == tag_out[i]);
        assign write_en[i] = {32{way_en[i] & load_data}};
    end
endgenerate

// way hit logic
assign hit_out = |hit;
assign dirty_out = |dirty_out_temp;
// address decoder
assign tag_in = mem_address[31:s_index+s_offset];
assign index = mem_address[s_index+s_offset-1:s_offset];
// address encoder
assign pmem_address = {pmem_read_address_hold ? tag_in[s_tag-1:0] : way_tag_out[s_tag-1:0], index[s_index-1:0], 5'b0};
// MUXes
assign way_tag_out = tag_out[way_lru];
assign pmem_wdata = data_out[way_lru];
assign mem_rdata256 = data_out[way_hit];
assign data_in = set_dirty ? mem_wdata256 : pmem_rdata;

/**************************************************************************************/

endmodule : L2_cache_datapath
