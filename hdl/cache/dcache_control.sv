`define BAD_STATE $fatal("%0t %s %0d: Illegal control state", $time, `__FILE__, `__LINE__)

module dcache_control (
    input logic clk,
    input logic pmem_resp,
    input logic mem_read,
    input logic mem_write,
    input logic hit,
    input logic dirty,

    output logic cache_resp,
    output logic set_dirty,
    output logic clear_dirty,
    output logic set_valid,
    output logic load_data,
    output logic read_data,
    output logic load_tag,
    output logic load_lru,

    output logic pmem_read,
    output logic pmem_write
);

enum int unsigned {
    IDLE = 0,
    HIT_DETECT = 1,
    STORE = 2,
    LOAD = 3
} state, next_state;

function void set_default();
    cache_resp = 1'b0;
    set_dirty = 1'b0;
    clear_dirty = 1'b0;
    set_valid = 1'b0;
    load_data = 1'b0;
    read_data = 1'b0;
    load_tag = 1'b0;
    load_lru = 1'b0;
    pmem_read = 1'b0;
    pmem_write = 1'b0;
endfunction

always_comb begin : state_actions
    set_default();

    unique case (state)
        IDLE: begin
            if (mem_read | mem_write)
                read_data = 1'b1;
        end

        HIT_DETECT: begin
            if (hit) begin
                cache_resp = 1'b1;
                load_lru = 1'b1;
                if (mem_write) begin
                    set_dirty = 1'b1;
                    load_data = 1'b1;
                end else
                    read_data = 1'b1;
            end else begin  // ~hit
                if (dirty) begin
                    clear_dirty = 1'b1;
                    pmem_write = 1'b1;
                end else begin // ~dirty
                    set_valid = 1'b1;
                    pmem_read = 1'b1;
                end
            end
        end

        STORE: begin
            if (pmem_resp)
                pmem_read = 1'b1;
            else // ~pmem_resp
                pmem_write = 1'b1;
        end

        LOAD: begin
            if (pmem_resp) begin
                load_data = 1'b1;
                load_tag = 1'b1;
                load_lru = 1'b1;
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
            if (mem_read | mem_write)
                next_state = HIT_DETECT;
        end

        HIT_DETECT: begin
            if (hit)
                next_state = IDLE;
            else if (dirty)
                next_state = STORE;
            else // ~dirty
                next_state = LOAD;
        end

        STORE: begin
            if (pmem_resp)
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

endmodule : dcache_control
