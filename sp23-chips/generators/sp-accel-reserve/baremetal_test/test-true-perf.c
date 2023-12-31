#include <inttypes.h>
#include <stdio.h>
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

#define CACHELINE 64

int main(void)
{

  /*
 int8_t sparse_row[] = {7,2,  7,3,  7,5,  7,7,  7,11,  7,13,  7,17,  7,19,  7,23,  7,29,  7,31, 7,37,  
                        7,41,  7,43,  7,47,  7,53,  7,59,  7,61,  7,67,  7,71,  7,73,  7,79,  7,83, 7,89,  
                        7,91,  7,97,  7,100,  7,105,  7,110,  7,115,  7,120,  7,140,  7,160,  7,180,  7,200, 7,230,  
                        7,235,  7,236,  7,237,  7,238,  7,239,  7,240,  7,241,  7,242,  7,243,  7,244,  7,245, 7,246,  
                        7,2,  7,3,  7,5,  7,7,  7,11,  7,13,  7,17,  7,19,  7,23,  7,29,  7,31, 7,37,
                        7,2,  7,3,  7,5,  7,7,};
  */
 int8_t sparse_row[] = {7,2,  7,3,  7,5,  7,7};
 
 int8_t sparse_row_size = 4;

 // 250 X 8 dense_matrix
 __attribute__((aligned(CACHELINE))) int8_t dense_matrix[] = {1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                          1,1,1,1,1,1,1,1, 2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,5,5,5,5, 6,6,6,6,6,6,6,6, 7,7,7,7,7,7,7,7,8, 8,8,8,8,8,8,8, 9,9,9,9,9,9,9,9, 10,10,10,10,10,10,10,10,
                       };

 int8_t dense_matrix_size = 8;

 int16_t output_buf[100];

 ROCC_INSTRUCTION_0_R_R(0, sparse_row,sparse_row_size,0);
 ROCC_INSTRUCTION_0_R_R(0, dense_matrix,dense_matrix_size,1);
 ROCC_INSTRUCTION_0_R_R(0, output_buf,output_buf,2);
 asm volatile("fence");

 ROCC_INSTRUCTION_0_R_R(0, sparse_row,sparse_row_size,0);
 ROCC_INSTRUCTION_0_R_R(0, dense_matrix,dense_matrix_size,1);
 ROCC_INSTRUCTION_0_R_R(0, output_buf,output_buf,2);
 asm volatile("fence");


printf("\nfinished true perf simulation!\n"); 
return 0;


}
