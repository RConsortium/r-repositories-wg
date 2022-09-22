SOURCES=`find * -maxdepth 0 -type d | grep -v \.Rcheck`

SOURCES=${shell ls *.in}
OUTS=$(SOURCES:.in=.out)

.SUFFICES:
.SUFFICES: .in .out
RDEV = Rdev
R_OPTS=--check-subdirs=yes-maybe
RLIBS=~/R/BioC-3.13

AffyTiling-VARS = MAKE=make MAKEFLAGS=
ArrayExpress-OPTS=--no-examples --no-vignettes
BGmix-VARS = MAKE=make MAKEFLAGS=
DECIPHER-OPTS = --no-vignettes
ENVISIONQuery-OPTS = --no-vignettes
GENE.E-OPTS = --no-examples --no-tests --no-vignettes
GSVA-OPTS = --no-build-vignettes
GOSim-OPTS = --no-vignettes
GenomicRanges-OPTS = --no-vignettes
RMAGEML-OPTS = --install=fake
Rsubread-OPTS = --install=fake
SJava-OPTS = --install=fake
affxparser-VARS = MAKE=make MAKEFLAGS=
annotate-OPTS=--no-examples --no-vignettes
baySeq-OPTS = --no-vignettes
## needs Cytoscape on port 9000
RCytoscape-OPTS = --no-examples --no-tests --no-vignettes
categoryCompare-OPTS = --no-vignettes
## needs Ensemble VEP
ensemblVEP-OPTS = --no-examples --no-tests --no-vignettes
gmapR-OPTS = --no-tests --no-vignettes
rhdf5-VARS = MAKE=make MAKEFLAGS=
segmentSeq-OPTS = --no-vignettes
xps-OPTS = --install=fake

%.out: %.in
	@echo $* ...
	-@rm -f $*/src/*o $*/src/symbols.rds
	-+@R_LIBS=$(RLIBS) $($*-VARS) time -f "Time %E, %U + %S" $(RDEV) --vanilla CMD check $(R_OPTS) $($*-OPTS) $* > $@ 2>&1
	@echo ... $* done

all:
	@make backup unpack
	@script

check: $(OUTS)

backup:
	@cp -p Makefile pkgdiff script unpack.sh ../tests-keep
	-@cp -p *.out ../tests-keep

clean:
	find * -maxdepth 0 -type d -exec rm -rf {} \;
	rm -f *.in

veryclean: clean
	rm -f *.out

unpack:
	-@sh unpack.sh
