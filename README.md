# GA4AMOEBA
This is a Machine Leaning (ML) Genetic Algorithm GA) program for optimizing the parameters of a polarizable force field based on the  AMOEBA functional form (http://pubs.acs.org/doi/abs/10.1021/ct4003702).  It is a MPI program that can be executed on high performance computers. The ML/GA codes were utilized computers at Argonne National Laboratory, on http://status.alcf.anl.gov/cooley/activity and https://www.lcrc.anl.gov/systems/resources/blues/. Please contact yingli@anl.gov or roux@uchicago.edu, if you have any question regarding the code.

<a id="installation"></a>
## Installation
The first step is to clone the repsoitory locally.

```bash
$ git clone https://github.com/AmYingLi/GA4AMOEBA.git
```
 
You can build the program with

```bash
$ make
```

It will show up the options for building different programs: vdW or electrostatics parameters

```bash
$ to install this GA program, type at the shell prompt:
$ make <OPTIONS>
$ 
$ OPTIONS:
$ vdw : compile the program for vdw parameters optimization
$ clean-vdw
$ ele : compile the program for electrostatic parameters optimization
$ clean-ele
```

After building, for instance, the vdw program, go to the vdw folder. Running the commant line

```bash
$ make vdw
$ cd vdw
$ sh run.sh
```
The results will show up as 

```bash
$ The best parameters set is KEY/000001/methanol.key
```
To see the parameters

```bash 
$ cat KEY/000001/methanol.key
```

<a id="note"></a>
## Note
This is a parallel genetic algorithm program, it requries Message Passing Interface libary pre-built in your system. Here is the link of MPI https://www.mpich.org
There are couple of variables should be paid attention with when trying to utilizing the program: 
```bash
$ vdw/xyz 
```
contains the XYZ files acquired from sampling
```bash
$ util/IE_kcal
```
contains the energy acquired for the sampled XYZ files
```bash
$ KEY
```
contains the candidated parameters sets
```bash
$ run.sh
```
two places could be changed according to the amount of computaion afforded
```bash
$ cat run.sh
$ #!/bin/sh
$ cp files/c0_in.txt c_in.txt
$ rm files/log
$ for i in `seq 1 1 **10**`;do
$    mpirun -n **10**  ./a.out |tee c_out.txt && cp c_out.txt c_in.txt && ./b.out |tee c_out.txt && cp c_out.txt c_in.txt
$ done  > files/log
$ k=`awk '{if (NR==2) printf "%06d\n", $13}' c_out.txt`
$ echo " "
$ echo "The best parameters set is KEY/$k/methanol.key"
$ echo " "
$ rm c_in.txt c_out.txt 
```
the first 10 specifies how many generations of the GA program, and the second 10 speicifies how many populations for each generation does the GA have. 
