# tests/07_control_flow.asm
# Instrucciones: beq, bne, j, jal, jr, addi, add, move, syscall.
# Logica:
#   - beq y bne tomados y no tomados;
#   - j al menos una vez.
#   - jal/jr con un procedimiento no hoja: proc_a guarda $ra en la pila
#     y llama a proc_b.
#   - escritura en $zero, comprobando despues que sigue valiendo 0.
#   - syscall 11 (impresion) y syscall 10 (terminar).
# Salida: 8 valores hex, en orden de ejecucion.

        .text
main:
        addi $s0, $zero, 0

        beq  $zero, $zero, cf_beq_taken
        addi $s0, $zero, 99
cf_beq_taken:
        addi $s0, $s0, 1
        move $a0, $s0
        jal  hex8
        jal  nl

        addi $t0, $zero, 1
        beq  $t0, $zero, cf_beq_not_taken
        addi $s0, $s0, 2
cf_beq_not_taken:
        move $a0, $s0
        jal  hex8
        jal  nl

        bne  $t0, $zero, cf_bne_taken
        addi $s0, $zero, 99
cf_bne_taken:
        addi $s0, $s0, 4
        move $a0, $s0
        jal  hex8
        jal  nl

        bne  $zero, $zero, cf_bne_not_taken
        addi $s0, $s0, 8
cf_bne_not_taken:
        move $a0, $s0
        jal  hex8
        jal  nl

        addi $s1, $zero, 3
cf_loop:
        addi $s0, $s0, 16
        addi $s1, $s1, -1
        bne  $s1, $zero, cf_loop
        move $a0, $s0
        jal  hex8
        jal  nl

        j    cf_jump
        addi $s0, $zero, 99
cf_jump:
        addi $s0, $s0, 64
        move $a0, $s0
        jal  hex8
        jal  nl

        jal  proc_a
        move $a0, $s0
        jal  hex8
        jal  nl

        move $a0, $zero
        jal  hex8
        jal  nl

        addi $v0, $zero, 10
        syscall

proc_a:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)
        addi $s0, $s0, 0x100
        jal  proc_b
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra

proc_b:
        addi $zero, $zero, 123
        addi $s0, $s0, 0x10
        jr   $ra

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
