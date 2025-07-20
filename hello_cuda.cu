#include <iostream>

// function qualifier marks the function as kernel i.e. it will be called from the cpu but run on gpu 
// hello_cuda.exe -> executable binary file
// hello_cuda.exp -> symbol export file
// hello_cuda.lib -> static import library
__global__ void helloFromGPU() {
    printf("Hello World from GPU!\n");
}

int main() {
    helloFromGPU<<<1, 1>>>();
    cudaDeviceSynchronize();
    return 0;
}
