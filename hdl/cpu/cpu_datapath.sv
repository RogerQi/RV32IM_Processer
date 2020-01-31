// `include "../rv32i_types.sv"
// `include "./pipeline_reg_types.sv"
`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

import rv32i_types::*;
import pipeline_reg_types::*;

module cpu_datapath (
    input logic             clk,
    mem_ro_itf.requestor    I,
    mem_rw_itf.requestor    D
);

    /* Begin Pipeline Signals Declaration */
    IF_ID_signal IF_out;
    IF_ID_signal ID_in;
    ID_EX_signal ID_out;
    ID_EX_signal EX_in;
    EX_MEM_signal EX_out;
    EX_MEM_signal MEM_in;
    MEM_WB_signal MEM_out;
    MEM_WB_signal WB_in;
    /* End Pipeline Signals Declaration */
    rv32i_word alumux1_out;
    rv32i_word alumux2_out;
    rv32i_word real_alu_out;
    rv32i_word real_mul_div_out;
    rv32i_word alu_out;
    rv32i_word cmpmux_out;
    rv32i_word br_target_addr;
    logic br_en;
    logic stall;
    logic flush;

    // pipeline registers control signals
    logic load_IF_ID, load_ID_EX, load_EX_MEM, load_MEM_WB;
    logic stall_i_cache, stall_d_cache;
    logic multiplier_done;
    always_comb begin : pipeline_reg_load_logic
        load_IF_ID = ~stall;
        load_ID_EX = ~stall;
        load_EX_MEM = ~stall;
        load_MEM_WB = ~stall;
    end
    ///////////////////// ignore the above for CP1 //////////////////////////

    //=============== IF ===============
    rv32i_word instruction;
    rv32i_word pcmux_out;
    rv32i_word pc_out;
    rv32i_word pc_plus4;
    pcmux::pcmux_sel_t pcmux_sel;
    logic load_pc;
    always_comb begin : PC_MUX
        unique case (pcmux_sel)
            pcmux::pc_plus4:
                pcmux_out = pc_plus4;
            pcmux::alu_out:
                pcmux_out = alu_out;
            pcmux::br_taken:
                pcmux_out = br_target_addr;
            pcmux::br_not_taken:
                pcmux_out = EX_in.pc_plus4;
            default:
                `BAD_MUX_SEL;
        endcase
    end

    assign load_pc = ~stall;

    pc_register pc (
        .clk(clk),
        .load(load_pc),
        .in(pcmux_out),
        .out(pc_out)
    );
    assign pc_plus4 = pc_out + 4;

    assign I.addr = pc_out;
    assign I.read = 1'b1;

    rv32i_word br_target_addr_mux_out1;
    rv32i_word br_target_addr_mux_out2;
    always_comb begin : BR_TARGET_ADDR_MUX
        br_target_addr_mux_out1 = pc_out;   // use this for now; TODO: possible to support jalr in IF stage?

        case (rv32i_opcode'(IF_out.instruction[6:0]))
            op_br:  // b_imm
                br_target_addr_mux_out2 = {{20{IF_out.instruction[31]}}, IF_out.instruction[7], IF_out.instruction[30:25], IF_out.instruction[11:8], 1'b0};
            op_jal: // j_imm
                br_target_addr_mux_out2 = {{12{IF_out.instruction[31]}}, IF_out.instruction[19:12], IF_out.instruction[20], IF_out.instruction[30:21], 1'b0};
            op_jalr: // i_imm
                br_target_addr_mux_out2 = {{21{IF_out.instruction[31]}}, IF_out.instruction[30:20]};
            default:
                br_target_addr_mux_out2 = '0;
        endcase
    end

    assign br_target_addr = br_target_addr_mux_out1 + br_target_addr_mux_out2;

    branch_predictor branch_predictor (
        .clk(clk),
        .stall,
        .IF_pc(IF_out.pc),
        .IF_instruction(IF_out.instruction),
        .EX_pc(EX_in.pc),
        .EX_br_en(br_en),
        .EX_opcode(EX_in.ctrl_word.opcode),
        .br_taken(IF_out.br_taken)
    );

    assign IF_out.pc = (flush)? 32'h00000000 : pc_out;
    assign IF_out.pc_plus4 = pc_plus4;
    assign IF_out.instruction = (flush)? 32'h00000013 : I.rdata;

    //=============== IF / ID interface ===============
    register #($bits(IF_ID_signal)) IF_ID_reg (
        .clk,
        .load(load_IF_ID),
        .in(IF_out),
        .out(ID_in)
    );

    //=============== ID ===============
    rv32i_opcode opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    rv32i_reg rs1;
    rv32i_reg rs2;

    assign instruction = (flush)? 32'h00000013 : ID_in.instruction;

    decoder decoder (
        .instruction(instruction),
        .funct3     (funct3),
        .funct7     (funct7),
        .opcode     (opcode),
        .i_imm      (ID_out.i_imm),
        .s_imm      (ID_out.s_imm),
        .b_imm      (ID_out.b_imm),
        .u_imm      (ID_out.u_imm),
        .j_imm      (ID_out.j_imm),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (ID_out.rd)
    );

    control_rom control_rom (
        .opcode     (opcode),
        .funct3     (funct3),
        .funct7     (funct7),
        .ctrl_word  (ID_out.ctrl_word)
    );

    rv32i_word regfilemux_out;
    logic load_regfile;
    rv32i_reg rd;
    rv32i_word rf_rs1_out, rf_rs2_out;
    regfile regfile (
        .clk    (clk),
        .load   (load_regfile),
        .in     (regfilemux_out),
        .src_a  (rs1),
        .src_b  (rs2),
        .dest   (rd),
        .reg_a  (rf_rs1_out),
        .reg_b  (rf_rs2_out)
    );

    // We only need to forward from WB stage.
    // Forwarding from other stages are handled by EXE forwarder
    logic ID_rs1_forward_from_WB, ID_rs2_forward_from_WB;
    assign ID_rs1_forward_from_WB = (rs1 != '0) & ((rs1 == WB_in.rd) & WB_in.ctrl_word.load_regfile);
    assign ID_rs2_forward_from_WB = (rs2 != '0) & ((rs2 == WB_in.rd) & WB_in.ctrl_word.load_regfile);

    assign ID_out.rs1 = rs1;
    assign ID_out.rs2 = rs2;
    assign ID_out.rs1_out = (ID_rs1_forward_from_WB)? regfilemux_out : rf_rs1_out;
    assign ID_out.rs2_out = (ID_rs2_forward_from_WB)? regfilemux_out : rf_rs2_out;
    assign ID_out.pc = (flush)? 32'h00000000 : ID_in.pc;
    assign ID_out.pc_plus4 = ID_in.pc_plus4;
    assign ID_out.br_taken = ID_in.br_taken;

    //=============== ID / EX interface ===============
    register #($bits(ID_EX_signal)) ID_EX_reg (
        .clk,
        .load(load_ID_EX), // Something interesting here
        .in(ID_out),
        .out(EX_in)
    );

    //=============== EX ===============
    logic EXE_rs1_forward_from_MEM, EXE_rs1_forward_from_WB, EXE_rs2_forward_from_MEM, EXE_rs2_forward_from_WB;
    rv32i_word real_EXE_rs1, real_EXE_rs2;

    assign EXE_rs1_forward_from_MEM = (EX_in.rs1 != '0) & ((EX_in.rs1 == MEM_in.rd) & MEM_in.ctrl_word.load_regfile);
    assign EXE_rs1_forward_from_WB = (EX_in.rs1 != '0) & ((EX_in.rs1 == WB_in.rd) & WB_in.ctrl_word.load_regfile);
    assign EXE_rs2_forward_from_MEM = (EX_in.rs2 != '0) & ((EX_in.rs2 == MEM_in.rd) & MEM_in.ctrl_word.load_regfile);
    assign EXE_rs2_forward_from_WB = (EX_in.rs2 != '0) & ((EX_in.rs2 == WB_in.rd) & WB_in.ctrl_word.load_regfile);

    always_comb begin : FORWARD_MUX
        /******* RS1 FORWARDING ********/
        unique case ({EXE_rs1_forward_from_MEM, EXE_rs1_forward_from_WB})
            2'b01: real_EXE_rs1 = regfilemux_out;
            2'b10: real_EXE_rs1 = MEM_out.regfilemux_out;
            2'b11: real_EXE_rs1 = MEM_out.regfilemux_out;
            default: real_EXE_rs1 = EX_in.rs1_out;
        endcase
        /******* RS2 FORWARDING ********/
        unique case ({EXE_rs2_forward_from_MEM, EXE_rs2_forward_from_WB})
            2'b01: real_EXE_rs2 = regfilemux_out;
            2'b10: real_EXE_rs2 = MEM_out.regfilemux_out;
            2'b11: real_EXE_rs2 = MEM_out.regfilemux_out;
            default: real_EXE_rs2 = EX_in.rs2_out;
        endcase
    end

    always_comb begin : ALU_MUX
        /******* ALUMUX1 ********/
        unique case (EX_in.ctrl_word.alumux1_sel)
            alumux::rs1_out:
                alumux1_out = real_EXE_rs1;
            alumux::pc_out:
                alumux1_out = EX_in.pc;
            default:
                `BAD_MUX_SEL;
        endcase

        /******* ALUMUX2 ********/
        unique case (EX_in.ctrl_word.alumux2_sel)
            alumux::i_imm:
                alumux2_out = EX_in.i_imm;
            alumux::u_imm:
                alumux2_out = EX_in.u_imm;
            alumux::b_imm:
                alumux2_out = EX_in.b_imm;
            alumux::s_imm:
                alumux2_out = EX_in.s_imm;
            alumux::j_imm:
                alumux2_out = EX_in.j_imm;
            alumux::rs2_out:
                alumux2_out = real_EXE_rs2;
            default:
                `BAD_MUX_SEL;
        endcase
    end

    always_comb begin : PCMUX_SEL_LOGIC     // and flush logic
        if (EX_in.ctrl_word.opcode == op_br && br_en != EX_in.br_taken) begin
            // wrong prediction detected in EX stage
            case ({br_en, EX_in.br_taken})
                2'b10:  // should be taken but not taken
                    pcmux_sel = pcmux::alu_out;
                2'b01:  // should be not taken but taken
                    pcmux_sel = pcmux::br_not_taken;
                default:    // should never be this case
                    pcmux_sel = pcmux::alu_out;
            endcase
            flush = 1'b1;
        end else if (EX_in.ctrl_word.opcode == op_jal || EX_in.ctrl_word.opcode == op_jalr) begin
            // handle jal and jalr in EX stage
            // TODO: handle op_jal in IF stage; handle op_jalr in ID stage
            pcmux_sel = pcmux::alu_out;
            flush = 1'b1;
        end else if (rv32i_opcode'(IF_out.instruction[6:0]) == op_br && IF_out.br_taken) begin
            // predict taken in IF stage
            pcmux_sel = pcmux::br_taken;
            flush = 1'b0;
        end else begin
            // no branch happening
            pcmux_sel = pcmux::pc_plus4;
            flush = 1'b0;
        end
    end

    always_comb begin : CMP_MUX
        unique case (EX_in.ctrl_word.cmpmux_sel)
            cmpmux::rs2_out:
                cmpmux_out = real_EXE_rs2;
            cmpmux::i_imm:
                cmpmux_out = EX_in.i_imm;
            default:
                `BAD_MUX_SEL;
        endcase
    end

    alu alu (
        .aluop  (EX_in.ctrl_word.aluop),
        .a      (alumux1_out),
        .b      (alumux2_out),
        .f      (real_alu_out)
    );

    multiplier_divider_unit mdu (
        .clk,
        .sel    (EX_in.ctrl_word.mulmux_sel == mulmux::mul_out),
        .mulop  (EX_in.ctrl_word.mulop),
        .a      (real_EXE_rs1),
        .b      (real_EXE_rs2),
        .f      (real_mul_div_out),
        .done   (multiplier_done)
    );

    always_comb begin : ALU_MUL_DIV_MUX
        unique case (EX_in.ctrl_word.mulmux_sel)
            mulmux::true_alu_out:
                alu_out = real_alu_out;
            mulmux::mul_out:
                alu_out = real_mul_div_out;
            default:
                `BAD_MUX_SEL;
        endcase
    end

    cmp cmp (
        .cmpop  (EX_in.ctrl_word.cmpop),
        .cmpmux (cmpmux_out),
        .rs1    (real_EXE_rs1),
        .br_en  (br_en)
    );

    assign EX_out.ctrl_word = EX_in.ctrl_word;
    assign EX_out.pc_plus4 = EX_in.pc_plus4;
    assign EX_out.alu_out = alu_out;
    assign EX_out.rs2_out = real_EXE_rs2;
    assign EX_out.u_imm = EX_in.u_imm;
    assign EX_out.br_en = br_en;
    assign EX_out.rs1 = EX_in.rs1;
    assign EX_out.rs2 = EX_in.rs2;
    assign EX_out.rd = EX_in.rd;

    //=============== EX / MEM interface ===============
    register #($bits(EX_MEM_signal)) EX_MEM_reg (
        .clk,
        .load(load_EX_MEM),
        .in(EX_out),
        .out(MEM_in)
    );

    //=============== MEM ===============
    logic MEM_rs2_forward_from_WB;
    assign MEM_rs2_forward_from_WB = (MEM_in.rs2 != '0) & ((MEM_in.rs2 == WB_in.rd) & WB_in.ctrl_word.load_regfile);
    rv32i_word real_MEM_rs2;
    assign real_MEM_rs2 = (MEM_rs2_forward_from_WB)? regfilemux_out : MEM_in.rs2_out;
    logic [1:0] dmem_addr_mod_4;

    assign D.read = MEM_in.ctrl_word.dmem_read;
    assign D.write = MEM_in.ctrl_word.dmem_write;
    // assign D.wdata = real_MEM_rs2;
    assign D.addr = MEM_in.alu_out;
    assign dmem_addr_mod_4 = D.addr[1:0];
    assign D.wmask = (MEM_in.ctrl_word.dmem_wmask) << dmem_addr_mod_4;
    assign MEM_out.dmem_data_out = D.rdata;

    assign MEM_out.ctrl_word = MEM_in.ctrl_word;
    assign MEM_out.pc_plus4 = MEM_in.pc_plus4;
    assign MEM_out.alu_out = MEM_in.alu_out;
    assign MEM_out.u_imm = MEM_in.u_imm;
    assign MEM_out.br_en = MEM_in.br_en;
    assign MEM_out.dmem_addr_mod_4 = dmem_addr_mod_4;
    assign MEM_out.rs1 = MEM_in.rs1;
    assign MEM_out.rs2 = MEM_in.rs2;
    assign MEM_out.rd = MEM_in.rd;

    always_comb begin : MEM_WDATA_MUX
        unique case (MEM_in.ctrl_word.dmem_wmask)
            4'b0001:    // sb
                unique case (dmem_addr_mod_4)
                    2'b00: D.wdata = real_MEM_rs2;
                    2'b01: D.wdata = real_MEM_rs2 << 8;
                    2'b10: D.wdata = real_MEM_rs2 << 16;
                    2'b11: D.wdata = real_MEM_rs2 << 24;
                endcase
            4'b0011:    // sh
                if (dmem_addr_mod_4 == 2'b00)
                    D.wdata = real_MEM_rs2;
                else
                    D.wdata = real_MEM_rs2 << 16;
            4'b1111:    // sw
                D.wdata = real_MEM_rs2;
            default:
                D.wdata = real_MEM_rs2;
        endcase
    end

    always_comb begin : REGFILE_MUX
        unique case (MEM_in.ctrl_word.regfilemux_sel)
            regfilemux::alu_out:
                MEM_out.regfilemux_out = MEM_in.alu_out;
            regfilemux::br_en:
                MEM_out.regfilemux_out = {31'b0, MEM_in.br_en};
            regfilemux::u_imm:
                MEM_out.regfilemux_out = MEM_in.u_imm;
            regfilemux::lw:
                MEM_out.regfilemux_out = D.rdata;
            regfilemux::pc_plus4:
                MEM_out.regfilemux_out = MEM_in.pc_plus4;
            regfilemux::lb:
                unique case (dmem_addr_mod_4)
                    2'b00: MEM_out.regfilemux_out = {{24{D.rdata[7]}}, D.rdata[7:0]};
                    2'b01: MEM_out.regfilemux_out = {{24{D.rdata[15]}}, D.rdata[15:8]};
                    2'b10: MEM_out.regfilemux_out = {{24{D.rdata[23]}}, D.rdata[23:16]};
                    2'b11: MEM_out.regfilemux_out = {{24{D.rdata[31]}}, D.rdata[31:24]};
                endcase
            regfilemux::lbu:
                unique case (dmem_addr_mod_4)
                    2'b00: MEM_out.regfilemux_out = {24'b0, D.rdata[7:0]};
                    2'b01: MEM_out.regfilemux_out = {24'b0, D.rdata[15:8]};
                    2'b10: MEM_out.regfilemux_out = {24'b0, D.rdata[23:16]};
                    2'b11: MEM_out.regfilemux_out = {24'b0, D.rdata[31:24]};
                endcase
            regfilemux::lh:
                if (dmem_addr_mod_4 == 2'b00)
                    MEM_out.regfilemux_out = {{16{D.rdata[15]}}, D.rdata[15:0]};
                else
                    MEM_out.regfilemux_out = {{16{D.rdata[31]}}, D.rdata[31:16]};
            regfilemux::lhu:
                if (dmem_addr_mod_4 == 2'b00)
                    MEM_out.regfilemux_out = {16'b0, D.rdata[15:0]};
                else
                    MEM_out.regfilemux_out = {16'b0, D.rdata[31:16]};
            default:
                `BAD_MUX_SEL;
        endcase
    end

    //=============== MEM / WB interface ===============
    register #($bits(MEM_WB_signal)) MEM_WB_reg (
        .clk,
        .load(load_MEM_WB),
        .in(MEM_out),
        .out(WB_in)
    );

    //=============== WB ===============
    assign regfilemux_out = WB_in.regfilemux_out;
    assign load_regfile = WB_in.ctrl_word.load_regfile;
    assign rd = WB_in.rd;

    // stall logic assuming MP2 cache for L1 cache
    assign stall_i_cache = I.read & ~I.resp;
    assign stall_d_cache = (D.read | D.write) & ~D.resp;
    assign stall_multiplier_divider = ~multiplier_done;
    assign stall = stall_i_cache | stall_d_cache | stall_multiplier_divider;

endmodule : cpu_datapath
