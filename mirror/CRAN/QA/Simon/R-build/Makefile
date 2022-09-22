CFLAGS=-Wall -pedantic -O3

all: fixup consh runpkg

fixup: src/fixup.c
	gcc -o $@ $^ $(CFLAGS) $(CPPFLAGS)
	sudo chown root:admin $@
	sudo chmod a+s $@

runpkg: src/runpkg.c
	gcc -o $@ $^ $(CFLAGS) $(CPPFLAGS)
	sudo chown root:admin $@
	sudo chmod a+s $@

consh: src/consh.c
	gcc -o $@ $^ $(CFLAGS) $(CPPFLAGS)

clean:
	rm -rf *~
	-rm -rf /tmp/CRAN.* /tmp/Rinst* /tmp/Rtmp*

.PHONY: all clean
