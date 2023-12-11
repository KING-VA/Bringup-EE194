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
    printf("starting \n");


    uint32_t * vec_1 = malloc(8 * sizeof(uint32_t));
    uint32_t * vec_2 = malloc(8 * sizeof(uint32_t));
    int i;
    
    for (i = 0; i < 8; i++) {
        vec_1[i] = 0x40800000;
        vec_2[i] = 0x41000000;
    }
    uint32_t upper = 8; 
    uint32_t lower = 0; 
    uint64_t vec_3 = concatenate_uint32t(upper, lower); //got vec3

    printf("Vec3: %lx \n",vec_3);

    lower = 1;
    uint64_t vec_4 = concatenate_uint32t(upper, lower); //got vec4

    printf("Vec4: %lx \n",vec_4);
    

    K_LOAD(vec_1, vec_3); //store vec1

    printf("Done with first load \n");
    K_LOAD(vec_2, vec_4); //store vec2

    printf("Done with second load \n");

    upper = 0;
    lower = 2;
    uint64_t vec_5 = concatenate_uint32t(upper, lower);
    asm volatile("fence");
    K_SUB(vec_5, vec_4);
    asm volatile("fence");
    printf("Done with Add \n");
    upper = 8;
    uint64_t vec_6 = concatenate_uint32t(upper, lower);

    uint32_t vec_empty[] = { 0, 0, 0, 0, 0, 0, 0, 0};
    asm volatile("fence");
    K_STORE(vec_empty, vec_6);
    asm volatile("fence");


    for (i = 0; i < 8; i++) {
        printf("Expecting subtraction result #%d in vec to be 0x40800000, is: %x \n", i, vec_empty[i]);
    }

    return 0;
}