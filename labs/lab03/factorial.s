.globl factorial

.data
n: .word 7

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    li t0, 1
factorial_loop:
    mul t0, t0, a0
    addi a0, a0, -1
    blt x0, a0, factorial_loop 
    add a0, t0, x0
    jr ra



    