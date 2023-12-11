#include "../../../tests/mmio.h"
#include <assert.h>
#include <stdio.h>
#include <inttypes.h>

/*
 * This is a sample test to show how to turn the prefetcher on and off.
 * The prefetcher initially starts in the "off" state.
 * */

#define PREFETCHER_EN 0x10050000
#define DATA_SIZE 512
#define STRIDE 16

static uint64_t read_cycles() {
    uint64_t cycles;
    asm volatile ("rdcycle %0" : "=r" (cycles));
    return cycles;
}

int main( int argc, char* argv[] ) {
    /*unsigned int mmio_addr = 0x1000;
 *     unsigned int data = 1;
 *         asm ("sw %0, 0(%1)" : : "r"(data), "r"(mmio_addr)); //MAGICALLY STARTED WORKING DO NOT TOUCH*/

    uint8_t enable = 1;
    reg_write8(PREFETCHER_EN, enable);
    uint64_t start, end, with_pref_cycles, without_pref_cycles;
    int array[DATA_SIZE];
    int array2[DATA_SIZE];

    start = read_cycles();
    //Workload start
    for (int i=0; i<DATA_SIZE; i+=STRIDE) {
        array[i] = 0;
    }
    //Workload end
    end = read_cycles();
    with_pref_cycles = end-start;
    printf("Cycles with prefetcher: %" PRIu64 "\n", with_pref_cycles);

    enable = 0;
    reg_write8(PREFETCHER_EN, enable);
    
    start = read_cycles();
    //Workload start
    for (int i=0; i<DATA_SIZE; i+=STRIDE) {
        array2[i] = 0;
    }
    //Workload end
    end = read_cycles();
    without_pref_cycles = end-start;
    printf("Cycles without prefetcher: %" PRIu64 "\n", without_pref_cycles);

    return !(with_pref_cycles < without_pref_cycles * 0.95);
}

