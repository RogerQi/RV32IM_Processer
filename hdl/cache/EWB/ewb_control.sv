`define BAD_STATE $fatal("%0t %s %0d: Illegal control state", $time, `__FILE__, `__LINE__)

module ewb_control(
    input logic clk,
    
    // input from upper level memory
    input logic u_read,
    input logic u_write,
    input logic l_resp,

    // signals from/to datapath
    input logic hit,
    input logic valid,
    input logic [3:0] counter,
    output logic dec_counter,
    output logic reset_counter,
    output logic load,
    output logic set_valid,
    output logic clear_valid,

    // outputs
    output logic l_read,
    output logic l_write,
    output logic u_resp
);

enum int unsigned {
    IDLE,
    HIT_DETECT,
    MEM_READ,
    WRITE_BACK,
    EWB_LOAD,
    COUNTDOWN
} state, next_state;

function void set_default();
    dec_counter = 1'b0;
    reset_counter = 1'b0;
    load = 1'b0;
    set_valid = 1'b0;
    clear_valid = 1'b0;
    l_read = 1'b0;
    l_write = 1'b0;
    u_resp = 1'b0;
endfunction

always_comb begin : state_actions
    set_default();
    unique case (state)
        IDLE: begin
            if (~(u_read | u_write) & valid)
                reset_counter = 1'b1;
            if (u_read)
                l_read = 1'b1;
            if (u_write) begin
                load = 1'b1;
                set_valid = 1'b1;
            end
        end
        HIT_DETECT: begin
            if (hit) begin
                u_resp = 1'b1;
                reset_counter = 1'b1;
            end else begin
                l_read = 1'b1;
            end
        end
        MEM_READ: begin
            if (l_resp)
                u_resp = 1'b1;
            else
                l_read = 1'b1;
        end
        WRITE_BACK: begin
            if (l_resp) begin
                if (u_write) begin
                    load = 1'b1;
                    set_valid = 1'b1;
                end else begin
                    clear_valid = 1'b1;
                end
            end else begin
                l_write = 1'b1;
            end
        end
        EWB_LOAD: begin
            u_resp = 1'b1;
            reset_counter = 1'b1;
        end
        COUNTDOWN: begin
            if (~(u_read | u_write) & (|counter))
                dec_counter = 1'b1;
            if (~(u_read | u_write | (|counter)) | u_write)
                l_write = 1'b1;
        end
        default: begin
            `BAD_STATE;
        end
    endcase
end

always_comb begin : next_state_logic
    next_state = state;

    unique case (state)
        IDLE: begin
            if (u_read)
                next_state = MEM_READ;
            else if (u_write)
                next_state = EWB_LOAD;
            else if (valid)
                next_state = COUNTDOWN;
        end
        HIT_DETECT: begin
            if (hit)
                next_state = COUNTDOWN;
            else
                next_state = MEM_READ;
        end
        MEM_READ: begin
            if (l_resp)
                next_state = IDLE;
        end
        WRITE_BACK: begin
            if (l_resp)
                if (u_write)
                    next_state = EWB_LOAD;
                else
                    next_state = IDLE;
        end
        EWB_LOAD: begin
            next_state = COUNTDOWN;
        end
        COUNTDOWN: begin
            if (~(u_read | u_write | (|counter)) | u_write)
                next_state = WRITE_BACK;
            else if (u_read)
                next_state = HIT_DETECT;
        end
        default: begin
            `BAD_STATE;
        end
    endcase
end

always_ff @ (posedge clk) begin : next_state_assignment
    state <= next_state;
end

endmodule : ewb_control