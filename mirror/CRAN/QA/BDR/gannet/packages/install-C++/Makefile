RDEV=/data/gannet/ripley/R/R-devel/bin/R
RLIBS=~/R/test-4.0
R_MAKEVARS = ~/R/packages/install-C++/Makevars


include ../Makefile.common

%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o
	@mkdir -p ~/R/packages/install-C++/Libs/$*-lib
	-+@R_LIBS=$(RLIBS) MAKE=make MAKEFLAGS= R_MAKEVARS_USER=$(R_MAKEVARS) time -f "Time %E, %U + %S" $(RDEV) CMD INSTALL -l ~/R/packages/install-C++/Libs/$*-lib $* >$@ 2>&1
	@echo ... $* done

check: $(OUTS)

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out


unpack:
	@/data/gannet/ripley/R/R-devel/bin/Rscript unpack.R

unpack-clang:
	@/data/gannet/ripley/R/R-clang/bin/Rscript unpack-clang.R
