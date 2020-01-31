`ifndef pipeline_reg_types
`define pipeline_reg_types
// `include "../rv32i_types.sv"
package pipeline_reg_types;

import rv32i_types::*;

typedef struct packed {
    rv32i_word instruction;
    rv32i_word pc;
    rv32i_word pc_plus4;
    logic br_taken;
} IF_ID_signal;

typedef struct packed {
    rv32i_control_word ctrl_word;   //29
    rv32i_word pc;
    rv32i_word pc_plus4;
    rv32i_word rs1_out;
    rv32i_word rs2_out;
    rv32i_word i_imm;
    rv32i_word u_imm;
    rv32i_word b_imm;
    rv32i_word s_imm;
    rv32i_word j_imm;
    rv32i_reg rs1;
    rv32i_reg rs2;
    rv32i_reg rd;
    logic br_taken;
} ID_EX_signal;

typedef struct packed {
    rv32i_control_word ctrl_word;
    rv32i_word pc_plus4;
    rv32i_word alu_out;
    rv32i_word rs2_out;
    rv32i_word u_imm;
    logic br_en;
    rv32i_reg rs1;
    rv32i_reg rs2;
    rv32i_reg rd;
} EX_MEM_signal;

typedef struct packed {
    rv32i_control_word ctrl_word;
    rv32i_word pc_plus4;
    rv32i_word alu_out;
    rv32i_word dmem_data_out;
    rv32i_word u_imm;
    rv32i_word regfilemux_out;
    logic br_en;
    logic [1:0] dmem_addr_mod_4;
    rv32i_reg rs1;
    rv32i_reg rs2;
    rv32i_reg rd;
} MEM_WB_signal;

endpackage : pipeline_reg_types

`endif
