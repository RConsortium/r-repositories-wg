pushd /R/W32/R-3-2-branch/src/gnuwin32
. gcc.sh
make rsync-recommended
svn up ../..
make 32-bit vignettes
cd /R/W64/R-3-2-branch/src/gnuwin32
. gcc.sh
make rsync-recommended
svn up ../..
make distribution
popd



