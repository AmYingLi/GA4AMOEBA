include ../../make.inc

# suffix rules
SRCS1 = mpiGA_e.f90
OBJS1 = mpiGA_e.o 

SRCS2 = qsort_e.c
OBJS2 = qsort_e.o 

$(OBJS1) : $(SRCS1) 
	$(MPIF90) -c -o $@ $< $(MPIF90_FLAGS)

$(OBJS2) : $(SRCS2) 
	$(CC) -c -o $@ $< $(CC_FLAGS)

EXE1 = a_e.out
EXE2 = b_e.out

$(EXE1): $(OBJS1)
	$(MPIF90) -o $@ $^ $(MPIF90_FLAGS)
	mv $(EXE1) ../


$(EXE2): $(OBJS2)
	$(CC) -o $@ $^ $(CC_FLAGS) 
	mv $(EXE2) ../

clean-ele:
	rm -f $(OBJS1) ../$(EXE1) $(OBJS2) ../$(EXE2)
