ref <- "../tests-devel"
this <- "MKL"
op <- file.path("/data/ftp/pub/bdr/Rblas", this)
source("../pkgdiff2.R")
report(op, c("datasailr", "spacetime"))
