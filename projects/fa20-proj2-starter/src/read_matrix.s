.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Set arguments
    mv a1, s0
	li a2, 0

    # Call fopen and save file in a0
    jal ra, fopen

    # Save file in s3
    mv s3, a0

    # fopen exception check
    li t0, -1
    li a1, 90
    beq a0, t0, error_check

    # read row of matrix
    mv a1, s3
    mv a2, s1
    li a3, 4

    # Call fread and check
    jal ra, fread
    li a1, 91
    li t0, 4
    bne  a0, t0, error_check

    # Read col of matrix
    mv a1, s3
    mv a2, s2
    li a3, 4

    # Call fread and check
    jal ra, fread
    li a1, 91
    li t0, 4
    bne a0, t0, error_check

    # Get size of matrix 
    lw t0, 0(s1)  # row
    lw t1, 0(s2)  # col
    mul t3, t0, t1  # size
    slli t0, t3, 2  # size of bytes
    mv s5, t0

    # Malloc for memory
    mv a0, t0
    jal malloc  # get a0 as ptr

    # Save a0 as s4
    mv s4, a0

    # Check malloc
    li a1, 88
    beq a0, x0, error_check

    # Read the rest of matrix and check
    mv a1, s3
    mv a2, a0
    mv a3, s5
    jal fread
    li a1, 91
    bne a0, s5, error_check

    # Close the file
    mv a1, s3
    jal fclose
    li a1, 92
    bne a0, x0, error_check

    # Return file ptr
    mv a0, s4


    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    # Epilogue
    ret

error_check:
    j exit2