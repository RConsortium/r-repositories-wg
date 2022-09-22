RDEV=/data/blackswan/ripley/R/R-patched/bin/R
R_OPTS=--check-subdirs=yes-maybe
RLIBS=~/R/R-patched/site-library

include ../Makefile.common

%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o
	-+@R_LIBS=$(RLIBS) $($*-VARS) time -f "Time %E, %U + %S" $(RDEV) CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	@echo ... $* done

.PHONY: all check clean veryclean unpack

dummy:
	@echo "dummy first target"

all:
	@make backup unpack
	@script

check: $(OUTS)

backup:
	@mkdir -p ../tests-keep
	@cp -p Makefile pkgdiff script unpack.R *.out ../tests-keep

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out

unpack:
	@~/R/R-patched/bin/Rscript unpack.R
