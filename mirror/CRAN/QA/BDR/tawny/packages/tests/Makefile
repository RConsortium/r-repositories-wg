.PHONY: clean check backup package summary timing veryclean unpack unpack

#RDEV=Rpat
RDEV=R
R_OPTS=--check-subdirs=yes-maybe --no-stop-on-test-error
RLIBS=~/R/test-4.1

include ../Makefile.common

%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o $*/src/symbols.rds $*.log
	-+@R_LIBS=$(RLIBS) $($*-VARS) time $(RDEV) CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	-@cp -p $*.Rcheck/00install.out $*.log
	@echo ... $* done

all:
	@make backup unpack
	@script

check: $(OUTS)

backup:
	@mkdir -p ../tests-keep
	@cp -p Makefile script unpack.R ../tests-keep
	@cp -p [A-Z]*.out ../tests-keep
	@cp -p [a-l]*.out ../tests-keep
	@cp -p [m-z]*.out ../tests-keep

clean:
	-@rm -f [A-Z]*.in; rm -f [a-l]*.in; rm -f [m-z]*.in
	-@rm -rf [A-Z]*.Rcheck; rm -rf [a-l]*.Rcheck; rm -rf [m-z]*.Rcheck
	@find [A-L]* -maxdepth 0 -type d -exec rm -rf {} \;
	@find [M-Z]* -maxdepth 0 -type d -exec rm -rf {} \;
	@find [a-f]* -maxdepth 0 -type d -exec rm -rf {} \;
	@find [g-n]* -maxdepth 0 -type d -exec rm -rf {} \;
	@find [o-r]* -maxdepth 0 -type d -exec rm -rf {} \;
	@find [s-z]* -maxdepth 0 -type d -exec rm -rf {} \;

veryclean: clean
	-@rm -f [A-Z]*.out; rm -f [a-l]*.out; rm -f [m-z]*.out
	-@rm -f [A-Z]*.log; rm -f [a-l]*.log; rm -f [m-z]*.log
	-@rm -f check_log

unpack:
	@/Users/ripley/R/R-patched/bin/Rscript unpack.R

unpack2:
	@/Users/ripley/R/R-patched/bin/Rscript unpack2.R
