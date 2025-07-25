#include <stdio.h>
#include <cuda_runtime.h> // CUDA runtime api -> provides runtime level functions and defs to 1. allocate memory
// 2. transfer data between CPU and GPU 3.Launch and manage kernels from host(CPU)

#define N 16 // preprocessor directive that defines a constant N with value 16, anywhere the code has N, it will be replaced with 16 before compilation
#define BLOCK_SIZE 4

int main(){
    int h_input[N], h_output[N], i;

    for(i = 0; i < N; i++){
        h_input[i] = i;

        int *d_input, *d_output;
        
                    
    }
}