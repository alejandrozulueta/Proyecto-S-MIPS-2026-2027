# tests/06_byte_memory.asm
# Instrucciones: lb, lbu, sb, lw.
# Logica:
#   - lb y lbu sobre bytes con el bit 7 a 1, en tres posiciones distintas
#     dentro de la palabra (d[1:0] = 0, 2 y 3).
#   - sb en las cuatro posiciones de una palabra (d[1:0] = 0, 1, 2 y 3),
#     comprobando con lw despues de cada sb que los otros bytes no cambiaron.
# Salida: 11 valores hex, en orden de ejecucion.

        .data
src:    .word 0x8192A3F4
dest:   .word 0x11223344

        .text
main:
        la   $s0, src

        lb   $a0, 0($s0)
        jal  hex8
        lbu  $a0, 0($s0)
        jal  hex8
        lb   $a0, 2($s0)
        jal  hex8
        lbu  $a0, 2($s0)
        jal  hex8
        lb   $a0, 3($s0)
        jal  hex8
        jal  nl

        lbu  $a0, 3($s0)
        jal  hex8
        la   $s1, dest
        lw   $a0, 0($s1)
        jal  hex8
        li   $t0, 0xAA
        sb   $t0, 0($s1)
        lw   $a0, 0($s1)
        jal  hex8
        li   $t0, 0xBB
        sb   $t0, 1($s1)
        lw   $a0, 0($s1)
        jal  hex8
        jal  nl

        li   $t0, 0xCC
        sb   $t0, 2($s1)
        lw   $a0, 0($s1)
        jal  hex8
        li   $t0, 0xDD
        sb   $t0, 3($s1)
        lw   $a0, 0($s1)
        jal  hex8
        jal  nl

        addi $v0, $zero, 10
        syscall

hex8:
        add  $t8, $a0, $zero
        addi $t9, $zero, 8
h8_loop:
        srl  $t7, $t8, 28
        slti $t6, $t7, 10
        beq  $t6, $zero, h8_digit
        addi $a0, $t7, 48
        j    h8_print
h8_digit:
        addi $a0, $t7, 55
h8_print:
        addi $v0, $zero, 11
        syscall
        sll  $t8, $t8, 4
        addi $t9, $t9, -1
        bne  $t9, $zero, h8_loop
        addi $a0, $zero, 32
        addi $v0, $zero, 11
        syscall
        jr   $ra

nl:
        addi $a0, $zero, 10
        addi $v0, $zero, 11
        syscall
        jr   $ra
