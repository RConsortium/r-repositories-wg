all: cleanrr mkfw

BASE=$(shell dirname `pwd`)
CPPFLAGS=-DBASE="\"$(BASE)\""

cleanrr: cleanrr.o
	rm -f $@
	$(CC) -s -o $@ $<
	sudo chown root:admin $@
	sudo chmod a+s $@

mkfw: mkfw.o
	rm -f $@
	$(CC) -s -o $@ $<
	sudo chown root:admin $@
	sudo chmod a+s $@

clean:
	rm -f *.o cleanrr mkfw *~

.PHONY: clean
