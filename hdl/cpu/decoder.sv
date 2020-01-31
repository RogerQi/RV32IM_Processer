// `include "../rv32i_types.sv"
import rv32i_types::*;

module decoder (
    input rv32i_word instruction,

    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output rv32i_opcode opcode,
    output rv32i_word i_imm,
    output rv32i_word s_imm,
    output rv32i_word b_imm,
    output rv32i_word u_imm,
    output rv32i_word j_imm,
    output rv32i_reg rs1,
    output rv32i_reg rs2,
    output rv32i_reg rd
);

    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign opcode = rv32i_opcode'(instruction[6:0]);
    assign i_imm = {{21{instruction[31]}}, instruction[30:20]};
    assign s_imm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
    assign b_imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    assign u_imm = {instruction[31:12], 12'h000};
    assign j_imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];

endmodule : decoder
