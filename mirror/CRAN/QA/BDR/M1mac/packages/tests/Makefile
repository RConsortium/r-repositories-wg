.PHONY: clean check backup package summary timing veryclean unpack unpack2

RDEV=R
R_OPTS=--check-subdirs=yes-maybe --no-stop-on-test-error
RLIBS=~/R/test-4.0

include ../Makefile.common

%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o $*/src/symbols.rds
	@rm -rf /tmp/RL-$*; mkdir /tmp/RL-$*
	-+@R_LIBS="$(RL):$(RLIBS)" time $(RDEV) CMD check $* $(R_OPTS) -l $(RLIBS) --install=check:../tests-keep/$*.log $($*-OPTS) > $@ 2>&1
	@rm -rf /tmp/RL-$*
	@rm -rf $* $*.Rcheck/$*
	@echo ... $* done

all:
	@make backup unpack
	@script

check: $(OUTS)

backup:
	@mkdir -p ../tests-keep
	@cp -p Makefile script unpack.R ../tests-keep
	@cp -p [A-z]*.out ../tests-keep

clean:
	-@rm -f [A-z]*.in
	-@rm -rf [A-z]*.Rcheck
	@find [A-z]* -maxdepth 0 -type d -exec rm -rf {} \;

veryclean: clean
	-@rm -f [A-z]*.out
	-@rm -f check_log

unpack:
	@Rscript unpack.R

unpack2:
	@Rscript unpack2.R

timing:
	@/Users/ripley/R/R-devel/bin/Rscript ../check_times.R
