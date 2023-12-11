#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include "nearmemdma.h"

#define CACHELINE         64
#define REGION_SIZE_LINES 8

__attribute__((aligned(CACHELINE))) uint64_t mem1[CACHELINE / sizeof(uint64_t) * REGION_SIZE_LINES];
__attribute__((aligned(CACHELINE))) uint64_t mem2[CACHELINE / sizeof(uint64_t) * REGION_SIZE_LINES];

int main(void)
{
    puts("Initializing memory");
    for (size_t i = 0; i < sizeof(mem1)/sizeof(uint64_t); i++) {
        mem1[i] = i;
    }

    void* src_addr = mem1;
    void* dest_addr = mem2;
    uint64_t stride = CACHELINE;
    uint32_t count = REGION_SIZE_LINES;

    puts("Waiting for DMA");

    while (DMA1->status.inProgress); // wait for ready

    puts("Performing DMA");

    DMA1->srcAddr = src_addr;
    DMA1->destAddr = dest_addr;
    DMA1->srcStride = stride;
    DMA1->mode = MODE_COPY; 
    DMA1->count = count;

    // wait for peripheral to complete
    while (!DMA1->status.completed);

    for (size_t i = 0; i < sizeof(mem1)/sizeof(uint64_t); i++) {
        uint64_t val = mem2[i], expected = mem1[i];
        if (val != expected) {
            printf("Unexpected value at offset 0x%lx: expected %lx, got %lx\n", i, expected, val);
        }
    }

    puts("Test complete");

    return 0;
}
