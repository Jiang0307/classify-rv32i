.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    LI t0, 1
    BLT a2, t0, error_terminate  
    BLT a3, t0, error_terminate   
    BLT a4, t0, error_terminate  

    LI t0, 0 # answer
    LI t1, 0 # i
    
    SLLI a3, a3, 2 # a3 = 4 * a3
    SLLI a4, a4, 2 # a4 = 4 * a4


loop_start:
    BGE t1, a2, loop_end
    # TODO
    LI t2, 0                            # t2 : multiply result
    LW t3, 0(a0)                        # t3 : multiplicand
    LW t4, 0(a1)                        # t4 : multiplier

    multiply_start:
        BEQZ t4, multiply_end           # end multiplication if multiplier is 0

        ANDI t5, t4, 1
        BEQZ t5, multiply_skip_add      # add only when multiplier's LSB is 1
        ADD t2, t2, t3

    multiply_skip_add:
        SLLI t3, t3, 1
        SRLI t4, t4, 1
        J multiply_start

    multiply_end:
        ADD t0, t0, t2                  # add multiply result to answer
        ADD a0, a0, a3
        ADD a1, a1, a4                  

        ADDI t1, t1, 1
        BLT t1, a2, loop_start

loop_end:
    MV a0, t0
    JR ra

error_terminate:
    BLT a2, t0, set_error_36
    LI a0, 37
    J exit

set_error_36:
    LI a0, 36
    J exit
