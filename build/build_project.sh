#!/bin/bash

# Script to clean, configure, and build the project

# Step 1: Clean previous build files
echo "Cleaning previous build files..."
make clean

# Step 2: Configure the project with CMake
echo "Configuring the project with CMake..."
cmake -DCMAKE_BUILD_TYPE=Release ..

# Step 3: Build the project
echo "Building the project..."
make

echo "Build process completed successfully!"

