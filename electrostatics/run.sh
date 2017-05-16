#!/bin/bash
nprocs=16

for i in `seq 1 1 100`;do
   mpirun --np ${nprocs}  ./a.out |tee c_out.txt
   cp c_out.txt c_in.txt
   ./b.out |tee c_out.txt
   cp c_out.txt c_in.txt
done
   
