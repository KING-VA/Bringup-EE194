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

 int8_t sparse_row[] = {-7,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0};
 int8_t sparse_row_size = 8;

 __attribute__((aligned(CACHELINE))) int8_t dense_matrix[] = {1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,
                                                              1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,};
                       
 int8_t dense_matrix_size = 8;

 int16_t output_buf[100];

 ROCC_INSTRUCTION_0_R_R(0, sparse_row,sparse_row_size,0);
 ROCC_INSTRUCTION_0_R_R(0, dense_matrix,dense_matrix_size,1);
 ROCC_INSTRUCTION_0_R_R(0, output_buf,output_buf,2);
 asm volatile("fence");

 //Since Rocc is issuing L2 requests now, it is actually unaware of Fence Instruction
 //So it's safe to to wait for many cycles before checking the result
 //But you still can issue the next acceleration instructions 
 for(int i = 0; i < 100; i++){
  ;
 }
 if (output_buf[0] !=- 7){
    printf("\nTest Failed\n");
    printf("got %d",  output_buf[0]);
 }
 else {
    printf("\nPASSED!\n"); 
 }
 
return 0;


}
