# tests/01_arithmetic.asm
# Instrucciones: add, sub, addi, addu (via move), addiu (via li).
# Logica:
#   - recurrencia acumulativa de 4 pasos controlada por un contador;
#   - diferencia final y carga inmediata directa.
# Salida: 6 valores hex, en orden de ejecucion.

        .text
main:
        li   $s0, 30000
        addi $s1, $zero, -777
        addi $s2, $zero, 4
bucle:
        add  $s0, $s0, $s1
        addi $s0, $s0, 31
        move $a0, $s0
        jal  hex8
        addi $s2, $s2, -1
        bne  $s2, $zero, bucle
        jal  nl

        sub  $a0, $s0, $s1
        jal  hex8
        li   $a0, 32767
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
