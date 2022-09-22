options(available_packages_filters =
     c("R_version", "OS_type", "subarch", "CRAN", "duplicates"))
options(timeout = 600)

source('common.R')
stoplist <- c(stoplist, noinstall)
if(getRversion() < "3.6.0") stoplist <- c(stoplist, noinstall_pat)

Sys.setenv(DISPLAY = ':5',
           RMPI_TYPE = "OPENMPI",
           RMPI_INCLUDE = "/usr/include/openmpi-x86_64",
           RMPI_LIB_PATH = "/usr/lib64/openmpi/lib",
 	   R_MAX_NUM_DLLS = "150")

chooseBioCmirror(ind=1)
setRepositories(ind = c(1:4))
options(repos = c(getOption('repos'),
                  INLA = "https://inla.r-inla-download.org/R/stable/"))

opts <- list(Rserve = "--without-server",
	     BRugs = "--with-openbugs=/data/blackswan/ripley/extras")
#             udunits2 = "--with-udunits2-include=/usr/include/udunits2")
update.packages(ask=FALSE, configure.args = opts)
setRepositories(ind = 1)
new <- new.packages()
new <- new[! new %in% stoplist]
if(length(new)) {
    setRepositories(ind = c(1:4))
    install.packages(new, configure.args = opts)
}
