#!/bin/sh

# depends: common runX11 fixtar dtree

: ${BASE=/Builds/packages}

RBUILDS=$BASE
# SKIPCHKD=1 : skip if pkg was already checked
# ERRONLY=1  : skip pkg that were checked successfully (looks for *.Rcheck/00install.out)

# don't check Suggests: dependencies to avoid cross-repos problems
export _R_CHECK_FORCE_SUGGESTS_=false

: ${CRANBASE=$RBUILDS/CRAN}
if [ "${CRANBASE}" = "${RBUILDS}/CRAN" ]; then
    plain_cran=yes
fi
: ${METABASE=$CRANBASE/meta}
PKGSRCDIR=$CRANBASE/src/contrib
METASRCDIR=`echo $PKGSRCDIR|sed -e "s|$CRANBASE|$METABASE|"`
PKGDEP=$CRANBASE/dep.list

if [ -n "$CUSTOM" ]; then
    RBUILDS=`pwd`
    CRANBASE=$RBUILDS
    PKGSRCDIR=$RBUILDS/$CUSTOM
    PKGDEP=$CRANBASE/dep.list
fi

OWD=`pwd`

. $RBUILDS/common

# TeX architecture (always native)
tarch=$arch
if [ arch == ppc ]; then tarch=powerpc; fi

# /sw/bin for makeinfo, teTeX for latex
PATH=/usr/local/bin:/usr/local/teTeX/bin/${tarch}-apple-darwin-current:$PATH
export PATH

: ${RBIN=R}

if [ -z "$RBIN" ]; then
    echo "RBIN must be either unset or non-empty"
    exit 1
fi

echo "RBUILDS: $RBUILDS"
echo "base: $CRANBASE"
echo "sources: $PKGSRCDIR"
echo "meta: $METASRCDIR"
echo "RBIN: $RBIN"

X11OK=no
if ps ax|grep 'X[v]fb :4' > /dev/null; then X11OK=yes; fi
if [ $X11OK = no -a -z "$FORCE" ]; then
    echo "*** Xvfb :4 is not running. Please use FORCE=1 if you want to continue anyway ***" >&2
    echo "FAILED: X11 is not running" > $BASE/FAILED-X11
#    echo " - starting virtual X11"
#    nohup $RBUILDS/runX11 &
    exit 5
fi

DISPLAY=:4
export DISPLAY

: ${sanity=yes}

# now we get it from common
RVER=$rver
RSVER=`echo $RVER|sed 's/\([0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/'`

echo "R version $RVER"
if [ -z "$RVER" ]; then
    echo "Cannot find usable R."
    exit 1;
fi

if [ -z "$SKIP_CHK" ]; then
    SKIP_CHK=no
fi
if [ $SKIP_CHK != no ]; then
    SKIP_CHK=yes
fi
if [ -z "$UPDATE" ]; then
    UPDATE=no
fi
if [ $UPDATE != no ]; then
    UPDATE=yes
fi

if [ -z "$CHK_ONLY" ]; then
    CHK_ONLY=no
fi
if [ $CHK_ONLY != no ]; then
    CHK_ONLY=yes
    if [ $SKIP_CHK == yes ]; then
	echo "Conflicting flags, CHK_ONLY and SKIP_CHK cannot be both 'yes'." >&2
	exit 1
    fi
fi

echo " SKIP_CHK: $SKIP_CHK"
echo " CHK_ONLY: $CHK_ONLY"
echo " UPDATE  : $UPDATE"

: ${OUTBASE=$RBUILDS}
BINOSX=$OUTBASE/$biname/bin/$RSVER
: ${RLIB=$RBUILDS/$biname/Rlib/$RSVER}
if [ "${plain_cran}" = yes -a -z "${NOBIOC}" ]; then
    biocsd=`head -n 1 ${RBUILDS}/bioc.repos`
    : ${RLIBS=$RLIB:${RBUILDS}/BIOC.new/bin/${biocsd}/${biname}/Rlib/${RSVER}}
else
    : ${RLIBS=$RLIB}
fi
CHKRES=$OUTBASE/$biname/results/$RSVER
STOPFILE=$RBUILDS/stop.$RSVER

echo "OUTPUT:"
echo "  Rlib: $RLIB"
echo "  bin : $BINOSX"
echo "  res : $CHKRES"
echo "RLIBS=$RLIBS"

rm -f $STOPFILE
RNAME=`openssl rand -base64 6|sed 'y|/|-|'`
#rm -rf /tmp/R* 2> /dev/null
BLDIR=/tmp/CRAN.bld.$biname.$RNAME
rm -rf $BLDIR 2> /dev/null
mkdir -p $BLDIR 2> /dev/null
#rm -rf $CHKRES 2> /dev/null
mkdir -p $CHKRES 2> /dev/null
mkdir -p $BINOSX 2> /dev/null
mkdir -p $RLIB 2> /dev/null

echo "Building package dependency tree.."
echo "(from $PKGSRCDIR)"
if [ -e "$PKGSRCDIR/Descriptions" ]; then
    ./dtreem --desc $PKGSRCDIR/Descriptions $PKGSRCDIR $EXTRAREPOS > $PKGDEP
else
    if [ -e "$METASRCDIR" ]; then
	./dtreem --desc $METASRCDIR $PKGSRCDIR $EXTRAREPOS > $PKGDEP
    else
	./dtreem $PKGSRCDIR $EXTRAREPOS > $PKGDEP
    fi
fi

echo "Checking all packages.."
PKGLIST=`cat $PKGDEP`
if [ -n "$FAKE" ]; then
    echo " fake run requested, terminating."
    rm -rf $BLDIR 2> /dev/null
    exit 0
fi



cd "${OWD}"
rm -rf $BLDIR 2> /dev/null
