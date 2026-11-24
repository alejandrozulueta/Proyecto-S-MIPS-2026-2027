# tests/08_integration.asm
# Instrucciones: add, addu (via move), sub, addi, addiu (via li), and, or,
#                andi, ori, lui, slt, slti, sll, srl, lw, sw, lb, lbu, sb,
#                beq, bne, j, jal, jr, syscall.
# Logica:
#   - recurrencia acumulativa, operaciones logicas y comparaciones;
#   - desplazamientos y acceso a memoria de palabra y byte;
#   - dos bucles anidados, subrutina con pila y syscall de impresion/salida.
# Salida: 11 valores hex, en orden de ejecucion.

        .data
buf:    .word 0x11111111, 0x22222222, 0x33333333, 0x44444444

        .text
main:
        li   $s0, 0x7000
        addi $s1, $zero, -17
        addi $s2, $zero, 4
acc_loop:
        add  $s0, $s0, $s1
        addi $s0, $s0, 3
        addi $s2, $s2, -1
        bne  $s2, $zero, acc_loop
        move $a0, $s0
        jal  hex8
        jal  nl

        sub  $a0, $s0, $s1
        jal  hex8
        jal  nl

        li   $t0, 0xF0F00F0F
        li   $t1, 0x3333CCCC
        and  $a0, $t0, $t1
        jal  hex8
        jal  nl
        or   $a0, $t0, $t1
        jal  hex8
        jal  nl

        andi $t7, $t0, 0xFF00
        ori  $t7, $t7, 0xBEEF
        lui  $t8, 0xC0DE
        or   $a0, $t7, $t8
        jal  hex8
        jal  nl

        addi $t2, $zero, 5
        addi $t3, $zero, -5
        slt  $a0, $t3, $t2
        jal  hex8
        jal  nl
        slti $a0, $t2, 3
        jal  hex8
        jal  nl
        beq  $t2, $t3, cmp_false
        addi $t4, $zero, 1
        j    cmp_done
cmp_false:
        addi $t4, $zero, 0
cmp_done:
        move $a0, $t4
        jal  hex8
        jal  nl

        li   $t5, 0x80000000
        srl  $t7, $t5, 28
        sll  $t8, $t5, 4
        or   $a0, $t7, $t8
        jal  hex8
        jal  nl

        li   $s7, 0x2000
        lw   $a0, 0($s7)
        addi $s7, $s7, 12
        lw   $a0, -8($s7)
        li   $t6, 0xABCDEF01
        sw   $t6, -12($s7)
        lw   $a0, -12($s7)
        jal  hex8
        jal  nl

        li   $t6, 0x8192A3F4
        sw   $t6, -4($s7)
        lbu  $a0, -4($s7)
        lb   $a0, -4($s7)
        addi $t6, $zero, 0x5A
        sb   $t6, -3($s7)
        lw   $s3, -4($s7)

        addi $s4, $zero, 12
        addi $s5, $zero, 0
outer_loop:
        addi $s6, $zero, 6
inner_loop:
        add  $s5, $s5, $s6
        addi $s6, $s6, -1
        bne  $s6, $zero, inner_loop
        addi $s4, $s4, -1
        bne  $s4, $zero, outer_loop

        jal  proc
        add  $a0, $s3, $s5
        jal  hex8
        jal  nl

        j    finish
proc:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)
        addi $s5, $s5, 0x100
        jal  leaf
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra
leaf:
        sll  $s5, $s5, 1
        jr   $ra
finish:
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
