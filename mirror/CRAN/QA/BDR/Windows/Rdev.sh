pushd /R/W32/R-devel/src/gnuwin32
. gcc.sh
make rsync-recommended
svn up ../..
make 32-bit vignettes
cd /R/W64/R-devel/src/gnuwin32
. gcc.sh
make rsync-recommended
svn up ../..
make distribution
popd



