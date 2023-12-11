#include <stdio.h>
#include <stdint.h>
#include "bearlyml23.h"

void delay(int n) {
    for(int i = 0; i < n; i++) {
        asm("nop");
    }
}

//FREQUENCY SETTINGS
void init() {
    PLL->RATIO = 8;
    PLL->FRACTION = 0;
    PLL->MDIV_RATIO = 1;
    PLL->ZDIV0_RATIO = 2;
    PLL->ZDIV0_RATIO_P5 = 0;
    PLL->ZDIV1_RATIO = 4;
    PLL->ZDIV1_RATIO_P5 = 0;
    PLL->VCODIV_RATIO = 0;
}

int main(void)
{
    init();
    delay(1);
    PLL-> POWERGOOD_VNN = 1;
    PLL-> LDO_ENABLE = 1;
    delay(5);
    PLL-> PLLFWEN_B = 1;
    delay(5);
    PLL-> PLLEN = 1;

    delay(500);
    printf("Hello Jason, it's me the PLL.\n");
    return 0;
}



