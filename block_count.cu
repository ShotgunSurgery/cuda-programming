#include <stdio.h>

__global__ void printIDs(){
    printf("Block: %d, Thread: %d\n", blockIdx.x, threadIdx.x);
}

int main(){
    printIDs<<<3, 5>>>();
    cudaDeviceSynchronize();
    return 0;

}

// x64 Native Tools Command Prompt for VS 2022 is a special terminal provided by vsc to compile 64 bit cpp code, we cannot 
// do it in vsc cause the libraries aren't in system path by default 

// CUDA uses SIMT (Single Instruction, Multiple Thread) model -> it picks blocks threads in accordance with the avalablity 
// of resources so they can be in any order, it decideds which block which wrap to exceute when 