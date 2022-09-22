RDEV=/data/gannet/ripley/R/gcc-SAN/bin/R
R_OPTS=--check-subdirs=yes-maybe --extra-arch --no-stop-on-test-error
RLIBS=~/R/test-dev

include ../Makefile.common
modello-VARS = MAKE=make MAKEFLAGS=

crmPack-OPTS = --no-vignettes
#prc-OPTS=--no-tests

## parallel install use excessive memory
BMSC-VARS = MAKE=make MAKEFLAGS=
blockcluster-VARS = MAKE=make MAKEFLAGS=

DeLorean-VARS = MAKE=make MAKEFLAGS=
MADPop-VARS = MAKE=make MAKEFLAGS=
MetaStan-VARS = MAKE=make MAKEFLAGS=
OpenMx-VARS = MAKE=make MAKEFLAGS=
OsteoBioR-VARS = MAKE=make MAKEFLAGS=
RBesT-VARS = MAKE=make MAKEFLAGS=
Rlgt-VARS = MAKE=make MAKEFLAGS=
baggr-VARS = MAKE=make MAKEFLAGS=
bayes4psy-VARS = MAKE=make MAKEFLAGS=
bayesdfa-VARS = MAKE=make MAKEFLAGS=
bayesvl-VARS = MAKE=make MAKEFLAGS=
beanz-VARS = MAKE=make MAKEFLAGS=
blavaan-VARS = MAKE=make MAKEFLAGS=
bmlm-VARS = MAKE=make MAKEFLAGS=
breathteststan-VARS = MAKE=make MAKEFLAGS=
conStruct-VARS = MAKE=make MAKEFLAGS=
ctsem-VARS = MAKE=make MAKEFLAGS=
dfpk-VARS = MAKE=make MAKEFLAGS=
eggCounts-VARS = MAKE=make MAKEFLAGS=
gastempt-VARS = MAKE=make MAKEFLAGS=
glmmfields-VARS = MAKE=make MAKEFLAGS=
hBayesDM-VARS = MAKE=make MAKEFLAGS=
idealstan-VARS = MAKE=make MAKEFLAGS=
idem-VARS = MAKE=make MAKEFLAGS=
llbayesireg-VARS = MAKE=make MAKEFLAGS=
metaBMA-VARS = MAKE=make MAKEFLAGS=
mlpack-VARS = MAKE=make MAKEFLAGS=
pcFactorStan-VARS = MAKE=make MAKEFLAGS=
rmdcev-VARS = MAKE=make MAKEFLAGS=
rstan-VARS = MAKE=make MAKEFLAGS=
rstanarm-VARS = MAKE=make MAKEFLAGS=
rstanemax-VARS = MAKE=make MAKEFLAGS=
rstap-VARS = MAKE=make MAKEFLAGS=
ssMousetrack-VARS = MAKE=make MAKEFLAGS=
survHE-VARS = MAKE=make MAKEFLAGS=
thurstonianIRT-VARS = MAKE=make MAKEFLAGS=
tmbstan-VARS = MAKE=make MAKEFLAGS=
trialr-VARS = MAKE=make MAKEFLAGS=
visit-VARS = MAKE=make MAKEFLAGS=
walker-VARS = MAKE=make MAKEFLAGS=

%.out: %.in
	@echo $* ...
	@rm -f $*/src/*.[s]o $*/src/*.a $*/src/*/*.o $*/src/*/*/*.o
	-+@R_LIBS=$(RLIBS) $($*-VARS) time -f "Time %E, %U + %S" $(RDEV) CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	@rm -rf $* $*.Rcheck/$*
	@echo ... $* done

dummy:
	@echo "dummy first target"

all:
	-@make backup
	@make unpack
	@./script
	@make unpack1
	@./script 4
	@make process

check: $(OUTS)

backup:
	@mkdir -p ../tests-gcc-SAN-keep
	@cp -p Makefile pkgdiff script process.R process2.R unpack.R *.out ../tests-gcc-SAN-keep

process:
	@/data/gannet/ripley/R/R-devel/bin/Rscript process.R
	@cp -p /data/ftp/pub/bdr/memtests/README.txt /data/ftp/pub/bdr/memtests/gcc-ASAN
	@cp -p /data/ftp/pub/bdr/memtests/README.txt /data/ftp/pub/bdr/memtests/gcc-UBSAN
	@/data/gannet/ripley/R/R-devel/bin/Rscript process2.R

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out check_log

unpack:
	@/data/gannet/ripley/R/R-devel/bin/Rscript unpack.R

unpack1:
	@/data/gannet/ripley/R/R-devel/bin/Rscript unpack1.R
