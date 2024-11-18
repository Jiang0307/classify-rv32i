.globl classify

.text
# =====================================
# NEURAL NETWORK CLASSIFIER
# =====================================
# Description:
#   Command line program for matrix-based classification
#
# Command Line Arguments:
#   1. M0_PATH      - First matrix file location
#   2. M1_PATH      - Second matrix file location
#   3. INPUT_PATH   - Input matrix file location
#   4. OUTPUT_PATH  - Output file destination
#
# Register Usage:
#   a0 (int)        - Input: Argument count
#                   - Output: Classification result
#   a1 (char **)    - Input: Argument vector
#   a2 (int)        - Input: Silent mode flag
#                     (0 = verbose, 1 = silent)
#
# Error Codes:
#   31 - Invalid argument count
#   26 - Memory allocation failure
#
# Usage Example:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
# =====================================
classify:
    # Error handling
    LI t0, 5
    BLT a0, t0, error_args
    
    # Prolouge
    ADDI sp, sp, -48
    
    SW ra, 0(sp)
    
    SW s0, 4(sp) # m0 matrix
    SW s1, 8(sp) # m1 matrix
    SW s2, 12(sp) # input matrix
    
    SW s3, 16(sp) # m0 matrix rows
    SW s4, 20(sp) # m0 matrix cols
    
    SW s5, 24(sp) # m1 matrix rows
    SW s6, 28(sp) # m1 matrix cols
     
    SW s7, 32(sp) # input matrix rows
    SW s8, 36(sp) # input matrix cols
    SW s9, 40(sp) # h
    SW s10, 44(sp) # o
    
    # Read pretrained m0
    
    ADDI sp, sp, -12
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    
    LI a0, 4
    JAL malloc # malloc 4 bytes for an integer, rows
    BEQ a0, x0, error_malloc
    MV s3, a0 # save m0 rows pointer for later
    
    LI a0, 4
    JAL malloc # malloc 4 bytes for an integer, cols
    BEQ a0, x0, error_malloc
    MV s4, a0 # save m0 cols pointer for later
    
    LW a1, 4(sp) # restores the argument pointer
    
    LW a0, 4(a1) # set argument 1 for the read_matrix function  
    MV a1, s3 # set argument 2 for the read_matrix function
    MV a2, s4 # set argument 3 for the read_matrix function
    
    JAL read_matrix
    
    MV s0, a0 # setting s0 to the m0, aka the return value of read_matrix
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    
    ADDI sp, sp, 12
    # Read pretrained m1
    
    ADDI sp, sp, -12
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    
    LI a0, 4
    JAL malloc # malloc 4 bytes for an integer, rows
    BEQ a0, x0, error_malloc
    MV s5, a0 # save m1 rows pointer for later
    
    LI a0, 4
    JAL malloc # malloc 4 bytes for an integer, cols
    BEQ a0, x0, error_malloc
    MV s6, a0 # save m1 cols pointer for later
    
    LW a1, 4(sp) # restores the argument pointer
    
    LW a0, 8(a1) # set argument 1 for the read_matrix function  
    MV a1, s5 # set argument 2 for the read_matrix function
    MV a2, s6 # set argument 3 for the read_matrix function
    
    JAL read_matrix
    
    MV s1, a0 # setting s1 to the m1, aka the return value of read_matrix
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    
    ADDI sp, sp, 12

    # Read input matrix
    
    ADDI sp, sp, -12
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    
    LI a0, 4
    JAL malloc # malloc 4 bytes for an integer, rows
    BEQ a0, x0, error_malloc
    MV s7, a0 # save input rows pointer for later
    
    LI a0, 4
    JAL malloc # malloc 4 bytes for an integer, cols
    BEQ a0, x0, error_malloc
    MV s8, a0 # save input cols pointer for later
    
    LW a1, 4(sp) # restores the argument pointer
    
    LW a0, 12(a1) # set argument 1 for the read_matrix function  
    MV a1, s7 # set argument 2 for the read_matrix function
    MV a2, s8 # set argument 3 for the read_matrix function
    
    JAL read_matrix
    
    MV s2, a0 # setting s2 to the input matrix, aka the return value of read_matrix
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    
    ADDI sp, sp, 12

    # Compute h = matmul(m0, input)
    ADDI sp, sp, -28
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    SW a3, 12(sp)
    SW a4, 16(sp)
    SW a5, 20(sp)
    SW a6, 24(sp)
    
    LW t0, 0(s3)
    LW t1, 0(s8)
    # mul a0, t0, t1 # FIXME: Replace 'mul' with your own implementation
    SLLI a0, a0, 2
    JAL malloc 
    BEQ a0, x0, error_malloc
    MV s9, a0 # move h to s9
    
    MV a6, a0 # h 
    
    MV a0, s0 # move m0 array to first arg
    LW a1, 0(s3) # move m0 rows to second arg
    LW a2, 0(s4) # move m0 cols to third arg
    
    MV a3, s2 # move input array to fourth arg
    LW a4, 0(s7) # move input rows to fifth arg
    LW a5, 0(s8) # move input cols to sixth arg
    
    JAL matmul
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    LW a3, 12(sp)
    LW a4, 16(sp)
    LW a5, 20(sp)
    LW a6, 24(sp)
    
    ADDI sp, sp, 28
    
    # Compute h = relu(h)
    ADDI sp, sp, -8
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    
    MV a0, s9 # move h to the first argument
    LW t0, 0(s3)
    LW t1, 0(s8)
    # mul a1, t0, t1 # length of h array and set it as second argument
    # FIXME: Replace 'mul' with your own implementation
    
    JAL relu
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    
    ADDI sp, sp, 8
    
    # Compute o = matmul(m1, h)
    ADDI sp, sp, -28
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    SW a3, 12(sp)
    SW a4, 16(sp)
    SW a5, 20(sp)
    SW a6, 24(sp)
    
    LW t0, 0(s3)
    LW t1, 0(s6)
    # mul a0, t0, t1 # FIXME: Replace 'mul' with your own implementation
    SLLI a0, a0, 2
    JAL malloc 
    BEQ a0, x0, error_malloc
    MV s10, a0 # move o to s10
    
    MV a6, a0 # o
    
    MV a0, s1 # move m1 array to first arg
    LW a1, 0(s5) # move m1 rows to second arg
    LW a2, 0(s6) # move m1 cols to third arg
    
    MV a3, s9 # move h array to fourth arg
    LW a4, 0(s3) # move h rows to fifth arg
    LW a5, 0(s8) # move h cols to sixth arg
    
    JAL matmul
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    LW a3, 12(sp)
    LW a4, 16(sp)
    LW a5, 20(sp)
    LW a6, 24(sp)
    
    ADDI sp, sp, 28
    
    # Write output matrix o
    ADDI sp, sp, -16
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    SW a3, 12(sp)
    
    LW a0, 16(a1) # load filename string into first arg
    MV a1, s10 # load array into second arg
    LW a2, 0(s5) # load number of rows into fourth arg
    LW a3, 0(s8) # load number of cols into third arg
    
    JAL write_matrix
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    LW a3, 12(sp)
    
    ADDI sp, sp, 16
    
    # Compute and return argmax(o)
    ADDI sp, sp, -12
    
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    
    MV a0, s10 # load o array into first arg
    LW t0, 0(s3)
    LW t1, 0(s6)
    mul a1, t0, t1 # load length of array into second arg
    # FIXME: Replace 'mul' with your own implementation
    
    JAL argmax
    
    MV t0, a0 # move return value of argmax into t0
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    
    ADDI sp, sp 12
    
    MV a0, t0

    # If enabled, print argmax(o) and newline
    bne a2, x0, epilouge
    
    ADDI sp, sp, -4
    SW a0, 0(sp)
    
    JAL print_int
    LI a0, '\n'
    JAL print_char
    
    LW a0, 0(sp)
    ADDI sp, sp, 4
    
    # Epilouge
epilouge:
    ADDI sp, sp, -4
    SW a0, 0(sp)
    
    MV a0, s0
    JAL free
    
    MV a0, s1
    JAL free
    
    MV a0, s2
    JAL free
    
    MV a0, s3
    JAL free
    
    MV a0, s4
    JAL free
    
    MV a0, s5
    JAL free
    
    MV a0, s6
    JAL free
    
    MV a0, s7
    JAL free
    
    MV a0, s8
    JAL free
    
    MV a0, s9
    JAL free
    
    MV a0, s10
    JAL free
    
    LW a0, 0(sp)
    ADDI sp, sp, 4

    LW ra, 0(sp)
    
    LW s0, 4(sp) # m0 matrix
    LW s1, 8(sp) # m1 matrix
    LW s2, 12(sp) # input matrix
    
    LW s3, 16(sp) 
    LW s4, 20(sp)
    
    LW s5, 24(sp)
    LW s6, 28(sp)
    
    LW s7, 32(sp)
    LW s8, 36(sp)
    
    LW s9, 40(sp) # h
    LW s10, 44(sp) # o
    
    ADDI sp, sp, 48
    
    JR ra

error_args:
    LI a0, 31
    J exit

error_malloc:
    LI a0, 26
    J exit
