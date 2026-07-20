# Parallel Computing — CPU and GPU Optimization

Profiling and parallelizing a physics/graphics engine across CPU cores with OpenMP and the
GPU with OpenCL, ending up with as much as a 34x speedup over the original.

![Language](https://img.shields.io/badge/C-77%25-00599C?logo=c&logoColor=white)
![OpenMP](https://img.shields.io/badge/OpenMP-CPU-orange)
![OpenCL](https://img.shields.io/badge/OpenCL-GPU-red)
![Build](https://img.shields.io/badge/Build-CMake-064F8C?logo=cmake&logoColor=white)

## Overview

The starting point was a single-threaded engine. From there I profiled to find where the
time was actually going, then applied optimizations one layer at a time — compiler
vectorization first, then multicore CPU parallelism with OpenMP, and finally a GPU port
with OpenCL. Measuring after each step made it clear which changes actually paid off.

## Optimization stages

1. Baseline: the single-threaded reference implementation
2. Compiler and SIMD: `-O3 -ftree-vectorize -ffast-math`, with AVX2
3. CPU multicore: OpenMP (`-fopenmp`) on the parallelizable loops
4. GPU: an OpenCL kernel (`parallel.cl`) offloading the hot path

## Results

| Version | Frametime (80x80 workload) | Speedup |
|---|---|---|
| Optimized CPU | 537 ms | baseline |
| OpenCL GPU | 69 ms | about 7.8x over the optimized CPU version |
| End to end | — | up to 34x over the original |

## Build

```bash
mkdir -p build && cd build
cmake ..
make
./parallel
```

Dependencies: OpenGL, GLUT, an OpenCL SDK, and an OpenMP-capable compiler.

## Repository layout

```
├── parallel.c        host program (OpenMP plus OpenCL host code)
├── parallel.cl       OpenCL GPU kernel
├── CMakeLists.txt
└── build/
```

## Skills demonstrated

OpenMP, OpenCL, GPU computing, SIMD and AVX2, performance profiling, CMake, C, and
parallel algorithm design.
