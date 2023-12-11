#include <stdio.h>

#include "rv_core.h"
#include "bearlyml23.h"

// EDIT THIS
static size_t n_cores = 4;

static void __attribute__((noinline)) barrier() {
  static volatile int sense;
  static volatile int count;
  static __thread int threadsense;

  __sync_synchronize();

  threadsense = !threadsense;
  if (__sync_fetch_and_add(&count, 1) == n_cores-1)
  {
    count = 0;
    sense = threadsense;
  }
  else while(sense != threadsense)
    ;

  __sync_synchronize();
}

void __main(void) {
  size_t mhartid = READ_CSR("mhartid");

  if (mhartid >= n_cores) while (1);

  for (size_t i=0; i<n_cores; i+=1) {
    if (mhartid == i) {
      printf("Hello world from core #%lu\n", mhartid);
    }
    barrier();
  }

  // Spin if not core 0
  if (mhartid > 0) while (1);
}

int main(void) {
  RCC->TILE0_RESET = 0;
  RCC->TILE1_RESET = 0;
  RCC->TILE2_RESET = 0;
  RCC->TILE3_RESET = 0;
  __main();
  return 0;
}
