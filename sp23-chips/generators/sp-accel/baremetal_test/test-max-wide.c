#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#include "golden_model.h"

#define CACHELINE 64

int main(void)
{   
    /* Sparse Matrix Specs - 1 x 96 elems */
    uint8_t num_sparse_rows = 20;
    int8_t* sparse_rows[num_sparse_rows];
    uint8_t num_sparse_cols = 30;
    uint8_t sparse_row_size = num_sparse_cols;

    /* Dense Matrix Specs - 96 x 128 elems */
    // Why 128 ? 128 /8 == 16, 16 is the maximum dense row size the test can pass
    uint8_t num_dense_rows = 30;
    uint8_t num_dense_cols = 128;
    uint8_t dense_matrix_stride = 8;
    uint8_t dense_matrix_size = num_dense_cols/dense_matrix_stride;

    //allocate dense matrix, but ensuring that it memory align with 1024 bits
    //1024 is maximum size in which the accelerator can operate on
    //1024 is 512 * 2, 512 bits is the size of a L2 cache line, it's the idea size for burst request
    
    __attribute__((aligned(CACHELINE))) int8_t dense_matrix[dense_matrix_size * num_dense_rows * dense_matrix_stride];

    rand_dense_matrix(dense_matrix, dense_matrix_stride, dense_matrix_size, num_dense_rows, 100);

    int8_t* output_buf_acc_rows[num_sparse_rows];
    int8_t* output_buf_model_rows[num_sparse_rows];

    for (int i = 0; i < num_sparse_rows; i += 1) {

        sparse_rows[i] = malloc(sizeof(int8_t) * num_sparse_cols * 2);

        __attribute__((aligned(CACHELINE))) int8_t output_acc_row[num_dense_cols];  //cache align this
        output_buf_acc_rows[i] = output_acc_row; // cache align this for better perf

        output_buf_model_rows[i] = malloc(sizeof(int8_t) * num_dense_cols);

        rand_sparse_row(sparse_rows[i], sparse_row_size, num_dense_rows, 100);
	
	printf("\nBeginning Accelerator\n");
        ROCC_INSTRUCTION_0_R_R(0, sparse_rows[i], sparse_row_size, 0);
        ROCC_INSTRUCTION_0_R_R(0, dense_matrix, dense_matrix_size, 1);
        ROCC_INSTRUCTION_0_R_R(0, output_buf_acc_rows[i], output_buf_acc_rows[i], 2);
        asm volatile("fence");

	printf("\nEnding Accelerator\n");

        accel_model(sparse_rows[i], sparse_row_size, dense_matrix, dense_matrix_stride, dense_matrix_size, output_buf_model_rows[i]);
        asm volatile("fence");

        // printf("\nModel Output\n");
        // for (int j = 0; j < num_dense_cols; j += 1) {
        //     printf("%d", output_buf_model_rows[i][j]);
        //     printf(" ");
        // }

        // printf("\nAccel Output\n");
        // for (int j = 0; j < num_dense_cols; j += 1) {
        //     printf("%d", output_buf_acc_rows[i][j]);
        //     printf(" ");
        // }

        for (int j = 0; j < num_dense_cols; j += 1) {
            if (output_buf_acc_rows[i][j] != output_buf_model_rows[i][j]) {
                printf("\nFAILED at output[%d][%d]. Expected %d. Got %d.\n", i, j, output_buf_model_rows[i][j], output_buf_acc_rows[i][j]);
                return -1;
            }
        }

// Instructions added for Add
 uint64_t register1 = 0x0706050403020100;
 uint64_t register2 = 0x0f0e0d0c0b0a0908;
 uint64_t useLUT = 0x1;
 // printf("output_buf[0] is  %d\n", output_buf[0]);

 ROCC_INSTRUCTION_0_R_R(0, register1,register2, 4);


        printf("\n\nPASSED !\n");
        printf("\nTest passed with maximum dense row size (128 cols, 16 section of 64bits !\n");

    }
    return 0;
}
