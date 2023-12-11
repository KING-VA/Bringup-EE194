#ifndef MIN
#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#endif

#ifndef MAX
#define MAX(x, y) (((x) > (y)) ? (x) : (y))
#endif

#define STR1(x) #x
#ifndef STR
#define STR(x) STR1(x)
#endif

#define CAT_(A, B) A##B
#define CAT(A, B) CAT_(A, B)

#define ROCC_INSTRUCTION_R_R_R(x, rd, rs1, rs2, func7)                               \
  {                                                                                  \
    asm volatile(                                                                    \
        ".insn r " STR(CAT(CUSTOM_, x)) ", " STR(0x7) ", " STR(func7) ", %0, %1, %2" \
        : "=r"(rd)                                                                   \
        : "r"(rs1), "r"(rs2));                                                       \
  }


#define ROCC_INSTRUCTION_0_R_R(x, rs1, rs2, func7)                                   \
  {                                                                                  \
    asm volatile(                                                                    \
        ".insn r " STR(CAT(CUSTOM_, x)) ", " STR(0x3) ", " STR(func7) ", x0, %0, %1" \
        :                                                                            \
        : "r"(rs1), "r"(rs2));                                                       \
  }

void rand_dense_matrix(int8_t* dense_matrix, uint8_t dense_matrix_stride, uint8_t dense_matrix_size, uint8_t num_dense_rows, uint8_t range) {
    printf("\nDense Matrix\n");
    for (uint8_t i = 0; i < num_dense_rows; i++) {
	//printf("\n");
        for (uint8_t j = 0; j < dense_matrix_size * dense_matrix_stride; j++) {
            dense_matrix[(i * dense_matrix_stride * dense_matrix_size) + j] = (rand() % range) - (range / 2);
	    printf("%d, ", dense_matrix[(i * dense_matrix_stride * dense_matrix_size) + j]);
        }
    }
}

void rand_sparse_row(int8_t* sparse_row, uint8_t sparse_row_size, uint8_t num_dense_rows, uint8_t range) {
    printf("\nSparse Row\n");
    for (uint8_t i = 0; i < 2 * sparse_row_size; i += 2) {
	sparse_row[i] = (rand() % range) - (range / 2);
        sparse_row[i + 1] = rand() % num_dense_rows;
	// printf("%d, ", sparse_row[i]);
    }
}

void accel_model(int8_t* sparse_row, uint8_t sparse_row_size, int8_t* dense_matrix, uint8_t dense_matrix_stride, uint8_t dense_matrix_size, int8_t* output_buf) {
    int32_t* temp_buf = malloc(32 * dense_matrix_stride * dense_matrix_size);
    printf("\nBeginning Model\n");
    for (uint8_t i = 0; i < dense_matrix_size * dense_matrix_stride; i++) {
        temp_buf[i] = MAX(-49280, MIN(49151, (int32_t)sparse_row[0] * (int32_t)dense_matrix[(sparse_row[1] * dense_matrix_stride * dense_matrix_size) + i]));
    }
    for (uint8_t i = 2; i < 2 * sparse_row_size; i += 2) {
        for (uint8_t j = 0; j < dense_matrix_size * dense_matrix_stride; j++) {
            temp_buf[j] = MAX(-49280, MIN(49151, temp_buf[j] + (int32_t)sparse_row[i] * (int32_t)dense_matrix[(sparse_row[i + 1] * dense_matrix_stride * dense_matrix_size) + j]));
        }
    }
    for(uint8_t i = 0; i < dense_matrix_size * dense_matrix_stride; i++){
	output_buf[i] = MAX(-128, MIN(127, temp_buf[i]));
    }
    free(temp_buf);
    printf("\nEnding Model\n");
}

// void accel_model(uint8_t* sparse_row, uint8_t sparse_row_size, uint8_t* dense_matrix, uint8_t dense_matrix_stride, uint8_t dense_matrix_size, uint8_t* output_buf) {
//     for (uint8_t i = 0; i < dense_matrix_size * dense_matrix_stride; i++) {
//         output_buf[i] = MIN(255, (sparse_row[0]& 0b00001111) * dense_matrix[(((sparse_row[0] & 0b11110000) >> 4) * dense_matrix_stride * dense_matrix_size) + i]);
//     }
//     for (uint8_t i = 1; i < sparse_row_size; i+=1) {
//         for (uint8_t j = 0; j < dense_matrix_size * dense_matrix_stride; j++) {
//             output_buf[j] = MIN(255, output_buf [j] + (sparse_row[i] & 0b00001111) * dense_matrix[(((sparse_row[i] & 0b11110000) >> 4) * dense_matrix_stride * dense_matrix_size) + j]);
//         }
//     }
// }

void rand_sparse_row_codebook(int8_t* sparse_row, uint8_t sparse_row_size, uint8_t num_dense_rows, uint8_t range) {
    printf("\nSparse Row\n");
    for (uint8_t i = 0; i < sparse_row_size; i+=1) {
        uint8_t data = rand() % range - (range / 2);
        uint8_t index = rand() % num_dense_rows;
        sparse_row[i] = (index << 4) | data;
        //printf("%d, ", sparse_row[i]);
    }
}

// range = 100 --> -50 -- 49
// creating the codebook:(range)
// void create_LUT_entry(uint8_t range, uint64_t register1, uint64_t register2) {
//     // calculating the value
//     uint8_t bin_size = range / 16;
//     for (uint8_t i = 0; i < 16; i += 1) {
//         int8_t weight = -range/2 + i * bin_size + bin_size/2; // the last bin register2[7] may have more values. 
//         printf("weight[%d] = %d", i, weight);
        
//         if (i < 8) {
//             uint64_t weight64 = ((uint64_t)weight & 0xFF) << (i * 8); 
//             weight64 &= 0x00000000000000FF << (i * 8); 
//             register1 += weight64;
//         } else {
//             uint64_t weight64 = ((uint64_t)weight & 0xFF) << ((i - 8) * 8); 
//             weight64 &= 0x00000000000000FF << ((i - 8) * 8); 
//             register2 += weight64;
//         }
//     }
//     // put in the corresponding position
// }

// process the sparse_row data to map it to correct value. (register1, register2)

// 1. map random weights to discrete bins

// 2. get the codebook value of that specific bin
// //implement golden model for calculating accel_model
// void accel_model_codebook(int8_t* sparse_row, uint8_t sparse_row_size, int8_t* dense_matrix, uint8_t dense_matrix_stride, uint8_t dense_matrix_size, int8_t* output_buf,
// uint64_t register1, uint64_t register2, uint8_t minimum) {
//     int32_t* temp_buf = malloc(32 * dense_matrix_stride * dense_matrix_size);
//     uint8_t bin_size = range / 16;
//     int32_t minimum = -(range / 2)
//     printf("\nBeginning Model\n");
//     for (uint8_t i = 0; i < dense_matrix_size * dense_matrix_stride; i++) {
//         int32_t bin_num = ((sparse_row[0] & 0b00001111) - minimum) / bin_size;
//         int32_t sparse_row0_value = minimum + bin_size / 2;
//         temp_buf[i] = MAX(-49280, MIN(49151, sparse_row0_value * (int32_t)dense_matrix[(sparse_row[1] * dense_matrix_stride * dense_matrix_size) + i]));
//     }
//     for (uint8_t i = 1; i < sparse_row_size; i += 1) {
//         for (uint8_t j = 0; j < dense_matrix_size * dense_matrix_stride; j++) {
//             int32_t bin_num = (sparse_row[i] - minimum) / bin_size;
//             int32_t sparse_row_value = minimum + bin_size * bin_num + bin_size / 2;
//             temp_buf[j] = MAX(-49280, MIN(49151, temp_buf[j] + (int32_t)sparse_row[i] * (int32_t)dense_matrix[(((sparse_row[i] & 0b11110000) >> 4) * dense_matrix_stride * dense_matrix_size) + j]));
//         }
//     }
//     for(uint8_t i = 0; i < dense_matrix_size * dense_matrix_stride; i++){
// 	    output_buf[i] = MAX(-128, MIN(127, temp_buf[i]));
//     }
//     free(temp_buf);
//     printf("\nEnding Model\n");
// }