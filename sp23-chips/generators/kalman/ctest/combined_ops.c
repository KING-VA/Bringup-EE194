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

//Loads in a vector of 4's, then adds 4, then multiplies by 4, then get dots product result with a vector of 4's to get 1024

int main(void) {
    printf("starting Combined test [(4 + 4) * 4] x8 dot [4] x8 = 1024 \n");


    uint32_t * vec_1 = malloc(8 * sizeof(uint32_t));
    uint32_t * vec_2 = malloc(8 * sizeof(uint32_t));
    uint32_t * vec_7 = malloc(8 * sizeof(uint32_t));
    int i;
    
    for (i = 0; i < 8; i++) {
        vec_1[i] = 0x40800000;
        vec_2[i] = 0x40800000;
        vec_7[i] = 0x40800000;
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

    K_LOAD(vec_7, 0x0000000800000002);

    printf("Done with third load\n");
    //Adding 0 to 1 storing result in 3
    upper = 0;
    lower = 3;
    uint64_t vec_5 = concatenate_uint32t(upper, lower);
    asm volatile("fence");
    K_ADD(vec_5, vec_4);
    asm volatile("fence");
    printf("Done with Add \n");

    //Multiplying 2 by 3, storing result in 0
    K_MUL(0x0000000100000000, 0x0000000000000002);

    printf("Done with Mul \n");

    //Should be all 32's in the vector now, dot producting 0 by 1 storing result in rd
    asm volatile("fence");

    uint64_t rd;
    printf("starting dot prod \n");
    K_DOT_PROD(rd, 0x0000000100000000, 0x0000000000000008);

    asm volatile("fence");

    printf("Expecting dot product to be 1024 (0x43000000), is: %lx \n", rd);

    return 0;
}