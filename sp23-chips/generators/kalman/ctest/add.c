#include "accelerator_funcs.h"
#include "../../../tests/rocc.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    printf("starting add test\n");
    uint32_t* vec_0 = malloc(8 * sizeof(uint32_t));
    uint32_t* vec_1 = malloc(8 * sizeof(uint32_t));
    uint32_t* vec_out = malloc(8 * sizeof(uint32_t));
    for (int i = 0; i < 8; i++) {
        vec_0[i] = 0x40800000;
        vec_1[i] = 0x40800000;
    }

    asm volatile("fence");
    K_SET_OUT(2);
    asm volatile("fence");

    asm volatile("fence");
    K_LOAD(0, vec_0);
    asm volatile("fence");

    asm volatile("fence");
    K_LOAD(1, vec_1);
    asm volatile("fence");

    asm volatile("fence");
    K_ADD(0, 1)
    asm volatile("fence");

    asm volatile("fence");
    K_STORE(2, vec_out);
    asm volatile("fence");

    for (int i = 0; i < 8; i++) {
        printf("Expecting addition result #%d in vec to be 0x41000000, is: %x \n", i, vec_out[i]);
    }

    return 0;
}