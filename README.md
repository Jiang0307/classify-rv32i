# Assignment 2: Classify

## Part A: Mathematical Functions

### Task 1: ReLU
In `relu.s`, traverse through the array and check the value one by one. If the value is negative then replace it with 0.

### Task 2: ArgMax
In `argmax.s`, traverse through the array and check the value one by one. If `current number` is greater than the `maximum number`, then update the `maximum number`.

### Task 3.1: Dot Product
#### Algorithm of muliplier
    1. Check LSB of multiplier, add multiplicand to result if LSB is `1`.
    2. Left shift multiplicand by 1 offset.
    3. Right shift multiplier by 1 offset.
    4. Repeat step 1~3 until multiplier is 0.

#### dot
In `dot.s`, calculate the stride0 and stide1 for array1 and array2. In each loop, calculate the value of current position using `multiplier`.

### Task 3.2: Matrix Multiplication
In `matmul.s` we need to implement `inner_loop_end` and `outer_loop_end`.

#### inner_loop_end
```
inner_loop_end:
    # TODO: ADD your own implementation
    MV t0, a2           # a2 is M0's column count
    SLLI t0, t0, 2      # Because a element is 4bytes, we need to shift 4 * (column count) bytes 
    ADD s3, s3, t0      # Move M0's element pointer to next row address
    ADDI s0, s0, 1      # Outer loop counter + 1
    J outer_loop_start  # Continue to calculate the next row
```
In `inner_loop_end`, we can intuitively know that every time the inner loop finishes, it will contiue a new outer loop, so the last instruction in `inner_loop_end` should be `J outer_loop_start`. At the same time, a loop also needs to increment the loop counter, so there should be a instruction `ADDI s0, s0, 1`, and we also need to calculate the matrix addresses for the next iteration.

#### outer_loop_end
```
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
```
In `outer_loop_end:`, We have to restore all `s` registers to their original state and then exit the function.

## Part B: File Operations and Main
In `read_matrix.s`,`write_matrix.s` and `classify.s`, all we have to do is replace mul with our self implemented `multiplier`.

## Other
### abs.s
In `abs.s`, check the input value, return if it's positive number. If not, just simply substract the input value by 0.

## Result
> bash ./test.sh all

```
test_abs_minus_one (__main__.TestAbs.test_abs_minus_one) ... ok
test_abs_one (__main__.TestAbs.test_abs_one) ... ok
test_abs_zero (__main__.TestAbs.test_abs_zero) ... ok
test_argmax_invalid_n (__main__.TestArgmax.test_argmax_invalid_n) ... ok
test_argmax_length_1 (__main__.TestArgmax.test_argmax_length_1) ... ok
test_argmax_standard (__main__.TestArgmax.test_argmax_standard) ... ok
test_chain_1 (__main__.TestChain.test_chain_1) ... ok
test_classify_1_silent (__main__.TestClassify.test_classify_1_silent) ... ok
test_classify_2_print (__main__.TestClassify.test_classify_2_print) ... ok
test_classify_3_print (__main__.TestClassify.test_classify_3_print) ... ok
test_classify_fail_malloc (__main__.TestClassify.test_classify_fail_malloc) ... ok
test_classify_not_enough_args (__main__.TestClassify.test_classify_not_enough_args) ... ok
test_dot_length_1 (__main__.TestDot.test_dot_length_1) ... ok
test_dot_length_error (__main__.TestDot.test_dot_length_error) ... ok
test_dot_length_error2 (__main__.TestDot.test_dot_length_error2) ... ok
test_dot_standard (__main__.TestDot.test_dot_standard) ... ok
test_dot_stride (__main__.TestDot.test_dot_stride) ... ok
test_dot_stride_error1 (__main__.TestDot.test_dot_stride_error1) ... ok
test_dot_stride_error2 (__main__.TestDot.test_dot_stride_error2) ... ok
test_matmul_incorrect_check (__main__.TestMatmul.test_matmul_incorrect_check) ... ok
test_matmul_length_1 (__main__.TestMatmul.test_matmul_length_1) ... ok
test_matmul_negative_dim_m0_x (__main__.TestMatmul.test_matmul_negative_dim_m0_x) ... ok
test_matmul_negative_dim_m0_y (__main__.TestMatmul.test_matmul_negative_dim_m0_y) ... ok
test_matmul_negative_dim_m1_x (__main__.TestMatmul.test_matmul_negative_dim_m1_x) ... ok
test_matmul_negative_dim_m1_y (__main__.TestMatmul.test_matmul_negative_dim_m1_y) ... ok
test_matmul_nonsquare_1 (__main__.TestMatmul.test_matmul_nonsquare_1) ... ok
test_matmul_nonsquare_2 (__main__.TestMatmul.test_matmul_nonsquare_2) ... ok
test_matmul_nonsquare_outer_dims (__main__.TestMatmul.test_matmul_nonsquare_outer_dims) ... ok
test_matmul_square (__main__.TestMatmul.test_matmul_square) ... ok
test_matmul_unmatched_dims (__main__.TestMatmul.test_matmul_unmatched_dims) ... ok
test_matmul_zero_dim_m0 (__main__.TestMatmul.test_matmul_zero_dim_m0) ... ok
test_matmul_zero_dim_m1 (__main__.TestMatmul.test_matmul_zero_dim_m1) ... ok
test_read_1 (__main__.TestReadMatrix.test_read_1) ... ok
test_read_2 (__main__.TestReadMatrix.test_read_2) ... ok
test_read_3 (__main__.TestReadMatrix.test_read_3) ... ok
test_read_fail_fclose (__main__.TestReadMatrix.test_read_fail_fclose) ... ok
test_read_fail_fopen (__main__.TestReadMatrix.test_read_fail_fopen) ... ok
test_read_fail_fread (__main__.TestReadMatrix.test_read_fail_fread) ... ok
test_read_fail_malloc (__main__.TestReadMatrix.test_read_fail_malloc) ... ok
test_relu_invalid_n (__main__.TestRelu.test_relu_invalid_n) ... ok
test_relu_length_1 (__main__.TestRelu.test_relu_length_1) ... ok
test_relu_standard (__main__.TestRelu.test_relu_standard) ... ok
test_write_1 (__main__.TestWriteMatrix.test_write_1) ... ok
test_write_fail_fclose (__main__.TestWriteMatrix.test_write_fail_fclose) ... ok
test_write_fail_fopen (__main__.TestWriteMatrix.test_write_fail_fopen) ... ok
test_write_fail_fwrite (__main__.TestWriteMatrix.test_write_fail_fwrite) ... ok

----------------------------------------------------------------------
Ran 46 tests in 56.370s

OK
```