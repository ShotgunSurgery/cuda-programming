#include <stdio.h>

__global__ void initializer(int* gpu_arr){
    int thread_index = threadIdx.x;
    gpu_arr[thread_index] = 0;
}

int main(){
    int n = 1000;
    int* gpu_arr;
    int cpu_arr[1000];
    cudaMalloc((void**)& gpu_arr, n * sizeof(int));
    // in one block only 1024 threads can be launched 
    initializer<<<1, 1000>>>(gpu_arr);
    cudaMemcpy(cpu_arr, gpu_arr,10 * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < 10; i++){
        printf("%d ", cpu_arr[i]);
    }
    cudaFree(gpu_arr);
    cudaDeviceSynchronize();
}