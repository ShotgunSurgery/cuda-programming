#include <stdio.h>

__global__ void addTen(int* d_arr, int n){
    int idx = threadIdx.x;
    if(idx < n){
        d_arr[idx] += 10;
    }
}

int main(){
    int n = 7;
    int h_arr[] = {1,2,3,4,5,6,7};

    int* d_arr;

    // the job of the first parameter is to store the address of memory allocated on GPU, &d_arr is derefrencing it i.e. address of variable
    // d_arr, we need to change the value that the d_arr is pointing to so we need it's address which is stored in d_arr. that's why it's a pointer to a pointer 

    // Types of RAM -> 1. DRAM(Types -> 1. VRAM) 2. SRAM 
    // this memory is being allocated on the DRAM (Dynamic Random Access Memory) -> Nvidia RTX 4060 8GB here 8GB is refring to DRAM 
    cudaMalloc( (void**)&d_arr, n * sizeof(int));


    // when a kernel is launched it's on the host memory(cpu) but for the gpu cores to access it we need to copy it on the GPU DRAM 
    // first param -> destination pointer memory location on gpu ram, second param -> source pointer memory location on host ram, third param -> number of bytes to copy, fourth 
    // param -> copy form host to gpu others can be cudaMemcpuyDeviceToHost() -> copy from Gpu to cpu 
    cudaMemcpy(d_arr, h_arr, n * sizeof(int), cudaMemcpyHostToDevice);

    addTen<<<1, n>>>(d_arr, n);

    cudaMemcpy(h_arr, d_arr, n * sizeof(int), cudaMemcpyDeviceToHost);

    for(int i = 0; i < n; i++){
        printf("%d ",h_arr[i]);
    }
    printf("\n");

    // to free allocated memory on gpu 

    cudaFree(d_arr);

    return 0;
}