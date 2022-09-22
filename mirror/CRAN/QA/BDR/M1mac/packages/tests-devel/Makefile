.PHONY: clean check backup package summary timing veryclean unpack unpack2

RDEV=Rdev
#RDEV=Rnc
R_OPTS=--check-subdirs=yes-maybe --no-stop-on-test-error
RLIBS=~/R/Library

include ../Makefile.common
rgdal-OPTS = --install-args="--configure-args='--with-data-copy --with-proj-data=/opt/R/arm64/share/proj'"
sf-OPTS = --install-args="--configure-args='--with-data-copy --with-proj-data=/opt/R/arm64/share/proj'"
## for compilation output
Matching-VARS = MAKE=make MAKEFLAGS=

%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o $*/src/symbols.rds
	-+@R_LIBS=$(RLIBS) $($*-VARS) time $(RDEV) CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	-@cp -p $*.Rcheck/00install.out $*.log
	@rm -rf $* $*.Rcheck/$*
	@echo ... $* done

all:
	@make backup unpack
	@script

check: $(OUTS)

backup:
	@mkdir -p ../tests-devel-keep
	@cp -p Makefile pkgdiff script script2 unpack.R ../tests-devel-keep
	@cp -p *.out *.log ../tests-devel-keep

summary:
	@/Users/ripley/R/R-devel/bin/Rscript ../summary.R

timing:
	@/Users/ripley/R/R-devel/bin/Rscript ../check_times.R


clean:
	-@rm -f *.in
	-@rm -rf *.Rcheck
	@find [A-Z]* -maxdepth 0 -type d -exec rm -rf {} \;
	@find [a-l]* -maxdepth 0 -type d -exec rm -rf {} \;
	@find [m-z]* -maxdepth 0 -type d -exec rm -rf {} \;

veryclean: clean
	-@rm -f *.out
	-@rm -f *.log
	-@rm -f check_log

unpack:
	@/Users/ripley/R/R-devel/bin/Rscript unpack.R
