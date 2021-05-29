#!/bin/bash
#SBATCH  -J  Seven
#SBATCH  -A  cs475-575
#SBATCH  -p  class
#SBATCH  -N 8      # number of nodes
#SBATCH  -n 8      # number of tasks
#SBATCH  -o  seven.out
#SBATCH  -e  seven.err
    mpic++ -o seven seven.cpp
    mpiexec -mca btl self,tcp -np   30   seven