// Important Note:
// If matrix Row dimension (P+N) is odd number, you need to pad a ZERO at the end of the row
// to ensure that the vector-matrix multiplication functions. 
// You also need to pad another zero at the end of the "x_data_matrix" vector.
// This is to make sure P+N is always an even number.
// --- EXAMPLE
// #define N 7 // number of internal states
// #define P 4 // number of sensor inputs
// #define M 2 // number of controller (motors, actuators) outputs
// T matrix has a dimension of (N+M) rows, each row has (P+N) elements
/* float T_matrix[((N+M)*(P+N+1))] =
{
  85.23, 85.23, 16, 42, 73, 87, 95, 92,  0, 58, 91, 0,   
  76, 85.23, 3, 59, 67, 78, 51, 66, 62, -80.19, 86, 0,
  98.343, 85.23, -60, 15.3,  -0.23,  6, 76, 78, 22, 44, 72, 0,
  85.23, 85.23, 16, 42, 73, 87, 95, 92,  0, 58, 91, 0,
  76, 85.23,  3, 59, 67, 78, 51, 66, 62, -80.19, 86, 0, 
  98.343, 85.23, -60, 15.3,  -0.23,  6, 76, 78, 22, 44, 72, 0, 
  20, 85.23, 45, 97, 61.34, 28, -92, -84, -43, -59, 12, 0, 
  20, 85.23, 45, -97.98, 61, -28, 92, 84, 43, 59, 12, 0 
};
// *********** Padding a zero !!
// 8 * (7 + 4 + 1)

float Y_data_matrix[P] =
{
  46, 77,  7, -86.1
};
// size 4

float X_data_matrix[N] =
{
  -93, 10.23, 3230.33, -9.6,  -5, 90.232, -9.6, 0
};
// *********** Padding a zero !!
// size 7 + 1

float U_data_matrix[M] =
{
  23.32, -203.88
}; */
// --- END EXAMPLE
// --- WHY?
// The reason why dimension (P+N) has to be an even number is due to the controller will read
// 2 floating number per request from cache. Thus, it expect that the memory address of the load
// is dividable by 8.
// If dimension (P+N) is odd, what will happen is that some row head will start with address dividable 
// by 4, which will induce memory exception.


#define N 6 // number of internal states
#define P 4 // number of sensor inputs
#define M 2 // number of controller (motors, actuators) outputs

// T matrix has a dimension of (N+M) rows, each row has (P+N) elements
float T_matrix[((N+M)*(P+N))] =
{
  85.23, 16, 42, 73, 87, 95, 92,  0, 58, 91,   
  76,  3, 59, 67, 78, 51, 66, 62, -80.19, 86, 
  98.343, -60, 15.3,  -0.23,  6, 76, 78, 22, 44, 72, 
  85.23, 16, 42, 73, 87, 95, 92,  0, 58, 91,   
  76,  3, 59, 67, 78, 51, 66, 62, -80.19, 86, 
  98.343, -60, 15.3,  -0.23,  6, 76, 78, 22, 44, 72, 
  20, 45, 97, 61.34, 28, -92, -84, -43, -59, 12, 
  20, 45, -97.98, 61, -28, 92, 84, 43, 59, 12, 
};
// 8 * 10

float Y_data_matrix[P] =
{
  46, 77,  7, -86.1
};
// size 4


float X_data_matrix[N] =
{
  -93, 10.23, 3230.33, -9.6,  -5, 90.232
};
// size 6

float U_data_matrix[M] =
{
  23.32, -203.88
};
// size 2

