## Argument handling.
args <- commandArgs(trailingOnly = TRUE)
args <- gsub("_.*", "", basename(args))

which <- c("Depends", "Imports", "LinkingTo")
if(any(ind <- args == "--most")) {
    which <- c(which, "Suggests")
    args <- args[!ind]
}

## Build a package db from the source packages in the working directory.

dir <- getwd()
tools::write_PACKAGES(dir)
curl <- sprintf("file://%s", dir)

options(available_packages_filters = NULL)

## For now, only consider reverse depends from CRAN.
repositories <- getOption("repos")
cran <- repositories[names(repositories) == "CRAN"]

available <- available.packages(contriburl = c(curl, contrib.url(cran)))

## Should also allow to include Suggests ...
rdepends <- tools::package_dependencies(args, available, which = which,
                                        reverse = TRUE)

rdepends <- intersect(unlist(rdepends), available[, "Package"])
rdepends <- setdiff(rdepends, args)

files <- sapply(sprintf("~/Data/CRAN/%s_*.tar.gz", rdepends), Sys.glob)

if(length(files)) {
    message("Copying reverse dependencies from CRAN ...")
    for(f in files) {
        message(sprintf("Copying %s ...", f), appendLF = FALSE)
        status <- if(file.copy(f, dir)) "ok" else "failed"
        message(status)
    }
}

tools::write_PACKAGES(dir)
