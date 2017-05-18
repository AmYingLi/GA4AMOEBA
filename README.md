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

After building, for instance, the vdw program, go to the vdw folder. Running the command line

```bash
$ make vdw
$ cd vdw
$ sh run.sh
```
The results will show up as 

```bash
$ The best parameters set is KEY/000001/methanol.key
```
To see the result of the optimized parameters

```bash 
$ cat KEY/000001/methanol.key
```

<a id="note"></a>
## Note
This is a parallel genetic algorithm program, it requries Message Passing Interface libary pre-built in your system. Here is the link of MPI https://www.mpich.org. **make.inc** file could be modified according to the different compilers/vendors. 
There are couple of files should be paid attention with when trying to utilizing the program: 
```bash
$ vdw/xyz 
```
contains the XYZ files acquired from sampling
```bash
$ vdw/util/IE_kcal
```
contains the energy acquired for the sampled XYZ files accordingly
```bash
$ vdw/KEY
```
contains the candidated parameters sets
```bash
$ vdw/util/
```
contains the Tinker programs for calculating the according energy from AMOEBA
```bash
$ vdw/files 
``` 
designed to contain the seeds parameters files and results log

Two places could be changed according to the amount of computaion can be afforded, the value of **g** specifies how many generations of the GA program, and the value of **p** speicifies how many populations for each generation does the GA have (which should not exceed the number of cores of the computing node/nodes).
```bash
$ cat run.sh
$ #!/bin/sh
$ g=2
$ p=4
$ ...
```

The above files/folders apply to the electrostatic parameters sets too, expect that it has one more folder **ele/pot** contains the point electrostatic potentails for each probing points sorrounding the methanol dimers.
