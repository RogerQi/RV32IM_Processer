// `include "../rv32i_types.sv"
`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

import rv32i_types::*;

module control_rom (
    input rv32i_opcode opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output rv32i_control_word ctrl_word
);

    branch_funct3_t branch_funct3;
    store_funct3_t store_funct3;
    load_funct3_t load_funct3;
    arith_funct3_t arith_funct3;
    alu_ops aluops_funct3;
    mul_ops mulops_funct3;

    assign branch_funct3 = branch_funct3_t'(funct3);
    assign store_funct3 = store_funct3_t'(funct3);
    assign load_funct3 = load_funct3_t'(funct3);
    assign arith_funct3 = arith_funct3_t'(funct3);
    assign aluops_funct3 = alu_ops'(funct3);
    assign mulops_funct3 = mul_ops'(funct3);

    function void loadRegfile(regfilemux::regfilemux_sel_t sel = regfilemux::alu_out);
        ctrl_word.load_regfile = 1'b1;
        ctrl_word.regfilemux_sel = sel;
    endfunction

    function void setALU(alumux::alumux1_sel_t sel1,
                         alumux::alumux2_sel_t sel2,
                         logic setop = 1'b0, alu_ops op = alu_add);
        ctrl_word.alumux1_sel = sel1;
        ctrl_word.alumux2_sel = sel2;
        if (setop)
            ctrl_word.aluop = op; // else default value
    endfunction

    function void setCMP(cmpmux::cmpmux_sel_t sel, branch_funct3_t op);
        ctrl_word.cmpmux_sel = sel;
        ctrl_word.cmpop = op;
    endfunction

    function void set_defaults();
        ctrl_word.opcode = opcode;

        setALU(alumux::rs1_out, alumux::i_imm, 1'b1, aluops_funct3);
        setCMP(cmpmux::rs2_out, branch_funct3);

        ctrl_word.regfilemux_sel = regfilemux::alu_out;
        ctrl_word.mulop = mulops_funct3;

        ctrl_word.load_regfile = 1'b0;

        ctrl_word.dmem_read = 1'b0;
        ctrl_word.dmem_write = 1'b0;
        ctrl_word.dmem_wmask = 4'b0000;
        ctrl_word.mulmux_sel = mulmux::true_alu_out;
    endfunction

    always_comb begin
        set_defaults();
        unique case (opcode)
            op_lui:
                loadRegfile(regfilemux::u_imm);
            op_auipc: begin
                setALU(alumux::pc_out, alumux::u_imm, 1'b1, alu_add);
                loadRegfile();
            end
            op_jal: begin
                setALU(alumux::pc_out, alumux::j_imm, 1'b1, alu_add);
                loadRegfile(regfilemux::pc_plus4);
            end
            op_jalr: begin
                setALU(alumux::rs1_out, alumux::i_imm, 1'b1, alu_add);
                loadRegfile(regfilemux::pc_plus4);
            end
            op_br:
                setALU(alumux::pc_out, alumux::b_imm, 1'b1, alu_add);
            op_load: begin
                setALU(alumux::rs1_out, alumux::i_imm, 1'b1, alu_add);
                ctrl_word.dmem_read = 1'b1;
                unique case (load_funct3)
                    lb:     loadRegfile(regfilemux::lb);
                    lh:     loadRegfile(regfilemux::lh);
                    lw:     loadRegfile(regfilemux::lw);
                    lbu:    loadRegfile(regfilemux::lbu);
                    lhu:    loadRegfile(regfilemux::lhu);
                    default: ;
                endcase
            end
            op_store: begin // Traceback to here, dmem_write and wmask stuck at GND
                setALU(alumux::rs1_out, alumux::s_imm, 1'b1, alu_add);
                ctrl_word.dmem_write = 1'b1;
                unique case (store_funct3)
                    sb: ctrl_word.dmem_wmask = 4'b0001;
                    sh: ctrl_word.dmem_wmask = 4'b0011;
                    sw: ctrl_word.dmem_wmask = 4'b1111;
                    default: ;
                endcase
            end
            op_imm: begin
                loadRegfile(regfilemux::alu_out);
                unique case (arith_funct3)
                    slt: begin
                        setCMP(cmpmux::i_imm, blt);
                        loadRegfile(regfilemux::br_en);
                    end
                    sltu: begin
                        setCMP(cmpmux::i_imm, bltu);
                        loadRegfile(regfilemux::br_en);
                    end
                    sr: begin
                        if (funct7[5])
                            setALU(alumux::rs1_out, alumux::i_imm, 1'b1, alu_sra);
                    end
                    default: ;
                endcase
            end
            op_reg: begin
                loadRegfile(regfilemux::alu_out);
                setALU(alumux::rs1_out, alumux::rs2_out, 1'b1, aluops_funct3);
                unique case (arith_funct3)
                    add: begin
                        if (funct7[5])
                            setALU(alumux::rs1_out, alumux::rs2_out, 1'b1, alu_sub);
                    end
                    slt: begin
                        setCMP(cmpmux::rs2_out, blt);
                        loadRegfile(regfilemux::br_en);
                    end
                    sltu: begin
                        setCMP(cmpmux::rs2_out, bltu);
                        loadRegfile(regfilemux::br_en);
                    end
                    sr: begin
                        if (funct7[5])
                            setALU(alumux::rs1_out, alumux::rs2_out, 1'b1, alu_sra);
                    end
                    default: ;
                endcase
                if (funct7 == m_extension) begin
                    ctrl_word.mulmux_sel = mulmux::mul_out;
                    loadRegfile(regfilemux::alu_out);
                end
            end
            op_csr: begin
                // unused
            end
            7'b0: begin
                // initial behavior
            end
            default: begin
                // $fatal("illegal opcode");
            end
        endcase
    end

endmodule : control_rom
