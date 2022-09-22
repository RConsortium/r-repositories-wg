options(available_packages_filters =
     c("R_version", "OS_type", "subarch", "CRAN", "duplicates"))

options(BioC_mirror = "https://bioconductor.org")
options(timeout = 300)

Sys.setenv(DISPLAY = ':5', NOAWT = "1", RMPI_TYPE = "OPENMPI",
          RGL_USE_NULL = "true")

opts <-
    list(ROracle = "--fake",
         git2r = " --configure-args='--without-libgit2'",
         RVowpalWabbit = "--configure-args='--with-boost=/opt/R/arm64'",
         rgdal = "--configure-args='--with-data-copy --with-proj-data=/opt/R/arm64/share/proj'",
         sf = "--configure-args='--with-data-copy --with-proj-data=/opt/R/arm64/share/proj'")

## things not to be updated
noupdate <- c('INLA')


