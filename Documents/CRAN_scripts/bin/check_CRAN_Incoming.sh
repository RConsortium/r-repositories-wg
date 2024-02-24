#! /bin/sh

check_dir="${HOME}/tmp/CRAN"
## R_check_library="${HOME}/tmp/R.check/Library"
R_check_library="${check_dir}/Library"
sh_scripts_dir="${HOME}/lib/bash"

xvfb_run='xvfb-run -a --server-args="-screen 0 1024x768x24"'

export _R_CHECK_CRAN_INCOMING_=true
export _R_CHECK_CRAN_INCOMING_USE_ASPELL_=true

export R_GC_NGROWINCRFRAC=0.2
export R_GC_VGROWINCRFRAC=0.2

update_check_dir=true
ignore_check_stoplist=false
check_reverse_depends=false
which_reverse_depends=

R_exe="${HOME}/tmp/R/bin/R"
R_opts="--no-save --no-restore --slave"
cargs="--as-cran"

while test -n "${1}"; do
    case ${1} in
	-n)
	    update_check_dir=false ;;
	-f)
	    ignore_check_stoplist=true ;;
	-r)
	    export _R_CHECK_CRAN_INCOMING_=false
	    cargs=""
	    ;;
	-R=m*)
	    check_reverse_depends=true
	    which_reverse_depends="--most"
	    ;;
	-R)
	    check_reverse_depends=true ;;
	--exe)
	    R_exe="${2}"
	    shift ;;
	*)
	    echo "unknown option '${1}'"; exit 1 ;;
    esac
    shift
done

## rm -rf "${R_check_library}"
## mkdir -p "${R_check_library}"

if ${update_check_dir}; then
    rm -rf "${check_dir}"
    getIncoming 2>/dev/null
    mkdir -p "${R_check_library}"
fi

cd ${check_dir}
packages=`ls *.tar.gz 2>/dev/null`

if test -z "${packages}"; then
    echo "No packages to check"
    exit 0
fi

if ${check_reverse_depends}; then
    cat "${HOME}/lib/R/Scripts/rdepends.R" \
	| ${R_exe} ${R_opts} --args ${packages} ${which_reverse_depends}
fi
rdepends=`ls *.tar.gz 2>/dev/null`
## Compute setdiff(rdepends, packages) ...
rdepends=`echo "${rdepends}\n${packages}" | sort | uniq -u`

${ignore_check_stoplist} || . ${sh_scripts_dir}/check_R_stoplists.sh

## <FIXME>
## We should really use the stoplists to figure out the '--install=no'
## packages (and not try installing them ...).  On the other hand, we
## can ignore (most of) the '--install=fake' ones, as we can resolve
## dependencies against BioC and Omegahat, and hopefully will soon be
## able to handle most of the "takes too long" packages using package
## specific check options.
##
## Not quite perfect, though: but currently (2009-02-17) there seems to
## way pass a '--fake' via install.packages() to the INSTALL script.
## Otoh, there's really only three '--install=no' ones and finding the
## fake/no ones from the given .tar.gz file names in shell code really
## is a nuisance ...
## </FIXME>

(

## R-install
cat "${HOME}/lib/R/Scripts/install.R" \
    | R_LIBS="${R_check_library}" \
    ${R_exe} ${R_opts} --args ${packages} ${rdepends}
## No install timings for now.

## export LAM_MPI_SESSION_SUFFIX=incoming

export R_C_BOUNDS_CHECK=yes

## R-check
for pfile in ${packages}; do
    ## Get package specific check options.
    pname=`echo ${pfile} | sed 's/_.*//'`
    if ${ignore_check_stoplist}; then
	pargs="" ;
    else
	pargs=`get_check_args ${pname}`
    fi
    echo -n "${pname}: " >> time_c.out
    /usr/bin/time -o time_c.out -a \
	env LC_ALL=en_US.UTF-8 \
	_R_CHECK_WARN_BAD_USAGE_LINES_=TRUE \
	R_LIBS="${R_check_library}" \
	xvfb-run -a --server-args="-screen 0 1024x768x24" \
	${R_exe} CMD check ${cargs} --timings ${pargs} ${pfile}
    ## if test -n "${pargs}"; then
    ## 	echo "* using check arguments '${pargs}'" \
    ## 	    >> ${pname}.Rcheck/00check.log
    ## fi
done
## For reverse depends, never run CRAN incoming checks (hence set
## _R_CHECK_CRAN_INCOMING_ to FALSE and do not use '--as-cran'), and
## rename output check dirs for clarity.
for pfile in ${rdepends}; do
    ## Get package specific check options.
    pname=`echo ${pfile} | sed 's/_.*//'`
    if ${ignore_check_stoplist}; then
	pargs="" ;
    else
	pargs=`get_check_args ${pname}`
    fi
    echo -n "rdepends_${pname}: " >> time_c.out
    /usr/bin/time -o time_c.out -a \
	env LC_ALL=en_US.UTF-8 \
	_R_CHECK_WARN_BAD_USAGE_LINES_=TRUE \
	_R_CHECK_CRAN_INCOMING_=FALSE \
	R_LIBS="${R_check_library}" \
	xvfb-run -a --server-args="-screen 0 1024x768x24" \
	${R_exe} CMD check --timings ${pargs} ${pfile}
    ## if test -n "${pargs}"; then
    ## 	echo "* using check arguments '${pargs}'" \
    ## 	    >> ${pname}.Rcheck/00check.log
    ## fi
    mv ${pname}.Rcheck rdepends_${pname}.Rcheck
done

## lamwipe -sessionsuffix incoming

## Summarize.
echo "Package check summary depends:"
summarize_R_check_depends
echo
echo "Package check summary results:"
summarize_R_check_results
echo
echo "Package check timings:"
summarize_R_check_timings
## cat time_c.out | \
##     grep elapsed | sed 's/elapsed//' | \
##     awk ' { print $1, $4 } '

) 2>&1 | tee ~/tmp/CRAN_`date +%FT%T`.log
