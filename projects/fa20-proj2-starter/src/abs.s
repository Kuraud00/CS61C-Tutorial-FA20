.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # bge === branch if greater than or equal
    # if its greater than x0(0), jump into done part
    bge a0, x0, done

    # if a0 is negative , abs(a0)=0-a0
    sub a0, x0, a0
done:
    ret
