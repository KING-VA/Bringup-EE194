#ifndef NEARMEMDMA_DMA_H
#define NEARMEMDMA_DMA_H

#include <stdint.h>

typedef struct nearmemdma_status {
    uint64_t error : 1;
    uint64_t completed : 1;
    uint64_t inProgress : 1;
} nearmemdma_status;

_Static_assert(sizeof(nearmemdma_status) == 8, "dma_status size check");
#define NEARMEMDMA_MODE_COPY 0
#define NEARMEMDMA_MODE_MAC 2

typedef struct nearmemdma {
    nearmemdma_status status;
    uint64_t mode;
    void* srcAddr;
    void* destAddr;
    uint64_t srcStride;
    uint32_t count;
    uint64_t unused0[2];
    uint64_t operandReg[8];
    uint64_t destReg[8];
} nearmemdma;

#define NEARMEMDMA1 ((volatile nearmemdma*) 0x8800000)
#define NEARMEMDMA2 ((volatile nearmemdma*) 0x8801000)
#define NEARMEMDMA3 ((volatile nearmemdma*) 0x8802000)
#define NEARMEMDMA4 ((volatile nearmemdma*) 0x8803000)

#define NEARMEMDMA_OPSZ 64

static volatile nearmemdma *nearmemdma_engines[] = {
    NEARMEMDMA1,
    NEARMEMDMA2,
    NEARMEMDMA3,
    NEARMEMDMA4,
};

#define NEARMEMDMA_NBANKS 4

#endif // NEARMEMDMA_DMA_H
