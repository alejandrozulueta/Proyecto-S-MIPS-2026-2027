# tests/04_shifts.asm
# Instrucciones: sll, srl.
# Logica:
#   - shamt = 0 y shamt != 0 en sll y srl.
#   - srl sobre un valor negativo (deben entrar ceros).
# Salida: 9 valores hex, en orden de ejecucion.

        .text
main:
        addi $t0, $zero, 1

        sll  $a0, $t0, 0
        jal  hex8
        sll  $a0, $t0, 4
        jal  hex8
        sll  $a0, $t0, 31
        jal  hex8
        li   $t1, 0x80000000
        srl  $a0, $t1, 0
        jal  hex8
        srl  $a0, $t1, 1
        jal  hex8
        jal  nl

        srl  $a0, $t1, 31
        jal  hex8
        li   $t1, 0xF0000000
        srl  $a0, $t1, 28
        jal  hex8
        li   $t1, 0x80000000
        sll  $a0, $t1, 1
        jal  hex8
        addi $t1, $zero, 1
        srl  $a0, $t1, 1
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
