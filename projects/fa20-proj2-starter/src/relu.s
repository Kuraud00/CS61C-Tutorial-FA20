.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================

# Important syntax:
#
# lw a,b(c)
# load words from memory to a from the address of memory c with the offset immediate b
#
# sw a,b(c)
# save value a from resistor to the address of memory c with the offset immediate b

relu:
    # Prologue
    add t0, a0, x0  # copy of the ptr to the array
    add t1, a1, x0  # copy of the size of array
    add t2, x0, x0  # like i in for loop
loop_start:
    bge t2, t1, loop_end    #exit the loop
    lw t3, 0(t0)    # load the first word in array
    bge t3, x0, loop_continue   #if is greater than 0,go to next
    add t3, x0, x0  # set current number as 0
    sw t3, 0(t0)    # save 
loop_continue:
    addi t2, t2, 1   # increase i
    addi t0, t0, 4   # go to next number
    j loop_start    #continue loop
loop_end:
    # Epilogue

    
	ret
