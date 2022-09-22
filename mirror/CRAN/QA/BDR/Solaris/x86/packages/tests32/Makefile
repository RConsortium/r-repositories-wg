SOURCES=${shell ls *.log}
OUTS=$(SOURCES:.log=.out)

.SUFFICES:
.SUFFICES: .in .out

.PHONY: clean

RDEV=/home/ripley/R/cc/bin/R
RLIBS=/home/ripley/R/Lib32
BACKUP=../tests32-keep

R_OPTS = --check-subdirs=yes-maybe  --no-stop-on-test-error

## runs multicore
spikeSlabGAM-OPTS = --no-vignettes

R2OpenBUGS-OPTS = --no-tests

patchDVI-OPTS = --no-vignettes

## OpenMP hangs
sme-OPTS = --no-examples --no-tests --no-vignettes


## examples hang
distrom-OPTS = --no-examples
clifro-OPTS = --no-tests
RCurl-OPTS = --no-examples

## hit CPU limit
BIEN-OPTS = --no-tests --no-vignettes
Mega2R-OPTS = --no-vignettes
ivmte-OPTS = --no-vignettes
hetGP-OPTS = --no-vignettes
laGP-OPTS = --no-vignettes
lokern-OPTS = --no-tests
morse-OPTS = --no-vignettes
onemap-OPTS = --no-vignettes
ordinalgmifs-OPTS = --no-vignettes
sommer-OPTS = --no-vignettes
tgp-OPTS = --no-vignettes

## hang until overall timeout
svSocket-OPTS = --no-vignettes

## needs R2BayesX
gamboostLSS-OPTS = --no-vignettes

## slow/broken web access
BACA-OPTS = --no-vignettes
DLMtool-OPTS = --no-build-vignettes
DSPRqtl-OPTS = --no-vignettes
EfficientMaxEigenpair-OPTS = --no-vignettes
GPareto-OPTS = --no-vignettes
GiANT-OPTS = --no-vignettes
MSIseq-OPTS = --no-build-vignettes
NCBI2R-OPTS = --no-examples
NMF-OPTS = --no-vignettes
PAGI-OPTS = --no-build-vignettes
PLmixed-OPTS = --no-vignettes
RNCEP-OPTS = --no-examples
SCGLR-OPTS = --no-build-vignettes
SNPtools-OPTS = --no-build-vignettes
TSgetSymbol-OPTS = --no-examples --no-vignettes
STAR-OPTS = --no-build-vignettes
TriMatch-OPTS = --no-build-vignettes
TSjson-OPTS = --no-examples --no-tests
amei-OPTS = --no-build-vignettes
amen-OPTS = --no-vignettes
argparse-OPTS = --no-build-vignettes
babel-OPTS = --no-vignettes
crmPack-OPTS = --no-vignettes
ctmm-OPTS = --no-vignettes
#dismo-OPTS = --no-build-vignettes
easyPubMed-OPTS = --no-examples
knockoff-OPTS = --no-vignettes
lfe-OPTS = --no-vignettes
mcemGLM-OPTS = --no-vignettes
metaMA-OPTS = --no-vignettes
metaRNASeq-OPTS = --no-build-vignettes
mcmc-OPTS = --no-build-vignettes
ndtv-OPTS = --no-build-vignettes
phylosim-OPTS = --no-vignettes
prophet-OPTS = --no-tests
spsurvey-OPTS = --no-vignettes

## needs pari/gp
elliptic-OPTS = --no-vignettes

## tries to use RMySQL
vegdata-OPTS = --no-vignettes
TSdata-OPTS = --no-vignettes

## problems with using snow
DSL-OPTS = --no-build-vignettes

## more BioC packages
opm-OPTS = --no-vignettes

## needs ipython
nbconvertR-OPTS = --no-vignettes

## Fake installs
ROracle-OPTS = --install=fake

## microbenchmark woes
Kmisc-OPTS = --no-vignettes
mvnfast-OPTS = --no-vignettes

## needs pandoc
Gmisc-OPTS = --no-tests

## needs exiftool
camtrapR-OPTS = --no-vignettes

## needs API key
fitbitScraper-OPTS = --no-vignettes

domino-OPTS = --no-tests

## needs rst2pdf
argparse-OPTS = --no-vignettes
optparse-OPTS = --no-vignettes

## very unreliable
ccaPP-OPTS = --no-vignettes
recosystem-OPTS = --no-vignettes
strataG-OPTS = --no-vignettes
future-OPTS = --no-tests
future.BatchJobs-OPTS = --no-tests

## installs in main lib
parlitools-OPTS = --no-vignettes
SUMMER-OPTS = --no-vignettes

## leave processes running
doFuture-OPTS = --no-tests
future.apply-OPTS = --no-tests

%.out: %.log
	@echo $* ...
	@rm -rf /tmp/RL-$*; mkdir /tmp/RL-$*;
	-+@R_LIBS="$(RL):$(RLIBS)" MAKE=make MAKEFLAGS= time $(RDEV) CMD check $* $(R_OPTS) -l $(RLIBS) --install=check:$*.log $($*-OPTS) > $@ 2>&1
	@rm -rf /tmp/RL-$*
	@echo ... $* done

check: $(OUTS)

install:
	@$(RDEV) --slave -f swift.R

installn:
	@$(RDEV) --slave -f swift-parallel.R


backup:
	@mkdir -p $(BACKUP)
	@cp -p Makefile script pkgdiff common.R swift*.R *.log *.out $(BACKUP)

package: summary timings
	@chmod 644 */DESCRIPTION
	@for f in *.out; do \
	  cp `basename $$f .out`/DESCRIPTION `basename $$f .out`.Rcheck/00package.dcf; \
	done
	@gtar cf Solx86.tar *.Rcheck/00check.log 
	@gtar rf Solx86.tar *.Rcheck/00install.out
	@gtar rf Solx86.tar *.Rcheck/00package.dcf
	@xz -f Solx86.tar
	@scp -q Solx86.tar.xz gannet:/data/gannet/Rlogs

summary:
	@Rscript ../summary.R
	@scp -pq check.csv gannet:/data/gannet/Rlogs/Solx86-check.csv

timings:
	@Rscript ../check_times.R
	@scp -pq timings.tab gannet:/data/gannet/Rlogs/Solx86-times.tab

clean0:
	find [A-Z]* -type d -exec rm -rf {} \;
	find [a-z]* -type d -exec rm -rf {} \;

veryclean: clean0
	rm -f *.out *.log

rm-recommended:
	rm -rf KernSmooth.* MASS.* Matrix.log Matrix.out class.* \
          boot.log boot.out cluster.log cluster.out \
	  codetools.* foreign.* lattice.* mgcv.* nlme.* nnet.* \
	  rpart.log rpart.out spatial.log spatial.out survival.*

cp-recommended:
	(cd ../tests32-keep; cp -p KernSmooth.out MASS.out Matrix.out \
	  boot.out class.out cluster.out \
          codetools.out foreign.out lattice.out mgcv.out nlme.out nnet.out \
          rpart.out spatial.out survival.out \
	  KernSmooth.log MASS.log Matrix.log \
          boot.log class.log cluster.log \
          codetools.log foreign.log lattice.log mgcv.log nlme.log nnet.log \
          rpart.log spatial.log survival.log \
	../tests32)
