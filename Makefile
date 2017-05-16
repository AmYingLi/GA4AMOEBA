# Copyright (C) Ying Li, yingli@anl.gov

#include make.inc

default :
	@echo 'to install this GA program, type at the shell prompt:'
	@echo '  make <OPTIONS>'
	@echo ' '
	@echo ' OPTIONS:'
	@echo ' all'
	@echo ' clean'
.PHONY: all clean

all :
	cd src && $(MAKE)
