all: fixtar sched CRAN

fixtar: src/fixtar.c
	gcc -s -o fixtar src/fixtar.c
	sudo chown root:admin fixtar
	sudo chmod a+s fixtar

sched: src/sched.c
	gcc -s -o $@ $^ -O3

packages:

cache: CRAN Makefile.CRAN
	$(MAKE) $(MAKEFLAGS) -C CRAN -f ../Makefile.CRAN cache

CRAN: CRAN.meta
	mkdir -p CRAN/src/contrib
	@(echo "*** use 'sync.bioc.in' to run CRAN+BioC sync")

CRAN.meta:
	mkdir CRAN.meta

bioc.cache:
	$(MAKE) $(MAKEFLAGS) -C BIOC.new cache

help:
	@(echo ''; echo ' Targets: all (fixtar, CRAN), cache, bioc.cache, clean'; echo '')

clean:
	rm -rf *~
	-rm -rf /tmp/CRAN.* /tmp/Rinst* /tmp/Rtmp*

.PHONY: all packages clean bioc.cache
