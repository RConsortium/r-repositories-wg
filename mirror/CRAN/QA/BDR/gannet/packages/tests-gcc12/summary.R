ref <- "../tests-devel"
this <- "gcc12"
op <- file.path("/data/ftp/pub/bdr", this)
source("../pkgdiff2.R")
report(op)
