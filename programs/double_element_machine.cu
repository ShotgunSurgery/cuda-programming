#include <stdio.h>

// so when the first thread calls this function inside the threadIdx.x returns 1 and hence the 1st thread only works on 
// doubling one element 
__global__ void double_function(int* gpu_arr, int n){
    int idx = threadIdx.x;
    if(idx < n){
        gpu_arr[idx] *= 2;
    }
}
int main(){
    int n = 5;
    int cpu_arr[5] = {1,2,3,4,5};
    int* gpu_arr;
    cudaMalloc( (void**)&gpu_arr, n * sizeof(int));
    cudaMemcpy(gpu_arr, cpu_arr, n * sizeof(int), cudaMemcpyHostToDevice);
    // when we write the following line then the gpu launches 1 block and n threads paralleley on it and each thread calls the kernel once
    // double_function<<<1, n>>>(gpu_arr, n);

    // an event is used to measure specific points in time during gpu execution 
    // below we declare two events 
    cudaEvent_t start, stop;

float milliseconds = 0;

// here we "create" those events i.e. allocate memory to them and now these can record timestamps 
cudaEventCreate(&start);
cudaEventCreate(&stop);

cudaEventRecord(start);  // Start timing

double_function<<<1, n>>>(gpu_arr, n);

cudaEventRecord(stop);   // Stop timing
    
cudaEventSynchronize(stop);  // Wait for kernel to finish

cudaEventElapsedTime(&milliseconds, start, stop);
printf("Kernel execution time: %f ms\n", milliseconds);

    cudaMemcpy(cpu_arr, gpu_arr, n * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < n; i++){
        printf("%d ", cpu_arr[i]);
    }
    printf("\n");   
    cudaFree(gpu_arr);
    return 0;
}