#!/bin/sh
g=10
p=10
cp files/c0_in.txt c_in.txt
rm files/log
for i in `seq 1 1 $g`;do
   mpirun -n $p  ./a_e.out |tee c_out.txt && cp c_out.txt c_in.txt && ./b_e.out |tee c_out.txt && cp c_out.txt c_in.txt
done  > files/log
k=`awk '{if (NR==2) printf "%06d\n", $18}' c_out.txt`
echo " "
echo "The best parameters set is KEY/$k/2me.key"
echo " "
rm c_in.txt c_out.txt
