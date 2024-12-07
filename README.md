# Parallel Computing Project

## Overview
This project explores the potential of parallel computing using both CPU and GPU architectures. It implements multicore parallelization with OpenMP and GPU-based parallelization using OpenCL, benchmarking the performance across various configurations. The goal is to understand the advantages and trade-offs of different parallelization techniques.

### Objectives
- Analyze and optimize a C-based physics and graphics engine.
- Implement OpenMP for CPU parallelization.
- Port the graphics engine to OpenCL for GPU execution.
- Benchmark and compare performance across configurations.
- Identify and resolve performance bottlenecks.

## Project Structure
The project is divided into two main parts:

### Part 1: CPU Parallelization with OpenMP
- Analyzed a physics and graphics engine in C.
- Benchmarked performance with various compiler optimization flags.
- Added multicore parallelization using OpenMP.
- Measured performance scaling with different numbers of CPU cores and threads.

### Part 2: GPU Parallelization with OpenCL
- Ported the graphics engine to OpenCL for GPU execution.
- Evaluated performance using various work group sizes.
- Addressed challenges such as memory access patterns and GPU limitations.

## Performance Results
### Benchmark Summary
| Configuration                              | Physics Routine (ms) | Graphics Routine (ms) | Total Frametime (ms) |
|-------------------------------------------|-----------------------|------------------------|-----------------------|
| Original C version (no optimizations)     | 110                   | 2286                  | 2399                 |
| Original C version (optimized)            | 25                    | 509                   | 537                  |
| OpenCL GPU (WG size 1x1)                  | 28                    | 190                   | 225                  |
| OpenCL GPU (WG size 4x4)                  | 24                    | 32                    | 69                   |
| OpenCL GPU (WG size 8x4)                  | 23                    | 31                    | 69                   |
| OpenCL GPU (WG size 16x16)                | 25                    | 34                    | 70                   |

### Key Findings
- OpenCL GPU performance outperformed CPU for most configurations due to efficient parallelization.
- Optimal work group size (e.g., 8x4) maximized GPU performance.
- Smaller workloads (e.g., 80x80) favored CPU execution due to reduced GPU utilization.

## Optimization Techniques
### CPU Optimization
- Used compiler flags such as `-O3`, `-ftree-vectorize`, and `-ffast-math`.
- Enabled SIMD instructions (e.g., AVX2).
- Added OpenMP pragmas for multicore execution.

### GPU Optimization
- Tuned work group sizes for balanced thread utilization.
- Minimized redundant OpenCL API calls.
- Utilized persistent buffers and local memory.
- Reduced kernel launch overheads.

## Challenges
- Debugging kernel crashes due to improper buffer sizes.
- Balancing workload distribution across GPU threads.
- Adapting the code for different hardware limitations (e.g., work group size limits).

## Lessons Learned
- Synchronization primitives and parallel frameworks like OpenMP and OpenCL are powerful tools for performance improvement.
- Proper profiling and optimization techniques significantly impact performance.
- Small workloads may underutilize GPU resources, making CPU execution more efficient.

## How to Run the Project
### Prerequisites
- Linux environment with GCC and OpenCL SDK installed.
- GPU with OpenCL support and discrete memory.
- Dependencies: OpenGL, GLUT, and math libraries.

### Compilation Commands
1. **Original C Version (no optimizations):**
   ```
   gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm
   ```
2. **Optimized C Version:**
   ```
   gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O3 -ftree-vectorize -ffast-math
   ```
3. **OpenMP Version:**
   ```
   gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O3 -ftree-vectorize -ffast-math -fopenmp
   ```
4. **OpenCL Version:**
   ```
   gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O3 -ftree-vectorize -ffast-math -fopenmp -lOpenCL
   ```

### Execution
Run the compiled binary:
```bash
./parallel
```

rupesh.majhi@tuni.fi

## Acknowledgments
Special thanks to Tampere University for providing the resources and guidance for this project.

