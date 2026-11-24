# tests/02_logic.asm
# Instrucciones: and, or, andi, ori, lui.
# Logica:
#   - and y or con operandos que tienen unos en los 16 bits altos.
#   - andi y ori con un inmediato cuyo bit 15 vale 1 (extension con ceros).
#   - lui con un inmediato cuyo bit 15 vale 1.
# Salida: 9 valores hex, en orden de ejecucion.

        .text
main:
        li   $t0, 0xF0F0F0F0
        li   $t1, 0x0F0F0F0F

        and  $a0, $t0, $t1
        jal  hex8
        and  $a0, $t0, $t0
        jal  hex8
        or   $a0, $t0, $t1
        jal  hex8
        or   $a0, $t0, $zero
        jal  hex8
        andi $a0, $t0, 0x8001
        jal  hex8
        jal  nl

        ori  $a0, $t0, 0x8001
        jal  hex8
        lui  $a0, 0x8001
        jal  hex8
        lui  $a0, 0xFFFF
        jal  hex8
        ori  $a0, $zero, 0x8001
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
