#include "accelerator_funcs.h"
#include "../../../tests/rocc.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

uint64_t concatenate_uint32t(uint32_t x, uint32_t y) {
    uint64_t z = y;
    z |= ((uint64_t)x << 32);
    return z;
}

int main(void) {
    uint32_t vec_1[] = { 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000};
    uint32_t vec_2[] = { 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000, 0x40800000};
    uint32_t lower = 1; //vec #
    uint32_t upper = 4; //vec size 
    uint64_t vec_3 = concatenate_uint32t(upper, lower); //got vec3

    printf("Vec3: %lx \n",vec_3);

    lower = 2;
    uint64_t vec_4 = concatenate_uint32t(upper, lower); //got vec4

    printf("Vec4: %lx \n",vec_4);
    

    K_LOAD(vec_1, vec_3); //store vec1
    K_LOAD(vec_2, vec_4); //store vec2

    upper = 1;
    lower = 0;
    uint64_t vec_5 = concatenate_uint32t(upper, lower); //got vec5

    uint64_t rd;

    asm volatile("fence");

    K_DOT_PROD(rd, vec_5, vec_4);

    asm volatile("fence");

    printf("Expecting dot product to be 128 (0x43000000), is: %lx \n", rd);


    return 0;
}