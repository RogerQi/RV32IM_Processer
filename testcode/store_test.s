#  sw,sh,sb test (assume lb,lh,lw working)
.align 4
.section .text
.globl _start
_start:
    beq x0, x0, sw_test
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # cache line boundary

sw_test:
    lw x1, TWO
    la x8, TEMP1
    
    sw x1, 0(x8)
    lw x2, 0(x8)

    bne x1, x2, BAD

sh_test:
    lw x1, NEGTWO
    la x8, TEMP2
    lw x5, HALF_MASK

    # lower half word test
    sh x1, 0(x8)
    lh x2, 0(x8)
    bne x1, x2, BAD

    # upper half word test
    sh x1, 2(x8)
    lh x3, 2(x8)
    bne x1, x3, BAD

sb_test:
    lw x1, ONE
    la x8, TEMP3
    lw x5, BYTE_MASK

    # byte 0 (LSB)
    sb x1, 3(x8)
    lb x2, 3(x8)
    bne x1, x2, BAD

    # byte 1
    sb x1, 2(x8)
    lb x3, 2(x8)
    bne x1, x3, BAD

    # byte 2
    sb x1, 1(x8)
    lb x4, 1(x8)
    bne x1, x4, BAD

    # byte 3
    sb x1, 0(x8)
    lb x6, 0(x8)
    bne x1, x6, BAD

DONE:
    lw x7, GOOD
    beq x0, x0, HALT

BAD:
    lw x7, BADD
    beq x0, x0, HALT

HALT:
    beq x0, x0, HALT

.section .rodata
.balign 256
ONE:    .word 0x00000001
TWO:    .word 0x00000002
NEGTWO: .word 0xFFFFFFFE
TEMP1:  .word 0x00000000
TEMP2:  .word 0x00000000
TEMP3:  .word 0x00000000
GOOD:   .word 0x600D600D
BADD:   .word 0xBADDBADD
HALF_MASK: .word 0x0000FFFF
BYTE_MASK: .word 0x000000FF
