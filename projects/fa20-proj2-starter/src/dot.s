.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Exception check

    # Initialize
    # add t0, a0, x0  # t0:vector 0
    mv t0, a0
    # add t1, a1, x0  # t1:vector 1
    mv t1, a1
    # add t2, x0, x0  # t2:i
    li t2, 0
    # add a0, x0, x0  # a0:return
    li a0, 0
loop_start:
    lw t3,0(t0)
    lw t4,0(t1)
    mul t4, t3, t4 # v0[i]*v1[i]
    add a0, a0, t4

    li t3, 4
    # v0 forward
    mul t4, a3, t3
    add t0, t0, t4
    # v1 forward
    mul t4, a4, t3
    add t1, t1, t4
    # i forward
    bge a3, a4, compare
    add t2, t2, a4
    bge t2, a2, loop_end
    j loop_start
compare:
    add t2, t2, a3
    bge t2, a2, loop_end
    j loop_start
loop_end:
    ret
