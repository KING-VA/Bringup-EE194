#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#include "golden_model.h"

#define CACHELINE 64

int main(void)
{   
    uint8_t num_sparse_rows = 2;
    int8_t* sparse_rows[num_sparse_rows];
    uint8_t num_sparse_cols = 4;
    uint8_t sparse_row_size = num_sparse_cols;

    uint8_t num_dense_rows = 4;
    uint8_t num_dense_cols = 128;
    uint8_t dense_matrix_stride = 8;
    uint8_t dense_matrix_size = num_dense_cols/dense_matrix_stride;

    __attribute__((aligned(CACHELINE))) int8_t dense_matrix[] = {
    30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 
    -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, -50, 
    41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41
    };

    int8_t* output_buf_acc_rows[num_sparse_rows];
    int8_t* output_buf_model_rows[num_sparse_rows];

    for (int i = 0; i < num_sparse_rows; i += 1) {
	sparse_rows[i] = malloc(48);
	sparse_rows[i][0] = 30;
	sparse_rows[i][1] = 0;
	sparse_rows[i][2] = 50;
	sparse_rows[i][3] = 1;
	sparse_rows[i][4] = 41;
	sparse_rows[i][5] = 2;

        __attribute__((aligned(CACHELINE))) int8_t output_acc_row[num_dense_cols];  //cache align this
        output_buf_acc_rows[i] = output_acc_row; // cache align this for better perf

        output_buf_model_rows[i] = malloc(sizeof(uint8_t) * num_dense_cols);

        ROCC_INSTRUCTION_0_R_R(0, sparse_rows[i], sparse_row_size, 0);
        ROCC_INSTRUCTION_0_R_R(0, dense_matrix, dense_matrix_size, 1);
        ROCC_INSTRUCTION_0_R_R(0, output_buf_acc_rows[i], output_buf_acc_rows[i], 2);
        asm volatile("fence");

        accel_model(sparse_rows[i], sparse_row_size, dense_matrix, dense_matrix_stride, dense_matrix_size, output_buf_model_rows[i]);
        asm volatile("fence");

        printf("\nModel Output\n");
        for (int j = 0; j < num_dense_cols; j += 1) {
            printf("%d", output_buf_model_rows[i][j]);
            printf(" ");
        }

        printf("\nAccel Output\n");
        for (int j = 0; j < num_dense_cols; j += 1) {
            printf("%d", output_buf_acc_rows[i][j]);
            printf(" ");
        }

        for (int j = 0; j < num_dense_cols; j += 1) {
            if (output_buf_acc_rows[i][j] != output_buf_model_rows[i][j]) {
                printf("\nFAILED at output[%d][%d]. Expected %d. Got %d.\n", i, j, output_buf_model_rows[i][j], output_buf_acc_rows[i][j]);
                return -1;
            }
        }

        printf("\n\nPASSED !\n");
        printf("\nTest passed with maximum dense row size (128 cols, 16 section of 64bits !\n");

    }
    return 0;
}

