#!/bin/bash
    mpic++ -o seven seven.cpp
    mpiexec -mca btl self,tcp -np   2   seven
