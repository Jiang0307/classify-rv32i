.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication Implementation
#
# Performs operation: D = M0 × M1
# Where:
#   - M0 is a (rows0 × cols0) matrix
#   - M1 is a (rows1 × cols1) matrix
#   - D is a (rows0 × cols1) result matrix
#
# Arguments:
#   First Matrix (M0):
#     a0: Memory address of first element
#     a1: Row count
#     a2: Column count
#
#   Second Matrix (M1):
#     a3: Memory address of first element
#     a4: Row count
#     a5: Column count
#
#   Output Matrix (D):
#     a6: Memory address for result storage
#
# Validation (in sequence):
#   1. Validates M0: Ensures positive dimensions
#   2. Validates M1: Ensures positive dimensions
#   3. Validates multiplication compatibility: M0_cols = M1_rows
#   All failures trigger program exit with code 38
#
# Output:
#   None explicit - Result matrix D populated in-place
# =======================================================
matmul:
    # Error checks
    LI t0 1
    BLT a1, t0, error
    BLT a2, t0, error
    BLT a4, t0, error
    BLT a5, t0, error
    BNE a2, a4, error

    # Prologue
    ADDI sp, sp, -28
    SW ra, 0(sp)

    SW s0, 4(sp)
    SW s1, 8(sp)
    SW s2, 12(sp)
    SW s3, 16(sp)
    SW s4, 20(sp)
    SW s5, 24(sp)
    
    LI s0, 0 # outer loop counter
    LI s1, 0 # inner loop counter
    
    MV s2, a6 # incrementing result matrix pointer
    MV s3, a0 # incrementing matrix A pointer, increments durring outer loop
    MV s4, a3 # incrementing matrix B pointer, increments during inner loop 
    
outer_loop_start:
    #s0 is going to be the loop counter for the rows in A
    LI s1, 0
    MV s4, a3
    BLT s0, a1, inner_loop_start

    J outer_loop_end

inner_loop_start:
# HELPER FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use = number of columns of A, or number of rows of B
#   a3 (int)  is the stride of arr0 = for A, stride = 1
#   a4 (int)  is the stride of arr1 = for B, stride = len(rows) - 1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1

    BEQ s1, a5, inner_loop_end

    ADDI sp, sp, -24
    SW a0, 0(sp)
    SW a1, 4(sp)
    SW a2, 8(sp)
    SW a3, 12(sp)
    SW a4, 16(sp)
    SW a5, 20(sp)
    
    MV a0, s3           # setting pointer for matrix A into the correct argument value
    MV a1, s4           # setting pointer for Matrix B into the correct argument value
    MV a2, a2           # setting the number of elements to use to the columns of A
    LI a3, 1            # stride for matrix A
    MV a4, a5           # stride for matrix B
    
    JAL dot
    
    MV t0, a0           # storing result of the dot product into t0
    
    LW a0, 0(sp)
    LW a1, 4(sp)
    LW a2, 8(sp)
    LW a3, 12(sp)
    LW a4, 16(sp)
    LW a5, 20(sp)
    ADDI sp, sp, 24
    
    SW t0, 0(s2)
    ADDI s2, s2, 4      # Incrememtning pointer for result matrix
    
    LI t1, 4
    ADD s4, s4, t1      # incrememtning the column on Matrix B
    
    ADDI s1, s1, 1
    J inner_loop_start
    
inner_loop_end:
    # TODO: ADD your own implementation
    MV t0, a2           # a2 is M0's column count
    SLLI t0, t0, 2      # Because a element is 4bytes, we need to shift 4 * (column count) bytes 
    ADD s3, s3, t0      # Move M0's element pointer to next row address
    ADDI s0, s0, 1      # Outer loop counter + 1
    J outer_loop_start  # Continue to calculate the next row

outer_loop_end:
    # Epilogue
    LW ra, 0(sp)
    LW s0, 4(sp)
    LW s1, 8(sp)
    LW s2, 12(sp)
    LW s3, 16(sp)
    LW s4, 20(sp)
    LW s5, 24(sp)
    ADDI sp, sp, 28
    JR ra

error:
    LI a0, 38
    J exit