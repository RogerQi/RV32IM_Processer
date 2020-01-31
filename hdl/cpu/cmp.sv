// `include "../rv32i_types.sv"
import rv32i_types::*;

module cmp (
    input branch_funct3_t cmpop,
    input rv32i_word cmpmux,
    input rv32i_word rs1,
    output logic br_en
);

always_comb begin
    unique case (cmpop)
        beq:    br_en = (rs1 == cmpmux);
        bne:    br_en = (rs1 != cmpmux);
        blt:    br_en = ($signed(rs1) < $signed(cmpmux));
        bge:    br_en = ($signed(rs1) >= $signed(cmpmux));
        bltu:   br_en = (rs1 < cmpmux);
        bgeu:   br_en = (rs1 >= cmpmux);
        default: begin
            // Do nothing
        end
    endcase
end

endmodule : cmp
