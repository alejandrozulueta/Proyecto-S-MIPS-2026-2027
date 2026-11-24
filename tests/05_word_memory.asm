# tests/05_word_memory.asm
# Instrucciones: lw, sw.
# Logica:
#   - lw y sw con desplazamiento positivo y con desplazamiento negativo.
#   - comprobacion de que un sw no modifica las palabras vecinas.
# Salida: 7 valores hex, en orden de ejecucion.

        .data
buf:    .word 0x11111111, 0x22222222, 0x33333333, 0x44444444

        .text
main:
        la   $s0, buf
        addi $s0, $s0, 8

        lw   $a0, 0($s0)
        jal  hex8
        lw   $a0, -8($s0)
        jal  hex8
        lw   $a0, 4($s0)
        jal  hex8
        lw   $a0, -4($s0)
        jal  hex8
        li   $t0, 0xAABBCCDD
        sw   $t0, -8($s0)
        lw   $a0, -8($s0)
        jal  hex8
        jal  nl

        sw   $t0, 4($s0)
        lw   $a0, 4($s0)
        jal  hex8
        lw   $a0, 0($s0)
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
