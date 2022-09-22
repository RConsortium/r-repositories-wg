options(available_packages_filters =
     c("R_version", "OS_type", "subarch", "CRAN", "duplicates"))

args <- commandArgs()[-(1:3)]
foo <- if(la <- length(args)) {
    if(la == 1L) {
        if(file.exists(args)) readLines(args) else args
    } else args
} else row.names(installed.packages(.libPaths()[1L]))

#foo <- setdiff(foo, c('proj4'))

options(BioC_mirror = "https://bioconductor.org")
options(timeout = 300)

setRepositories(ind = 1:4)
options(repos = c(getOption('repos'),
		  Omegahat = "http://www.omegahat.net/R"))

Sys.setenv(DISPLAY = ':5', NOAWT = "1", RMPI_TYPE = "OPENMPI",
          RGL_USE_NULL = "true", PG_INCDIR = "libpq",
	  ODBC_INCLUDE = "/Users/ripley/Sources/iodbc/include")

tmp <- "PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/Library/Frameworks/GTK+.framework/Resources/lib/pkgconfig"
tmp2 <- "PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"
opts <- list(RGtk2 = tmp, cairoDevice = tmp)
opts2 <- list(ROracle = "--fake",
              rgdal = "--configure-args='--with-data-copy --with-proj-data=/usr/local/share/proj'",
              sf = "--configure-args='--with-data-copy --with-proj-data=/usr/local/share/proj'")

install.packages(foo, Ncpus = 10, configure.vars = opts, type="source", INSTALL_opts = opts2)
