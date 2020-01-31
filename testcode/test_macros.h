#ifndef TEST_MACROS_H_
#define TEST_MACROS_H_

#define __riscv_xlen 32
#define MASK_XLEN(x) ((x) & ((1 << (__riscv_xlen - 1) << 1) - 1))

#define TEST_INSERT_NOPS_0
#define TEST_INSERT_NOPS_1  nop; TEST_INSERT_NOPS_0
#define TEST_INSERT_NOPS_2  nop; TEST_INSERT_NOPS_1
#define TEST_INSERT_NOPS_3  nop; TEST_INSERT_NOPS_2
#define TEST_INSERT_NOPS_4  nop; TEST_INSERT_NOPS_3
#define TEST_INSERT_NOPS_5  nop; TEST_INSERT_NOPS_4
#define TEST_INSERT_NOPS_6  nop; TEST_INSERT_NOPS_5
#define TEST_INSERT_NOPS_7  nop; TEST_INSERT_NOPS_6
#define TEST_INSERT_NOPS_8  nop; TEST_INSERT_NOPS_7
#define TEST_INSERT_NOPS_9  nop; TEST_INSERT_NOPS_8
#define TEST_INSERT_NOPS_10 nop; TEST_INSERT_NOPS_9

#define SEXT_IMM(x) ((x) | (-(((x) >> 11) & 1) << 11))
// USE x31 register to store TESTNUM...
#define TESTNUM x31
#define AVOID_HAZARD

#define TEST_CASE( testnum, testreg, correctval, code... ) \
test_ ## testnum: \
    AVOID_HAZARD \
    code; \
    AVOID_HAZARD \
    li  x29, MASK_XLEN(correctval); \
    AVOID_HAZARD \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    bne testreg, x29, fail; \
    AVOID_HAZARD \

#define TEST_IMM_OP( testnum, inst, result, val1, imm ) \
    TEST_CASE( testnum, x14, result, \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      inst x14, x1, SEXT_IMM(imm); \
    )

#define TEST_IMM_SRC1_EQ_DEST( testnum, inst, result, val1, imm ) \
    TEST_CASE( testnum, x1, result, \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      inst x1, x1, SEXT_IMM(imm); \
    )

#define TEST_IMM_DEST_BYPASS( testnum, nop_cycles, inst, result, val1, imm ) \
    TEST_CASE( testnum, x6, result, \
      li  x4, 0; \
      AVOID_HAZARD \
1:    li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      inst x14, x1, SEXT_IMM(imm); \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## nop_cycles \
      AVOID_HAZARD \
      addi  x6, x14, 0; \
      AVOID_HAZARD \
      addi  x4, x4, 1; \
      AVOID_HAZARD \
      li  x5, 2; \
      AVOID_HAZARD \
      bne x4, x5, 1b \
)

#define TEST_IMM_SRC1_BYPASS( testnum, nop_cycles, inst, result, val1, imm ) \
    TEST_CASE( testnum, x14, result, \
      li  x4, 0; \
      AVOID_HAZARD \
1:    li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## nop_cycles \
      AVOID_HAZARD \
      inst x14, x1, SEXT_IMM(imm); \
      AVOID_HAZARD \
      addi  x4, x4, 1; \
      AVOID_HAZARD \
      li  x5, 2; \
      AVOID_HAZARD \
      bne x4, x5, 1b \
    )

#define TEST_IMM_ZEROSRC1( testnum, inst, result, imm ) \
    TEST_CASE( testnum, x1, result, \
      inst x1, x0, SEXT_IMM(imm); \
    )

#define TEST_IMM_ZERODEST( testnum, inst, val1, imm ) \
    TEST_CASE( testnum, x0, 0, \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      inst x0, x1, SEXT_IMM(imm); \
    )

#-----------------------------------------------------------------------
# Tests for an instruction with register operands
#-----------------------------------------------------------------------

#define TEST_R_OP( testnum, inst, result, val1 ) \
    TEST_CASE( testnum, x14, result, \
      li  x1, val1; \
      AVOID_HAZARD \
      inst x14, x1; \
    )

#define TEST_R_SRC1_EQ_DEST( testnum, inst, result, val1 ) \
    TEST_CASE( testnum, x1, result, \
      li  x1, val1; \
      AVOID_HAZARD \
      inst x1, x1; \
    )

#define TEST_R_DEST_BYPASS( testnum, nop_cycles, inst, result, val1 ) \
    TEST_CASE( testnum, x6, result, \
      li  x4, 0; \
      AVOID_HAZARD \
1:    li  x1, val1; \
      AVOID_HAZARD \
      inst x14, x1; \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## nop_cycles \
      AVOID_HAZARD \
      addi  x6, x14, 0; \
      AVOID_HAZARD \
      addi  x4, x4, 1; \
      AVOID_HAZARD \
      li  x5, 2; \
      AVOID_HAZARD \
      bne x4, x5, 1b \
    )

#-----------------------------------------------------------------------
# Tests for an instruction with register-register operands
#-----------------------------------------------------------------------

#define TEST_RR_OP( testnum, inst, result, val1, val2 ) \
    TEST_CASE( testnum, x14, result, \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      li  x2, MASK_XLEN(val2); \
      AVOID_HAZARD \
      inst x14, x1, x2; \
    )

#define TEST_RR_SRC1_EQ_DEST( testnum, inst, result, val1, val2 ) \
    TEST_CASE( testnum, x1, result, \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      li  x2, MASK_XLEN(val2); \
      AVOID_HAZARD \
      inst x1, x1, x2; \
    )

#define TEST_RR_SRC2_EQ_DEST( testnum, inst, result, val1, val2 ) \
    TEST_CASE( testnum, x2, result, \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      li  x2, MASK_XLEN(val2); \
      AVOID_HAZARD \
      inst x2, x1, x2; \
    )

#define TEST_RR_SRC12_EQ_DEST( testnum, inst, result, val1 ) \
    TEST_CASE( testnum, x1, result, \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      inst x1, x1, x1; \
    )

#define TEST_RR_DEST_BYPASS( testnum, nop_cycles, inst, result, val1, val2 ) \
    TEST_CASE( testnum, x6, result, \
      li  x4, 0; \
      AVOID_HAZARD \
1:    li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      li  x2, MASK_XLEN(val2); \
      AVOID_HAZARD \
      inst x14, x1, x2; \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## nop_cycles \
      AVOID_HAZARD \
      addi  x6, x14, 0; \
      AVOID_HAZARD \
      addi  x4, x4, 1; \
      AVOID_HAZARD \
      li  x5, 2; \
      AVOID_HAZARD \
      bne x4, x5, 1b \
    )

#define TEST_RR_SRC12_BYPASS( testnum, src1_nops, src2_nops, inst, result, val1, val2 ) \
    TEST_CASE( testnum, x14, result, \
      li  x4, 0; \
      AVOID_HAZARD \
1:    li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## src1_nops \
      AVOID_HAZARD \
      li  x2, MASK_XLEN(val2); \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## src2_nops \
      AVOID_HAZARD \
      inst x14, x1, x2; \
      AVOID_HAZARD \
      addi  x4, x4, 1; \
      AVOID_HAZARD \
      li  x5, 2; \
      AVOID_HAZARD \
      bne x4, x5, 1b \
    )

#define TEST_RR_SRC21_BYPASS( testnum, src1_nops, src2_nops, inst, result, val1, val2 ) \
    TEST_CASE( testnum, x14, result, \
      li  x4, 0; \
      AVOID_HAZARD \
1:    li  x2, MASK_XLEN(val2); \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## src1_nops \
      AVOID_HAZARD \
      li  x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      TEST_INSERT_NOPS_ ## src2_nops \
      AVOID_HAZARD \
      inst x14, x1, x2; \
      AVOID_HAZARD \
      addi  x4, x4, 1; \
      AVOID_HAZARD \
      li  x5, 2; \
      AVOID_HAZARD \
      bne x4, x5, 1b \
    )

#define TEST_RR_ZEROSRC1( testnum, inst, result, val ) \
    TEST_CASE( testnum, x2, result, \
      li x1, MASK_XLEN(val); \
      AVOID_HAZARD \
      inst x2, x0, x1; \
    )

#define TEST_RR_ZEROSRC2( testnum, inst, result, val ) \
    TEST_CASE( testnum, x2, result, \
      li x1, MASK_XLEN(val); \
      AVOID_HAZARD \
      inst x2, x1, x0; \
    )

#define TEST_RR_ZEROSRC12( testnum, inst, result ) \
    TEST_CASE( testnum, x1, result, \
      inst x1, x0, x0; \
    )

#define TEST_RR_ZERODEST( testnum, inst, val1, val2 ) \
    TEST_CASE( testnum, x0, 0, \
      li x1, MASK_XLEN(val1); \
      AVOID_HAZARD \
      li x2, MASK_XLEN(val2); \
      AVOID_HAZARD \
      inst x0, x1, x2; \
    )

#-----------------------------------------------------------------------
# Test memory instructions
#-----------------------------------------------------------------------

#define TEST_LD_OP( testnum, inst, result, offset, base ) \
    TEST_CASE( testnum, x14, result, \
      la  x1, base; \
      AVOID_HAZARD \
      inst x14, offset(x1); \
    )

#define TEST_ST_OP( testnum, load_inst, store_inst, result, offset, base ) \
    TEST_CASE( testnum, x14, result, \
      la  x1, base; \
      AVOID_HAZARD \
      li  x2, result; \
      AVOID_HAZARD \
      store_inst x2, offset(x1); \
      AVOID_HAZARD \
      load_inst x14, offset(x1); \
    )

#define TEST_LD_DEST_BYPASS( testnum, nop_cycles, inst, result, offset, base ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  la  x1, base; \
    AVOID_HAZARD \
    inst x14, offset(x1); \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## nop_cycles \
    AVOID_HAZARD \
    addi  x6, x14, 0; \
    AVOID_HAZARD \
    li  x29, result; \
    AVOID_HAZARD \
    bne x6, x29, fail; \
    AVOID_HAZARD \
    addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b; \

#define TEST_LD_SRC1_BYPASS( testnum, nop_cycles, inst, result, offset, base ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  la  x1, base; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## nop_cycles \
    AVOID_HAZARD \
    inst x14, offset(x1); \
    AVOID_HAZARD \
    li  x29, result; \
    AVOID_HAZARD \
    bne x14, x29, fail; \
    AVOID_HAZARD \
    addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b \

#define TEST_ST_SRC12_BYPASS( testnum, src1_nops, src2_nops, load_inst, store_inst, result, offset, base ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  li  x1, result; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src1_nops \
    AVOID_HAZARD \
    la  x2, base; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src2_nops \
    AVOID_HAZARD \
    store_inst x1, offset(x2); \
    AVOID_HAZARD \
    load_inst x14, offset(x2); \
    AVOID_HAZARD \
    li  x29, result; \
    AVOID_HAZARD \
    bne x14, x29, fail; \
    AVOID_HAZARD \
    addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b \

#define TEST_ST_SRC21_BYPASS( testnum, src1_nops, src2_nops, load_inst, store_inst, result, offset, base ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  la  x2, base; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src1_nops \
    AVOID_HAZARD \
    li  x1, result; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src2_nops \
    AVOID_HAZARD \
    store_inst x1, offset(x2); \
    AVOID_HAZARD \
    load_inst x14, offset(x2); \
    AVOID_HAZARD \
    li  x29, result; \
    AVOID_HAZARD \
    bne x14, x29, fail; \
    AVOID_HAZARD \
    addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b \

#define TEST_BR2_OP_TAKEN( testnum, inst, val1, val2 ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x1, val1; \
    AVOID_HAZARD \
    li  x2, val2; \
    AVOID_HAZARD \
    inst x1, x2, 2f; \
    AVOID_HAZARD \
    bne x0, TESTNUM, fail; \
    AVOID_HAZARD \
1:  bne x0, TESTNUM, 3f; \
    AVOID_HAZARD \
2:  inst x1, x2, 1b; \
    AVOID_HAZARD \
    bne x0, TESTNUM, fail; \
3:

#define TEST_BR2_OP_NOTTAKEN( testnum, inst, val1, val2 ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x1, val1; \
    AVOID_HAZARD \
    li  x2, val2; \
    AVOID_HAZARD \
    inst x1, x2, 1f; \
    AVOID_HAZARD \
    bne x0, TESTNUM, 2f; \
    AVOID_HAZARD \
1:  bne x0, TESTNUM, fail; \
    AVOID_HAZARD \
2:  inst x1, x2, 1b; \
    AVOID_HAZARD \
3:  AVOID_HAZARD

#define TEST_BR2_SRC12_BYPASS( testnum, src1_nops, src2_nops, inst, val1, val2 ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  li  x1, val1; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src1_nops \
    AVOID_HAZARD \
    li  x2, val2; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src2_nops \
    AVOID_HAZARD \
    inst x1, x2, fail; \
    AVOID_HAZARD \
    addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b \

#define TEST_BR2_SRC21_BYPASS( testnum, src1_nops, src2_nops, inst, val1, val2 ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  li  x2, val2; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src1_nops \
    AVOID_HAZARD \
    li  x1, val1; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## src2_nops \
    AVOID_HAZARD \
    inst x1, x2, fail; \
    AVOID_HAZARD \
    addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b \

#-----------------------------------------------------------------------
# Test jump instructions
#-----------------------------------------------------------------------

#define TEST_JR_SRC1_BYPASS( testnum, nop_cycles, inst ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  la  x6, 2f; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## nop_cycles \
    AVOID_HAZARD \
    inst x6; \
    AVOID_HAZARD \
    bne x0, TESTNUM, fail; \
    AVOID_HAZARD \
2:  addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b \

#define TEST_JALR_SRC1_BYPASS( testnum, nop_cycles, inst ) \
test_ ## testnum: \
    li  TESTNUM, testnum; \
    AVOID_HAZARD \
    li  x4, 0; \
    AVOID_HAZARD \
1:  la  x6, 2f; \
    AVOID_HAZARD \
    TEST_INSERT_NOPS_ ## nop_cycles \
    AVOID_HAZARD \
    inst x13, x6, 0; \
    AVOID_HAZARD \
    bne x0, TESTNUM, fail; \
    AVOID_HAZARD \
2:  addi  x4, x4, 1; \
    AVOID_HAZARD \
    li  x5, 2; \
    AVOID_HAZARD \
    bne x4, x5, 1b \

#-----------------------------------------------------------------------
# Pass and fail code (assumes test num is in TESTNUM)
#-----------------------------------------------------------------------

#define TEST_PASSFAIL \
        AVOID_HAZARD \
        bne x0, TESTNUM, pass; \
        AVOID_HAZARD \
fail: \
        addi x1, x0, 777; \
        AVOID_HAZARD \
fail_loop: \
        beq x0, x0, fail_loop; \
pass: \
        AVOID_HAZARD \
        addi x1, x0, 666; \
        AVOID_HAZARD \
pass_loop: \
        beq x0, x0, pass_loop; \

#endif // TEST_MACROS_H_
