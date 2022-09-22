check_dir="${HOME}/tmp/R.check"
lock_file="${check_dir}/.lock"

if test -f ${lock_file}; then
  echo  "Old process still running ... aborting." | \
    env from=Kurt.Hornik@wu.ac.at replyto=Kurt.Hornik@wu.ac.at \
	REPLYTO=Kurt.Hornik@wu.ac.at \
    mail -s "cran_daily_check_results FAILURE" \
         -r Kurt.Hornik@wu.ac.at \
	 Kurt.Hornik@R-project.org
  exit 1
fi

## <FIXME>
## Adjust when 3.2.2 is released.
## Used for the manuals ... adjust as needed.
##   flavors="prerel patched release"
##   flavors="patched release"
flavors="patched"
## </FIXME>
## <NOTE>
## This needed 
##   flavors="patched"
## prior to the 3.0.2 release.
## </NOTE>

## <NOTE>
## Keeps this in sync with
##   lib/bash/check_R_cp_logs.sh
##   lib/R/Scripts/check.R
## as well as
##   CRAN-package-list
## (or create a common data base eventually ...)
## </NOTE>

## Rsync daily check results for the various "flavors" using KH's
## check-R/check-R-ng layout.

echo ${!} > ${lock_file}

## r-devel-linux-x86_64-debian-clang
sh ${HOME}/lib/bash/rsync_daily_check_flavor.sh \
  gimli.wu.ac.at::R.check/r-devel-clang/ \
  ${check_dir}/r-devel-linux-x86_64-debian-clang/

## r-devel-linux-x86_64-debian-gcc
sh ${HOME}/lib/bash/rsync_daily_check_flavor.sh \
  gimli2.wu.ac.at::R.check/r-devel-gcc/ \
  ${check_dir}/r-devel-linux-x86_64-debian-gcc/

## r-prerel-linux-x86_64
sh ${HOME}/lib/bash/rsync_daily_check_flavor.sh \
  gimli.wu.ac.at::R.check/r-patched-gcc/ \
  ${check_dir}/r-patched-linux-x86_64/

## r-release-linux-x86_64
sh ${HOME}/lib/bash/rsync_daily_check_flavor.sh \
  gimli.wu.ac.at::R.check/r-release-gcc/ \
  ${check_dir}/r-release-linux-x86_64/

## Hand-crafted procedures for getting the results for other layouts.

## r-devel-linux-x86_64-fedora-clang
mkdir -p "${check_dir}/r-devel-linux-x86_64-fedora-clang"
(cd "${check_dir}/r-devel-linux-x86_64-fedora-clang";
  rsync -q --times \
    --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
    r-proj@gannet.stats.ox.ac.uk::Rlogs/clang-times.tab .;
  rsync -q --times \
    --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
    r-proj@gannet.stats.ox.ac.uk::Rlogs/clang.tar.xz .;
  test clang.tar.xz -nt PKGS && \
    rm -rf PKGS && mkdir PKGS && cd PKGS && tar xf ../clang.tar.xz)

## r-devel-linux-x86_64-fedora-gcc
mkdir -p "${check_dir}/r-devel-linux-x86_64-fedora-gcc"
(cd "${check_dir}/r-devel-linux-x86_64-fedora-gcc";
  rsync -q --times \
    --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
    r-proj@gannet.stats.ox.ac.uk::Rlogs/gcc-times.tab .;
  rsync -q --times \
    --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
    r-proj@gannet.stats.ox.ac.uk::Rlogs/gcc.tar.xz .;
  test gcc.tar.xz -nt PKGS && \
    rm -rf PKGS && mkdir PKGS && cd PKGS && tar xf ../gcc.tar.xz)

## r-devel-windows-x86_64
mkdir -p "${check_dir}/r-devel-windows-x86_64/PKGS"
rsync --recursive --delete --times \
  129.217.206.10::CRAN-bin-windows-check/4.3/ \
  ${check_dir}/r-devel-windows-x86_64/PKGS

## ## r-devel-windows-x86_64-new-TK
## mkdir -p "${check_dir}/r-devel-windows-x86_64-new-TK/PKGS"
## rsync --recursive --delete --times \
##   /home/kalibera/winutf8/ucrt3/CRAN/checks/gcc10-UCRT/export/ \
##   ${check_dir}/r-devel-windows-x86_64-new-TK/PKGS

## r-release-windows-x86_64
mkdir -p "${check_dir}/r-release-windows-x86_64/PKGS"
rsync --recursive --delete --times \
  129.217.206.10::CRAN-bin-windows-check/4.2/ \
  ${check_dir}/r-release-windows-x86_64/PKGS

## r-release-macos-arm64
mkdir -p "${check_dir}/r-release-macos-arm64/PKGS"
## FIXME nz.build.rsync.urbanek.info
rsync --recursive --delete --times \
  --include="/*.Rcheck" \
  --include="/*.Rcheck/00[a-z]*" \
  --include="/*VERSION" \
  --include="/00_*" \
  --exclude="*" \
  cran@nz.build.rsync.urbanek.info:/data/results/big-sur-arm64/results/4.2/ \
  ${check_dir}/r-release-macos-arm64/PKGS/

## r-release-macos-x86_64
mkdir -p "${check_dir}/r-release-macos-x86_64/PKGS"
## FIXME nz.build.rsync.urbanek.info
rsync --recursive --delete --times \
  --include="/*.Rcheck" \
  --include="/*.Rcheck/00[a-z]*" \
  --include="/*VERSION" \
  --include="/00_*" \
  --exclude="*" \
  cran@nz.build.rsync.urbanek.info:/data/results/high-sierra/4.2/ \
  ${check_dir}/r-release-macos-x86_64/PKGS/

## Discontinued as of 2021-12.
## ## r-patched-solaris-x86
## mkdir -p "${check_dir}/r-patched-solaris-x86/PKGS"
## (cd "${check_dir}/r-patched-solaris-x86";
##   rsync -q --times \
##     --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
##     r-proj@gannet.stats.ox.ac.uk::Rlogs/Solx86-times.tab .;
##   rsync -q --times \
##     --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
##     r-proj@gannet.stats.ox.ac.uk::Rlogs/Solx86.tar.xz .;
##   test Solx86.tar.xz -nt PKGS && \
##     rm -rf PKGS && mkdir PKGS && cd PKGS && tar xf ../Solx86.tar.xz)

## r-oldrel-windows-ix86+x86_64
mkdir -p "${check_dir}/r-oldrel-windows-ix86+x86_64/PKGS"
rsync --recursive --delete --times \
  129.217.206.10::CRAN-bin-windows-check/4.1/ \
  ${check_dir}/r-oldrel-windows-ix86+x86_64/PKGS

## r-oldrel-macos-arm64
mkdir -p "${check_dir}/r-oldrel-macos-arm64/PKGS"
## FIXME nz.build.rsync.urbanek.info
rsync --recursive --delete --times \
  --include="/*.Rcheck" \
  --include="/*.Rcheck/00[a-z]*" \
  --include="/*VERSION" \
  --include="/00_*" \
  --exclude="*" \
  cran@nz.build.rsync.urbanek.info:/data/results/big-sur-arm64/results/4.1/ \
  ${check_dir}/r-oldrel-macos-arm64/PKGS/

## r-oldrel-macos-x86_64
mkdir -p "${check_dir}/r-oldrel-macos-x86_64/PKGS"
## FIXME nz.build.rsync.urbanek.info
rsync --recursive --delete --times \
  --include="/*.Rcheck" \
  --include="/*.Rcheck/00[a-z]*" \
  --include="/*VERSION" \
  --include="/00_*" \
  --exclude="*" \
  cran@nz.build.rsync.urbanek.info:/data/results/high-sierra/4.1/ \
  ${check_dir}/r-oldrel-macos-x86_64/PKGS/

## BDR memtests
## mkdir -p "${check_dir}/bdr-memtests"
## rsync -q --recursive --delete --times \
##   --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
##   r-proj@gannet.stats.ox.ac.uk::Rlogs/memtests/ \
##   ${check_dir}/bdr-memtests

## Issues
mkdir -p "${check_dir}/issues/"
rsync -q --recursive --delete --times \
  --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
  r-proj@gannet.stats.ox.ac.uk::Rlogs/memtests/*.csv \
  ${check_dir}/issues
## rsync -q --recursive --delete --times \
##   --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
##   r-proj@gannet.stats.ox.ac.uk::Rlogs/noLD/*.csv \
##   ${check_dir}/issues
## rsync -q --recursive --delete --times \
##   --password-file="${HOME}/lib/bash/rsync_password_file_gannet.txt" \
##   r-proj@gannet.stats.ox.ac.uk::Rlogs/LTO.csv \
##   ${check_dir}/issues

wget -q \
  https://raw.githubusercontent.com/kalibera/cran-checks/master/rchk/rchk.csv \
  -O ${check_dir}/issues/rchk.csv
wget -q \
  https://raw.githubusercontent.com/kalibera/cran-checks/master/rcnst/rcnst.csv \
  -O ${check_dir}/issues/rcnst.csv
wget -q \
  https://raw.githubusercontent.com/kalibera/cran-checks/master/rlibro/rlibro.csv \
  -O ${check_dir}/issues/rlibro.csv

## Dbs.

mkdir -p "${check_dir}/dbs"
rsync -q --recursive --times \
  gimli.wu.ac.at::R.check/*.rds \
  ${check_dir}/dbs  
rsync -q --recursive --times \
  gimli2.wu.ac.at::R.check/*.rds \
  ${check_dir}/dbs
R --slave --no-save <<EOF
  files <- Sys.glob("/srv/www/cran-archive/web/checks/*/*.rds")
  infos <- lapply(files, readRDS)
  names(infos) <- files
  saveRDS(infos, "${check_dir}/dbs/archive.rds")
EOF

## Summaries and logs.

LANG=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
  sh ${HOME}/lib/bash/check_R_summary.sh

LANG=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
  sh ${HOME}/lib/bash/check_R_cp_logs.sh

## Manuals.
manuals_dir=/srv/ftp/pub/R/doc/manuals
for flavor in devel ${flavors} ; do
    rm -rf ${manuals_dir}/r-${flavor}
done    
cp -pr ${check_dir}/r-devel-linux-x86_64-debian-gcc/Manuals \
    ${manuals_dir}/r-devel
for flavor in ${flavors} ; do
  cp -pr ${check_dir}/r-${flavor}-linux-x86_64/Manuals \
    ${manuals_dir}/r-${flavor}
done  

rm -f ${lock_file}

### Local Variables: ***
### mode: sh ***
### sh-basic-offset: 2 ***
### End: ***
