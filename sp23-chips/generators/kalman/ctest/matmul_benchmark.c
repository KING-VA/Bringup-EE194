#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include "accelerator_funcs.h"
#include "../../../tests/rocc.h"



/* C <- A + B */


void mul_software(float * a, float * b, float * c, int n) {
    int j;
    for(j=0; j< n; j += 1) {
        c[j] = a[j] * b[j];
    }
}

int main(void) {
    int j;
    
    float* arr1;
    float* arr2;
    //float* arr3;
   
   

    // Allocate memory for the arrays
    arr1 = (float*) malloc(64 * sizeof(float));
    arr2 = (float*) malloc(64 * sizeof(float));
    //arr3 = (float*) malloc(64 * sizeof(float));

     int i;
    // Fill the arrays with the value 2.5
    for(i = 0; i < 64; i++) {
        arr1[i] = 2.5;
        arr2[i] = 1.0;
    }
    for (j = 0; j < 500; j++) {
  
    mul_software(arr1, arr2, arr2, 64);

    


    }

    printf("%f\n", arr2[0]);



    return 0;
}