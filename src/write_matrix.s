.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Write a matrix of integers to a binary file
# FILE FORMAT:
#   - The first 8 bytes store two 4-byte integers representing the number of 
#     rows and columns, respectively.
#   - Each subsequent 4-byte segment represents a matrix element, stored in 
#     row-major order.
#
# Arguments:
#   a0 (char *) - Pointer to a string representing the filename.
#   a1 (int *)  - Pointer to the matrix's starting location in memory.
#   a2 (int)    - Number of rows in the matrix.
#   a3 (int)    - Number of columns in the matrix.
#
# Returns:
#   None
#
# Exceptions:
#   - Terminates with error code 27 on `fopen` error or end-of-file (EOF).
#   - Terminates with error code 28 on `fclose` error or EOF.
#   - Terminates with error code 30 on `fwrite` error or EOF.
# ==============================================================================
write_matrix:
    # Prologue
    ADDI sp, sp, -44
    SW ra, 0(sp)
    SW s0, 4(sp)
    SW s1, 8(sp)
    SW s2, 12(sp)
    SW s3, 16(sp)
    SW s4, 20(sp)

    # save arguments
    MV s1, a1        # s1 = matrix pointer
    MV s2, a2        # s2 = number of rows
    MV s3, a3        # s3 = number of columns

    LI a1, 1

    JAL fopen

    LI t0, -1
    BEQ a0, t0, fopen_error   # fopen didn't work

    MV s0, a0        # file descriptor

    # Write number of rows and columns to file
    SW s2, 24(sp)    # number of rows
    SW s3, 28(sp)    # number of columns

    MV a0, s0
    ADDI a1, sp, 24  # buffer with rows and columns
    LI a2, 2         # number of elements to write
    LI a3, 4         # size of each element

    JAL fwrite

    LI t0, 2
    BNE a0, t0, fwrite_error

    # mul s4, s2, s3   # s4 = total elements
    # FIXME: Replace 'mul' with your own implementation
    # s2 : multiplicand
    # s3 : multiplier
    LI t4, 0
    multiply_start:
        BEQZ s3, multiply_end           # end multiplication if multiplier is 0
        ANDI t3, s3, 1
        BEQZ t3, multiply_skip_add      # add only when multiplier's LSB is 1
        ADD t4, t4, s2
    multiply_skip_add:
        SLLI s2, s2, 1
        SRLI s3, s3, 1
        J multiply_start
    multiply_end:
        MV s4, t4

    # write matrix data to file
    MV a0, s0
    MV a1, s1        # matrix data pointer
    MV a2, s4        # number of elements to write
    LI a3, 4         # size of each element

    JAL fwrite

    BNE a0, s4, fwrite_error

    MV a0, s0

    JAL fclose

    LI t0, -1
    BEQ a0, t0, fclose_error

    # Epilogue
    LW ra, 0(sp)
    LW s0, 4(sp)
    LW s1, 8(sp)
    LW s2, 12(sp)
    LW s3, 16(sp)
    LW s4, 20(sp)
    ADDI sp, sp, 44

    JR ra

fopen_error:
    LI a0, 27
    J error_exit

fwrite_error:
    LI a0, 30
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
    ADDI sp, sp, 44
    J exit
