#include <nearmemdma/nearmemdma.h>
#include <stdint.h>
#include <stdio.h>

#define REGION_SIZE_LINES 16 
#define STRIDE (4 * NEARMEMDMA_OP_ALIGN)

__attribute__((aligned(NEARMEMDMA_OP_ALIGN))) int8_t mem1[REGION_SIZE_LINES][NEARMEMDMA_OP_ALIGN / sizeof(int8_t)];

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

int main() {
    
    void *v2addr = mem1;
    uint64_t stride = STRIDE;
    uint32_t count = REGION_SIZE_LINES / (STRIDE / NEARMEMDMA_OP_ALIGN);
    int8_t v1Buf[REGION_SIZE_LINES/sizeof(uint8_t)];
    int16_t out[REGION_SIZE_LINES/sizeof(int16_t)];

    for (size_t i = 0; i < REGION_SIZE_LINES; i++) {
        for (size_t j = 0; j < NEARMEMDMA_OP_ALIGN/sizeof(int8_t); j++) {
            mem1[i][j] = i + j;
        }
    }

    for (size_t i = 0; i < sizeof(v1Buf)/sizeof(uint8_t); i++) {
        v1Buf[i] = (i + 3) * (i & 1 ? -1 : 1);
    }

    nearmemdma_dotp_i8(v1Buf, v2addr, out, sizeof(v1Buf), stride, count);

    int16_t expected[REGION_SIZE_LINES/sizeof(int16_t)];

    for (size_t i = 0; i < count; i++) {
        int32_t sum = 0;
        for (size_t j = 0; j < sizeof(v1Buf)/sizeof(uint8_t); j++) {
            sum += (int16_t)v1Buf[j] * (int16_t)mem1[i*(STRIDE/NEARMEMDMA_OP_ALIGN)][j];
        }
        expected[i] = saturate(sum);
    }

    for (size_t i = 0; i < count; i++) {
        if (expected[i] != out[i]) {
            printf("Expected %d at index %ld, got %d\n", expected[i], i, out[i]);
        }
    }


}