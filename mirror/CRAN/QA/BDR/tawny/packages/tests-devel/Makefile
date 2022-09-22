.PHONY: clean check backup package summary timing veryclean unpack unpack

RDEV=Rdev
R_OPTS=--check-subdirs=yes-maybe --no-stop-on-test-error
RLIBS=~/R/test-dev

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
	@mkdir -p ../tests-devel-keep
	@cp -p Makefile script unpack.R ../tests-devel-keep
	@cp -p [A-Z]*.out ../tests-devel-keep
	@cp -p [a-l]*.out ../tests-devel-keep
	@cp -p [m-z]*.out ../tests-devel-keep

package: summary timing
	@chmod 644 [A-Z]*/DESCRIPTION
	@chmod 644 [a-z]*/DESCRIPTION
	@for f in *.in; do \
	  cp `basename $$f .in`/DESCRIPTION `basename $$f .in`.Rcheck/00package.dcf; \
	done
	@tar cf mavericks.tar [A-Z]*.Rcheck/00check.log
	@tar rf mavericks.tar [a-z]*.Rcheck/00check.log
	@tar rf mavericks.tar [A-Z]*.Rcheck/00install.out
	@tar rf mavericks.tar [a-z]*.Rcheck/00install.out
	@tar rf mavericks.tar [A-Z]*.Rcheck/00package.dcf
	@tar rf mavericks.tar [a-z]*.Rcheck/00package.dcf
	@rm -f mavericks.tar.bz2
	@bzip2 mavericks.tar
	@scp -pq mavericks.tar.bz2 gannet:/data/gannet/Rlogs

summary:
	@/Users/ripley/R/R-devel/bin/Rscript ../summary.R
	@scp -pq check.csv gannet:/data/gannet/Rlogs/mavericks-check.csv

timing:
	@/Users/ripley/R/R-devel/bin/Rscript ../check_times.R
	@scp -pq timings.tab gannet:/data/gannet/Rlogs/mavericks-times.tab


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
	@/Users/ripley/R/R-devel/bin/Rscript unpack.R

unpack2:
	@/Users/ripley/R/R-devel/bin/Rscript unpack2.R
