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
    //uint16_t vec_1[] = { 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004};
    uint32_t * vec_1 = malloc(8 * sizeof(uint32_t));
    int i;
    
    for (i = 0; i < 8; i++) {
        vec_1[i] = 0x40800000;
    }
    uint32_t upper = 8;//vec size in words
    uint32_t lower = 0; //vec #
    uint64_t vec_2 = concatenate_uint32t(upper, lower); //got vec2
    

    printf("Address of vec_1 is: %p \n", vec_1);
    printf("First element of vec_1 is: %x \n", vec_1[0]);

    printf("Vec2: %lx \n",vec_2);
    asm volatile("fence");
    K_LOAD(vec_1, vec_2);
    asm volatile("fence");

    uint32_t vec_empty[] = { 0, 0, 0, 0, 0, 0, 0, 0};
    asm volatile("fence");
    K_STORE(vec_empty, vec_2);
    asm volatile("fence");
    for (i = 0; i < 8; i++) {
        printf("Expecting num #%d in vec to be %x, is: %x \n", i, vec_1[i] , vec_empty[i]);
    }

    uint32_t seven_vec[] = {0x40E00000, 0x40E00000, 0x40E00000, 0x40E00000, 0x40E00000, 0x40E00000, 0x40E00000};
    //uint16_t * seven_vec = malloc(7 * sizeof(uint16_t));
    for (i = 0; i < 7; i++) {
        seven_vec[i] = 0x40E00000;
    }
    uint32_t empty_vec2[] = {0, 0, 0, 0, 0, 0, 0, 0};
    uint64_t load_details = 0x0000011100000001;
    printf("Testing second vector where 7 elements are loaded and stored \n");
    printf("Preforming Load \n");
    asm volatile("fence");
    K_LOAD(seven_vec, load_details);
    asm volatile("fence");
    printf("Preforming Store \n");
    K_STORE(empty_vec2, load_details);
    asm volatile("fence");
    for (i = 0; i < 7; i++) {
        printf("Expecting num #%d in vec to be %x, is: %x \n", i, seven_vec[i] , empty_vec2[i]);
    }
    printf("Expecting num #7 in vec to be 0, is: %x \n",  empty_vec2[7]);
    printf("Done! \n");
    return 0;
}