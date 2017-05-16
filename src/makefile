include ../make.inc

# suffix rules
.SUFFIXES: .o .f90 .c
.f90.o: 
	$(MPIF90) $(MPIF90_FLAGS) -c $<
.c:
	$(CC) $(CC_FLAGS) -c $<

%.o: %.mod

SRCS1 := mipGA.f90
OBJS1 := $(SRCS1:.f90) 

SRCS2 := qsort.c
OBJS2 := $(SRCS2:.c) 

EXE1 = a.out
EXE2 = b.out

$(EXE1): $(OBJS1)
	$(MPIF90) $(MPIF90_FLAGS) -o $(EXE1) $(OBJS1)


$(EXE2): $(OBJS2)
	$(CC) $(CC_FLAGS) -o $(EXE2) $(OBJS2)

clean:
	rm -f $(OBJS1) $(EXE1) $(OBJS2) $(EXE2)
