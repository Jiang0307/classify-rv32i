.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================

# t0 : maximum number
# t1 : maximum index

# t2 : current index
# t3 : current number

argmax:
    LI t6, 1
    BLT a1, t6, handle_error
    BEQ a1, t6, only_one_element

    LW t0, 0(a0)
    LI t1, 0
    
    LI t2, 1
    ADDI a0, a0, 4

loop_start:
    # TODO: Add your own implementation
    LW t3, 0(a0)
    BGT t3, t0, update_maximum
    J next_number

update_maximum:
    MV t0, t3
    MV t1, t2

next_number:
    ADDI a0, a0, 4
    ADDI t2, t2, 1
    BLT t2, a1, loop_start
    MV a0, t1
    RET

only_one_element:
    LI a0, 0
    RET

handle_error:
    LI a0, 36
    J exit