#include <stdio.h>
#include <stdint.h>
#include "bearlyml23.h"

int main() {
    PLL->FZ_TIGHT_LOOPB = 10;
    PLL->FZ_TIGHT_LOOPB = 2;
    PLL->POWERGOOD_VNN = 1;
    PLL->PLLEN = 1;
    PLL->LDO_ENABLE = 1;
    
    printf("\nhello world\n");
    return 0;
}
