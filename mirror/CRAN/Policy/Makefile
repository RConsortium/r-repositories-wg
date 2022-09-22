MAKEINFO_HTML_FLAGS = --html --no-split --css-include=CRAN_policies.css
MAKEINFO_TEXT_FLAGS = --fill-column=76 --no-split --no-headers --number-sections

all: pdf html

pdf: CRAN_policies.pdf
html: CRAN_policies.html URL_checks.html submission_checklist.html external_libs.html
txt: CRAN_policies.txt

CRAN_policies.pdf: CRAN_policies.texi
	texi2pdf $<

CRAN_policies.html: CRAN_policies.texi CRAN_policies.css
	makeinfo $(MAKEINFO_HTML_FLAGS) $< -o - | sed -f texi2html_pp.sed > $@
##	makeinfo $(MAKEINFO_HTML_FLAGS) $< -o - | grep -v '="dir.html#Top"' > $@

CRAN_policies.txt: CRAN_policies.texi
	makeinfo $(MAKEINFO_TEXT_FLAGS) $< -o $@

URL_checks.html: URL_checks.texi CRAN_policies.css
	makeinfo $(MAKEINFO_HTML_FLAGS) $< -o - | sed -f texi2html_pp.sed > $@

submission_checklist.html: submission_checklist.texi CRAN_policies.css
	makeinfo $(MAKEINFO_HTML_FLAGS) $< -o - | sed -f texi2html_pp.sed > $@

external_libs.html: external_libs.texi CRAN_policies.css
	makeinfo $(MAKEINFO_HTML_FLAGS) $< -o - | sed -f texi2html_pp.sed > $@

## Careful: you need to svn commit before installing as the files
## contain the SVN revision.
install: CRAN_policies.html CRAN_policies.pdf URL_checks.html submission_checklist.html external_libs.html
	scp CRAN_policies.html \
	  cran.wu.ac.at:/home/ftp/pub/R/web/packages/policies.html
	scp CRAN_policies.pdf \
	  cran.wu.ac.at:/home/ftp/pub/R/web/packages/policies.pdf
	scp URL_checks.html \
	  cran.wu.ac.at:/home/ftp/pub/R/web/packages/URL_checks.html
	scp submission_checklist.html \
	  cran.wu.ac.at:/home/ftp/pub/R/web/packages/submission_checklist.html
	scp external_libs.html \
	  cran.wu.ac.at:/home/ftp/pub/R/web/packages/external_libs.html

clean:
	-@rm -f *.aux *.cp *.fn *.html *.ky *.log *.pdf *.pg *.toc *.tp *.vr
