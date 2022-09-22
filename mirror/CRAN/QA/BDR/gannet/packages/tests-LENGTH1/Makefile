RDEV=/data/gannet/ripley/R/R-devel/bin/R
R_OPTS=--check-subdirs=yes-maybe --no-stop-on-test-error
RLIBS=~/R/test-dev

include ../Makefile.common

#prc-OPTS=--no-tests


%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o
	-+@R_LIBS=$(RLIBS) $($*-VARS) time -f "Time %E, %U + %S" $(RDEV) CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	-@cp -p $*.Rcheck/00install.out $*.log
	@chmod 644 $*/DESCRIPTION
	@cp $*/DESCRIPTION $*.Rcheck/00package.dcf
	@rm -rf $* $*.Rcheck/$*
	@echo ... $* done

all:
	@make backup unpack
	@script
	@make summary

check: $(OUTS)

backup:
	@mkdir -p ../tests-LENGTH1-keep
	@cp -p Makefile pkgdiff script summary.R unpack.R cleanup *.out *.log ../tests-LENGTH1-keep

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out *.log check_log

unpack:
	@/data/gannet/ripley/R/R-devel/bin/Rscript unpack.R

summary:
	@/data/gannet/ripley/R/R-devel/bin/Rscript summary.R

process:
	@/data/gannet/ripley/R/R-devel/bin/Rscript process.R


