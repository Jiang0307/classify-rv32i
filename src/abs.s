.globl abs

.text
# =================================================================
# FUNCTION: Absolute Value Converter
#
# Transforms any integer into its absolute (non-negative) value by
# modifying the original value through pointer dereferencing.
# For example: -5 becomes 5, while 3 remains 3.
#
# Args:
#   a0 (int *): Memory address of the integer to be converted
#
# Returns:
#   None - The operation modifies the value at the pointer address
# =================================================================
abs:
    # Prologue
    EBREAK
    # Load number from memory
    LW t0 0(a0)
    BGE t0, zero, done

    # TODO: Add your own implementation
    LI t1, 0
    SUB t0, t1, t0
    SW t0, 0(a0)

done:
    # Epilogue
    JR ra