import rv32i_types::*;

module cache_perf_cnt # (
    parameter ASSOCIATIVITY = 2
) (
    input logic clk,
    // input logic read,
    // input logic write,
    input int state,
    input logic resp,
    input logic [ASSOCIATIVITY-1:0] hit
);

    int num_hit [ASSOCIATIVITY-1:0] /* synthesis ramstyle = "logic" */ = '{default: '0};
    int num_hit_total /* synthesis ramstyle = "logic" */ = '{default: '0};
    int num_miss /* synthesis ramstyle = "logic" */ = '{default: '0};

    always_ff @ (posedge clk) begin
        if ((state == 3) & resp) begin
            num_miss ++;
        end
        else if ((state == 1) & (|hit)) begin
            num_hit_total ++;
            for (int i = 0; i < ASSOCIATIVITY; i++)
                if (hit[i])
                    num_hit[i] ++;
        end
        // if ((read | write) & resp) begin
        //     if (|hit) begin
        //         num_hit_total ++;
        //         for (int i = 0; i < ASSOCIATIVITY; i++)
        //             if (hit[i])
        //                 num_hit[i] ++;
        //     end else begin
        //         num_miss ++;
        //     end
        // end
    end

endmodule : cache_perf_cnt