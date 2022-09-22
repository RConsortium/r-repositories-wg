## Argument handling.
args <- commandArgs(trailingOnly = TRUE)
args <- gsub("_.*", "", basename(args))

dir <- getwd()
## Build a package db from the source packages in the working directory
## (but only if there is none already).
if(!file.exists("PACKAGES"))
    tools::write_PACKAGES(dir)

curls <- c(sprintf("file://%s", dir), contrib.url(getOption("repos")))
options(available_packages_filters = NULL)
available <- available.packages(contriburl = curls)
## Note that calling available.packages() with filters = NULL uses the
## value of the available_packages_filters option.

depends <- tools::package_dependencies(args, available, which = "most")
depends <- setdiff(unique(unlist(depends)),
                   unlist(tools:::.get_standard_package_names()))

## Need to install depends which are not installed or installed but old.
installed <- installed.packages()[, "Package"]
depends <- c(setdiff(depends, installed),
             intersect(intersect(depends, installed),
                       old.packages(contriburl = curls)[, "Package"]))

if(length(depends))
    install.packages(depends, lib = .libPaths()[1L],
                     contriburl = curls, available = available,
                     dependencies = TRUE)
