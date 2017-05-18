# Copyright (C) Ying Li, yingli@anl.gov

#include make.inc

default :
	@echo 'to install this GA program, type at the shell prompt:'
	@echo ' make <OPTIONS>'
	@echo ' '
	@echo ' OPTIONS:'
	@echo ' a.out : compile the MPI GA program'
	@echo ' b.out : compile the quick sort program'
	@echo ' all : compile the whole program'
	@echo ' clean'
.PHONY: all-vdW clean-vdW

a.out :
	cd vdW/src && $(MAKE) $@
b.out :
	cd vdW/src && $(MAKE) $@
all-vdW : a.out b.out
	cd vdW/src && $(MAKE) $^
clean-vdW :
	cd vdW/src && $(MAKE) $@
