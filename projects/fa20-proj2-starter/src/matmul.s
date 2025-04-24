.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks

    # save s0~s8
    addi sp, sp, -40
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)
    sw s4,16(sp)
    sw s5,20(sp)
    sw s6,24(sp)
    sw s7,28(sp)
    sw s8,32(sp)
    sw ra,36(sp)

    # move into s0~s8
    mv s0, a0  # a0 start of m0
    mv s1, a1  # a1 row of m0
    mv s2, a2  # a2 col of m0
    mv s3, a3  # a3 start of m1
    mv s4, a4  # a4 row of m1
    mv s5, a5  # a5 col of m1
    mv s6, a6  # a6 result
    li s7, 0  # i
    li s8, 0  # j

outer_loop_start:
    bge s7, s1, outer_loop_end

inner_loop_start:
    bge s8, s5, inner_loop_end
    # Arguments:
    #   a0 (int*) is the pointer to the start of v0
    #   a1 (int*) is the pointer to the start of v1
    #   a2 (int)  is the length of the vectors
    #   a3 (int)  is the stride of v0
    #   a4 (int)  is the stride of v1
    mv a0, s0
    mv a1, s3
    mul a2, s4, s5
    li a3, 1
    mv a4, s5

    jal ra, dot  
    # here use ra , but matmul is also a function needs to use ra to back into main function !
    # the solution is to save original ra at first and load at the end !
    sw a0,0(s6)
    addi s6, s6, 4


    addi s3, s3, 4
    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    # put s3 to origin
    li t0, 4
    mul t0, t0, s5
    sub s3, s3, t0

    # put s0 to next row
    li t0, 4
    mul t0, t0, s2
    add s0, s0, t0

    # i++
    addi s7, s7, 1 
    # j = 0
    li s8, 0

    # continue loop
    j outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    lw s3,12(sp)
    lw s4,16(sp)
    lw s5,20(sp)
    lw s6,24(sp)
    lw s7,28(sp)
    lw s8,32(sp)
    lw ra,36(sp)
    addi sp, sp, 40

    ret
