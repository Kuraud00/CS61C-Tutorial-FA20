.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    add t0, a0, x0  # copy of ptr to the start of vector
    add t1, a1, x0  # size of vector
    add t2, x0, x0  # like i in for loop
    add t3, x0, x0  # record max index
    lw t4, 0(t0)    # record max
loop_start:
    bge t2, t1, loop_end    # end loop
    lw t5, 0(t0)    # get num[i]
    bge t4, t5, loop_continue   # if num[i] is less than num[max],continue 
    add t4, t5, x0  # record max as num[i]
    add t3, t2, x0  # record max index as i
loop_continue:
    addi t0, t0, 4  # go to next number
    addi t2, t2, 1  # go to next i
    j loop_start
loop_end:
    add a0, t3, x0

    # Epilogue


    ret
