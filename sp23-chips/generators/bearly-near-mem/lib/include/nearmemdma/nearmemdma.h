#ifndef NEARMEMDMA_NEARMEMDMA_H
#define NEARMEMDMA_NEARMEMDMA_H

#include <stdint.h>
#include <stddef.h>

#include "dma.h"

int nearmemdma_dotp_i8(int8_t *v1, int8_t *v2s, int16_t *out, size_t vlen, size_t v2_stride, size_t v2_count);

#define NEARMEMDMA_OP_ALIGN NEARMEMDMA_OPSZ

#define NEARMEMDMA_ENOTALIGNED 0x5
#define NEARMEMDMA_EFAILED 0x6

// errors from currently unimplemented features
#define NEARMEMDMA_ESTRIDENOTMULTIPLE 0x16
#define NEARMEMDMA_ECOUNTTOOBIG 0x17
#define NEARMEMDMA_ELENTOOBIT 0x18

#endif // NEARMEMDMA_NEARMEMDMA_H