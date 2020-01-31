// `include "../rv32i_types.sv"
import rv32i_types::*;

module multiplier_divider_unit (
    input clk,
    input sel,
    input mul_ops mulop,
    input [31:0] a, b,
    output logic [31:0] f,
    output logic done
);
    logic [63:0] multiply_product, negated_multiply_product;
    logic [31:0] divider_result, remainder;
    logic [31:0] input_a, input_b;
    logic negate_result_flag;
    logic divider_start, divider_done;
    logic multiplier_start, multiplier_done;
    /* Setup inputs based on mulop */
    always_comb begin : MULTIPLIER_DIVIDER_INPUT
        negate_result_flag = 1'b0;
        input_a = a;
        input_b = b;
        unique case (mulop)
            m_mulh, m_div: begin
                if (a[31]) begin
                    input_a = -a;
                    negate_result_flag = ~negate_result_flag;
                end else begin
                    input_a = a;
                end
                if (b[31]) begin
                    input_b = -b;
                    negate_result_flag = ~negate_result_flag;
                end else begin
                    input_b = b;
                end
            end
            m_mulhsu: begin
                input_b = b;
                if (a[31]) begin
                    // a is negative
                    input_a = -a;
                    negate_result_flag = ~negate_result_flag;
                end else begin
                    // a is positive
                    input_a = a;
                end
            end
            m_rem: begin
                if (a[31]) begin
                    input_a = -a;
                    negate_result_flag = ~negate_result_flag;
                end else begin
                    input_a = a;
                end
                if (b[31]) begin
                    input_b = -b;
                    // negate_result_flag = ~negate_result_flag;
                end else begin
                    input_b = b;
                end
            end
            default: begin
                input_a = a;
                input_b = b;
            end
        endcase
    end

    assign divider_start = (sel == 1'b1) & ((mulop == m_div) | (mulop == m_divu) | (mulop == m_rem) | (mulop == m_remu));
    assign multiplier_start = (sel == 1'b1) & ((mulop == m_mul) | (mulop == m_mulh) | (mulop == m_mulhsu) | (mulop == m_mulhu));

    /* Use Wallace multiplier to do a 32 bits operation */
    /* or use SRT divider to execute DIV/REM */

    /* Two 32-bit to one 64-bit unsigned multiplier */
    wallace_multiplier wm (
        .clk,
        .start(multiplier_start),
        .fake_a(input_a),
        .fake_b(input_b),
        .fake_f(multiply_product),
        .done(multiplier_done)
    );
    // TODO: implement multi-cycle logic
    // assign multiplier_done = 1'b1;
    // assign multiply_product = a + b;
    assign negated_multiply_product = -multiply_product; // for simplicity of indexing...
    /* (2* 32-bit) to (32-bit) unsigned Divider */
    restoring_divider #(32) rd (
        .clk,
        .numerator(input_a),
        .denominator(input_b),
        .start_i(divider_start),
        .result_o(divider_result),
        .remainder_o(remainder),
        .done_o(divider_done)
    );

    /* Pad outputs based on mulop */
    always_comb begin : MULTIPLIER_DIVIDER_OUTPUT
        f = multiply_product[31:0];
        unique case (mulop)
            m_mul: begin
                f = multiply_product[31:0];
            end
            m_mulh: begin
                if (negate_result_flag) begin
                    f = negated_multiply_product[63:32];
                end else begin
                    f = multiply_product[63:32];
                end
            end
            m_mulhsu: begin
                if (negate_result_flag) begin
                    f = negated_multiply_product[63:32];
                end else begin
                    f = multiply_product[63:32];
                end
            end
            m_mulhu: begin
                f = multiply_product[63:32];
            end
            m_div: begin
                if (b == '0) begin
                    // special case for divison by zero according to RISC-V specs
                    f = 32'hffffffff;
                end else begin
                    if ((a == 32'h80000000) && (b == 32'hffffffff)) begin
                        // special case for negative overflow
                        f = 32'h80000000;
                    end else begin
                        if (negate_result_flag) begin
                            f = -divider_result;
                        end else begin
                            f = divider_result;
                        end
                    end
                end
            end
            m_divu: begin
                if (b == '0) begin
                    // special case for divison by zero
                    f = 32'hffffffff;
                end else begin
                    f = divider_result;
                end
            end
            m_rem: begin
                if (b == '0) begin
                    // special case for divison by zero
                    f = a;
                end else begin
                    if ((a == 32'h80000000) && (b == 32'hffffffff)) begin
                        // special case for negative overflow
                        f = '0;
                    end else begin
                        if (negate_result_flag) begin
                            f = -remainder;
                        end else begin
                            f = remainder;
                        end
                    end
                end
            end
            m_remu: begin
                if (b == '0) begin
                    // special case for divison by zero
                    f = a;
                end else begin
                    f = remainder;
                end
            end
            default: ;
        endcase
    end

    assign done = multiplier_done & divider_done;

endmodule : multiplier_divider_unit
