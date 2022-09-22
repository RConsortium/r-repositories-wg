source("common.R")
stoplist <- c(stoplist, noinstall)


Sys.setenv(DISPLAY = ':5',
           RMPI_TYPE = "OPENMPI",
           RMPI_INCLUDE = "/usr/include/openmpi-x86_64",
           RMPI_LIB_PATH = "/usr/lib64/openmpi/lib")

options(available_packages_filters =
     c("R_version", "OS_type", "subarch", "CRAN", "duplicates"))

#chooseBioCmirror(ind=6)
chooseBioCmirror(ind = 1)
setRepositories(ind=c(1:4))

opts <- list(Rserve = "--without-server",
             udunits2 = "--with-udunits2-include=/usr/include/udunits2")

update.packages(ask=FALSE, configure.args = opts, Ncpus = 4)
setRepositories(ind=1)
new <- new.packages()
new <- new[! new %in% stoplist]
setRepositories(ind=c(1:4))
if(length(new)) install.packages(new, configure.args = opts, Ncpus = 4)
