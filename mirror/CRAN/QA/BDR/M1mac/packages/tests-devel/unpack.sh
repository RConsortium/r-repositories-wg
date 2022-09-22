for p in ../contrib/*.tar.gz; do
  pkgname=`basename $p | sed  -e 's/_.*//'`
if test $pkgname != TCC -a $p -nt $pkgname.in; then
  echo $pkgname
  rm -rf $pkgname
  tar zxf $p
  touch -r $p $pkgname.in
fi
done
for p in ../3.1.0/Other/*.tar.gz; do
  pkgname=`basename $p | sed  -e 's/_.*//'`
if test $p -nt $pkgname.in; then
  echo $pkgname
  rm -rf $pkgname
  tar zxf $p
  touch -r $p $pkgname.in
fi
done
