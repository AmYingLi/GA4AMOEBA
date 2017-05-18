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



