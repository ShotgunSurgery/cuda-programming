// matrix multiplication using constant memory - 64KB usually, cached i.e. stores frequently used instructions, data enabling faster 
//retrival 

// each thread has threadIdx.x, threadIdx.y, threadIdx.z and they tell the position of the thread 
// within that block, hence if a block has 4*4 threads then threadIdx.x will be in range [0, 3] and so will 
// be threadIdx.y but threadIdx.z will be 0, so like for this thread -> (1, 2) -> threadIdx.x = 1 and threadIdx.y = 2

// the same as above also applies for blocks i.e. blockIdx.x ... 

// blockDim.x tell the number of threads in x dimension and so on ..
#include <stdio.h>

#define N 512

// the __constant__ keyword tells the compiler that this variable will recide in constant memory 
__constant__ float d_B[N][N];

__global__ void matrix_multiplication_constant(){

}   

int main(){
    // all these matrices would be of size N * N 
    float *host_matrix_a, *host_matrix_b, *host_matrix_c;
    float *device_matrix_a, *device_matrix_c;

    // size_t is unsigned int type 
    size_t bytes = N * N * sizeof(float);

    cudaMemcpy(device_matrix_a, host_matrix_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(device_matrix_c, host_matrix_c, bytes, cudaMemcpyHostToDevice);

    // the follwoing function is used to copy data from host to __constant__ variable
    // decond parameter is the source on host 
    cudaMemcpyToSymbol(d_B, host_matrix_b, N * N * sizeof(float));
    matrix_multiplication_constant<<<>>>(host_matrix_a, host_matrix_c, N);


         
}