pmdoc: mkcont
	./mkdoc

tools: mkcont

mkcont:
	gcc -o $@ mkcont.c -O3 -Wall -pedantic $(CFLAGS) $(CPPFLAGS)

clean:
	rm -rf mkcont *~ R.pmdoc R.pkg R-template.pmdoc/*~

.PHONY: tools clean all pmdoc
