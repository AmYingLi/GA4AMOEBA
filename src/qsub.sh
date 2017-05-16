#!/bin/sh
nodes=60
mode=12
nprocs=`bc <<<${nodes}*${mode}`
proj=PetaSimNano
queue=default
output=prun-${nodes}-${mode}
time=12:00:00

cat << EOF >run.sh
#!/bin/bash
nodes=${nodes}
mode=${mode}
nprocs=`bc <<<${nodes}*${mode}`
EOF

cat <<'EOF'>>run.sh

for i in `seq 1 1 500`;do
   mpirun --np ${nprocs}  ./a.out |tee c_out.txt && cp c_out.txt c_in.txt && ./b.out |tee c_out.txt && cp c_out.txt c_in.txt
done
   
EOF
chmod 750 run.sh

if [ -z $1 ]; then
  dep=""
else
  dep="--dependencies $1"
fi

#cat run.sh
echo "qsub -t ${time} ${dep} -A ${proj} -q ${queue} -n ${nodes} --mode script -O ${output} run.sh"
qsub -t ${time} ${dep} -A ${proj} -q ${queue} -n ${nodes} --mode script -O ${output} run.sh
