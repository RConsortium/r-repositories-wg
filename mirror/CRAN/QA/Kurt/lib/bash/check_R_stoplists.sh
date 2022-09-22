## Data base of special flags to be employed for CRAN package checking.

## Packages which depend on unavailable packages cannot be installed,
## and hence must be checked with '--install=no'.  (This used to include
## all packages depending on packages from Bioconductor or Omegahat.)
## The same applies to reverse dependencies of such packages, of course.
## For sake of simplicity, we also use --install=no for packages with
## non-CRAN depends which cannot fully be installed.
##
## Packages which can otherwise not fully be installed must be checked
## with '--install=fake'.  This includes
## * Packages  which depend on unavailable external software (as
##   hopefully recorded in the package DESCRIPTION SystemRequirements,
##   and checked for using the package configure scripts)
## * Packages for which installation takes too long
## * Packages for which *loading* requires special system conditions
## * Reverse dependencies of such packages.
## (This operates under the assumption that installation does not run
## package code.)
##
## Packages for which *running* requires special system conditions are
## fully installed (unless this takes too long), but all run-time checks
## are turned off.
##
## Package run time tests which take too long are selectively turned off.
##
## We control the flags via a simple flag data base which for reasons of
## portability does not take advantage of Bash arrays.  For convenience
## (to avoid iterating through the db) we record the fake/no install
## packages right away.

no_run_time_checks_args="--no-examples --no-vignettes --no-tests"

pkgs_install_fake_regexp=
pkgs_install_no_regexp=

set_check_args () {
    safe=`echo "${1}" | tr . _`
    eval "check_args_db_${safe}='${2}'"
    case "${2}" in
      --install=fake)
        pkgs_install_fake_regexp="${pkgs_install_fake_regexp}|${1}" ;;
      --install=no)
        pkgs_install_no_regexp="${pkgs_install_no_regexp}|${1}" ;;
    esac
}
get_check_args () {
    safe=`echo "${1}" | tr . _`
    eval echo '${'check_args_db_${safe}'}' ;
}

## As of 2021-10, this apparently checks ok "as is".
## ## Package Rmosek requires MOSEK (hence needs at least a fake install)
## ## and exports shared object symbols into the namespace (hence, no).
## ## As of 2019-01, apparently --install=fake is good enough ...
## ## set_check_args Rmosek			"--install=no"
## set_check_args Rmosek			"--install=fake"
## ## Package REBayes depends on Rmosek.
## ## set_check_args REBayes			"--install=no"
## set_check_args REBayes			"--install=fake"

## Package RSAP needs SAP headers/libraries and exports shared object
## symbols into the namespace.
set_check_args RSAP			"--install=no"		# Archived

## Packages which depend on Windows.
## Packages with OS_type 'windows' as of 2014-12-23:
##   BiplotGUI excel.link installr MDSGUI R2MLwiN R2PPT R2wd RPyGeo
##   RWinEdt 
## Packages which depend on these: none.
## There really is no need to special-case these as
## * Checking on Linux automatically switches to --install=no.
## * Regular CRAN checking skips these packages (using OS_type for
##   filtering available packages) [mostly to avoid false positives
##   when checking Windows-specific content (Rd xrefs)].
## <FIXME>
## Is this needed?
##   Package excel.link depends on RDCOMClient (@Omegahat) which only
##   works under Windows.
##     set_check_args excel.link		"--install=no"
## </FIXME>

## Packages which depend on 64-bit Linux.
## (Archived in 2010.)
##   set_check_args cmprskContin	"--install=fake"

## Package which depend on external software packages.
## Package FEST requires merlin.
set_check_args FEST			"--install=fake"	# Archived
## Package HiPLARM needs CUDA/PLASMA/MAGMA.
set_check_args HiPLARM			"--install=fake"	# Archived
## Package R2OpenBUGS requires OpenBugs: this has Ubuntu binaries at
## http://www.openbugs.info/w/Downloads but no Debian binaries.
## Re-activated 2014-12-18: no longer true.
##   set_check_args R2OpenBUGS		"--install=fake"
## Package RMark requires MARK which is not open source.
set_check_args RMark			"--install=fake"
## Package RMongo requires MongoDB.
## Re-activated 2014-12-18.
##   set_check_args RMongo		"--install=fake"
## Package ROracle requires Oracle.
set_check_args ROracle			"--install=fake"
## Packages ROracleUI ora depend on ROracle.
set_check_args ROracleUI		"--install=fake"	# Archived
set_check_args ora			"--install=fake"
## Packages Rcplex cplexAPI require the CPLEX solvers.
set_check_args Rcplex			"--install=fake"
set_check_args cplexAPI			"--install=fake"
## Package Rlsf requires LSF.
set_check_args Rlsf			"--install=fake"	# Archived
## Package caretLSF depends on Rlsf.
set_check_args caretLSF			"--install=fake"	# Archived
## Packages that require CUDA:
##    CARramps FSCUDA WideLM cudaBayesreg gmatrix gpda gputools iFes
##    kmcudaR magma permGPU rpud
set_check_args CARramps			"--install=fake"	# Archived
set_check_args FSCUDA			"--install=fake"	# Archived
set_check_args WideLM			"--install=fake"	# Archived
set_check_args cudaBayesreg		"--install=fake"	# Archived
set_check_args gmatrix			"--install=fake"	# Archived
set_check_args gpda			"--install=fake"	# Archived
set_check_args gputools			"--install=fake"	# Archived
set_check_args iFes			"--install=fake"	# Archived
set_check_args kmcudaR			"--install=fake"
set_check_args magma			"--install=fake"	# Archived
set_check_args permGPU			"--install=fake"
set_check_args rpud			"--install=fake"	# Archived
## As of 2021-10, this apparently installs ok "as is".
## ## Package gcbd requires a lot (MKL, CUDA, ...)
## set_check_args gcbd			"--install=fake"
## Package rLindo needs LINDO API 8.0 (no Debian package).
set_check_args rLindo			"--install=fake"	# Archived
## Package rsbml needs libsbml (no Debian package).
## (Moved from CRAN to Bioconductor.)
##   set_check_args rsbml		"--install=fake"
## Package ndvits needs TISEAN executables from
## http://www.mpipks-dresden.mpg.de/~tisean/.
##   set_check_args ndvits		"--install=fake"
## Package ncdf4 requires libnetcdf 4.1 or better, which as of
## 2010-02-24 is only in Debian experimental, and breaks RNetCDF.
##   set_check_args ncdf4		"--install=fake"

## As of 2021-10, this apparently installs ok "as is".
## ## Package localsolver needs localsolver.
## set_check_args localsolver		"--install=fake"
## Package RElem needs Libelemental.
set_check_args RElem			"--install=fake"	# Archived

## Packages for which *loading* requires special system conditions.
## Loading package Rmpi calls lamboot (which it really should not as
## this is implementation specific).  However, fake installs seem to
## cause trouble for packages potentially using Rmpi ...
##   set_check_args Rmpi		"--install=fake"
## Loading package RScaLAPACK calls lamboot or mpdboot.
set_check_args RScaLAPACK		"--install=fake"	# Archived
## Loading package taskPR calls lamnodes.
##   set_check_args taskPR			"--install=fake"

## Packages which take too long to install.
##   set_check_args RQuantLib		"--install=fake"

## Packages for which *running* requires special system conditions.
## Package caRpools needs MAGeCK.
set_check_args caRpools			"${no_run_time_checks_args}"
## Package caretNWS run-time depends on NWS.
set_check_args caretNWS			"${no_run_time_checks_args}"	# Archived
## Package sound requires access to audio devices.
##   set_check_args sound		"${no_run_time_checks_args}"
## Package rpvm might call PVM.
set_check_args rpvm			"${no_run_time_checks_args}"	# Archived
## Package npRmpi requires special MPI conditions.
set_check_args npRmpi			"${no_run_time_checks_args}"	# Archived
## Package nbconvertR requires ipython (>= 3.0), but as of 2015-07-10
## Debian testing only has ipython 2.3.0.
## Re-activated 2018-09-25.
##   set_check_args nbconvertR		"${no_run_time_checks_args}"
## Package domino needs the domino command line client.
## Re-activated 2021-10-18:
##   set_check_args domino		"--no-tests"
## Package ROI.plugin.cplex needs CPLEX.
set_check_args ROI.plugin.cplex		"--no-tests"
## As of 2016-01-04, the Intel OpenCL drivers do not yet support OpenCL
## 2.0 (needed for gpuR); using the Debian opencl-headers and AMD driver
## packages provides this, but finds no devices ...
## Re-activated 2022-01-09 (pocl back in unstable).
##   set_check_args OpenCL		"${no_run_time_checks_args}"
## Re-activated 2018-09-25.
##   set_check_args CARrampsOcl		"${no_run_time_checks_args}"
## Seems we have no OpenCL drivers which make current gpuR happy:
set_check_args gpuR			"--no-tests"		# Archived
## Package bayesCL needs OpenCL.
set_check_args bayesCL			"${no_run_time_checks_args}"	# Archived
## Package rbi needs LibBi <http://libbi.org>.
## Re-activated 2021-11-18:
##   set_check_args rbi			"${no_run_time_checks_args}"
## Package IRATER needs ADMB <http://admb-project.org>.
set_check_args IRATER			"${no_run_time_checks_args}"
## Package localsolver needs localsolver.
set_check_args localsolver		"${no_run_time_checks_args}"

## Packages which (may) cause trouble when running their code as part of
## R CMD check.

## Package BACA keeps failing its vignette checks.
## Re-activated 2016-06-27.
##   set_check_args BACA		"--no-vignettes"

## As of 2018-07, package BIEN keeps hanging in its tests.  As of
## 2019-03, also in its vignettes ...
## Re-activated 2021-10-18.
##   set_check_args BIEN		"${no_run_time_checks_args}"

## As of 2019-03, BMTME has problems in its tests.
## Re-activated 2021-10-18.
##   set_check_args BMTME		"--no-tests"

## Package DSL needs a working Hadoop environment for its vignette.
##   set_check_args DSL			"--no-vignettes"

## Package ElstonStewart keeps hanging.
## Re-activated 2016-06-27.
##   set_check_args ElstonStewart	"${no_run_time_checks_args}"

## As of 2016-06, package GSE keeps hanging (at least when using the GCC
## 6 compilers).
## Re-activated 2018-09-25.
##   set_check_args GSE			"--no-examples"

## As of 2018-11, package GetITRData keeps having trouble accessing web
## resources in its vignette.
set_check_args GetITRData		"--no-vignettes"	# Archived

## Goslate keeps getting HTTP Error 503: Service Unavailable.
## Archived on 2016-04-07
##    set_check_args Goslate		"--no-examples"

## As of 2018-03, package NMF on all Debian systems fails to run its
## examples and/or vignettes with 
##   Error: memory could not be allocated for instance of type big.matrix
## Re-activated 2019-01-09.
##   set_check_args NMF			"${no_run_time_checks_args}"

## Package NORMT3 keeps exploding memory on linux/amd64.
## Re-activated 2010-11-03.
##   set_check_args NORMT3		"${no_run_time_checks_args}"

## Package OjaNP (0.9-4) keeps hanging.
## Re-activated 2011-12-13.
##   set_check_args OjaNP		"${no_run_time_checks_args}"

## As of 2016-10, package RFc keeps hanging.
set_check_args RFc			"${no_run_time_checks_args}"	# Archived

## As of 2011-01, package RLastFM kept hanging on several platforms.
## Re-activated 2011-12-13.
##   set_check_args RLastFM		"${no_run_time_checks_args}"

## Package Rgretl uses gretl, which apparently always creates ~/.gretl
## (acceptable) and ~/gretl (definitely not).
set_check_args Rgretl			"${no_run_time_checks_args}"	# Archived

## Package Rlabkey had examples which require a LabKey server running on
## port 8080 of localhost.  No longer as of 2010-08-24.
##   set_check_args Rlabkey		"${no_run_time_checks_args}"

## As of 2016-11, package Rtts keeps hanging in its examples.
## Re-activated 2019-01-09.
##   set_check_args Rtts		"--no-examples"

## Package SNPtools keeps hanging.
## Re-activated 2016-06-27.
##   set_check_args SNPtools		"${no_run_time_checks_args}"

## Package TSdata needs data base run time functionality.
set_check_args TSdata			"--no-vignettes"

## Package TSjson keeps hanging.
## Archived on 2015-02-01.
##   set_check_args TSjson		"${no_run_time_checks_args}"

## As of 2016-06, package XBRL keeps hanging.
## Re-activated 2016-07-03.
##   set_check_args XBRL		"${no_run_time_checks_args}"

## As of 2012-03-03, package adegenet keeps hanging.
##   set_check_args adegenet		"${no_run_time_checks_args}"

## As of 2019-03, package bazar keeps leaving an rscala process behind
## which blocks the umount of the read-only user library, and hence
## trashes subsequent check runs. 
set_check_args bazar			"${no_run_time_checks_args}"

## Package beanplot keeps leaving a pdf viewer behind.
## Re-activated 2010-11-03.
##   set_check_args beanplot		"${no_run_time_checks_args}"

## Package brew (1.0-2) keeps hanging.
## Re-activated 2011-12-13.
##   set_check_args brew		"${no_run_time_checks_args}"

## Package catnet keeps hanging in its examples or vignettes.
## Re-activated 2019-01-09.
##   set_check_args catnet		"${no_run_time_checks_args}"

## As of 2018-04, package ccaPP keeps hanging in its vignette, every now
## and then ...
## Re-activated 2021-10-18.
##   set_check_args ccaPP		"--no-vignettes"

## Package celsius (1.0.7) keeps hanging, most likely due to slow web
## access to http://celsius.genomics.ctrl.ucla.edu.
## Archived on 2010-07-30.
##   set_check_args celsius		"${no_run_time_checks_args}"

## Package climdex.pcic (1.0-3) keeps segfaulting when running
## tests/bootstrap.R, which manages to hang the check process(es).
## Re-activated 2019-01-09.
##   set_check_args climdex.pcic	"--no-tests"

## As of 2017-12, package clustermq fails its tests and leaves testthat
## child processes behind.
## Re-activated 2017-12-19.
##   set_check_args clustermq		"--no-tests"

## As of 2016-11, package coop keeps failing its tests.
## Re-activated 2019-01-09.
##   set_check_args coop		"--no-tests"

## As if 2020-11, data.table has yet another error from testing things
## it should not test for.  As these problems never get fixed in a
## timely manner, best to avoid finding these.
set_check_args data.table		"--no-tests"

## As of 2016-08, package distrom keeps hanging.
## Re-activated 2019-01-09.
##   set_check_args distrom		"${no_run_time_checks_args}"

## As of 2016-09, Rmpi tests in doRNG seem to hang.
## Re-activated 2019-01-09.
##   set_check_args doRNG		"--no-tests"

## Package dynGraph leaves a JVM behind.
set_check_args dynGraph			"${no_run_time_checks_args}"	# Archived

## As of 2018-04, package edarf keeps failing its tests with lots of
## output.
## Re-activated 2019-01-09.
##   set_check_args edarf		"--no-tests"

## As of 2016-11, package easyPubMed keeps hanging.
## Re-activated 2019-01-23.
##   set_check_args easyPubMed		"--no-examples"

## As of 2017-06, package eyetrackingR keeps hanging.
## Re-activated 2019-01-09.
##   set_check_args eyetrackingR	"${no_run_time_checks_args}"

## Package feature (1.1.9) kept hanging on at least one ix86 platform
## (late May 2007).
## Re-activated 2010-11-03.
##   set_check_args feature		"${no_run_time_checks_args}"

## Package fitbitScraper needs an API key for running its vignette.
set_check_args fitbitScraper		"--no-vignettes"

## Package fscaret (1.0) hangs on 2013-06-14.
## Re-activated 2013-06-17.
##   set_check_args fscaret		"${no_run_time_checks_args}"

## Package gcbd needs gputools for its vignettes.
set_check_args gcbd			"--no-vignettes"

## As of 2017-09, package harvestr fails its tests as often as not.
## Re-activated 2019-01-09.
##   set_check_args harvestr		"--no-tests"

## Package httpRequest kept causing internet access trouble.
##   set_check_args httpRequest		"${no_run_time_checks_args}"

## Package hwriter keeps hanging the browser.
## Apparently (2009-02-11) not any more ...
##   set_check_args hwriter		"${no_run_time_checks_args}"

## Package junr needs little CPU but lots of elapsed time to run its
## vignettes and tests.
## Re-activated 2019-01-09.
##   set_check_args junr		"--no-vignettes --no-tests"

## As of 2016-11, package largeVis keeps hanging.
set_check_args largeVis			"${no_run_time_checks_args}"	# Archived

## As of 2019-11, package lifecontingencies keeps failing in its
## vignettes (problems in pandoc?).
## Re-activated 2021-10-18.
##   set_check_args lifecontingencies	"--no-vignettes"

## As of 2010-01, package meboot hung amd64 check processes.
## Re-activated 2011-12-13.
##   set_check_args meboot		"${no_run_time_checks_args}"

## As of 2018-08, package metaBMA keeps hanging.
## Re-activated 2019-01-09.
##   set_check_args metaBMA		"--no-vignettes"

## Package multicore leaves child processes behind.
set_check_args multicore		"${no_run_time_checks_args}"	# Archived

## As of 2017-05-01, package nzelect again hangs in its vignettes.
## Re-activated 2019-01-09.
##   set_check_args nzelect		"--no-vignettes"

## As of 2019-01, package odpc keeps hanging in its tests on most of the
## regular check runs.
## Re-activated 2021-10-18:
##   set_check_args odpc		"--no-tests"

## Package patchDVI contains a vignette with Japanese text which
## requires a localized version of LaTeX for processing.
##   set_check_args patchDVI		"--no-build-vignettes"

## As of 2018-03, package pbmcapply keeps eating its example input.
## Re-activated 2019-01-09.
##   set_check_args pbmcapply		"--no-examples"

## As of 2016-07, package pdfetch keeps hanging.
## Re-activated 2019-01-09.
##   set_check_args pdfetch		"${no_run_time_checks_args}"

## As of 2016-02-26, package plotly allocates too much VM.
## Re-activated 2016-06-27.
##   set_check_args plotly		"--no-tests"

## Package ptinpoly (2.0) keeps hanging
## Re-activated 2016-06-27.
##   set_check_args ptinpoly		"${no_run_time_checks_args}"

## As of 2015-05-05, package raincpc keeps hanging in its vignettes
## checks.
## Re-activated 2016-06-27.
##   set_check_args raincpc		"--no-vignettes"

## Package random keeps failing its tests at random with
##   URL 'https://www.random.org/integers/?num=100&min=1&max=100&col=5&base=10&format=plain&rnd=new': status was '503 Service Unavailable'
## Re-activated 2019-01-09.
##   set_check_args random		"--no-tests"

## As of 2018-10, package rcongresso often has trouble accessing 
## web resources.
set_check_args rcongresso		"${no_run_time_checks_args}"	# Archived

## As of 2016-03, package rentrez keeps having trouble accessing
## web reources.
## Re-activated 2016-06-27.
##   set_check_args rentrez		"--no-vignettes"

## As of 2019-12, package restfulr has strange problems in the tests.
set_check_args restfulr			"--no-tests"

## As of 2018-04, package roadoi keeps having problems accessing
## api.oadoi.org.
## Re-activated 2019-01-09.
##   set_check_args roadoi		"--no-vignettes"

## As of 2016-05, package robreg3S keeps hanging.
## Re-activated 2019-01-09.
##   set_check_args robreg3S		"${no_run_time_checks_args}"

## As of 2016-06, package robustvarComp keeps hanging (at least when
## using the GCC 6 compilers).
## Re-activated 2018-09-25.
##   set_check_args robustvarComp	"--no-examples"

## As of 2017-09, package rprev times out rebuilding its vignettes.
## Re-activated 2019-01-09.
##   set_check_args rprev		"--no-vignettes"

## As of 2019-12, package rsolr has strange problems in its vignettes.
## Running the tests downloads 150MB into the R user dir, so skip too.
## Re-activated 2022-05-18.
##   set_check_args rsolr		"--no-vignettes --no-tests"
## As of 2022-06, the tests sometimes run forever, so turn off again.
set_check_args rsolr			"--no-tests"

## As of 2018-08, package runjags keeps hanging in its examples (and the
## tests already took too long).
## Re-activated 2019-01-09.
##   set_check_args runjags		"${no_run_time_checks_args}"

## Package rslurm needs SLURM for its vignettes.
## Re-activated 2017-10-21.
##   set_check_args rslurm		"--no-vignettes"

## As of 2015-11-28, package rstatscn keeps hanging.
## Re-activated 2016-06-27.
##   set_check_args rstatscn		"--no-examples"

## As of 2016-03-14, package rusda keeps having trouble accessing
## web reources.
## Re-activated 2016-06-27.
##   set_check_args rusda		"${no_run_time_checks_args}"

## As of 2016-09, Rmpi tests in simsalapar (tstTGforecasts.R) seem to
## hang.
## Re-activated 2021-10-18.
##   set_check_args simsalapar		"--no-tests"

## As of 2017-06-26, spatgraphs keeps hanging in its examples when
## compiled with GCC 7 (Debian 7.1.0-9).
## Re-activated 2018-09-25.
##   set_check_args spatgraphs		"--no-examples"

## Package speedglm keeps failing its examples due to problems with web
## access to http://dssm.unipa.it/enea/data1.txt.
## Re-activated 2016-06-27.
##   set_check_args speedglm		"--no-examples"

## As of 2016-07, package strataG keeps hanging.
set_check_args strataG			"--no-vignettes"	# Archived

## As of 2019-01, package superml keeps hitting the total check timeout
## (interestingly, only on gimli2 ...).
## Re-activated 2021-10-18.
##   set_check_args superml		"--no-vignettes"

## As of 2019-01, package surveysd keeps hitting the total check timeout
## (interestingly, only on gimli2 ...).
## Re-activated 2021-10-18.
##   set_check_args surveysd		"--no-tests"

## As of 2016-11, package systemicrisk keeps hanging in its vignettes.
## Re-activated 2019-01-09.
##   set_check_args systemicrisk	"--no-vignettes"

## As of 2018-08, package tidybayes keeps hanging.
## Re-activated 2019-01-09.
##   set_check_args tidybayes		"--no-tests"

## <FIXME>
## As of 2020-10, package tiledb seems to cause trouble?
##   set_check_args tiledb			"${no_run_time_checks_args}"
##   set_check_args tiledb			"--no-vignettes --no-tests"
## </FIXME>

## Package titan requires interaction.
## Re-activated 2010-11-03.
##   set_check_args titan		"${no_run_time_checks_args}"

## Package vardpoor uses an unstable web resource in its examples.
## Re-activated 2019-01-09.
##   set_check_args vardpoor		"--no-examples"

## Packages which keep having problems accessing maps.googleapis.com.
## Re-activated 2019-01-25.
##   set_check_args FLightR		"--no-examples --no-tests"
##   set_check_args LearnGeom		"--no-examples"
##   set_check_args OutbreakTools	"--no-examples --no-vignettes" # Archived
##   set_check_args PWFSLSmoke		"--no-vignettes"
##   set_check_args RapidPolygonLookup	"--no-vignettes"
##   set_check_args RgoogleMaps		"--no-examples"
##   set_check_args SensusR		"--no-examples"
##   set_check_args census		"--no-examples --no-vignettes" # Archived
##   set_check_args earthtones		"--no-vignettes --no-tests" 
##   set_check_args ggmap		"--no-examples"
##   set_check_args ggvoronoi		"--no-vignettes"
##   set_check_args moveVis		"--no-tests"
##   set_check_args placement		"--no-examples"                # Archived
##   set_check_args stormwindmodel	"--no-vignettes"

## Packages for which run-time checks take too long.
##   set_check_args Bergm		"${no_run_time_checks_args}"
##   set_check_args GenABEL		"${no_run_time_checks_args}"
##   set_check_args IsoGene		"${no_run_time_checks_args}"
##   set_check_args SubpathwayMiner	"${no_run_time_checks_args}"
##   set_check_args degreenet		"${no_run_time_checks_args}"
##   set_check_args ensembleBMA		"${no_run_time_checks_args}"
##   set_check_args eqtl		"${no_run_time_checks_args}"
##   set_check_args expectreg		"${no_run_time_checks_args}"
##   set_check_args fields		"${no_run_time_checks_args}"
##   set_check_args gamm4		"${no_run_time_checks_args}"
##   set_check_args geozoo		"${no_run_time_checks_args}"
##   set_check_args ks			"${no_run_time_checks_args}"
##   set_check_args latentnet		"${no_run_time_checks_args}"
##   set_check_args mixtools		"${no_run_time_checks_args}"
##   set_check_args np			"${no_run_time_checks_args}"
##   set_check_args pscl		"${no_run_time_checks_args}"
##   set_check_args rWMBAT		"${no_run_time_checks_args}"
##   set_check_args sna			"${no_run_time_checks_args}"
##   set_check_args speff2trial		"${no_run_time_checks_args}"
##   set_check_args surveillance	"${no_run_time_checks_args}"
##   set_check_args ttime		"${no_run_time_checks_args}"

FQDN=`hostname -f`
case ${FQDN} in
  xmgyges.wu.ac.at)
    ## Package BRugs requires OpenBugs which currently is only
    ## available for amd64.
    ## [As of 2012-03-14, not any more ...]
    ## Packages BTSPAS and tdm depend on BRugs.
    ##   set_check_args BRugs		"--install=fake"
    ##   set_check_args BTSPAS		"--install=fake"
    ##   set_check_args tdm		"--install=fake"
    ## Package OpenCL requires OpenCL headers and libraries.
    ## Intel's SDK is only available for amd64.
    set_check_args OpenCL		"--install=fake"
    ## Package lokern keeps hanging in its tests.
    set_check_args lokern		"--no-tests"
    ;;
esac

## Packages for which some run-time checks take too long ...
set_check_args BASS			"--no-vignettes"
## set_check_args BB			"--no-vignettes"
set_check_args Bclim			"--no-vignettes"	# Archived
## set_check_args GLIDE			"--no-vignettes"
set_check_args GPareto			"--no-vignettes"
## set_check_args GSM			"--no-tests"
set_check_args GiANT			"--no-vignettes"	# Archived
## Re-activated 2021-10-18:
##   set_check_args HTLR		"--no-vignettes"
set_check_args HTSSIP			"--no-vignettes"
## set_check_args MSIseq		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args ModelMap		"--no-vignettes"
## set_check_args NITPicker		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args NNS			"--no-vignettes"
set_check_args NetworkChange		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args PowerTOST		"--no-vignettes"
set_check_args RBrownie			"--no-vignettes"	# Archived
set_check_args RSuite			"--no-vignettes"	# Archived
## set_check_args STAR			"--no-vignettes"
## set_check_args SensMixed		"--no-tests"
## set_check_args TBSSurvival		"--no-tests"
set_check_args TrajDataMining		"--no-tests"
set_check_args TropFishR		"--no-vignettes"
## set_check_args VSE			"--no-vignettes"
set_check_args amen			"--no-vignettes"
set_check_args aptg			"--no-vignettes"
set_check_args bark			"--no-examples"		# Archived
## Re-activated 2021-10-18:
##   set_check_args colorednoise	"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args comorbidity		"--no-tests"
set_check_args crmPack			"--no-vignettes"
set_check_args ctmm			"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args ctsem		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args dismo		"--no-vignettes"
set_check_args ergm			"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args expss		"--no-tests"
## set_check_args fCopulae		"--no-tests"
set_check_args fmlogcondens		"--no-vignettes"	# Archived
set_check_args fxregime			"--no-vignettes"
set_check_args glmmsr			"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args gtfs2gps		"--no-tests"
## set_check_args heemod		"--no-tests"
set_check_args hetGP			"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args httk		"--no-vignettes"
## set_check_args hydrolinks		"--no-vignettes"
set_check_args iSubpathwayMiner		"--no-vignettes"	# Archived
## set_check_args icosa			"--no-vignettes"
set_check_args ifaTools			"--no-tests --no-vignettes"
set_check_args ivmte			"--no-vignettes"
set_check_args knockoff			"--no-vignettes"
set_check_args laGP			"--no-vignettes"
set_check_args lolog			"--no-vignettes"
set_check_args mazeinda			"--no-vignettes"
set_check_args mcemGLM			"--no-vignettes"
## set_check_args mediation		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args micEconCES		"--no-vignettes"
set_check_args misreport		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args morse		"--no-vignettes"
set_check_args mrdrc			"--no-tests"		# Archived
set_check_args onemap			"--no-vignettes"
set_check_args optimall			"--no-vignettes"
## set_check_args ordinalgmifs		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args patentsview		"--no-vignettes"
set_check_args phybreak			"--no-vignettes"	# Archived
set_check_args phylosim			"--no-vignettes"	# Archived
## Re-activated 2021-10-18:
##   set_check_args pmc			"--no-vignettes"
## set_check_args portfolioSim		"--no-vignettes"
set_check_args psychomix		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args segclust2d		"--no-vignettes"
set_check_args segmentr			"--no-vignettes"
set_check_args simulator		"--no-vignettes"	# Archived
## Re-activated 2021-10-18:
##   set_check_args smooth		"--no-vignettes"
set_check_args sommer			"--no-vignettes"
set_check_args sperrorest		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args spikeSlabGAM	"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args spsurvey		"--no-vignettes"
set_check_args stapler			"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args steps		"--no-tests"
## set_check_args superml		"--no-vignettes"
set_check_args survPen			"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args tergm		"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args textmineR		"--no-vignettes"
set_check_args tgp			"--no-vignettes"
## Re-activated 2021-10-18:
##   set_check_args tvReg		"--no-vignettes"
set_check_args twang			"--no-vignettes"
set_check_args xtractomatic		"--no-vignettes"	# Archived
## set_check_args PerformanceAnalytics	"--no-examples --no-vignettes"
## set_check_args Rcgmin		"--no-tests"
## set_check_args Rvmmin		"--no-tests"
## set_check_args TESS			"--no-vignettes"
## set_check_args TilePlot		"--no-examples"
## set_check_args TriMatch		"--no-vignettes"
## set_check_args Zelig			"--no-vignettes"
## set_check_args abc			"--no-vignettes"
## set_check_args amei			"--no-vignettes"
## set_check_args bcool			"--no-vignettes"
## set_check_args caret			"--no-vignettes"
## set_check_args catnet		"--no-vignettes"
## set_check_args crimCV		"--no-examples"
## set_check_args crs			"--no-vignettes"
## set_check_args dmt			"--no-vignettes"
## set_check_args fanplot		"--no-vignettes"
## set_check_args geiger		"--no-vignettes"
## set_check_args ggstatsplot		"--no-vignettes"
## set_check_args lossDev		"--no-vignettes"
## set_check_args mcmc			"--no-vignettes"
## set_check_args metaMA		"--no-vignettes"
## set_check_args pomp			"--no-tests"
## set_check_args rebmix		"--no-vignettes"
## set_check_args runjags		"--no-tests"
## set_check_args unmarked		"--no-vignettes"

## Done.

if test -n "${pkgs_install_fake_regexp}"; then
    pkgs_install_fake_regexp=`
        echo "${pkgs_install_fake_regexp}" | sed 's/^|/^(/; s/$/)$/;'`
fi    
if test -n "${pkgs_install_no_regexp}"; then
    pkgs_install_no_regexp=`
	echo "${pkgs_install_no_regexp}" | sed 's/^|/^(/; s/$/)$/;'`
fi    

### Local Variables: ***
### mode: sh ***
### sh-basic-offset: 2 ***
### End: ***
