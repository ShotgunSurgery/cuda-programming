#include <stdio.h>

__global__ void threadCount() {
    // threadIdx is a inbuilt variable that tells us about the id of the current thread 
    int id = threadIdx.x;
    printf("Thread %d\n", id);
}

int main(){
    // launch 1 block    with 5 threads 
    threadCount<<<1, 5>>>();
    cudaDeviceSynchronize();
    return 0;
}

// Streamming Multiprocessor -> Runs multiple blocks 
// Grid -> group of blocks 
// Block -> group of threads
// Wrap -> group  of 32 threads