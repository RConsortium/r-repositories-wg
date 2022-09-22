RDEV=/data/gannet/ripley/R/ATLAS/bin/R
R_OPTS=--check-subdirs=yes-maybe --no-stop-on-test-error
RLIBS=~/R/test-dev

include ~/R/packages/Makefile.common

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

dummy:
	@echo "dummy first target"

all:
	@make unpack
	@./script
	@make summary0

check: $(OUTS)

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out *.log check_log

unpack:
	@/data/gannet/ripley/R/R-devel/bin/Rscript ~/R/packages/tests-devel/unpack.R

process:
	@/data/gannet/ripley/R/R-devel/bin/Rscript process.R

summary:
	@/data/gannet/ripley/R/R-patched/bin/Rscript summary.R | less

summary0:
	-@/data/gannet/ripley/R/R-patched/bin/Rscript summary.R
	@/data/gannet/ripley/R/R-devel/bin/Rscript process.R
