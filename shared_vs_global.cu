// shared memory -> avaliable to all threads in a block (but not between diffrent blocks) -> low latency/ size -> used 
// to temorarily store data in while the kernel execution 
// global memory -> GPU's VRAM -> avaliable to all blocks -> more latency/ size
#include <stdio.h>
#include <cuda_runtime.h> // CUDA runtime api -> provides runtime level functions and defs to 1. allocate memory
// 2. transfer data between CPU and GPU 3.Launch and manage kernels from host(CPU)

#define N 16 // preprocessor directive that defines a constant N with value 16, anywhere the code has N, it will be replaced with 16 before compilation
#define BLOCK_SIZE 4

__global__ void global_memory_kernel(int* device_input, int* device_output){
    // the following line calculates the global thread index 
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if(index < N){
        device_output[index] = device_input[index] * 2;
    }
}

__global__ void shared_memory_kernel(int* input, int* output){
    // __shared__ is a CUDA storage qualifire, it marks the variable to be stored in shared memory
    __shared__ int temp[BLOCK_SIZE];

    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    int tx = threadIdx.x;

    // the input array in which we would be using 'idx' is of size 'N' so to prevent threads from accessing
    // memory beyond array size we check the following condition 
    if(idx < N){
        temp[tx] = input[idx];
        // __syncthreads() is a barrier syncronization function in CUDA -> makes all the threads in the block wait till 
        // everythread in the block has reached it 
        __syncthreads();
        
        output[idx]  = temp[tx] * 2;
    }
}

int main(){
    int host_input[N], host_output[N], i;
     int *device_input, *device_output;

    for(i = 0; i < N; i++){
        host_input[i] = i;

        cudaMalloc((void**)& device_input, N * sizeof(int));
        cudaMalloc((void**)& device_output, N * sizeof(int));

        cudaMemcpy(device_input, host_input, N * sizeof(int), cudaMemcpyHostToDevice);

        // grid is a collection of blocks 
        // dim3 is a CUDA specific datatype used to specify dimension of thread blocks or grid 
        dim3 blocks(N / BLOCK_SIZE); // this defines how many blocks will be launched in the grid 
        dim3 threads(BLOCK_SIZE); // this defines how many threads will be launched per block 

        printf("Running global memory kernel: \n");
        global_memory_kernel<<<blocks, threads>>>(device_input, device_output);
 cudaMemcpy(host_output, device_output, N * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < N; i++)
        printf("%d ", host_output[i]);
    printf("\n");

    printf("Running shared memory kernel...\n");
    shared_memory_kernel<<<blocks, threads>>>(device_input, device_output);
    cudaMemcpy(host_output, device_output, N * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < N; i++)
        printf("%d ", host_output[i]);
    printf("\n");

    cudaFree(device_input);
    cudaFree(device_output);


    }




}