.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    # Save arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # Call fopen
    mv a1, s0
    li a2, 1
    jal ra, fopen

    # Check fopen
    li t0, -1
    li a1, 93
    beq a0, t0, error_check

    # Save file ptr to s4
    mv s4, a0

    # Put row and col into stack
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)

    # Call fwrite
    mv a1, s4
    mv a2, sp
    li a3, 2
    li a4, 4
    jal ra,fwrite

    # Check fwrite
    li a1, 94
    li t0, 2
    bne a0, t0, error_check

    # Free stack
    addi sp, sp, 8

    # Ready to call fwrite
    mv a1, s4
    mv a2, s1
    mul t0, s2, s3
    mv a3, t0
    li a4, 4

    # Call fwrite
    jal ra, fwrite

    # Check fwrite
    mul t0, s2, s3
    li a1, 94
    bne t0, a0, error_check

    # Call fclose
    mv a1, s4
    jal ra, fclose
    li a1, 95
    li t0, -1
    beq a0, t0, error_check

    # Load ss
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    # Epilogue

    ret

error_check:
    j exit2


