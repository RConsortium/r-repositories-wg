SRC <- "~/R/R-devel"
setwd("~/R/svn/R-devel")
ff <- dir("tests", pattern="[.]Rout[.]save$",
          full.names = TRUE, recursive = TRUE)
ff2 <- sub("[.]save$", "", ff)
file.copy(file.path(SRC, ff2), ff, overwrite = TRUE)
for (pkg in c("grDevices", "grid", "parallel", "stats")) {
    ff <- dir(file.path("src", "library", pkg),
              pattern="[.]Rout[.]save$", full.names = TRUE, recursive = TRUE)
    ff2 <- sub("[.]save$", "", basename(ff))
    ff3 <- file.path(SRC, "tests", paste0(pkg, ".Rcheck"), "tests", ff2)
    file.copy(ff3, ff,  overwrite = TRUE)
}
