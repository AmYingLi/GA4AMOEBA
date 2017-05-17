# Copyright (C) Ying Li, yingli@anl.gov

#include make.inc

default :
	@echo 'to install this GA program, type at the shell prompt:'
	@echo '  make <OPTIONS>'
	@echo ' '
	@echo ' OPTIONS:'
	@echo ' a.out : compile the MPI GA program'
	@echo ' b.out : compile the quick sort program'
	@echo ' clean'
.PHONY: all clean

a.out :
	cd src && $(MAKE) $@
b.out :
	cd src && $(MAKE) $@
