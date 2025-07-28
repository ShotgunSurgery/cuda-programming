// program to add two arrays using shared memroy
#include <stdio.h>

__global__ void addition_using_shared_memory(int *a1, int *a2, int *out)
{
    __shared__ int a[7];
    __shared__ int b[7];
    // a1, a2 are pointer to memory
    // address in the global memory but we want to copy them into shared memory(on chip)
    // for more effecient working
    int idx = threadIdx.x;
    if (idx < 7)
    {
        a[idx] = a1[idx];
        b[idx] = a2[idx];
        out[idx] = a[idx] + b[idx];
    }
    __syncthreads();
}

int main()
{
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    int arr1[7] = {1, 2, 3, 4, 5, 6, 7};
    int arr2[7] = {1, 2, 3, 4, 5, 6, 7};
    int *device_output;
    int *host_output;
    int size = 7;
    // we can never directly write into the VRAM so we always need to copy form the cpu 
    int *d_arr1;
    int *d_arr2;
    cudaMalloc((void **)&d_arr1, size * sizeof(int));
    cudaMalloc((void **)&d_arr2, size * sizeof(int));
    cudaMemcpy(d_arr1, arr1, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_arr2, arr2, size * sizeof(int), cudaMemcpyHostToDevice);
    
    host_output = (int *)malloc(size * sizeof(int));
    cudaMalloc((void **)&device_output, size * sizeof(int));
    cudaEventRecord(start);
    addition_using_shared_memory<<<1, size>>>(d_arr1, d_arr2, device_output);
    cudaMemcpy(host_output, device_output, size * sizeof(int), cudaMemcpyDeviceToHost);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    for (int j = 0; j < size; j++)
    {
        printf("%d ", host_output[j]);
    }
    printf("\n");
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    printf("Time taken: %f ms\n", milliseconds);
    cudaFree(d_arr1);
    cudaFree(d_arr2);
    cudaFree(device_output);
    cudaDeviceSynchronize();
    return 0;
}