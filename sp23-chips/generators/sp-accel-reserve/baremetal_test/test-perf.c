#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef MIN
#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#endif

#ifndef MAX
#define MAX(x, y) (((x) > (y)) ? (x) : (y))
#endif

#define STR1(x) #x
#ifndef STR
#define STR(x) STR1(x)
#endif

#define CAT_(A, B) A##B
#define CAT(A, B) CAT_(A, B)

#define ROCC_INSTRUCTION_R_R_R(x, rd, rs1, rs2, func7)                               \
  {                                                                                  \
    asm volatile(                                                                    \
        ".insn r " STR(CAT(CUSTOM_, x)) ", " STR(0x7) ", " STR(func7) ", %0, %1, %2" \
        : "=r"(rd)                                                                   \
        : "r"(rs1), "r"(rs2));                                                       \
  }


#define ROCC_INSTRUCTION_0_R_R(x, rs1, rs2, func7)                                   \
  {                                                                                  \
    asm volatile(                                                                    \
        ".insn r " STR(CAT(CUSTOM_, x)) ", " STR(0x3) ", " STR(func7) ", x0, %0, %1" \
        :                                                                            \
        : "r"(rs1), "r"(rs2));                                                       \
  }



void rand_dense_matrix(int8_t* dense_matrix, int8_t dense_matrix_stride, int8_t dense_matrix_size, int8_t num_dense_rows) {
    //printf("\nDense Matrix\n");
    for (int8_t i = 0; i < num_dense_rows; i++) {
        for (int8_t j = 0; j < dense_matrix_size * dense_matrix_stride; j++) {
            dense_matrix[(i * dense_matrix_stride * dense_matrix_size) + j] = (rand() % 255) - 128;
            //printf("%d", dense_matrix[(i * dense_matrix_stride * dense_matrix_size) + j]);
            //printf(" ");
        }
        //printf("\n");
    }
}

void rand_sparse_row(int8_t* sparse_row, int8_t sparse_row_size, int8_t num_dense_rows) {
    //printf("\nSparse Row\n");
    for (int8_t i = 0; i <  2 * sparse_row_size; i+=2) {
        sparse_row[i] = (rand() % 255) - 128;
        sparse_row[i+1] = i % num_dense_rows;
        //printf("%d", sparse_row[i]);
        //printf(" ");
        //printf("%d", sparse_row[i+1]);
        //printf(", ");
    }
}

#define CACHELINE 64


int main(void)
{   
    /* Sparse Matrix Specs - 1 x 96 elems */
    int num_sparse_rows = 10;
    int8_t* sparse_rows[num_sparse_rows];
    int num_sparse_cols = 44;
    int sparse_row_size = num_sparse_cols;

    
    int num_dense_rows = num_sparse_cols;


    int8_t num_dense_cols = 64;
    int8_t dense_matrix_stride = 8;
    int8_t dense_matrix_size = num_dense_cols/dense_matrix_stride;


    
    __attribute__((aligned(CACHELINE))) int8_t dense_matrix[dense_matrix_size * num_dense_rows * dense_matrix_stride];

    rand_dense_matrix(dense_matrix, dense_matrix_stride, dense_matrix_size, num_dense_rows);

    int16_t* output_buf_acc_rows[num_sparse_rows];

    for (int i = 0; i < num_sparse_rows; i += 1){
        sparse_rows[i] = malloc(sizeof(int8_t) * num_sparse_cols * 2);
        output_buf_acc_rows[i] = malloc(sizeof(int16_t) * num_dense_cols);
        rand_sparse_row(sparse_rows[i], sparse_row_size, num_dense_rows);
    }
    
    for (int i = 0; i < num_sparse_rows; i += 1) {

        ROCC_INSTRUCTION_0_R_R(0, sparse_rows[i], sparse_row_size, 0);
        ROCC_INSTRUCTION_0_R_R(0, dense_matrix, dense_matrix_size, 1);
        ROCC_INSTRUCTION_0_R_R(0, output_buf_acc_rows[i], output_buf_acc_rows[i], 2);
        asm volatile("fence");        
    }
    
    printf("\n\n Perf evaluation finished !\n");
    return 0;
}
