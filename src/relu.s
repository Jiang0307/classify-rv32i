.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================

relu:
    LI t0, 1
    BLT a1, t0, error
    LI t1, 0

loop_start:
    # TODO: Add your own implementation
    LI t3, 0

    LW t2, 0(a0)
    BLT t2, t3, negative
    J next_number

negative:
    SW t3, 0(a0)

next_number:
    ADDI a0, a0, 4
    ADDI a1, a1, -1
    BGT a1, t3, loop_start
    ret

error:
    li a0, 36 
    j exit