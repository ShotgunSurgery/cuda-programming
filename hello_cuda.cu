// each cuda core runs multiple threads at a time
#include <iostream>

// function qualifier marks the function as kernel i.e. it will be called from the cpu but run on gpu 
// here kernel only means a function that runs on gpu 

/* hello_cuda.exe -> executable binary file
 hello_cuda.exp -> symbol export file
 hello_cuda.lib -> static import library */
__global__ void helloFromGPU() {
    printf("Hello World from GPU!\n");
}

// when the program is compiled then the cpu and compiler are only working even when the program starts executing 
/* but when there is a 'kernel launch' i.e. the kernel is called only then will the cpu give the gpu the 
function to execute in parallel */
int main() {
    // <<how many blocks of threads to launch, threads per block>>(args);
    helloFromGPU<<<1, 1>>>();
    cudaDeviceSynchronize(); // CUDA runtime api call which blocks the CPU until previously isshued GPU tasks aren't completed
    return 0;
}
