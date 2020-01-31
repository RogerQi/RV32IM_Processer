#include "test_macros.h"
.align 4
.section .text
.globl _start
_start:
  #-------------------------------------------------------------
  # ADD
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  add, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  add, 0x00000002, 0x00000001, 0x00000001 );
  TEST_RR_OP( MAGIC_COUNT,  add, 0x0000000a, 0x00000003, 0x00000007 );

  TEST_RR_OP( MAGIC_COUNT,  add, 0xffffffffffff8000, 0x0000000000000000, 0xffffffffffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  add, 0xffffffff80000000, 0xffffffff80000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  add, 0xffffffff7fff8000, 0xffffffff80000000, 0xffffffffffff8000 );

  TEST_RR_OP( MAGIC_COUNT,  add, 0x0000000000007fff, 0x0000000000000000, 0x0000000000007fff );
  TEST_RR_OP( MAGIC_COUNT,  add, 0x000000007fffffff, 0x000000007fffffff, 0x0000000000000000 );
  TEST_RR_OP( MAGIC_COUNT, add, 0x0000000080007ffe, 0x000000007fffffff, 0x0000000000007fff );

  TEST_RR_OP( MAGIC_COUNT, add, 0xffffffff80007fff, 0xffffffff80000000, 0x0000000000007fff );
  TEST_RR_OP( MAGIC_COUNT, add, 0x000000007fff7fff, 0x000000007fffffff, 0xffffffffffff8000 );

  TEST_RR_OP( MAGIC_COUNT, add, 0xffffffffffffffff, 0x0000000000000000, 0xffffffffffffffff );
  TEST_RR_OP( MAGIC_COUNT, add, 0x0000000000000000, 0xffffffffffffffff, 0x0000000000000001 );
  TEST_RR_OP( MAGIC_COUNT, add, 0xfffffffffffffffe, 0xffffffffffffffff, 0xffffffffffffffff );

  TEST_RR_OP( MAGIC_COUNT, add, 0x0000000080000000, 0x0000000000000001, 0x000000007fffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, add, 24, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, add, 25, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, add, 26, 13 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, add, 24, 13, 11 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, add, 25, 14, 11 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, add, 26, 15, 11 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, add, 24, 13, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, add, 25, 14, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, add, 26, 15, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, add, 24, 13, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, add, 25, 14, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, add, 26, 15, 11 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, add, 24, 13, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, add, 25, 14, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, add, 26, 15, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, add, 24, 13, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, add, 25, 14, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, add, 26, 15, 11 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, add, 15, 15 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, add, 32, 32 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, add, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, add, 16, 30 );

  #-------------------------------------------------------------
  # ADDi
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT,  addi, 0x00000000, 0x00000000, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT,  addi, 0x00000002, 0x00000001, 0x001 );
  TEST_IMM_OP( MAGIC_COUNT,  addi, 0x0000000a, 0x00000003, 0x007 );

  TEST_IMM_OP( MAGIC_COUNT,  addi, 0xfffffffffffff800, 0x0000000000000000, 0x800 );
  TEST_IMM_OP( MAGIC_COUNT,  addi, 0xffffffff80000000, 0xffffffff80000000, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT,  addi, 0xffffffff7ffff800, 0xffffffff80000000, 0x800 );

  TEST_IMM_OP( MAGIC_COUNT,  addi, 0x00000000000007ff, 0x00000000, 0x7ff );
  TEST_IMM_OP( MAGIC_COUNT,  addi, 0x000000007fffffff, 0x7fffffff, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT, addi, 0x00000000800007fe, 0x7fffffff, 0x7ff );

  TEST_IMM_OP( MAGIC_COUNT, addi, 0xffffffff800007ff, 0xffffffff80000000, 0x7ff );
  TEST_IMM_OP( MAGIC_COUNT, addi, 0x000000007ffff7ff, 0x000000007fffffff, 0x800 );

  TEST_IMM_OP( MAGIC_COUNT, addi, 0xffffffffffffffff, 0x0000000000000000, 0xfff );
  TEST_IMM_OP( MAGIC_COUNT, addi, 0x0000000000000000, 0xffffffffffffffff, 0x001 );
  TEST_IMM_OP( MAGIC_COUNT, addi, 0xfffffffffffffffe, 0xffffffffffffffff, 0xfff );

  TEST_IMM_OP( MAGIC_COUNT, addi, 0x0000000080000000, 0x7fffffff, 0x001 );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, addi, 24, 13, 11 );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 0, addi, 24, 13, 11 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 1, addi, 23, 13, 10 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 2, addi, 22, 13,  9 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, addi, 24, 13, 11 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, addi, 23, 13, 10 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, addi, 22, 13,  9 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, addi, 32, 32 );
  TEST_IMM_ZERODEST( MAGIC_COUNT, addi, 33, 50 );

  #-------------------------------------------------------------
  # AND
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT, and, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_OP( MAGIC_COUNT, and, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_OP( MAGIC_COUNT, and, 0x000f000f, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_OP( MAGIC_COUNT, and, 0xf000f000, 0xf00ff00f, 0xf0f0f0f0 );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, and, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, and, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, and, 0xff00ff00, 0xff00ff00 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT,  0, and, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, and, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, and, 0x000f000f, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, and, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, and, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, and, 0x000f000f, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, and, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, and, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, and, 0x000f000f, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, and, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, and, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, and, 0x000f000f, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, and, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, and, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, and, 0x000f000f, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, and, 0, 0xff00ff00 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, and, 0, 0x00ff00ff );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, and, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, and, 0x11111111, 0x22222222 );

  #-------------------------------------------------------------
  # ANDi
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT, andi, 0xff00ff00, 0xff00ff00, 0xf0f );
  TEST_IMM_OP( MAGIC_COUNT, andi, 0x000000f0, 0x0ff00ff0, 0x0f0 );
  TEST_IMM_OP( MAGIC_COUNT, andi, 0x0000000f, 0x00ff00ff, 0x70f );
  TEST_IMM_OP( MAGIC_COUNT, andi, 0x00000000, 0xf00ff00f, 0x0f0 );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, andi, 0x00000000, 0xff00ff00, 0x0f0 );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  0, andi, 0x00000700, 0x0ff00ff0, 0x70f );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  1, andi, 0x000000f0, 0x00ff00ff, 0x0f0 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  2, andi, 0xf00ff00f, 0xf00ff00f, 0xf0f );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, andi, 0x00000700, 0x0ff00ff0, 0x70f );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, andi, 0x000000f0, 0x00ff00ff, 0x0f0 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, andi, 0x0000000f, 0xf00ff00f, 0x70f );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, andi, 0, 0x0f0 );
  TEST_IMM_ZERODEST( MAGIC_COUNT, andi, 0x00ff00ff, 0x70f );

  #-------------------------------------------------------------
  # auipc
  #-------------------------------------------------------------

  TEST_CASE(MAGIC_COUNT, a0, 10000, \
    .align 3; \
    lla a0, 1f + 10000; \
    jal a1, 1f; \
    1: sub a0, a0, a1; \
  )

  TEST_CASE(MAGIC_COUNT, a0, -10000, \
    .align 3; \
    lla a0, 1f - 10000; \
    jal a1, 1f; \
    1: sub a0, a0, a1; \
  )

  .align 4;

  #-------------------------------------------------------------
  # beq
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( MAGIC_COUNT, beq,  0,  0 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, beq,  1,  1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, beq, -1, -1 );

  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, beq,  0,  1 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, beq,  1,  0 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, beq, -1,  1 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, beq,  1, -1 );

  # Bypassing tests

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT,  0, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, beq, 0, -1 );

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, beq, 0, -1 );

  # Test delay slot instructions not executed nor bypassed

  TEST_CASE( MAGIC_COUNT, x1, 3, \
    li  x1, 1; \
    beq x0, x0, 1f; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
1:  addi x1, x1, 1; \
    addi x1, x1, 1; \
  )

  #-------------------------------------------------------------
  # bge
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bge,  0,  0 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bge,  1,  1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bge, -1, -1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bge,  1,  0 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bge,  1, -1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bge, -1, -2 );

  TEST_BR2_OP_NOTTAKEN(  MAGIC_COUNT, bge,  0,  1 );
  TEST_BR2_OP_NOTTAKEN(  MAGIC_COUNT, bge, -1,  1 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bge, -2, -1 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bge, -2,  1 );

  # Bypassing tests

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bge, -1, 0 );

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bge, -1, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bge, -1, 0 );

  # Test delay slot instructions not executed nor bypassed

  TEST_CASE( MAGIC_COUNT, x1, 3, \
    li  x1, 1; \
    bge x1, x0, 1f; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
1:  addi x1, x1, 1; \
    addi x1, x1, 1; \
  )

  #-------------------------------------------------------------
  # bgeu
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bgeu, 0x00000000, 0x00000000 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bgeu, 0x00000001, 0x00000001 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bgeu, 0xffffffff, 0xffffffff );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bgeu, 0x00000001, 0x00000000 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bgeu, 0xffffffff, 0xfffffffe );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bgeu, 0xffffffff, 0x00000000 );

  TEST_BR2_OP_NOTTAKEN(  MAGIC_COUNT, bgeu, 0x00000000, 0x00000001 );
  TEST_BR2_OP_NOTTAKEN(  MAGIC_COUNT, bgeu, 0xfffffffe, 0xffffffff );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bgeu, 0x00000000, 0xffffffff );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bgeu, 0x7fffffff, 0x80000000 );

  # Bypassing tests

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bgeu, 0xefffffff, 0xf0000000 );

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bgeu, 0xefffffff, 0xf0000000 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bgeu, 0xefffffff, 0xf0000000 );

  # Test delay slot instructions not executed nor bypassed

  TEST_CASE( MAGIC_COUNT, x1, 3, \
    li  x1, 1; \
    bgeu x1, x0, 1f; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
1:  addi x1, x1, 1; \
    addi x1, x1, 1; \
  )

  #-------------------------------------------------------------
  # blt
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( MAGIC_COUNT, blt,  0,  1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, blt, -1,  1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, blt, -2, -1 );

  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, blt,  1,  0 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, blt,  1, -1 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, blt, -1, -2 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, blt,  1, -2 );

  # Bypassing tests

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT,  0, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, blt, 0, -1 );

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, blt, 0, -1 );

  # Test delay slot instructions not executed nor bypassed

  TEST_CASE( MAGIC_COUNT, x1, 3, \
    li  x1, 1; \
    blt x0, x1, 1f; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
1:  addi x1, x1, 1; \
    addi x1, x1, 1; \
  )

  #-------------------------------------------------------------
  # bltu
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bltu, 0x00000000, 0x00000001 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bltu, 0xfffffffe, 0xffffffff );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bltu, 0x00000000, 0xffffffff );

  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bltu, 0x00000001, 0x00000000 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bltu, 0xffffffff, 0xfffffffe );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bltu, 0xffffffff, 0x00000000 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bltu, 0x80000000, 0x7fffffff );

  # Bypassing tests

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT,  0, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bltu, 0xf0000000, 0xefffffff );

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bltu, 0xf0000000, 0xefffffff );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bltu, 0xf0000000, 0xefffffff );

  # Test delay slot instructions not executed nor bypassed

  TEST_CASE( MAGIC_COUNT, x1, 3, \
    li  x1, 1; \
    bltu x0, x1, 1f; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
1:  addi x1, x1, 1; \
    addi x1, x1, 1; \
  )

  #-------------------------------------------------------------
  # bne
  #-------------------------------------------------------------

  # Each test checks both forward and backward branches

  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bne,  0,  1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bne,  1,  0 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bne, -1,  1 );
  TEST_BR2_OP_TAKEN( MAGIC_COUNT, bne,  1, -1 );

  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bne,  0,  0 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bne,  1,  1 );
  TEST_BR2_OP_NOTTAKEN( MAGIC_COUNT, bne, -1, -1 );

  # Bypassing tests

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT,  0, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bne, 0, 0 );

  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 0, 2, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 1, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( MAGIC_COUNT, 2, 0, bne, 0, 0 );

  # Test delay slot instructions not executed nor bypassed

  TEST_CASE( MAGIC_COUNT, x1, 3, \
    li  x1, 1; \
    bne x1, x0, 1f; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
    addi x1, x1, 1; \
1:  addi x1, x1, 1; \
    addi x1, x1, 1; \
  )

  #-------------------------------------------------------------
  # jal
  #-------------------------------------------------------------

test_jal_2:
  li  TESTNUM, MAGIC_COUNT
  li  ra, 0

  jal x4, target_jal_2
linkaddr_jal_2:
  nop
  nop

  j fail

target_jal_2:
  la  x2, linkaddr_jal_2
  bne x2, x4, fail

  # Test delay slot instructions not executed nor bypassed

  TEST_CASE( MAGIC_COUNT, ra, 3, \
    li  ra, 1; \
    jal x0, 1f; \
    addi ra, ra, 1; \
    addi ra, ra, 1; \
    addi ra, ra, 1; \
    addi ra, ra, 1; \
1:  addi ra, ra, 1; \
    addi ra, ra, 1; \
  )

  #-------------------------------------------------------------
  # jalr
  #-------------------------------------------------------------

test_jalr_2:
  li  TESTNUM, MAGIC_COUNT
  li  t0, 0
  la  t1, target_jalr_2

  jalr t0, t1, 0
linkaddr_jalr_2:
  j fail

target_jalr_2:
  la  t1, linkaddr_jalr_2
  bne t0, t1, fail

  # Bypassing tests

  TEST_JALR_SRC1_BYPASS( MAGIC_COUNT, 0, jalr );
  TEST_JALR_SRC1_BYPASS( MAGIC_COUNT, 1, jalr );
  TEST_JALR_SRC1_BYPASS( MAGIC_COUNT, 2, jalr );

  # Test delay slot instructions not executed nor bypassed

  .option push
  .align 2
  .option norvc
  TEST_CASE( MAGIC_COUNT, t0, 4, \
    li  t0, 1; \
    la  t1, 1f; \
    jr  t1, -4; \
    addi t0, t0, 1; \
    addi t0, t0, 1; \
    addi t0, t0, 1; \
    addi t0, t0, 1; \
1:  addi t0, t0, 1; \
    addi t0, t0, 1; \
  )
  .option pop

  .align 4

  #-------------------------------------------------------------
  # lb
  #-------------------------------------------------------------

  TEST_LD_OP( MAGIC_COUNT, lb, 0xffffffffffffffff, 0,  lb_test_data );
  TEST_LD_OP( MAGIC_COUNT, lb, 0x0000000000000000, 1,  lb_test_data );
  TEST_LD_OP( MAGIC_COUNT, lb, 0xfffffffffffffff0, 2,  lb_test_data );
  TEST_LD_OP( MAGIC_COUNT, lb, 0x000000000000000f, 3, lb_test_data );

  # Test with negative offset

  TEST_LD_OP( MAGIC_COUNT, lb, 0xffffffffffffffff, -3, lb_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lb, 0x0000000000000000, -2,  lb_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lb, 0xfffffffffffffff0, -1,  lb_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lb, 0x000000000000000f, 0,   lb_test_data4 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0xffffffffffffffff, \
    la  x1, lb_test_data; \
    addi x1, x1, -32; \
    lb x5, 32(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0x0000000000000000, \
    la  x1, lb_test_data; \
    addi x1, x1, -6; \
    lb x5, 7(x1); \
  )

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 0, lb, 0xfffffffffffffff0, 1, lb_test_data2 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 1, lb, 0x000000000000000f, 1, lb_test_data3 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 2, lb, 0x0000000000000000, 1, lb_test_data1 );

  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 0, lb, 0xfffffffffffffff0, 1, lb_test_data2 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 1, lb, 0x000000000000000f, 1, lb_test_data3 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 2, lb, 0x0000000000000000, 1, lb_test_data1 );

  #-------------------------------------------------------------
  # Test write-after-write hazard
  #-------------------------------------------------------------

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lb_test_data; \
    lb  x2, 0(x5); \
    li  x2, 2; \
  )

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lb_test_data; \
    lb  x2, 0(x5); \
    nop; \
    li  x2, 2; \
  )

  #-------------------------------------------------------------
  # lbu
  #-------------------------------------------------------------

  TEST_LD_OP( MAGIC_COUNT, lbu, 0x00000000000000ff, 0,  lbu_test_data );
  TEST_LD_OP( MAGIC_COUNT, lbu, 0x0000000000000000, 1,  lbu_test_data );
  TEST_LD_OP( MAGIC_COUNT, lbu, 0x00000000000000f0, 2,  lbu_test_data );
  TEST_LD_OP( MAGIC_COUNT, lbu, 0x000000000000000f, 3, lbu_test_data );

  # Test with negative offset

  TEST_LD_OP( MAGIC_COUNT, lbu, 0x00000000000000ff, -3, lbu_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lbu, 0x0000000000000000, -2,  lbu_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lbu, 0x00000000000000f0, -1,  lbu_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lbu, 0x000000000000000f, 0,   lbu_test_data4 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0x00000000000000ff, \
    la  x1, lbu_test_data; \
    addi x1, x1, -32; \
    lbu x5, 32(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0x0000000000000000, \
    la  x1, lbu_test_data; \
    addi x1, x1, -6; \
    lbu x5, 7(x1); \
  )

  # Bypassing tests

  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 0, lbu, 0x00000000000000f0, 1, lbu_test_data2 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 1, lbu, 0x000000000000000f, 1, lbu_test_data3 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 2, lbu, 0x0000000000000000, 1, lbu_test_data1 );

  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 0, lbu, 0x00000000000000f0, 1, lbu_test_data2 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 1, lbu, 0x000000000000000f, 1, lbu_test_data3 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 2, lbu, 0x0000000000000000, 1, lbu_test_data1 );

  # Test write-after-write hazard

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lbu_test_data; \
    lbu  x2, 0(x5); \
    li  x2, 2; \
  )

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lbu_test_data; \
    lbu  x2, 0(x5); \
    nop; \
    li  x2, 2; \
  )

  #-------------------------------------------------------------
  # lh
  #-------------------------------------------------------------

  TEST_LD_OP( MAGIC_COUNT, lh, 0x00000000000000ff, 0,  lh_test_data );
  TEST_LD_OP( MAGIC_COUNT, lh, 0xffffffffffffff00, 2,  lh_test_data );
  TEST_LD_OP( MAGIC_COUNT, lh, 0x0000000000000ff0, 4,  lh_test_data );
  TEST_LD_OP( MAGIC_COUNT, lh, 0xfffffffffffff00f, 6, lh_test_data );

  # Test with negative offset

  TEST_LD_OP( MAGIC_COUNT, lh, 0x00000000000000ff, -6,  lh_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lh, 0xffffffffffffff00, -4,  lh_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lh, 0x0000000000000ff0, -2,  lh_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lh, 0xfffffffffffff00f,  0, lh_test_data4 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0x00000000000000ff, \
    la  x1, lh_test_data; \
    addi x1, x1, -32; \
    lh x5, 32(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0xffffffffffffff00, \
    la  x1, lh_test_data; \
    addi x1, x1, -5; \
    lh x5, 7(x1); \
  )

  # Bypassing tests

  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 0, lh, 0x0000000000000ff0, 2, lh_test_data2 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 1, lh, 0xfffffffffffff00f, 2, lh_test_data3 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 2, lh, 0xffffffffffffff00, 2, lh_test_data1 );

  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 0, lh, 0x0000000000000ff0, 2, lh_test_data2 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 1, lh, 0xfffffffffffff00f, 2, lh_test_data3 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 2, lh, 0xffffffffffffff00, 2, lh_test_data1 );

  # Test write-after-write hazard

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lh_test_data; \
    lh  x2, 0(x5); \
    li  x2, 2; \
  )

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lh_test_data; \
    lh  x2, 0(x5); \
    nop; \
    li  x2, 2; \
  )

  #-------------------------------------------------------------
  # lhu
  #-------------------------------------------------------------

  TEST_LD_OP( MAGIC_COUNT, lhu, 0x00000000000000ff, 0,  lhu_test_data );
  TEST_LD_OP( MAGIC_COUNT, lhu, 0x000000000000ff00, 2,  lhu_test_data );
  TEST_LD_OP( MAGIC_COUNT, lhu, 0x0000000000000ff0, 4,  lhu_test_data );
  TEST_LD_OP( MAGIC_COUNT, lhu, 0x000000000000f00f, 6, lhu_test_data );

  # Test with negative offset

  TEST_LD_OP( MAGIC_COUNT, lhu, 0x00000000000000ff, -6,  lhu_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lhu, 0x000000000000ff00, -4,  lhu_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lhu, 0x0000000000000ff0, -2,  lhu_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lhu, 0x000000000000f00f,  0, lhu_test_data4 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0x00000000000000ff, \
    la  x1, lhu_test_data; \
    addi x1, x1, -32; \
    lhu x5, 32(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0x000000000000ff00, \
    la  x1, lhu_test_data; \
    addi x1, x1, -5; \
    lhu x5, 7(x1); \
  )

  # Bypassing tests

  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 0, lhu, 0x0000000000000ff0, 2, lhu_test_data2 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 1, lhu, 0x000000000000f00f, 2, lhu_test_data3 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 2, lhu, 0x000000000000ff00, 2, lhu_test_data1 );

  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 0, lhu, 0x0000000000000ff0, 2, lhu_test_data2 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 1, lhu, 0x000000000000f00f, 2, lhu_test_data3 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 2, lhu, 0x000000000000ff00, 2, lhu_test_data1 );

  # Test write-after-write hazard

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lhu_test_data; \
    lhu  x2, 0(x5); \
    li  x2, 2; \
  )

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lhu_test_data; \
    lhu  x2, 0(x5); \
    nop; \
    li  x2, 2; \
  )

  #-------------------------------------------------------------
  # lui
  #-------------------------------------------------------------

  TEST_CASE( MAGIC_COUNT, x1, 0x0000000000000000, lui x1, 0x00000 );
  TEST_CASE( MAGIC_COUNT, x1, 0xfffffffffffff800, lui x1, 0xfffff;sra x1,x1,1);
  TEST_CASE( MAGIC_COUNT, x1, 0x00000000000007ff, lui x1, 0x7ffff;sra x1,x1,20);
  TEST_CASE( MAGIC_COUNT, x1, 0xfffffffffffff800, lui x1, 0x80000;sra x1,x1,20);

  TEST_CASE( MAGIC_COUNT, x0, 0, lui x0, 0x80000 );

  #-------------------------------------------------------------
  # lw
  #-------------------------------------------------------------

  TEST_LD_OP( MAGIC_COUNT, lw, 0x0000000000ff00ff, 0,  lw_test_data );
  TEST_LD_OP( MAGIC_COUNT, lw, 0xffffffffff00ff00, 4,  lw_test_data );
  TEST_LD_OP( MAGIC_COUNT, lw, 0x000000000ff00ff0, 8,  lw_test_data );
  TEST_LD_OP( MAGIC_COUNT, lw, 0xfffffffff00ff00f, 12, lw_test_data );

  # Test with negative offset

  TEST_LD_OP( MAGIC_COUNT, lw, 0x0000000000ff00ff, -12, lw_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lw, 0xffffffffff00ff00, -8,  lw_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lw, 0x000000000ff00ff0, -4,  lw_test_data4 );
  TEST_LD_OP( MAGIC_COUNT, lw, 0xfffffffff00ff00f, 0,   lw_test_data4 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0x0000000000ff00ff, \
    la  x1, lw_test_data; \
    addi x1, x1, -32; \
    lw x5, 32(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0xffffffffff00ff00, \
    la  x1, lw_test_data; \
    addi x1, x1, -3; \
    lw x5, 7(x1); \
  )

  # Bypassing tests

  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 0, lw, 0x000000000ff00ff0, 4, lw_test_data2 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 1, lw, 0xfffffffff00ff00f, 4, lw_test_data3 );
  TEST_LD_DEST_BYPASS( MAGIC_COUNT, 2, lw, 0xffffffffff00ff00, 4, lw_test_data1 );

  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 0, lw, 0x000000000ff00ff0, 4, lw_test_data2 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 1, lw, 0xfffffffff00ff00f, 4, lw_test_data3 );
  TEST_LD_SRC1_BYPASS( MAGIC_COUNT, 2, lw, 0xffffffffff00ff00, 4, lw_test_data1 );

  # Test write-after-write hazard

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lw_test_data; \
    lw  x2, 0(x5); \
    li  x2, 2; \
  )

  TEST_CASE( MAGIC_COUNT, x2, 2, \
    la  x5, lw_test_data; \
    lw  x2, 0(x5); \
    nop; \
    li  x2, 2; \
  )

  #-------------------------------------------------------------
  # or
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_OP( MAGIC_COUNT, or, 0xfff0fff0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_OP( MAGIC_COUNT, or, 0x0fff0fff, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_OP( MAGIC_COUNT, or, 0xf0fff0ff, 0xf00ff00f, 0xf0f0f0f0 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, or, 0xff00ff00, 0xff00ff00 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_RR_DEST_BYPASS( MAGIC_COUNT,  0, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, or, 0xfff0fff0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, or, 0x0fff0fff, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, or, 0xfff0fff0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, or, 0x0fff0fff, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, or, 0xfff0fff0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, or, 0x0fff0fff, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, or, 0xfff0fff0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, or, 0x0fff0fff, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, or, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, or, 0xfff0fff0, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, or, 0x0fff0fff, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, or, 0xff00ff00, 0xff00ff00 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, or, 0x00ff00ff, 0x00ff00ff );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, or, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, or, 0x11111111, 0x22222222 );

  #-------------------------------------------------------------
  # ori
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT, ori, 0xffffffffffffff0f, 0xffffffffff00ff00, 0xf0f );
  TEST_IMM_OP( MAGIC_COUNT, ori, 0x000000000ff00ff0, 0x000000000ff00ff0, 0x0f0 );
  TEST_IMM_OP( MAGIC_COUNT, ori, 0x0000000000ff07ff, 0x0000000000ff00ff, 0x70f );
  TEST_IMM_OP( MAGIC_COUNT, ori, 0xfffffffff00ff0ff, 0xfffffffff00ff00f, 0x0f0 );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, ori, 0xff00fff0, 0xff00ff00, 0x0f0 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  0, ori, 0x000000000ff00ff0, 0x000000000ff00ff0, 0x0f0 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  1, ori, 0x0000000000ff07ff, 0x0000000000ff00ff, 0x70f );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  2, ori, 0xfffffffff00ff0ff, 0xfffffffff00ff00f, 0x0f0 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, ori, 0x000000000ff00ff0, 0x000000000ff00ff0, 0x0f0 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, ori, 0xffffffffffffffff, 0x0000000000ff00ff, 0xf0f );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, ori, 0xfffffffff00ff0ff, 0xfffffffff00ff00f, 0x0f0 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, ori, 0x0f0, 0x0f0 );
  TEST_IMM_ZERODEST( MAGIC_COUNT, ori, 0x00ff00ff, 0x70f );

  #-------------------------------------------------------------
  # sb
  #-------------------------------------------------------------

  TEST_ST_OP( MAGIC_COUNT, lb, sb, 0xffffffffffffffaa, 0, sb_test_data );
  TEST_ST_OP( MAGIC_COUNT, lb, sb, 0x0000000000000000, 1, sb_test_data );
  TEST_ST_OP( MAGIC_COUNT, lh, sb, 0xffffffffffffefa0, 2, sb_test_data );
  TEST_ST_OP( MAGIC_COUNT, lb, sb, 0x000000000000000a, 3, sb_test_data );

  # Test with negative offset

  TEST_ST_OP( MAGIC_COUNT, lb, sb, 0xffffffffffffffaa, -3, sb_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lb, sb, 0x0000000000000000, -2, sb_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lb, sb, 0xffffffffffffffa0, -1, sb_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lb, sb, 0x000000000000000a, 0,  sb_test_data8 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0x78, \
    la  x1, sb_test_data9; \
    li  x2, 0x12345678; \
    addi x4, x1, -32; \
    sb x2, 32(x4); \
    lb x5, 0(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0xffffffffffffff98, \
    la  x1, sb_test_data9; \
    li  x2, 0x00003098; \
    addi x1, x1, -6; \
    sb x2, 7(x1); \
    la  x4, sb_test_data10; \
    lb x5, 0(x4); \
  )

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 0, lb, sb, 0xffffffffffffffdd, 0, sb_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 1, lb, sb, 0xffffffffffffffcd, 1, sb_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 2, lb, sb, 0xffffffffffffffcc, 2, sb_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 1, 0, lb, sb, 0xffffffffffffffbc, 3, sb_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 1, 1, lb, sb, 0xffffffffffffffbb, 4, sb_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 2, 0, lb, sb, 0xffffffffffffffab, 5, sb_test_data );

  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 0, lb, sb, 0x33, 0, sb_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 1, lb, sb, 0x23, 1, sb_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 2, lb, sb, 0x22, 2, sb_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 1, 0, lb, sb, 0x12, 3, sb_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 1, 1, lb, sb, 0x11, 4, sb_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 2, 0, lb, sb, 0x01, 5, sb_test_data );

  li a0, 0xef
  la a1, sb_test_data
  sb a0, 3(a1)

  #-------------------------------------------------------------
  # sh
  #-------------------------------------------------------------

  TEST_ST_OP( MAGIC_COUNT, lh, sh, 0x00000000000000aa, 0, sh_test_data );
  TEST_ST_OP( MAGIC_COUNT, lh, sh, 0xffffffffffffaa00, 2, sh_test_data );
  TEST_ST_OP( MAGIC_COUNT, lw, sh, 0xffffffffbeef0aa0, 4, sh_test_data );
  TEST_ST_OP( MAGIC_COUNT, lh, sh, 0xffffffffffffa00a, 6, sh_test_data );

  # Test with negative offset

  TEST_ST_OP( MAGIC_COUNT, lh, sh, 0x00000000000000aa, -6, sh_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lh, sh, 0xffffffffffffaa00, -4, sh_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lh, sh, 0x0000000000000aa0, -2, sh_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lh, sh, 0xffffffffffffa00a, 0,  sh_test_data8 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0x5678, \
    la  x1, sh_test_data9; \
    li  x2, 0x12345678; \
    addi x4, x1, -32; \
    sh x2, 32(x4); \
    lh x5, 0(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0x3098, \
    la  x1, sh_test_data9; \
    li  x2, 0x00003098; \
    addi x1, x1, -5; \
    sh x2, 7(x1); \
    la  x4, sh_test_data10; \
    lh x5, 0(x4); \
  )

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 0, lh, sh, 0xffffffffffffccdd, 0,  sh_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 1, lh, sh, 0xffffffffffffbccd, 2,  sh_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 2, lh, sh, 0xffffffffffffbbcc, 4,  sh_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 1, 0, lh, sh, 0xffffffffffffabbc, 6, sh_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 1, 1, lh, sh, 0xffffffffffffaabb, 8, sh_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 2, 0, lh, sh, 0xffffffffffffdaab, 10, sh_test_data );

  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 0, lh, sh, 0x2233, 0,  sh_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 1, lh, sh, 0x1223, 2,  sh_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 2, lh, sh, 0x1122, 4,  sh_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 1, 0, lh, sh, 0x0112, 6, sh_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 1, 1, lh, sh, 0x0011, 8, sh_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 2, 0, lh, sh, 0x3001, 10, sh_test_data );

  li a0, 0xbeef
  la a1, sh_test_data
  sh a0, 6(a1)

  #-------------------------------------------------------------
  # sw
  #-------------------------------------------------------------

  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0x0000000000aa00aa, 0,  sw_test_data );
  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0xffffffffaa00aa00, 4,  sw_test_data );
  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0x000000000aa00aa0, 8,  sw_test_data );
  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0xffffffffa00aa00a, 12, sw_test_data );

  # Test with negative offset

  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0x0000000000aa00aa, -12, sw_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0xffffffffaa00aa00, -8,  sw_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0x000000000aa00aa0, -4,  sw_test_data8 );
  TEST_ST_OP( MAGIC_COUNT, lw, sw, 0xffffffffa00aa00a, 0,   sw_test_data8 );

  # Test with a negative base

  TEST_CASE( MAGIC_COUNT, x5, 0x12345678, \
    la  x1, sw_test_data9; \
    li  x2, 0x12345678; \
    addi x4, x1, -32; \
    sw x2, 32(x4); \
    lw x5, 0(x1); \
  )

  # Test with unaligned base

  TEST_CASE( MAGIC_COUNT, x5, 0x58213098, \
    la  x1, sw_test_data9; \
    li  x2, 0x58213098; \
    addi x1, x1, -3; \
    sw x2, 7(x1); \
    la  x4, sw_test_data10; \
    lw x5, 0(x4); \
  )

  # Bypassing tests

  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 0, lw, sw, 0xffffffffaabbccdd, 0,  sw_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 1, lw, sw, 0xffffffffdaabbccd, 4,  sw_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 0, 2, lw, sw, 0xffffffffddaabbcc, 8,  sw_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 1, 0, lw, sw, 0xffffffffcddaabbc, 12, sw_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 1, 1, lw, sw, 0xffffffffccddaabb, 16, sw_test_data );
  TEST_ST_SRC12_BYPASS( MAGIC_COUNT, 2, 0, lw, sw, 0xffffffffbccddaab, 20, sw_test_data );

  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 0, lw, sw, 0x00112233, 0,  sw_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 1, lw, sw, 0x30011223, 4,  sw_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 0, 2, lw, sw, 0x33001122, 8,  sw_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 1, 0, lw, sw, 0x23300112, 12, sw_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 1, 1, lw, sw, 0x22330011, 16, sw_test_data );
  TEST_ST_SRC21_BYPASS( MAGIC_COUNT, 2, 0, lw, sw, 0x12233001, 20, sw_test_data );

  #-------------------------------------------------------------
  # sll
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  sll, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_RR_OP( MAGIC_COUNT,  sll, 0x0000000000000002, 0x0000000000000001, 1  );
  TEST_RR_OP( MAGIC_COUNT,  sll, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_OP( MAGIC_COUNT,  sll, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_OP( MAGIC_COUNT,  sll, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_OP( MAGIC_COUNT,  sll, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_RR_OP( MAGIC_COUNT,  sll, 0xfffffffffffffffe, 0xffffffffffffffff, 1  );
  TEST_RR_OP( MAGIC_COUNT,  sll, 0xffffffffffffff80, 0xffffffffffffffff, 7  );
  TEST_RR_OP( MAGIC_COUNT, sll, 0xffffffffffffc000, 0xffffffffffffffff, 14 );
  TEST_RR_OP( MAGIC_COUNT, sll, 0xffffffff80000000, 0xffffffffffffffff, 31 );

  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000000042424242, 0x0000000021212121, 1  );
  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000001090909080, 0x0000000021212121, 7  );
  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000084848484000, 0x0000000021212121, 14 );
  TEST_RR_OP( MAGIC_COUNT, sll, 0x1090909080000000, 0x0000000021212121, 31 );

  # Verify that shifts only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000000021212121, 0x0000000021212121, 0xffffffffffffffc0 );
  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000000042424242, 0x0000000021212121, 0xffffffffffffffc1 );
  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000001090909080, 0x0000000021212121, 0xffffffffffffffc7 );
  TEST_RR_OP( MAGIC_COUNT, sll, 0x0000084848484000, 0x0000000021212121, 0xffffffffffffffce );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, sll, 0x00000080, 0x00000001, 7  );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, sll, 0x00004000, 0x00000001, 14 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, sll, 24, 3 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, sll, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, sll, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, sll, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, sll, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, sll, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, sll, 0x0000000080000000, 0x0000000000000001, 31 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, sll, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, sll, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, sll, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, sll, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, sll, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, sll, 0x0000000080000000, 0x0000000000000001, 31 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, sll, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, sll, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, sll, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, sll, 0, 15 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, sll, 32, 32 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, sll, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, sll, 1024, 2048 );

  #-------------------------------------------------------------
  # slli
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT,  slli, 0x0000000000000001, 0x0000000000000001, 0  );
  TEST_IMM_OP( MAGIC_COUNT,  slli, 0x0000000000000002, 0x0000000000000001, 1  );
  TEST_IMM_OP( MAGIC_COUNT,  slli, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_IMM_OP( MAGIC_COUNT,  slli, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_IMM_OP( MAGIC_COUNT,  slli, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_IMM_OP( MAGIC_COUNT,  slli, 0xffffffffffffffff, 0xffffffffffffffff, 0  );
  TEST_IMM_OP( MAGIC_COUNT,  slli, 0xfffffffffffffffe, 0xffffffffffffffff, 1  );
  TEST_IMM_OP( MAGIC_COUNT,  slli, 0xffffffffffffff80, 0xffffffffffffffff, 7  );
  TEST_IMM_OP( MAGIC_COUNT, slli, 0xffffffffffffc000, 0xffffffffffffffff, 14 );
  TEST_IMM_OP( MAGIC_COUNT, slli, 0xffffffff80000000, 0xffffffffffffffff, 31 );

  TEST_IMM_OP( MAGIC_COUNT, slli, 0x0000000021212121, 0x0000000021212121, 0  );
  TEST_IMM_OP( MAGIC_COUNT, slli, 0x0000000042424242, 0x0000000021212121, 1  );
  TEST_IMM_OP( MAGIC_COUNT, slli, 0x0000001090909080, 0x0000000021212121, 7  );
  TEST_IMM_OP( MAGIC_COUNT, slli, 0x0000084848484000, 0x0000000021212121, 14 );
  TEST_IMM_OP( MAGIC_COUNT, slli, 0x1090909080000000, 0x0000000021212121, 31 );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, slli, 0x00000080, 0x00000001, 7 );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 0, slli, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 1, slli, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 2, slli, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, slli, 0x0000000000000080, 0x0000000000000001, 7  );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, slli, 0x0000000000004000, 0x0000000000000001, 14 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, slli, 0x0000000080000000, 0x0000000000000001, 31 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, slli, 0, 31 );
  TEST_IMM_ZERODEST( MAGIC_COUNT, slli, 33, 20 );

  #-------------------------------------------------------------
  # slt
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  slt, 0, 0x0000000000000000, 0x0000000000000000 );
  TEST_RR_OP( MAGIC_COUNT,  slt, 0, 0x0000000000000001, 0x0000000000000001 );
  TEST_RR_OP( MAGIC_COUNT,  slt, 1, 0x0000000000000003, 0x0000000000000007 );
  TEST_RR_OP( MAGIC_COUNT,  slt, 0, 0x0000000000000007, 0x0000000000000003 );

  TEST_RR_OP( MAGIC_COUNT,  slt, 0, 0x0000000000000000, 0xffffffffffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  slt, 1, 0xffffffff80000000, 0x0000000000000000 );
  TEST_RR_OP( MAGIC_COUNT,  slt, 1, 0xffffffff80000000, 0xffffffffffff8000 );

  TEST_RR_OP( MAGIC_COUNT,  slt, 1, 0x0000000000000000, 0x0000000000007fff );
  TEST_RR_OP( MAGIC_COUNT, slt, 0, 0x000000007fffffff, 0x0000000000000000 );
  TEST_RR_OP( MAGIC_COUNT, slt, 0, 0x000000007fffffff, 0x0000000000007fff );

  TEST_RR_OP( MAGIC_COUNT, slt, 1, 0xffffffff80000000, 0x0000000000007fff );
  TEST_RR_OP( MAGIC_COUNT, slt, 0, 0x000000007fffffff, 0xffffffffffff8000 );

  TEST_RR_OP( MAGIC_COUNT, slt, 0, 0x0000000000000000, 0xffffffffffffffff );
  TEST_RR_OP( MAGIC_COUNT, slt, 1, 0xffffffffffffffff, 0x0000000000000001 );
  TEST_RR_OP( MAGIC_COUNT, slt, 0, 0xffffffffffffffff, 0xffffffffffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, slt, 0, 14, 13 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, slt, 1, 11, 13 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, slt, 0, 13 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, slt, 1, 11, 13 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, slt, 0, 14, 13 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, slt, 1, 12, 13 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, slt, 0, 14, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, slt, 1, 11, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, slt, 0, 15, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, slt, 1, 10, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, slt, 0, 16, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, slt, 1,  9, 13 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, slt, 0, 17, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, slt, 1,  8, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, slt, 0, 18, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, slt, 1,  7, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, slt, 0, 19, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, slt, 1,  6, 13 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, slt, 0, -1 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, slt, 1, -1 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, slt, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, slt, 16, 30 );

  #-------------------------------------------------------------
  # slti
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT,  slti, 0, 0x0000000000000000, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT,  slti, 0, 0x0000000000000001, 0x001 );
  TEST_IMM_OP( MAGIC_COUNT,  slti, 1, 0x0000000000000003, 0x007 );
  TEST_IMM_OP( MAGIC_COUNT,  slti, 0, 0x0000000000000007, 0x003 );

  TEST_IMM_OP( MAGIC_COUNT,  slti, 0, 0x0000000000000000, 0x800 );
  TEST_IMM_OP( MAGIC_COUNT,  slti, 1, 0xffffffff80000000, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT,  slti, 1, 0xffffffff80000000, 0x800 );

  TEST_IMM_OP( MAGIC_COUNT,  slti, 1, 0x0000000000000000, 0x7ff );
  TEST_IMM_OP( MAGIC_COUNT, slti, 0, 0x000000007fffffff, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT, slti, 0, 0x000000007fffffff, 0x7ff );

  TEST_IMM_OP( MAGIC_COUNT, slti, 1, 0xffffffff80000000, 0x7ff );
  TEST_IMM_OP( MAGIC_COUNT, slti, 0, 0x000000007fffffff, 0x800 );

  TEST_IMM_OP( MAGIC_COUNT, slti, 0, 0x0000000000000000, 0xfff );
  TEST_IMM_OP( MAGIC_COUNT, slti, 1, 0xffffffffffffffff, 0x001 );
  TEST_IMM_OP( MAGIC_COUNT, slti, 0, 0xffffffffffffffff, 0xfff );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, slti, 1, 11, 13 );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 0, slti, 0, 15, 10 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 1, slti, 1, 10, 16 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 2, slti, 0, 16,  9 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, slti, 1, 11, 15 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, slti, 0, 17,  8 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, slti, 1, 12, 14 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, slti, 0, 0xfff );
  TEST_IMM_ZERODEST( MAGIC_COUNT, slti, 0x00ff00ff, 0xfff );

  #-------------------------------------------------------------
  # sltiu
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 0, 0x0000000000000000, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 0, 0x0000000000000001, 0x001 );
  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 1, 0x0000000000000003, 0x007 );
  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 0, 0x0000000000000007, 0x003 );

  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 1, 0x0000000000000000, 0x800 );
  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 0, 0xffffffff80000000, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 1, 0xffffffff80000000, 0x800 );

  TEST_IMM_OP( MAGIC_COUNT,  sltiu, 1, 0x0000000000000000, 0x7ff );
  TEST_IMM_OP( MAGIC_COUNT, sltiu, 0, 0x000000007fffffff, 0x000 );
  TEST_IMM_OP( MAGIC_COUNT, sltiu, 0, 0x000000007fffffff, 0x7ff );

  TEST_IMM_OP( MAGIC_COUNT, sltiu, 0, 0xffffffff80000000, 0x7ff );
  TEST_IMM_OP( MAGIC_COUNT, sltiu, 1, 0x000000007fffffff, 0x800 );

  TEST_IMM_OP( MAGIC_COUNT, sltiu, 1, 0x0000000000000000, 0xfff );
  TEST_IMM_OP( MAGIC_COUNT, sltiu, 0, 0xffffffffffffffff, 0x001 );
  TEST_IMM_OP( MAGIC_COUNT, sltiu, 0, 0xffffffffffffffff, 0xfff );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, sltiu, 1, 11, 13 );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 0, sltiu, 0, 15, 10 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 1, sltiu, 1, 10, 16 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 2, sltiu, 0, 16,  9 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, sltiu, 1, 11, 15 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, sltiu, 0, 17,  8 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, sltiu, 1, 12, 14 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, sltiu, 1, 0xfff );
  TEST_IMM_ZERODEST( MAGIC_COUNT, sltiu, 0x00ff00ff, 0xfff );

  #-------------------------------------------------------------
  # sltu
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  sltu, 0, 0x00000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  sltu, 0, 0x00000001, 0x00000001 );
  TEST_RR_OP( MAGIC_COUNT,  sltu, 1, 0x00000003, 0x00000007 );
  TEST_RR_OP( MAGIC_COUNT,  sltu, 0, 0x00000007, 0x00000003 );

  TEST_RR_OP( MAGIC_COUNT,  sltu, 1, 0x00000000, 0xffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  sltu, 0, 0x80000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  sltu, 1, 0x80000000, 0xffff8000 );

  TEST_RR_OP( MAGIC_COUNT,  sltu, 1, 0x00000000, 0x00007fff );
  TEST_RR_OP( MAGIC_COUNT, sltu, 0, 0x7fffffff, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT, sltu, 0, 0x7fffffff, 0x00007fff );

  TEST_RR_OP( MAGIC_COUNT, sltu, 0, 0x80000000, 0x00007fff );
  TEST_RR_OP( MAGIC_COUNT, sltu, 1, 0x7fffffff, 0xffff8000 );

  TEST_RR_OP( MAGIC_COUNT, sltu, 1, 0x00000000, 0xffffffff );
  TEST_RR_OP( MAGIC_COUNT, sltu, 0, 0xffffffff, 0x00000001 );
  TEST_RR_OP( MAGIC_COUNT, sltu, 0, 0xffffffff, 0xffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, sltu, 0, 14, 13 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, sltu, 1, 11, 13 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, sltu, 0, 13 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, sltu, 1, 11, 13 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, sltu, 0, 14, 13 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, sltu, 1, 12, 13 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, sltu, 0, 14, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, sltu, 1, 11, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, sltu, 0, 15, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, sltu, 1, 10, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, sltu, 0, 16, 13 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, sltu, 1,  9, 13 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, sltu, 0, 17, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, sltu, 1,  8, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, sltu, 0, 18, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, sltu, 1,  7, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, sltu, 0, 19, 13 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, sltu, 1,  6, 13 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, sltu, 1, -1 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, sltu, 0, -1 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, sltu, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, sltu, 16, 30 );

  #-------------------------------------------------------------
  # sra
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  sra, 0xffffffff80000000, 0xffffffff80000000, 0  );
  TEST_RR_OP( MAGIC_COUNT,  sra, 0xffffffffc0000000, 0xffffffff80000000, 1  );
  TEST_RR_OP( MAGIC_COUNT,  sra, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_RR_OP( MAGIC_COUNT,  sra, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_RR_OP( MAGIC_COUNT,  sra, 0xffffffffffffffff, 0xffffffff80000001, 31 );

  TEST_RR_OP( MAGIC_COUNT,  sra, 0x000000007fffffff, 0x000000007fffffff, 0  );
  TEST_RR_OP( MAGIC_COUNT,  sra, 0x000000003fffffff, 0x000000007fffffff, 1  );
  TEST_RR_OP( MAGIC_COUNT,  sra, 0x0000000000ffffff, 0x000000007fffffff, 7  );
  TEST_RR_OP( MAGIC_COUNT, sra, 0x000000000001ffff, 0x000000007fffffff, 14 );
  TEST_RR_OP( MAGIC_COUNT, sra, 0x0000000000000000, 0x000000007fffffff, 31 );

  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffff81818181, 0xffffffff81818181, 0  );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffffc0c0c0c0, 0xffffffff81818181, 1  );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffffff030303, 0xffffffff81818181, 7  );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xfffffffffffe0606, 0xffffffff81818181, 14 );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffffffffffff, 0xffffffff81818181, 31 );

  # Verify that shifts only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffff81818181, 0xffffffff81818181, 0xffffffffffffffc0 );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffffc0c0c0c0, 0xffffffff81818181, 0xffffffffffffffc1 );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffffff030303, 0xffffffff81818181, 0xffffffffffffffc7 );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xfffffffffffe0606, 0xffffffff81818181, 0xffffffffffffffce );
  TEST_RR_OP( MAGIC_COUNT, sra, 0xffffffffffffffff, 0xffffffff81818181, 0xffffffffffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, sra, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, sra, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, sra, 0, 7 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, sra, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, sra, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, sra, 0xffffffffffffffff, 0xffffffff80000000, 31 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, sra, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, sra, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, sra, 0xffffffffffffffff, 0xffffffff80000000, 31 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, sra, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, sra, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, sra, 0xffffffffffffffff, 0xffffffff80000000, 31 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, sra, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, sra, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, sra, 0xffffffffffffffff, 0xffffffff80000000, 31 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, sra, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, sra, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, sra, 0xffffffffffffffff, 0xffffffff80000000, 31 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, sra, 0, 15 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, sra, 32, 32 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, sra, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, sra, 1024, 2048 );

  #-------------------------------------------------------------
  # srai
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT,  srai, 0xffffff8000000000, 0xffffff8000000000, 0  );
  TEST_IMM_OP( MAGIC_COUNT,  srai, 0xffffffffc0000000, 0xffffffff80000000, 1  );
  TEST_IMM_OP( MAGIC_COUNT,  srai, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_IMM_OP( MAGIC_COUNT,  srai, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_IMM_OP( MAGIC_COUNT,  srai, 0xffffffffffffffff, 0xffffffff80000001, 31 );

  TEST_IMM_OP( MAGIC_COUNT,  srai, 0x000000007fffffff, 0x000000007fffffff, 0  );
  TEST_IMM_OP( MAGIC_COUNT,  srai, 0x000000003fffffff, 0x000000007fffffff, 1  );
  TEST_IMM_OP( MAGIC_COUNT,  srai, 0x0000000000ffffff, 0x000000007fffffff, 7  );
  TEST_IMM_OP( MAGIC_COUNT, srai, 0x000000000001ffff, 0x000000007fffffff, 14 );
  TEST_IMM_OP( MAGIC_COUNT, srai, 0x0000000000000000, 0x000000007fffffff, 31 );

  TEST_IMM_OP( MAGIC_COUNT, srai, 0xffffffff81818181, 0xffffffff81818181, 0  );
  TEST_IMM_OP( MAGIC_COUNT, srai, 0xffffffffc0c0c0c0, 0xffffffff81818181, 1  );
  TEST_IMM_OP( MAGIC_COUNT, srai, 0xffffffffff030303, 0xffffffff81818181, 7  );
  TEST_IMM_OP( MAGIC_COUNT, srai, 0xfffffffffffe0606, 0xffffffff81818181, 14 );
  TEST_IMM_OP( MAGIC_COUNT, srai, 0xffffffffffffffff, 0xffffffff81818181, 31 );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, srai, 0xffffffffff000000, 0xffffffff80000000, 7 );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 0, srai, 0xffffffffff000000, 0xffffffff80000000, 7  );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 1, srai, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 2, srai, 0xffffffffffffffff, 0xffffffff80000001, 31 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, srai, 0xffffffffff000000, 0xffffffff80000000, 7 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, srai, 0xfffffffffffe0000, 0xffffffff80000000, 14 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, srai, 0xffffffffffffffff, 0xffffffff80000001, 31 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, srai, 0, 4 );
  TEST_IMM_ZERODEST( MAGIC_COUNT, srai, 33, 10 );

  #-------------------------------------------------------------
  # srl
  #-------------------------------------------------------------

#define TEST_SRL(n, v, a) \
  TEST_RR_OP(n, srl, ((v) & ((1 << (__riscv_xlen-1) << 1) - 1)) >> (a), v, a)

  TEST_SRL( MAGIC_COUNT,  0xffffffff80000000, 0  );
  TEST_SRL( MAGIC_COUNT,  0xffffffff80000000, 1  );
  TEST_SRL( MAGIC_COUNT,  0xffffffff80000000, 7  );
  TEST_SRL( MAGIC_COUNT,  0xffffffff80000000, 14 );
  TEST_SRL( MAGIC_COUNT,  0xffffffff80000001, 31 );

  TEST_SRL( MAGIC_COUNT,  0xffffffffffffffff, 0  );
  TEST_SRL( MAGIC_COUNT,  0xffffffffffffffff, 1  );
  TEST_SRL( MAGIC_COUNT,  0xffffffffffffffff, 7  );
  TEST_SRL( MAGIC_COUNT, 0xffffffffffffffff, 14 );
  TEST_SRL( MAGIC_COUNT, 0xffffffffffffffff, 31 );

  TEST_SRL( MAGIC_COUNT, 0x0000000021212121, 0  );
  TEST_SRL( MAGIC_COUNT, 0x0000000021212121, 1  );
  TEST_SRL( MAGIC_COUNT, 0x0000000021212121, 7  );
  TEST_SRL( MAGIC_COUNT, 0x0000000021212121, 14 );
  TEST_SRL( MAGIC_COUNT, 0x0000000021212121, 31 );

  # Verify that shifts only use bottom six(rv64) or five(rv32) bits

  TEST_RR_OP( MAGIC_COUNT, srl, 0x0000000021212121, 0x0000000021212121, 0xffffffffffffffc0 );
  TEST_RR_OP( MAGIC_COUNT, srl, 0x0000000010909090, 0x0000000021212121, 0xffffffffffffffc1 );
  TEST_RR_OP( MAGIC_COUNT, srl, 0x0000000000424242, 0x0000000021212121, 0xffffffffffffffc7 );
  TEST_RR_OP( MAGIC_COUNT, srl, 0x0000000000008484, 0x0000000021212121, 0xffffffffffffffce );
  TEST_RR_OP( MAGIC_COUNT, srl, 0x0000000000000000, 0x0000000021212121, 0xffffffffffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, srl, 0x01000000, 0x80000000, 7  );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, srl, 0x00020000, 0x80000000, 14 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, srl, 0, 7 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, srl, 0x01000000, 0x80000000, 7  );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, srl, 0x00020000, 0x80000000, 14 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, srl, 0x00000001, 0x80000000, 31 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, srl, 0x01000000, 0x80000000, 7  );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, srl, 0x00020000, 0x80000000, 14 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, srl, 0x00000001, 0x80000000, 31 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, srl, 0x01000000, 0x80000000, 7  );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, srl, 0x00020000, 0x80000000, 14 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, srl, 0x00000001, 0x80000000, 31 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, srl, 0x01000000, 0x80000000, 7  );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, srl, 0x00020000, 0x80000000, 14 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, srl, 0x00000001, 0x80000000, 31 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, srl, 0x01000000, 0x80000000, 7  );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, srl, 0x00020000, 0x80000000, 14 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, srl, 0x00000001, 0x80000000, 31 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, srl, 0, 15 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, srl, 32, 32 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, srl, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, srl, 1024, 2048 );

  #-------------------------------------------------------------
  # srli
  #-------------------------------------------------------------

#define TEST_SRLI(n, v, a) \
  TEST_IMM_OP(n, srli, ((v) & ((1 << (__riscv_xlen-1) << 1) - 1)) >> (a), v, a)

  TEST_SRLI( MAGIC_COUNT,  0xffffffff80000000, 0  );
  TEST_SRLI( MAGIC_COUNT,  0xffffffff80000000, 1  );
  TEST_SRLI( MAGIC_COUNT,  0xffffffff80000000, 7  );
  TEST_SRLI( MAGIC_COUNT,  0xffffffff80000000, 14 );
  TEST_SRLI( MAGIC_COUNT,  0xffffffff80000001, 31 );

  TEST_SRLI( MAGIC_COUNT,  0xffffffffffffffff, 0  );
  TEST_SRLI( MAGIC_COUNT,  0xffffffffffffffff, 1  );
  TEST_SRLI( MAGIC_COUNT,  0xffffffffffffffff, 7  );
  TEST_SRLI( MAGIC_COUNT, 0xffffffffffffffff, 14 );
  TEST_SRLI( MAGIC_COUNT, 0xffffffffffffffff, 31 );

  TEST_SRLI( MAGIC_COUNT, 0x0000000021212121, 0  );
  TEST_SRLI( MAGIC_COUNT, 0x0000000021212121, 1  );
  TEST_SRLI( MAGIC_COUNT, 0x0000000021212121, 7  );
  TEST_SRLI( MAGIC_COUNT, 0x0000000021212121, 14 );
  TEST_SRLI( MAGIC_COUNT, 0x0000000021212121, 31 );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, srli, 0x01000000, 0x80000000, 7 );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 0, srli, 0x01000000, 0x80000000, 7  );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 1, srli, 0x00020000, 0x80000000, 14 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT, 2, srli, 0x00000001, 0x80000001, 31 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, srli, 0x01000000, 0x80000000, 7  );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, srli, 0x00020000, 0x80000000, 14 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, srli, 0x00000001, 0x80000001, 31 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, srli, 0, 4 );
  TEST_IMM_ZERODEST( MAGIC_COUNT, srli, 33, 10 );

  #-------------------------------------------------------------
  # sub
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  sub, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );
  TEST_RR_OP( MAGIC_COUNT,  sub, 0x0000000000000000, 0x0000000000000001, 0x0000000000000001 );
  TEST_RR_OP( MAGIC_COUNT,  sub, 0xfffffffffffffffc, 0x0000000000000003, 0x0000000000000007 );

  TEST_RR_OP( MAGIC_COUNT,  sub, 0x0000000000008000, 0x0000000000000000, 0xffffffffffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  sub, 0xffffffff80000000, 0xffffffff80000000, 0x0000000000000000 );
  TEST_RR_OP( MAGIC_COUNT,  sub, 0xffffffff80008000, 0xffffffff80000000, 0xffffffffffff8000 );

  TEST_RR_OP( MAGIC_COUNT,  sub, 0xffffffffffff8001, 0x0000000000000000, 0x0000000000007fff );
  TEST_RR_OP( MAGIC_COUNT,  sub, 0x000000007fffffff, 0x000000007fffffff, 0x0000000000000000 );
  TEST_RR_OP( MAGIC_COUNT, sub, 0x000000007fff8000, 0x000000007fffffff, 0x0000000000007fff );

  TEST_RR_OP( MAGIC_COUNT, sub, 0xffffffff7fff8001, 0xffffffff80000000, 0x0000000000007fff );
  TEST_RR_OP( MAGIC_COUNT, sub, 0x0000000080007fff, 0x000000007fffffff, 0xffffffffffff8000 );

  TEST_RR_OP( MAGIC_COUNT, sub, 0x0000000000000001, 0x0000000000000000, 0xffffffffffffffff );
  TEST_RR_OP( MAGIC_COUNT, sub, 0xfffffffffffffffe, 0xffffffffffffffff, 0x0000000000000001 );
  TEST_RR_OP( MAGIC_COUNT, sub, 0x0000000000000000, 0xffffffffffffffff, 0xffffffffffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, sub, 2, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, sub, 3, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, sub, 0, 13 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, sub, 2, 13, 11 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, sub, 3, 14, 11 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, sub, 4, 15, 11 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, sub, 2, 13, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, sub, 3, 14, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, sub, 4, 15, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, sub, 2, 13, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, sub, 3, 14, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, sub, 4, 15, 11 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, sub, 2, 13, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, sub, 3, 14, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, sub, 4, 15, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, sub, 2, 13, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, sub, 3, 14, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, sub, 4, 15, 11 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, sub, 15, -15 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, sub, 32, 32 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, sub, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, sub, 16, 30 );

  #-------------------------------------------------------------
  # xor
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_OP( MAGIC_COUNT, xor, 0xff00ff00, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_OP( MAGIC_COUNT, xor, 0x0ff00ff0, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_OP( MAGIC_COUNT, xor, 0x00ff00ff, 0xf00ff00f, 0xf0f0f0f0 );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, xor, 0x00000000, 0xff00ff00 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT,  0, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, xor, 0xff00ff00, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, xor, 0x0ff00ff0, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, xor, 0xff00ff00, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, xor, 0x0ff00ff0, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, xor, 0xff00ff00, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, xor, 0x0ff00ff0, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, xor, 0xff00ff00, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, xor, 0x0ff00ff0, 0x00ff00ff, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, xor, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, xor, 0xff00ff00, 0x0ff00ff0, 0xf0f0f0f0 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, xor, 0x0ff00ff0, 0x00ff00ff, 0x0f0f0f0f );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, xor, 0xff00ff00, 0xff00ff00 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, xor, 0x00ff00ff, 0x00ff00ff );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, xor, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, xor, 0x11111111, 0x22222222 );

  #-------------------------------------------------------------
  # xori
  #-------------------------------------------------------------

  TEST_IMM_OP( MAGIC_COUNT, xori, 0xffffffffff00f00f, 0x0000000000ff0f00, 0xf0f );
  TEST_IMM_OP( MAGIC_COUNT, xori, 0x000000000ff00f00, 0x000000000ff00ff0, 0x0f0 );
  TEST_IMM_OP( MAGIC_COUNT, xori, 0x0000000000ff0ff0, 0x0000000000ff08ff, 0x70f );
  TEST_IMM_OP( MAGIC_COUNT, xori, 0xfffffffff00ff0ff, 0xfffffffff00ff00f, 0x0f0 );

  # Source/Destination tests

  TEST_IMM_SRC1_EQ_DEST( MAGIC_COUNT, xori, 0xffffffffff00f00f, 0xffffffffff00f700, 0x70f );

  # Bypassing tests

  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  0, xori, 0x000000000ff00f00, 0x000000000ff00ff0, 0x0f0 );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  1, xori, 0x0000000000ff0ff0, 0x0000000000ff08ff, 0x70f );
  TEST_IMM_DEST_BYPASS( MAGIC_COUNT,  2, xori, 0xfffffffff00ff0ff, 0xfffffffff00ff00f, 0x0f0 );

  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 0, xori, 0x000000000ff00f00, 0x000000000ff00ff0, 0x0f0 );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 1, xori, 0x0000000000ff0ff0, 0x0000000000ff0fff, 0x00f );
  TEST_IMM_SRC1_BYPASS( MAGIC_COUNT, 2, xori, 0xfffffffff00ff0ff, 0xfffffffff00ff00f, 0x0f0 );

  TEST_IMM_ZEROSRC1( MAGIC_COUNT, xori, 0x0f0, 0x0f0 );
  TEST_IMM_ZERODEST( MAGIC_COUNT, xori, 0x00ff00ff, 0x70f );

  #-------------------------------------------------------------
  # mul
  #-------------------------------------------------------------

  TEST_RR_OP(MAGIC_COUNT,  mul, 0x00001200, 0x00007e00, 0xb6db6db7 );
  TEST_RR_OP(MAGIC_COUNT,  mul, 0x00001240, 0x00007fc0, 0xb6db6db7 );

  TEST_RR_OP( MAGIC_COUNT,  mul, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mul, 0x00000001, 0x00000001, 0x00000001 );
  TEST_RR_OP( MAGIC_COUNT,  mul, 0x00000015, 0x00000003, 0x00000007 );

  TEST_RR_OP( MAGIC_COUNT,  mul, 0x00000000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  mul, 0x00000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mul, 0x00000000, 0x80000000, 0xffff8000 );

  TEST_RR_OP(MAGIC_COUNT,  mul, 0x0000ff7f, 0xaaaaaaab, 0x0002fe7d );
  TEST_RR_OP(MAGIC_COUNT,  mul, 0x0000ff7f, 0x0002fe7d, 0xaaaaaaab );

  TEST_RR_OP(MAGIC_COUNT,  mul, 0x00000000, 0xff000000, 0xff000000 );

  TEST_RR_OP(MAGIC_COUNT,  mul, 0x00000001, 0xffffffff, 0xffffffff );
  TEST_RR_OP(MAGIC_COUNT,  mul, 0xffffffff, 0xffffffff, 0x00000001 );
  TEST_RR_OP(MAGIC_COUNT,  mul, 0xffffffff, 0x00000001, 0xffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, mul, 143, 13, 11 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, mul, 154, 14, 11 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, mul, 169, 13 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, mul, 143, 13, 11 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, mul, 154, 14, 11 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, mul, 165, 15, 11 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, mul, 143, 13, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, mul, 154, 14, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, mul, 165, 15, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, mul, 143, 13, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, mul, 154, 14, 11 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, mul, 165, 15, 11 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, mul, 143, 13, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, mul, 154, 14, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, mul, 165, 15, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, mul, 143, 13, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, mul, 154, 14, 11 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, mul, 165, 15, 11 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, mul, 0, 31 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, mul, 0, 32 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, mul, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, mul, 33, 34 );

  #-------------------------------------------------------------
  # mulh
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  mulh, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mulh, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( MAGIC_COUNT,  mulh, 0x00000000, 0x00000003, 0x00000007 );

  TEST_RR_OP( MAGIC_COUNT,  mulh, 0x00000000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  mulh, 0x00000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mulh, 0x00000000, 0x80000000, 0x00000000 );

  TEST_RR_OP(MAGIC_COUNT,  mulh, 0xffff0081, 0xaaaaaaab, 0x0002fe7d );
  TEST_RR_OP(MAGIC_COUNT,  mulh, 0xffff0081, 0x0002fe7d, 0xaaaaaaab );

  TEST_RR_OP(MAGIC_COUNT,  mulh, 0x00010000, 0xff000000, 0xff000000 );

  TEST_RR_OP(MAGIC_COUNT,  mulh, 0x00000000, 0xffffffff, 0xffffffff );
  TEST_RR_OP(MAGIC_COUNT,  mulh, 0xffffffff, 0xffffffff, 0x00000001 );
  TEST_RR_OP(MAGIC_COUNT,  mulh, 0xffffffff, 0x00000001, 0xffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, mulh, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, mulh, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, mulh, 43264, 13<<20 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, mulh, 36608, 13<<20, 11<<20 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, mulh, 39424, 14<<20, 11<<20 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, mulh, 42240, 15<<20, 11<<20 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, mulh, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, mulh, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, mulh, 42240, 15<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, mulh, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, mulh, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, mulh, 42240, 15<<20, 11<<20 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, mulh, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, mulh, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, mulh, 42240, 15<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, mulh, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, mulh, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, mulh, 42240, 15<<20, 11<<20 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, mulh, 0, 31<<26 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, mulh, 0, 32<<26 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, mulh, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, mulh, 33<<20, 34<<20 );

  #-------------------------------------------------------------
  # mulhsu
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  mulhsu, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mulhsu, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( MAGIC_COUNT,  mulhsu, 0x00000000, 0x00000003, 0x00000007 );

  TEST_RR_OP( MAGIC_COUNT,  mulhsu, 0x00000000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  mulhsu, 0x00000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mulhsu, 0x80004000, 0x80000000, 0xffff8000 );

  TEST_RR_OP(MAGIC_COUNT,  mulhsu, 0xffff0081, 0xaaaaaaab, 0x0002fe7d );
  TEST_RR_OP(MAGIC_COUNT,  mulhsu, 0x0001fefe, 0x0002fe7d, 0xaaaaaaab );

  TEST_RR_OP(MAGIC_COUNT,  mulhsu, 0xff010000, 0xff000000, 0xff000000 );

  TEST_RR_OP(MAGIC_COUNT,  mulhsu, 0xffffffff, 0xffffffff, 0xffffffff );
  TEST_RR_OP(MAGIC_COUNT,  mulhsu, 0xffffffff, 0xffffffff, 0x00000001 );
  TEST_RR_OP(MAGIC_COUNT,  mulhsu, 0x00000000, 0x00000001, 0xffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, mulhsu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, mulhsu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, mulhsu, 43264, 13<<20 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, mulhsu, 36608, 13<<20, 11<<20 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, mulhsu, 39424, 14<<20, 11<<20 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, mulhsu, 42240, 15<<20, 11<<20 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, mulhsu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, mulhsu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, mulhsu, 42240, 15<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, mulhsu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, mulhsu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, mulhsu, 42240, 15<<20, 11<<20 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, mulhsu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, mulhsu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, mulhsu, 42240, 15<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, mulhsu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, mulhsu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, mulhsu, 42240, 15<<20, 11<<20 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, mulhsu, 0, 31<<26 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, mulhsu, 0, 32<<26 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, mulhsu, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, mulhsu, 33<<20, 34<<20 );

  #-------------------------------------------------------------
  # mulhu
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT,  mulhu, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mulhu, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( MAGIC_COUNT,  mulhu, 0x00000000, 0x00000003, 0x00000007 );

  TEST_RR_OP( MAGIC_COUNT,  mulhu, 0x00000000, 0x00000000, 0xffff8000 );
  TEST_RR_OP( MAGIC_COUNT,  mulhu, 0x00000000, 0x80000000, 0x00000000 );
  TEST_RR_OP( MAGIC_COUNT,  mulhu, 0x7fffc000, 0x80000000, 0xffff8000 );

  TEST_RR_OP(MAGIC_COUNT,  mulhu, 0x0001fefe, 0xaaaaaaab, 0x0002fe7d );
  TEST_RR_OP(MAGIC_COUNT,  mulhu, 0x0001fefe, 0x0002fe7d, 0xaaaaaaab );

  TEST_RR_OP(MAGIC_COUNT,  mulhu, 0xfe010000, 0xff000000, 0xff000000 );

  TEST_RR_OP(MAGIC_COUNT,  mulhu, 0xfffffffe, 0xffffffff, 0xffffffff );
  TEST_RR_OP(MAGIC_COUNT,  mulhu, 0x00000000, 0xffffffff, 0x00000001 );
  TEST_RR_OP(MAGIC_COUNT,  mulhu, 0x00000000, 0x00000001, 0xffffffff );

  # Source/Destination tests

  TEST_RR_SRC1_EQ_DEST( MAGIC_COUNT, mulhu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC2_EQ_DEST( MAGIC_COUNT, mulhu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_EQ_DEST( MAGIC_COUNT, mulhu, 43264, 13<<20 );

  # Bypassing tests

  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 0, mulhu, 36608, 13<<20, 11<<20 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 1, mulhu, 39424, 14<<20, 11<<20 );
  TEST_RR_DEST_BYPASS( MAGIC_COUNT, 2, mulhu, 42240, 15<<20, 11<<20 );

  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 0, mulhu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 1, mulhu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 0, 2, mulhu, 42240, 15<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 0, mulhu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 1, 1, mulhu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC12_BYPASS( MAGIC_COUNT, 2, 0, mulhu, 42240, 15<<20, 11<<20 );

  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 0, mulhu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 1, mulhu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 0, 2, mulhu, 42240, 15<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 0, mulhu, 36608, 13<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 1, 1, mulhu, 39424, 14<<20, 11<<20 );
  TEST_RR_SRC21_BYPASS( MAGIC_COUNT, 2, 0, mulhu, 42240, 15<<20, 11<<20 );

  TEST_RR_ZEROSRC1( MAGIC_COUNT, mulhu, 0, 31<<26 );
  TEST_RR_ZEROSRC2( MAGIC_COUNT, mulhu, 0, 32<<26 );
  TEST_RR_ZEROSRC12( MAGIC_COUNT, mulhu, 0 );
  TEST_RR_ZERODEST( MAGIC_COUNT, mulhu, 33<<20, 34<<20 );
/*
  #-------------------------------------------------------------
  # div
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT, div,  3,  20,   6 );
  TEST_RR_OP( MAGIC_COUNT, div, -3, -20,   6 );
  TEST_RR_OP( MAGIC_COUNT, div, -3,  20,  -6 );
  TEST_RR_OP( MAGIC_COUNT, div,  3, -20,  -6 );

  TEST_RR_OP( MAGIC_COUNT, div, -1<<31, -1<<31,  1 );
  TEST_RR_OP( MAGIC_COUNT, div, -1<<31, -1<<31, -1 );

  TEST_RR_OP( MAGIC_COUNT, div, -1, -1<<31, 0 );
  TEST_RR_OP( MAGIC_COUNT, div, -1,      1, 0 );
  TEST_RR_OP( MAGIC_COUNT, div, -1,      0, 0 );

  #-------------------------------------------------------------
  # divu
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT, divu,                   3,  20,   6 );
  TEST_RR_OP( MAGIC_COUNT, divu,           715827879, -20,   6 );
  TEST_RR_OP( MAGIC_COUNT, divu,                   0,  20,  -6 );
  TEST_RR_OP( MAGIC_COUNT, divu,                   0, -20,  -6 );

  TEST_RR_OP( MAGIC_COUNT, divu, -1<<31, -1<<31,  1 );
  TEST_RR_OP( MAGIC_COUNT, divu,     0,  -1<<31, -1 );

  TEST_RR_OP( MAGIC_COUNT, divu, -1, -1<<31, 0 );
  TEST_RR_OP( MAGIC_COUNT, divu, -1,      1, 0 );
  TEST_RR_OP( MAGIC_COUNT, divu, -1,      0, 0 );

  #-------------------------------------------------------------
  # rem
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT, rem,  2,  20,   6 );
  TEST_RR_OP( MAGIC_COUNT, rem, -2, -20,   6 );
  TEST_RR_OP( MAGIC_COUNT, rem,  2,  20,  -6 );
  TEST_RR_OP( MAGIC_COUNT, rem, -2, -20,  -6 );

  TEST_RR_OP( MAGIC_COUNT, rem,  0, -1<<31,  1 );
  TEST_RR_OP( MAGIC_COUNT, rem,  0, -1<<31, -1 );

  TEST_RR_OP( MAGIC_COUNT, rem, -1<<31, -1<<31, 0 );
  TEST_RR_OP( MAGIC_COUNT, rem,      1,      1, 0 );
  TEST_RR_OP( MAGIC_COUNT, rem,      0,      0, 0 );

  #-------------------------------------------------------------
  # remu
  #-------------------------------------------------------------

  TEST_RR_OP( MAGIC_COUNT, remu,   2,  20,   6 );
  TEST_RR_OP( MAGIC_COUNT, remu,   2, -20,   6 );
  TEST_RR_OP( MAGIC_COUNT, remu,  20,  20,  -6 );
  TEST_RR_OP( MAGIC_COUNT, remu, -20, -20,  -6 );

  TEST_RR_OP( MAGIC_COUNT, remu,      0, -1<<31,  1 );
  TEST_RR_OP( MAGIC_COUNT, remu, -1<<31, -1<<31, -1 );

  TEST_RR_OP( MAGIC_COUNT, remu, -1<<31, -1<<31, 0 );
  TEST_RR_OP( MAGIC_COUNT, remu,      1,      1, 0 );
  TEST_RR_OP( MAGIC_COUNT, remu,      0,      0, 0 );
*/
  TEST_PASSFAIL

.data
.balign 256
.align 4
lb_test_data:
lb_test_data1:  .byte 0xff
lb_test_data2:  .byte 0x00
lb_test_data3:  .byte 0xf0
lb_test_data4:  .byte 0x0f

lbu_test_data:
lbu_test_data1:  .byte 0xff
lbu_test_data2:  .byte 0x00
lbu_test_data3:  .byte 0xf0
lbu_test_data4:  .byte 0x0f

lh_test_data:
lh_test_data1:  .half 0x00ff
lh_test_data2:  .half 0xff00
lh_test_data3:  .half 0x0ff0
lh_test_data4:  .half 0xf00f

lhu_test_data:
lhu_test_data1:  .half 0x00ff
lhu_test_data2:  .half 0xff00
lhu_test_data3:  .half 0x0ff0
lhu_test_data4:  .half 0xf00f

lw_test_data:
lw_test_data1:  .word 0x00ff00ff
lw_test_data2:  .word 0xff00ff00
lw_test_data3:  .word 0x0ff00ff0
lw_test_data4:  .word 0xf00ff00f

.align 4
sb_test_data:
sb_test_data1:  .byte 0xef
sb_test_data2:  .byte 0xef
sb_test_data3:  .byte 0xef
sb_test_data4:  .byte 0xef
sb_test_data5:  .byte 0xef
sb_test_data6:  .byte 0xef
sb_test_data7:  .byte 0xef
sb_test_data8:  .byte 0xef
sb_test_data9:  .byte 0xef
sb_test_data10: .byte 0xef

.align 4
sh_test_data:
sh_test_data1:  .half 0xbeef
sh_test_data2:  .half 0xbeef
sh_test_data3:  .half 0xbeef
sh_test_data4:  .half 0xbeef
sh_test_data5:  .half 0xbeef
sh_test_data6:  .half 0xbeef
sh_test_data7:  .half 0xbeef
sh_test_data8:  .half 0xbeef
sh_test_data9:  .half 0xbeef
sh_test_data10: .half 0xbeef

.align 4
sw_test_data:
sw_test_data1:  .word 0xdeadbeef
sw_test_data2:  .word 0xdeadbeef
sw_test_data3:  .word 0xdeadbeef
sw_test_data4:  .word 0xdeadbeef
sw_test_data5:  .word 0xdeadbeef
sw_test_data6:  .word 0xdeadbeef
sw_test_data7:  .word 0xdeadbeef
sw_test_data8:  .word 0xdeadbeef
sw_test_data9:  .word 0xdeadbeef
sw_test_data10: .word 0xdeadbeef
