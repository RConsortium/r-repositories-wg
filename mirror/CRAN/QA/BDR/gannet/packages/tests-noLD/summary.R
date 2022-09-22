ref <- "../tests-devel"
this <- "noLD"
op <- file.path("/data/ftp/pub/bdr", this)
source("../pkgdiff2.R")
report(op)
