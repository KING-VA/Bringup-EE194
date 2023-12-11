#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <inttypes.h>
#include "nearmemdma.h"

#define CACHELINE         64
#define REGION_SIZE_LINES 16 
#define STRIDE (4 * CACHELINE)

__attribute__((aligned(CACHELINE))) int8_t mem1[REGION_SIZE_LINES][CACHELINE / sizeof(int8_t)];

int16_t saturate(int32_t x) {
    int16_t max = (1 << 15) - 1;
    int16_t min = -(1 << 15);
    if (x > max) {
        return max;
    } else if (x < min) {
        return min;
    } else {
        return x;
    }
}

int main(void)
{
    puts("Initializing memory");
    for (size_t i = 0; i < REGION_SIZE_LINES; i++) {
        for (size_t j = 0; j < CACHELINE/sizeof(int8_t); j++) {
            mem1[i][j] = i + j;
        }
    }

    int8_t operandReg[sizeof(DMA1->operandReg)/sizeof(uint8_t)];
    for (size_t i = 0; i < sizeof(operandReg)/sizeof(uint8_t); i++) {
        operandReg[i] = (10)*((i > sizeof(operandReg)/sizeof(uint8_t) + 1) ? 1 : -1);
    }

    _Static_assert(sizeof(operandReg) == 64, "opreg size");

    _Static_assert(STRIDE % CACHELINE == 0, "stride not aligned");
    uint32_t count = REGION_SIZE_LINES / (STRIDE / CACHELINE);
    int16_t expected[sizeof(DMA1->destReg)/sizeof(int16_t)];
    for (size_t i = 0; i < count; i++) {
        int sum = 0;
        for (size_t j = 0; j < sizeof(operandReg)/sizeof(uint8_t); j++) {
            sum += (int16_t)operandReg[j] * (int16_t)mem1[i*(STRIDE/CACHELINE)][j];
        }
        expected[i] = saturate(sum);
    }
 
    void* src_addr = mem1;
    uint64_t stride = STRIDE;

    puts("Waiting for DMA");

    while (DMA1->status.inProgress); // wait for ready

    puts("Performing DMA");

    DMA1->srcAddr = src_addr;
    DMA1->srcStride = stride;
    DMA1->mode = MODE_MAC;
    memcpy(DMA1->operandReg, operandReg, sizeof(operandReg));
    __asm__ ("" ::: "memory");

    // wait for peripheral to complete
    DMA1->count = count;
    while (!DMA1->status.completed);
    for (size_t i = 0; i < count; i++) {
        if (expected[i] != ((volatile int16_t *)DMA1->destReg)[i]) {
            printf("Expected %d at index %ld, got %d\n", expected[i], i, ((volatile int16_t *)DMA1->destReg)[i]);
        }
    }
    printf("Dumping...\n");

    for (size_t i = 0; i < 8; i++) {
        printf("\t%016" PRIx64 "\n", DMA1->destReg[i]);
    }
    

    puts("Test complete");

    return 0;
}
