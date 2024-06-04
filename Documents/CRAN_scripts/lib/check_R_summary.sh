#! /bin/sh

check_dir="${HOME}/tmp/R.check"
write_dir="${check_dir}/web"
target_dir="/srv/ftp/pub/R/web/checks"
R_scripts_dir="${HOME}/lib/R/Scripts"

rm -rf "${write_dir}" && mkdir "${write_dir}"

R --slave --no-save <<EOF
  source("${R_scripts_dir}/check.R")
  .check_R_summary("${check_dir}", "${write_dir}", "${target_dir}")
EOF

if test -d "${write_dir}"; then
  rm -rf "${target_dir}" && mv "${write_dir}" "${target_dir}"
fi    

### Local Variables: ***
### mode: sh ***
### sh-basic-offset: 2 ***
### End: ***
