#! /home/Hornik/tmp/R/bin/Rscript --default-packages=NULL

## <FIXME>
## Once /usr/bin/Rscript is 3.7.0 or better: Change to
##   #! /usr/bin/Rscript
## and clean up.
## Note that on the incoming check systems we need /home/hornik:
## There is no simply way to get shebangs to do
##   #! $HOME/tmp/R/bin/Rscript --default-packages=NULL
## modulo moving the actual script to a .R script file, and using
##   #! /bin/sh
##   exec $HOME/tmp/R/bin/Rscript --default-packages=NULL file.R
## </FIXME>

## <FIXME>
## Ideally the default flavor could be set in one place.
flavor <- "gcc"
##   flavor <- "clang"
## </FIXME>

all <- FALSE
drop <- FALSE
more <- FALSE

worse <- FALSE
better <- FALSE

dir <- file.path(normalizePath("~"), "tmp", "CRAN")

args <- commandArgs(trailingOnly = TRUE)

if(any(ind <- args %in% c("-a", "--all"))) {
    all <- TRUE
    args <- args[!ind]
}
if(any(ind <- args %in% c("-d", "--drop"))) {
    drop <- TRUE
    args <- args[!ind]
}
if(any(ind <- args %in% c("-m", "--more"))) {
    more <- TRUE
    args <- args[!ind]
}
if(any(ind <- args %in% c("-w", "--worse"))) {
    worse <- TRUE
    args <- args[!ind]
}
if(any(ind <- args %in% c("-b", "--better"))) {
    better <- TRUE
    args <- args[!ind]
}
if(any(ind <- grepl("^-f.+", args))) {
    flavor <- substring(args[ind][1L], 3L, 3L)
    flavor <- c(g = "gcc", c = "clang")[flavor]
    if(is.na(flavor)) stop("Invalid flavor.")
    args <- args[!ind]
}
if(length(args)) {
    dir <- normalizePath(args[1L])
}

.canonicalize_outputs <- function(d) {
    ind <- d$Check == "whether package can be installed"
    if(any(ind)) {
        d$Output[ind] <-
            sub("\nSee[^\n]*for details[.]$", "",
                d$Output[ind])
    }
    d
}

clevels <- c("", "OK", "NOTE", "WARNING", "ERROR", "FAILURE")

old <-
    tools:::CRAN_check_details(sprintf("r-devel-linux-x86_64-debian-%s",
                                       flavor))

outdirs <- tools:::R_check_outdirs(dir, all = all, invert = TRUE)
logs <- file.path(outdirs, "00check.log")
logs <- logs[utils::file_test("-f", logs)]
new <- tools:::check_packages_in_dir_details(logs = logs,
                                             drop_ok = FALSE)

if(more) {
    new <- .canonicalize_outputs(new)
    old <- .canonicalize_outputs(old)
}

changes <- tools:::check_details_changes(new, old, more)

strip <- if(more) function(x) sub("\n.*", "", x) else identity

if(drop)
    changes <- changes[changes$Check != "installed package size", ]
if(worse)
    changes <- changes[ordered(strip(changes$Old), clevels) <
                       ordered(strip(changes$New), clevels), ]
if(better)
    changes <- changes[ordered(strip(changes$Old), clevels) >
                       ordered(strip(changes$New), clevels), ]

print(changes)
