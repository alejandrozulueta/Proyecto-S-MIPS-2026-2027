# tests/03_comparisons.asm
# Instrucciones: slt, slti.
# Logica:
#   - un caso con resultado 1 y otro con resultado 0.
#   - operandos negativos donde la comparacion con signo y sin signo
#     producen resultados distintos.
# Salida: 9 valores hex, en orden de ejecucion.

        .text
main:
        addi $t0, $zero, 5
        addi $t1, $zero, 7

        slt  $a0, $t0, $t1
        jal  hex8
        slt  $a0, $t1, $t0
        jal  hex8
        addi $t2, $zero, -1
        addi $t3, $zero, 1
        slt  $a0, $t2, $t3
        jal  hex8
        slt  $a0, $t3, $t2
        jal  hex8
        slt  $a0, $zero, $zero
        jal  hex8
        jal  nl

        addi $t4, $zero, -10
        slti $a0, $t4, -5
        jal  hex8
        slti $a0, $zero, -5
        jal  hex8
        slti $a0, $t3, -1
        jal  hex8
        slti $a0, $t4, 0
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
