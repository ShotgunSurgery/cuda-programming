#include <stdio.h>

__global__ void square_fxn(int *arr, int n)
{
    int thread_index = threadIdx.x;
    // blockDim.x -> returns the number of threads in the block along x dimension
    for (int i = threadIdx.x; i < n; i += blockDim.x)
    {
        arr[i] *= arr[i];
    }
}

int main()
{
    int n = 4;
    int arr[4] = {1, 2, 3, 4};
    int *gpu_arr;
    cudaMalloc((void **)&gpu_arr, n * sizeof(int));
    cudaMemcpy(gpu_arr, arr, n * sizeof(int), cudaMemcpyHostToDevice);
    square_fxn<<<1, 2>>>(gpu_arr, n);
    cudaMemcpy(arr, gpu_arr, n * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < n; i++){
        printf("%d ", arr[i]);
    }
    cudaFree(gpu_arr);
    return 0;
}