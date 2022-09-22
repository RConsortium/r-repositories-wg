#! /usr/local/bin/Rscript
check_results_diff_db <- function(base)
{
    ## Assume that we know that both check.csv.prev and check.csv exist
    ## in dir.
    x <- read.csv(paste(base, '.prev', sep=''), colClasses = "character")
    x <- x[names(x) != "Maintainer"]
    y <- read.csv(base, colClasses = "character")
    y <- y[names(y) != "Maintainer"]
    z <- merge(x, y, by = 1, all = TRUE)
    row.names(z) <- z$Package
    z
}

check_results_diffs <- function(base)
{
    db <- check_results_diff_db(base)
    db <- db[, c("Version.x", "Status.x", "Version.y", "Status.y")]
    ## Show packages with one status missing (removed or added) as
    ## status change only.
    is_na_x <- is.na(db$Status.x)
    is_na_y <- is.na(db$Status.y)
    isc <- (is_na_x | is_na_y | (db$Status.x != db$Status.y))
                                        # Status change.
    ivc <- (!is_na_x & !is_na_y & (db$Version.x != db$Version.y))
                                        # Version change.
    names(db) <- c("V_Old", "S_Old", "V_New", "S_New")
    db <- cbind("S" = ifelse(isc, "*", ""),
                "V" = ifelse(ivc, "*", ""),
                db)
    db[c(which(isc & !ivc), which(isc & ivc), which(!isc & ivc)),
       c("S", "V", "S_Old", "S_New", "V_Old", "V_New")]
}

do_one <- function(base = "check.csv")
{
    db <- check_results_diffs(base)
    if(nrow(db)) print(db) else writeLines(' no change')
}

writeLines(c("",
             "Changes in check status (S) and/or version (V) for R-devel gcc-Fedora"))
do_one('/data/gannet/Rlogs/gcc-check.csv')

writeLines(c("",
             "Changes in check status (S) and/or version (V) for R-devel clang-Fedora"))
do_one('/data/gannet/Rlogs/clang-check.csv')

for (d in c("tests", "tests-devel", "tests-clang"))
{
    p <- file.path("/data/gannet/ripley/R/packages/keep", d, Sys.Date())
    dir.create(p)
    setwd(file.path("/data/gannet/ripley/R/packages", d))
    ff <- system("egrep 'Status.*(ERROR|WARN)' *.out", intern = TRUE)
    ff <- sub(":.*$", "", ff)
    fi <- file.mtime(ff)
    ff <- ff[as.Date(fi) > Sys.Date() - 2]
    if(length(ff)) {
        file.copy(ff, p, copy.date = TRUE)
        ff <- sub("out$", "log", ff)
	ff <- ff[file.exists(ff)]
        file.copy(ff, p, copy.date = TRUE)
    }
NULL
}

for (d in c("LTO", "ATLAS", "MKL", "OpenBLAS", "clang11", "gcc11", "noLD", "noOMP"))
{
    p <- file.path("/data/gannet/ripley/R/packages/keep", d, Sys.Date())
    f <- dir(file.path("/data/ftp/pub/bdr", d), full.names = TRUE)
    fi <- file.mtime(f)
    f <- f[as.Date(fi) > Sys.Date() - 2]
    if(length(f)) {
       dir.create(p)
       file.copy(f, p, recursive = TRUE, copy.date = TRUE)
    }
    NULL
}

p <- file.path("/data/gannet/ripley/R/packages/keep/memtests", Sys.Date())
dir.create(p)
for (d in c("clang-ASAN", "clang-UBSAN", "gcc-ASAN", "gcc-UBSAN", "valgrind"))
{
    q <- file.path(p, d)
    f <- dir(file.path("/data/ftp/pub/bdr/memtests", d), full.names = TRUE)
    fi <- file.mtime(f)
    f <- f[as.Date(fi) > Sys.Date() - 2]
    if(length(f)) {
       dir.create(q)
       file.copy(f, q, recursive = TRUE, copy.date = TRUE)
    }
    NULL
}
