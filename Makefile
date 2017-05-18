# Copyright (C) Ying Li, yingli@anl.gov

#include make.inc

default :
	@echo 'to install this GA program, type at the shell prompt:'
	@echo ' make <OPTIONS>'
	@echo ' '
	@echo ' OPTIONS:'
	@echo ' vdw : compile the program for vdw parameters optimization'
	@echo ' clean-vdw'
	@echo ' ele : compile the program for electrostatic parameters optimization'
	@echo ' clean-ele'
.PHONY: vdw clean-vdw ele clean-ele

a.out :
	cd vdw/src && $(MAKE) $@
b.out :
	cd vdw/src && $(MAKE) $@
vdw : a.out b.out
	cd vdw/src && $(MAKE) $^
clean-vdw :
	cd vdw/src && $(MAKE) $@
a_e.out :
	cd ele/src && $(MAKE) $@
b_e.out :
	cd ele/src && $(MAKE) $@
ele : a_e.out b_e.out
	cd ele/src && $(MAKE) $^
clean-ele :
	cd ele/src && $(MAKE) $@
