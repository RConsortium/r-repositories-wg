SDIRS:=$(shell find ?.? -type d -name contrib)
TARS:=$(shell find $(SDIRS) -name \*.tar.gz)
BDIRS:=$(shell for i in `find bin/* -name tiger-universal -type d`; do ls -d $$i/bin/?*; done)
BINS:=$(shell find $(BDIRS) -name \*.tgz)
DIRS=$(BDIRS) $(SDIRS)

METADIRS = $(DIRS:%=meta/%)
DESCS = $(TARS:%.tar.gz=meta/%.DESCRIPTION) $(BINS:%.tgz=meta/%.DESCRIPTION)

all: cache

cache: meta $(METADIRS) $(DESCS)
	@(for i in `find meta -name \*DESCRIPTION|sed -e 's|^meta/||' -e '/\/bin\// s/DESCRIPTION/tgz/' -e 's/DESCRIPTION/tar.gz/'`; do \
	  if [ ! -e $$i ]; then echo "$$i doesn't exist, removing meta"; rm -f `echo "$$i"|sed -e 's/tgz$$/DESCRIPTION/' -e 's/tar.gz$$/DESCRIPTION/' -e 's|.*|meta/&|'`; fi; \
	  done)

meta:
	mkdir meta

$(METADIRS):
	mkdir -p $@

meta/%.DESCRIPTION: %.tar.gz
	tar fxzO $< \*/DESCRIPTION > $@

meta/%.DESCRIPTION: %.tgz
	tar fxzO $< \*/DESCRIPTION > $@

.PHONY: all cache
