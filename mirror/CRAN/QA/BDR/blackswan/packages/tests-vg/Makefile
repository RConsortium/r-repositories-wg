RDEV=/data/blackswan/ripley/R/R-devel-vg/bin/R
R_OPTS=--check-subdirs=yes-maybe --use-valgrind --extra-arch --no-stop-on-test-error
RLIBS=~/R/R-devel/site-library

.PHONY: all check clean veryclean unpack

include ../Makefile.common
REBayes-OPTS = --install=fake
Rmosek-OPTS = --install=fake

bio3d-OPTS = --no-tests

%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o
	-+@R_LIBS=$(RLIBS) $($*-VARS) time -f "Time %E, %U + %S" $(RDEV) CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	@echo ... $* done

dummy:
	@echo "dummy first target"

all:
	@make unpack
	@script
	@make process

check: $(OUTS)

process:
	@cp -p /data/ftp/pub/bdr/memtests/README.txt /data/ftp/pub/bdr/memtests/valgrind
	@/data/blackswan/ripley/R/R-devel-vg/bin/Rscript summary.R
	@/data/blackswan/ripley/R/R-devel/bin/Rscript process.R
	@scp -p valgrind.csv gannet:/data/gannet/Rlogs/memtests

backup:
	@mkdir -p ../tests-vg-keep
	@cp -p Makefile pkgdiff script unpack.R *.out ../tests-vg-keep

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out

unpack:
	@/data/blackswan/ripley/R/R-devel-vg/bin/Rscript unpack.R
