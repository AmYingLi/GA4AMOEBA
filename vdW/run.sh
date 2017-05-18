#!/bin/sh
cp files/c0_in.txt c_in.txt
rm files/log
for i in `seq 1 1 10`;do
   mpirun -n 10  ./a.out |tee c_out.txt && cp c_out.txt c_in.txt && ./b.out |tee c_out.txt && cp c_out.txt c_in.txt
done  > files/log
k=`awk '{if (NR==2) printf "%06d\n", $13}' c_out.txt`
echo " "
echo "The best parameters set is KEY/$k/methanol.key"
echo " "
rm c_in.txt c_out.txt
