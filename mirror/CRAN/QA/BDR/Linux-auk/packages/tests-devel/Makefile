RDEV = Rdev
RLIBS = ~/R/test-3.5
R_VARS = MAKE=make MAKEFLAGS=
BACKUP = ../tests-devel-keep

include ../Makefile.common

%.out: %.in
	@echo $* ...
	-@rm -f $*/src/*.o $*/src/*.so $*/src/symbols.rds
	-+@R_LIBS=$(RLIBS) $(R_VARS) $($*-VARS) time -f "Time %E, %U + %S" $(RDEV) CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	@\cp -p $*.Rcheck/00install.out $*.log
	@rm -rf $*
	@echo ... $* done

all:
	@make backup
	@make unpack
	@script

check: $(OUTS)

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out *.log

backup:
	@cp -p Makefile pkgdiff script unpack.R $(BACKUP)
	-@cp -p *.out *.log $(BACKUP)

unpack:
	@/home/ripley/R/R-devel/bin/Rscript unpack.R
