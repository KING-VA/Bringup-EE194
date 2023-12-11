#include <nearmemdma/nearmemdma.h>
#include <nearmemdma/dma.h>
#include <string.h>

#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) < (b) ? (a) : (b))

_Static_assert((NEARMEMDMA_OPSZ & -NEARMEMDMA_OPSZ) == NEARMEMDMA_OPSZ, "opsz must have exactly one bit set");
_Static_assert(NEARMEMDMA_NBANKS == (sizeof(nearmemdma_engines) / sizeof(nearmemdma*)), "NBANKS not consistent with engines");
_Static_assert(NEARMEMDMA_OPSZ == sizeof(((nearmemdma*)NULL)->operandReg), "OPSZ wrong");

#define HINT_SPIN() do { } while(0)

int nearmemdma_dotp_i8(int8_t *v1, int8_t *v2s, int16_t *out, size_t vlen, size_t v2_stride, size_t v2_count) {
    if (((size_t)v2s & (NEARMEMDMA_OPSZ - 1)) != 0) {
        return -NEARMEMDMA_ENOTALIGNED;
    }
    if ((v2_stride & (NEARMEMDMA_OPSZ - 1)) != 0) {
        return -NEARMEMDMA_ENOTALIGNED;
    }

    size_t stride_in_banks = v2_stride / NEARMEMDMA_OPSZ;
    if (stride_in_banks % NEARMEMDMA_NBANKS != 0) {
        // For now, only handle when stride is a multiple of NBANKS
        return -NEARMEMDMA_ESTRIDENOTMULTIPLE;
    }

    if (v2_count > (NEARMEMDMA_OPSZ / sizeof(int16_t))) {
        return -NEARMEMDMA_ECOUNTTOOBIG;
    }

    size_t start_bank = (((size_t)v2s) / NEARMEMDMA_OPSZ) % NEARMEMDMA_NBANKS;

    nearmemdma control_copy[NEARMEMDMA_NBANKS] = {};

    nearmemdma* curr_bank = control_copy + start_bank;
    memset(curr_bank->operandReg, 0, sizeof(curr_bank->operandReg));
    memcpy(curr_bank->operandReg, v1, min(vlen, sizeof(curr_bank->operandReg)));

    curr_bank->count = v2_count;
    curr_bank->mode = NEARMEMDMA_MODE_MAC;
    curr_bank->srcStride = v2_stride;
    curr_bank->srcAddr = v2s;

    volatile nearmemdma* curr_bank_real = nearmemdma_engines[start_bank];
    while (curr_bank_real->status.inProgress) { HINT_SPIN(); }
    curr_bank_real->mode = curr_bank->mode;
    for (unsigned int i = 0; i < sizeof(curr_bank->operandReg) / sizeof(curr_bank->operandReg[0]); i++) {
        curr_bank_real->operandReg[i] = curr_bank->operandReg[i];
    }
    curr_bank_real->srcStride = curr_bank->srcStride;
    curr_bank_real->srcAddr = curr_bank->srcAddr;

    // start operation
    curr_bank_real->count = curr_bank->count;

    if (curr_bank_real->status.error) {
        return -NEARMEMDMA_EFAILED;
    }

    while (!curr_bank_real->status.completed) { HINT_SPIN(); }

    if (curr_bank_real->status.error) {
        return -NEARMEMDMA_EFAILED;
    }

    for (unsigned int i = 0; i < sizeof(curr_bank->destReg) / sizeof(curr_bank->destReg[0]); i++) {
        curr_bank->destReg[i] = curr_bank_real->destReg[i];
    }
    memcpy(out, curr_bank->destReg, min(vlen, sizeof(curr_bank->destReg)));

    return 0;
}
