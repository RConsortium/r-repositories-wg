## run tests on all sub-archs even for packages with no compiled code
R_OPTS = --force-multiarch
RLIBS = "c:/R/test-3.3;c:/R/BioC-devel"
RDEV = c:/R/R-devel/bin/x64/Rcmd.exe
RLIB = c:/R/test-3.3

include ../tests/Makefile.common


%.out: %.log
	@echo $* ...
	-@rm -rf $*.Rcheck
	+@R_LIBS=$(RLIBS) R_BROWSER=false R_PDFVIEWER=false time -f "Time %E" $(RDEV) check $(R_OPTS) $($*-OPTS) -l $(RLIB) --install=check:$*.log $* > $@ 2>&1
	@echo ... $* done

backup:
	cp -p Makefile BioC.R manip.R reinstall.R *.out *.log ../tests-devel-keep
