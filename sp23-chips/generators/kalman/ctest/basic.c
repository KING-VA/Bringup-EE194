#include "../../../tests/rocc.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include "accelerator_funcs.h"

/*int opcode_add = 0b1;
int opcode_sub = 1;
int opcode_mul = 2;
int opcode_div = 3;
int opcode_dotprod = 4;*/

void split_uint64(uint64_t input, uint32_t* upper, uint32_t* lower) {
    *upper = (uint32_t)(input >> 32);
    *lower = (uint32_t)(input & 0xFFFFFFFF);
}

/*int main(void) {

uint64_t input = 0x123456789ABCDEF0;
uint32_t upper, lower;
split_uint64(input, &upper, &lower);
printf("Input: %016llX\nUpper: %08X\nLower: %08X\n", input, upper, lower);

}*/

void test_vec_add(void) {
  uint32_t vec_1[] = { 0x3f000000, 0x3f000000};
  uint32_t vec_2[] = {0x3fc00000, 0x3fc00000};
  uint64_t vec_o;
  printf("Vec Add Test \n");

  printf("vec1[0] = %x \n", vec_1[0]);
  printf("vec2[0] = %x \n", vec_2[0]);
  printf("vec1[1] = %x \n", vec_1[1]);
  printf("vec2[1] = %x \n", vec_2[1]);


  /* Fence to ensure inputs are ready to be shared between core and RoCC accelerator, no pending accesses */
  asm volatile("fence");

   printf("post-fence1\n");

  /* Issue a RoCC instruction with opcode custom1, rd, rs1, rs2, funct7 */
  K_LOAD(vec_1,vec_2);
  K_STORE(vec_1,vec_2);
  //K_DOT_PROD(vec_o,vec_1,vec_2);
  ROCC_INSTRUCTION_DSS(1, vec_o, vec_1, vec_2, 0);

  /* Fence waits for de-assertion of busy signal, to ensure the RoCC accelerator has completed its task */
  asm volatile("fence");

  printf("post-fence2\n");


  printf("veco expected: 0x4000000040000000 \n");
  printf("veco = %lx \n", vec_o);
}

void test_vec_sub(void) {
  uint32_t vec_1[] = { 0x3f000000, 0x3f000000};
  uint32_t vec_2[] = {0x3fc00000, 0x3fc00000};
  uint64_t vec_o;
  printf("Vec Sub Test \n");

  printf("vec1[0] = %x \n", vec_1[0]);
  printf("vec2[0] = %x \n", vec_2[0]);
  printf("vec1[1] = %x \n", vec_1[1]);
  printf("vec2[1] = %x \n", vec_2[1]);

  /* Fence to ensure inputs are ready to be shared between core and RoCC accelerator, no pending accesses */
  asm volatile("fence");

   printf("post-fence1\n");

  /* Issue a RoCC instruction with opcode custom1, rd, rs1, rs2, funct7 */
  ROCC_INSTRUCTION_DSS(1, vec_o, vec_1, vec_2, 1);

  /* Fence waits for de-assertion of busy signal, to ensure the RoCC accelerator has completed its task */
  asm volatile("fence");

  printf("post-fence2\n");



  printf("veco expected: 0xbf000000bf000000 \n");
  printf("veco = %lx \n", vec_o);
}

void test_vec_mul(void) {
  uint32_t vec_1[] = { 0x3f000000, 0x3f000000};
  uint32_t vec_2[] = {0x3fc00000, 0x3fc00000};
  uint64_t vec_o;
  printf("Vec Mul Test \n");

  printf("vec1[0] = %x \n", vec_1[0]);
  printf("vec2[0] = %x \n", vec_2[0]);
  printf("vec1[1] = %x \n", vec_1[1]);
  printf("vec2[1] = %x \n", vec_2[1]);

  /* Fence to ensure inputs are ready to be shared between core and RoCC accelerator, no pending accesses */
  asm volatile("fence");

   printf("post-fence1\n");

  /* Issue a RoCC instruction with opcode custom1, rd, rs1, rs2, funct7 */
  ROCC_INSTRUCTION_DSS(1, vec_o, vec_1, vec_2, 2);

  /* Fence waits for de-assertion of busy signal, to ensure the RoCC accelerator has completed its task */
  asm volatile("fence");

  printf("post-fence2\n");


  printf("veco expected: 0x3f4000003f400000 \n");
  printf("veco = %lx \n", vec_o);
}

void test_vec_div(void) {
  uint32_t vec_1[] = { 0x40a00000, 0x40a00000};
  uint32_t vec_2[] = { 0x3f4ccccd, 0x3f4ccccd};
  uint64_t vec_o;
  printf("Vec Div Test \n");
  printf("vec1[0] = %x \n", vec_1[0]);
  printf("vec2[0] = %x \n", vec_2[0]);
  printf("vec1[1] = %x \n", vec_1[1]);
  printf("vec2[1] = %x \n", vec_2[1]);


  /* Fence to ensure inputs are ready to be shared between core and RoCC accelerator, no pending accesses */
  asm volatile("fence");

   printf("post-fence1\n");

  /* Issue a RoCC instruction with opcode custom1, rd, rs1, rs2, funct7 */
  ROCC_INSTRUCTION_DSS(1, vec_o, vec_1, vec_2, 3);

  /* Fence waits for de-assertion of busy signal, to ensure the RoCC accelerator has completed its task */
  asm volatile("fence");

  printf("post-fence2\n");


  printf("veco expected: 0x40c8000040c80000 \n");
  printf("veco = %lx \n", vec_o);
}

void test_vec_dotprod(void) {
  uint32_t vec_1[] = { 0x3fc00000, 0x40200000};
  uint32_t vec_2[] = { 0x40400000, 0x40400000};
  uint64_t vec_o;
  printf("Vec Dot-Product Test \n");


  printf("vec1[0] = %x \n", vec_1[0]);
  printf("vec2[0] = %x \n", vec_2[0]);
  printf("vec1[1] = %x \n", vec_1[1]);
  printf("vec2[1] = %x \n", vec_2[1]);

  /* Fence to ensure inputs are ready to be shared between core and RoCC accelerator, no pending accesses */
  asm volatile("fence");

   printf("post-fence1\n");

  /* Issue a RoCC instruction with opcode custom1, rd, rs1, rs2, funct7 */
  ROCC_INSTRUCTION_DSS(1, vec_o, vec_1, vec_2, 4);

  /* Fence waits for de-assertion of busy signal, to ensure the RoCC accelerator has completed its task */
  asm volatile("fence");

  printf("post-fence2\n");


  printf("veco expected: 0x0000000041400000 \n");
  printf("veco = %lx \n", vec_o);
}

int main(void) {

  test_vec_add();
  test_vec_sub();
  //test_vec_mul();
  //test_vec_div();
  test_vec_dotprod();
  return 0;
}

