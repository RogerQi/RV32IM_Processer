`define BAD_STATE $fatal("%0t %s %0d: Illegal control state", $time, `__FILE__, `__LINE__)

module i_cache_ctrl (
    input logic clk,
    input logic pmem_resp,
    input logic mem_read,
    input logic hit,

    output logic cache_resp,
    output logic set_valid,
    output logic load_data,
    output logic read_data,
    output logic load_tag,
    output logic load_lru,

    output logic pmem_read
);

enum int unsigned {
    IDLE = 0,
    HIT_DETECT = 1,
    LOAD = 3
} state, next_state;

function void set_default();
    cache_resp = 1'b0;
    set_valid = 1'b0;
    load_data = 1'b0;
    read_data = 1'b0;
    load_tag = 1'b0;
    load_lru = 1'b0;
    pmem_read = 1'b0;
endfunction

always_comb begin : state_actions
    set_default();

    unique case (state)
        IDLE: begin
            if (mem_read)
                read_data = 1'b1;
        end

        HIT_DETECT: begin
            if (hit) begin
                cache_resp = 1'b1;
                load_lru = 1'b1;
                read_data = 1'b1;
            end else begin  // ~hit
                pmem_read = 1'b1;
            end
        end

        LOAD: begin
            if (pmem_resp) begin
                load_data = 1'b1;
                load_tag = 1'b1;
                load_lru = 1'b1;
                set_valid = 1'b1;
            end else // ~pmem_resp
                pmem_read = 1'b1;
        end

        default: begin `BAD_STATE; end
    endcase
end

always_comb begin : next_state_logic
    // default
    next_state = state;

    unique case (state)
        IDLE: begin
            if (mem_read)
                next_state = HIT_DETECT;
        end

        HIT_DETECT: begin
            if (~hit)
                next_state = LOAD;
        end

        LOAD: begin
            if (pmem_resp)
                next_state = IDLE;
        end

        default: begin next_state = state; `BAD_STATE; end
    endcase
end

always_ff @ (posedge clk) begin : next_state_assignment
    state <= next_state;
end

endmodule : i_cache_ctrl
