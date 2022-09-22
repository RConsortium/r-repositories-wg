## run tests on all sub-archs even for packages with no compiled code
R_OPTS = --force-multiarch
RLIBS = "c:/R/test-3.1;c:/R/BioC-3.0"
RDEV = c:/R/R-3.1.3/bin/x64/Rcmd.exe
RLIB = c:/R/test-3.1

include Makefile.common


%.out: %.log
	@echo $* ...
	-@rm -rf $*.Rcheck
	+@R_LIBS=$(RLIBS) R_BROWSER=false R_PDFVIEWER=false time -f "Time %E" $(RDEV) check $(R_OPTS) $($*-OPTS) -l $(RLIB) --install=check:$*.log $* > $@ 2>&1
	@echo ... $* done

backup:
	cp -p Makefile Makefile.common manip.R exceptions.R reinstall.R *.out *.log ../tests-keep
