.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Binary Matrix File Reader
#
# Loads matrix data from a binary file into dynamically allocated memory.
# Matrix dimensions are read from file header and stored at provided addresses.
#
# Binary File Format:
#   Header (8 bytes):
#     - Bytes 0-3: Number of rows (int32)
#     - Bytes 4-7: Number of columns (int32)
#   Data:
#     - Subsequent 4-byte blocks: Matrix elements
#     - Stored in row-major order: [row0|row1|row2|...]
#
# Arguments:
#   Input:
#     a0: Pointer to filename string
#     a1: Address to write row count
#     a2: Address to write column count
#
#   Output:
#     a0: Base address of loaded matrix
#
# Error Handling:
#   Program terminates with:
#   - Code 26: Dynamic memory allocation failed
#   - Code 27: File access error (open/EOF)
#   - Code 28: File closure error
#   - Code 29: Data read error
#
# Memory Note:
#   Caller is responsible for freeing returned matrix pointer
# ==============================================================================
read_matrix:
    
    # Prologue
    ADDI sp, sp, -40
    SW ra, 0(sp)
    SW s0, 4(sp)
    SW s1, 8(sp)
    SW s2, 12(sp)
    SW s3, 16(sp)
    SW s4, 20(sp)

    MV s3, a1         # save and copy rows
    MV s4, a2         # save and copy cols

    LI a1, 0

    JAL fopen

    LI t0, -1
    BEQ a0, t0, fopen_error   # fopen didn't work

    MV s0, a0        # file

    # read rows n columns
    MV a0, s0
    ADDI a1, sp, 28  # a1 is a buffer

    LI a2, 8         # look at 2 numbers

    JAL fread

    LI t0, 8
    BNE a0, t0, fread_error

    LW t1, 28(sp)    # opening to save num rows
    LW t2, 32(sp)    # opening to save num cols

    SW t1, 0(s3)     # saves num rows
    SW t2, 0(s4)     # saves num cols

    # mul s1, t1, t2   # s1 is number of elements
    # FIXME: Replace 'mul' with your own implementation
    # t1 : multiplicand
    # t2 : multiplier
    LI t4, 0
    multiply_start:
        BEQZ t2, multiply_end           # end multiplication if multiplier is 0
        ANDI t3, t2, 1
        BEQZ t3, multiply_skip_add      # add only when multiplier's LSB is 1
        ADD t4, t4, t1
    multiply_skip_add:
        SLLI t1, t1, 1
        SRLI t2, t2, 1
        J multiply_start
    multiply_end:
        MV s1, t4

    SLLI t3, s1, 2
    SW t3, 24(sp)    # size in bytes

    LW a0, 24(sp)    # a0 = size in bytes

    JAL malloc

    BEQ a0, x0, malloc_error

    # set up file, buffer and bytes to read
    MV s2, a0        # matrix
    MV a0, s0
    MV a1, s2
    LW a2, 24(sp)

    JAL fread

    LW t3, 24(sp)
    BNE a0, t3, fread_error

    MV a0, s0

    JAL fclose

    LI t0, -1

    BEQ a0, t0, fclose_error

    MV a0, s2

    # Epilogue
    LW ra, 0(sp)
    LW s0, 4(sp)
    LW s1, 8(sp)
    LW s2, 12(sp)
    LW s3, 16(sp)
    LW s4, 20(sp)
    ADDI sp, sp, 40

    JR ra

malloc_error:
    LI a0, 26
    J error_exit

fopen_error:
    LI a0, 27
    J error_exit

fread_error:
    LI a0, 29
    J error_exit

fclose_error:
    LI a0, 28
    J error_exit

error_exit:
    LW ra, 0(sp)
    LW s0, 4(sp)
    LW s1, 8(sp)
    LW s2, 12(sp)
    LW s3, 16(sp)
    LW s4, 20(sp)
    ADDI sp, sp, 40
    J exit