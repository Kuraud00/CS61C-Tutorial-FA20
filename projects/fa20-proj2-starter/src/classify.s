.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi t0, x0, 5
    bne a0, t0, exception89

    # Save s
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================

    #=======================================================================================
    # Format of read_matrix
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    # Returns:
    #   a0 (int*)  is the pointer to the matrix in memory
    #=======================================================================================

    # Load pretrained m0 s3
    addi sp, sp, -8
    lw a0, 4(s1) # read M0_PATH
    addi a1, sp, 4 # store row 
    addi a2, sp, 0 # store col
    jal read_matrix
    mv s3, a0

    # Load pretrained m1 s4
    addi sp, sp, -8
    lw a0, 8(s1) # read M1_PATH
    addi a1, sp, 4 # store row 
    addi a2, sp, 0 # store col
    jal read_matrix
    mv s4, a0

    # Load input matrix s5
    addi sp, sp, -8
    lw a0, 12(s1) # read INPUT_PATH
    addi a1, sp, 4 # store row 
    addi a2, sp, 0 # store col
    jal read_matrix
    mv s5, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # Step 1: m0 * input

    lw t0, 20(sp) # m0 row
    lw t1, 0(sp) # input col
    mul t0, t0, t1 # d size count
    slli a0, t0, 2 # d byte size
    jal malloc
    beq a0, x0, exception88
    mv a6 ,a0
    mv s6, a6

    mv a0, s3
    lw a1, 20(sp)
    lw a2, 16(sp)

    mv a3, s5
    lw a4, 4(sp)
    lw a5, 0(sp)

    jal matmul

    # Step2: ReLU(m0 * input)

    mv a0, s6 # pointer to array
    lw t0, 20(sp) # m0 row
    lw t1, 0(sp) # input col
    mul a1, t0, t1 # d size count

    jal relu

    # Step3: m1 * ReLU(m0 * input)

    lw t0, 12(sp) # m1 row
    lw t1, 0(sp) # m0 * input col
    mul t0, t0, t1 # d size count
    slli a0, t0, 2 # d byte size
    jal malloc
    beq a0, x0, exception88
    mv a6 ,a0
    mv s7, a6

    mv a0, s4
    lw a1, 12(sp)
    lw a2, 8(sp)
    mv a3, s6
    lw a4, 20(sp)
    lw a5, 0(sp)

    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1)
    mv a1, s7
    lw a2, 12(sp)
    lw a3, 0(sp)

    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s7
    lw t0, 12(sp)
    lw t1, 0(sp)
    mul a1, t0, t1

    jal argmax

    # Print classification
    beq a0, x0, free_memory
    mv a1, a0
    jal print_int

    # Print newline afterwards for clarity
    addi a1, x0, '\n'
    jal print_char

free_memory:
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free

    addi sp, sp, 24

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36

    ret

exception89:
    li a1, 89
    jal exit2

exception88:
    li a1, 88
    jal exit2
