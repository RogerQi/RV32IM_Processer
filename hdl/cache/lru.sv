module lru # (
    parameter SETS = 8,     
    parameter ASSOCIATIVITY = 2
)(
    input  logic clk,
    input  logic [$clog2(ASSOCIATIVITY)-1:0] mru_in, // cfr
    input  logic [$clog2(SETS)-1:0] index_in,
    input  logic load_in,
    output logic [$clog2(ASSOCIATIVITY)-1:0] lru_out // cfr
);

    localparam integer IO_MSB = $clog2(ASSOCIATIVITY)-1;
    localparam integer BT_MSB = ASSOCIATIVITY-2;

    logic [SETS-1:0] [BT_MSB:0] mru_bt /* synthesis ramstyle = "logic" */ = '{default: '0};

    genvar i;
    logic [BT_MSB:0] mru_in_bt;
    generate
        for (i = BT_MSB; i >= 0; i--) begin: gen_mru_in
            assign mru_in_bt[i] = mru_in[IO_MSB - $clog2(BT_MSB-i+2) + 1];
        end
    endgenerate

    logic [BT_MSB:0] mru_bt_load;
    generate
        assign mru_bt_load[BT_MSB] = 1;
        for (i = BT_MSB-1; i >= 0; i--) begin: gen_mru_load
            localparam int out = (BT_MSB-i) - (2**($clog2(BT_MSB-i+2)-1) - 2) - 1;
            assign mru_bt_load[i] = mru_in[IO_MSB:IO_MSB - $clog2(BT_MSB-i+2) + 2] == out;
        end
    endgenerate

    always_ff @ (posedge clk) begin : mru_load
        if (load_in)
            for (int i = BT_MSB; i >= 0; i--)
                if (mru_bt_load[i])
                    mru_bt[index_in][i] = mru_in_bt[i];
    end

    generate
        assign lru_out[IO_MSB] = ~mru_bt[index_in][BT_MSB];

        for (i = IO_MSB-1; i >= 0; i--) begin: gen_lru_out
            localparam integer base = BT_MSB - (2**(IO_MSB-i) - 1);
            assign lru_out[i] = ~mru_bt[index_in][base - lru_out[IO_MSB:i+1]];
        end
    endgenerate

endmodule : lru