#!/bin/sh
cp c0_in.txt c_in.txt
for i in `seq 1 1 5`;do
   mpirun -n 5  ./a.out |tee c_out.txt && cp c_out.txt c_in.txt && ./b.out |tee c_out.txt && cp c_out.txt c_in.txt
done
