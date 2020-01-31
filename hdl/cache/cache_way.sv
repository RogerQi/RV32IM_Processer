module cache_way #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index,
    parameter ASSOCIATIVITY = 2
)
(
    input logic                     clk,

    input logic                     way_enable,

    // From Control Unit
    input logic                     set_dirty,
    input logic                     clear_dirty,
    input logic                     set_valid,

    // From CPU (through Bus Adapter)
    input logic [s_index-1:0]       index,        // directly from CPUs

    // To Control Unit
    output logic                    dirty,

    // To outer level datapath
    output logic                    valid
);

logic _load_dirty, _load_valid;

// reg arrays load logic
assign _load_dirty = (set_dirty | clear_dirty) & way_enable;
assign _load_valid = set_valid & way_enable;

latched_array #(s_index, 1) dirty_array(
    .clk(clk),
    .read(1'b1),
    .load(_load_dirty),
    .index(index),
    .datain(set_dirty),
    .dataout(dirty)
);

latched_array #(s_index, 1) valid_array(
    .clk(clk),
    .read(1'b1),
    .load(_load_valid),
    .index(index),
    .datain(1'b1),
    .dataout(valid)
);

endmodule : cache_way
