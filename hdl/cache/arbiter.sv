// `include "../rv32i_types.sv"
`define BAD_STATE $fatal("%0t %s %0d: Illegal control state", $time, `__FILE__, `__LINE__)

// import rv32i_types::*;

module arbiter(
    input logic             clk,
    mem_ro_itf.server       I,      // I-cache interface
    mem_rw_itf.server       D,      // D-cache interface
    mem_rw_itf.requestor    L2      // L2 cache interface
);

    enum int unsigned {
        IDLE, I_CACHE, D_CACHE, L2_I_RESP, L2_D_RESP
    } state, next_state;

    logic L2_read, L2_write;
    logic [255:0] L2_wdata;
    logic [31:0] L2_wmask;
    logic [31:0] L2_addr;

    function void set_defaults();
        I.resp = 1'b0;
        I.rdata = L2.rdata;
        D.resp = 1'b0;
        D.rdata = L2.rdata;
        L2_read = 1'b0;
        L2_write = 1'b0;
        L2_wmask = '1;
        L2_addr = '0;
        L2_wdata = '0;
    endfunction

    function void i_cache_actions();
        // I.resp = L2.resp;
        I.rdata = L2.rdata;
        L2_read = I.read;
        L2_addr = I.addr;
    endfunction

    function void d_cache_actions();
        // D.resp = L2.resp;
        D.rdata = L2.rdata;
        L2_read = D.read;
        L2_write = D.write;
        L2_addr = D.addr;
        L2_wdata = D.wdata;
    endfunction

    always_comb begin : state_actions
        set_defaults();

        unique case (state)
            IDLE: begin
                if (I.read)
                    i_cache_actions();
                else if (D.read | D.write)
                    d_cache_actions();
            end
            I_CACHE: begin
                I.resp = L2.resp;
                i_cache_actions();
            end
            D_CACHE: begin
                D.resp = L2.resp;
                d_cache_actions();
            end
            L2_I_RESP: 
                i_cache_actions();
            L2_D_RESP:
                d_cache_actions();
            default: ;
        endcase
    end

    always_comb begin : next_state_logic
        next_state = state;     // default

        unique case (state)
            IDLE: begin
                if (I.read)
                    next_state = I_CACHE;
                else if (D.read | D.write)
                    next_state = D_CACHE;
            end
            I_CACHE: begin
                if (L2.resp)
                    next_state = L2_I_RESP;
            end
            D_CACHE: begin
                if (L2.resp)
                    next_state = L2_D_RESP;
            end
            L2_I_RESP, L2_D_RESP:
                next_state = IDLE;
            default:
                begin next_state = state; `BAD_STATE; end
        endcase

    end

    always_ff @(posedge clk) begin : next_state_assignment
        state <= next_state;
    end

    always_ff @(posedge clk) begin : L2_input_buffer_assignment
        L2.read <= L2_read;
        L2.write <= L2_write;
        L2.wmask <= L2_wmask;
        L2.addr <= L2_addr;
        L2.wdata <= L2_wdata;
    end

endmodule : arbiter
