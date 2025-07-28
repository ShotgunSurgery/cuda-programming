#include <stdio.h>

__global__ void addition_using_global_memory(int* host_arr1, int* host_arr2, int* result_arr){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if(idx < 7){
        result_arr[idx] = host_arr1[idx] + host_arr2[idx];
    }
}

int main(){
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
cudaEventCreate(&stop);

    int size = 7;
    int host_arr1[7] = {1,2,3,4,5,6,7};
    int host_arr2[7] = {1,2,3,4,5,6,7};
    int* result;
    int* device_arr1;
    int* device_arr2;
    // we are passing the address of the pointer device_arr1 to the function after typecasting it in void** cause it expects it that way
    // CUDA allocates the memory in VRAM and then store the address of that allocated memory in device_arr1, also it doesn't know what 
    // datatype we are going to store there so it just asks for void 
    cudaMalloc((void**)& device_arr1, size * sizeof(int));
    cudaMalloc((void**)& device_arr2,  size * sizeof(int));
    cudaMalloc((void**)& result, size * sizeof(int));

    cudaMemcpy(device_arr1, host_arr1, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(device_arr2, host_arr2, sizeof(int), cudaMemcpyHostToDevice);

    cudaEventRecord(start);
    addition_using_global_memory<<<1, 7>>>(device_arr1, device_arr2, result);

    cudaDeviceSynchronize();
    cudaEventRecord(stop);
cudaEventSynchronize(stop);  // wait for event to complete

    int host_result[7];
cudaMemcpy(host_result, result, size * sizeof(int), cudaMemcpyDeviceToHost);

for(int j = 0; j < size; j++){
    printf("%d ", host_result[j]);
}

printf("\n");   
float milliseconds = 0;
cudaEventElapsedTime(&milliseconds, start, stop);
printf("Time taken by kernel: %f ms\n", milliseconds);

    cudaFree(device_arr1);
    cudaFree(device_arr2);
    cudaFree(result);
    
}
