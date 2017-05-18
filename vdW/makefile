include ../make.inc

# suffix rules
SRCS1 = mpiGA.f90
OBJS1 = mpiGA.o 

SRCS2 = qsort.c
OBJS2 = qsort.o 

$(OBJS1) : $(SRCS1) 
	$(MPIF90) -c -o $@ $< $(MPIF90_FLAGS)

$(OBJS2) : $(SRCS2) 
	$(CC) -c -o $@ $< $(CC_FLAGS)

EXE1 = a.out
EXE2 = b.out

$(EXE1): $(OBJS1)
	$(MPIF90) -o $@ $^ $(MPIF90_FLAGS)


$(EXE2): $(OBJS2)
	$(CC) -o $@ $^ $(CC_FLAGS) 

clean:
	rm -f $(OBJS1) $(EXE1) $(OBJS2) $(EXE2)
