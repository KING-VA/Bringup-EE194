#include "rocc.h"
// check if need to code address using special regs!!!!!!!!1
#include <inttypes.h>
#include <assert.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

float dot_product(float v[], float u[], int n)
{
    float result = 0.0;
    for (int i = 0; i < n; i++)
        result += v[i]*u[i];
    return result;
}

// this is a simplified version of test
// all vector are preset, no need to append zeros and only take 1 fold
int main() {
    // --------------- CASE 1 ---------------------------
    float t_row1[4] = {1.1, 2.2, 3.3, -4.4 };
    float y_xhat1[4] = {-1, 2, 3, 4};
    
    uint32_t sum = 0;

    asm volatile ("fence");
    ROCC_INSTRUCTION_SS(0, t_row1, y_xhat1, 0);   // passing two vector base       
    ROCC_INSTRUCTION_DS(0, sum, 4, 1);  // passing result pointer and the length
    asm volatile ("fence");

    float a = dot_product (t_row1, y_xhat1, 4);
    uint32_t gtruth = *((uint32_t*)& (a));
    printf("result sum  %x \n", sum);

    printf("truth  %x  \n", gtruth);
    printf("-------------end of case 1-------------------\n");
    
    // --------------- CASE 2 ---------------------------
    float t_row2[5] = {1.1, 2.2, 3.3, -4.4, 7};
    float y_xhat2[5] = {-1, 2, 3, 4, 98};
    
    uint32_t sum_2 = 0;

    asm volatile ("fence");
    ROCC_INSTRUCTION_SS(0, t_row2, y_xhat2, 0);   // passing two vector base       
    ROCC_INSTRUCTION_DS(0, sum_2, 5, 1);  // passing result pointer and the length
    asm volatile ("fence");

    a = dot_product (t_row2, y_xhat2, 5);
    gtruth = *((uint32_t*)& (a));
    printf("result sum  %x \n", sum_2);

    printf("truth  %x  \n", gtruth);
    printf("-------------end of case 2-------------------\n");

    float t_row3[15] = {1.1, 2.2, 3.3, -424.4, 7, 1.1, 2.2, 3.3, -4.4, 7, 1.1, 2.2, 3.3, -4.4, 7};
    float y_xhat3[15] = {-1, 2, 3, 4, 98, -1, 2, 3, 4, 98, -1, 2, 3, 4, 98};

    asm volatile ("fence");
    ROCC_INSTRUCTION_SS(0, t_row3, y_xhat3, 0);   // passing two vector base       
    ROCC_INSTRUCTION_DS(0, sum_2, 15, 1);  // passing result pointer and the length
    asm volatile ("fence");

    a = dot_product (t_row3, y_xhat3, 15);
    gtruth = *((uint32_t*)& (a));
    printf("result sum  %x \n", sum_2);

    printf("truth  %x  \n", gtruth);
    printf("-------------end of case 3-------------------\n");
    return 0;
}
