np=60
for i in `seq 0 1 10000`;do
   ll=1154
   line=`bc <<<${i}*${ll}+${np}*12+3`;
   sed -n "${line}p" prun-${np}-12.output
done
