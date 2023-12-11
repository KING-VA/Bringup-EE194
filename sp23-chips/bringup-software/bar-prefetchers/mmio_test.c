#include "../../tests/mmio.h"

/*
 * This is a sample test to show how to turn the prefetcher on and off.
 * The prefetcher initially starts in the "off" state.
 * */

#define PREFETCHER_EN 0x10050000

int main( int argc, char* argv[] ) {
    /*unsigned int mmio_addr = 0x1000;
 *     unsigned int data = 1;
 *         asm ("sw %0, 0(%1)" : : "r"(data), "r"(mmio_addr)); //MAGICALLY STARTED WORKING DO NOT TOUCH*/

    uint8_t enable = 1;
    reg_write8(PREFETCHER_EN, enable);

    int array[1024];

    for (int i=0; i<1024; i++) {
        array[i] = 0;
    }

    enable = 0;
    reg_write8(PREFETCHER_EN, enable);

    int array2[1024];

    for (int i=0; i<1024; i++) {
        array2[i] = 0;
    }

    return 0;
}
