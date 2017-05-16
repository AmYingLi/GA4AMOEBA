np=1
for i in `seq 0 1 10000`;do
   ll=`bc <<<${np}*24+2` 
   line=`bc <<<${i}*${ll}+${np}*16+3`;
   sed -n "${line}p" output
done
