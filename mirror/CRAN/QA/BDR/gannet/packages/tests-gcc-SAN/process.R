CRAN <- 'file:///data/gannet/ripley/R/packages/contrib'
av <- row.names(available.packages(contriburl = CRAN))
av <- setdiff(av, c('Rsomoclu', 'fastrtext'))
for(type in c("ASAN", "UBSAN")) {
    bpath <- paste0("/data/ftp/pub/bdr/memtests/gcc-", type)
    Packages <- list.dirs(bpath, FALSE, FALSE)
    Av <- Packages[Packages %in% av]
    unlink(file.path(bpath, Av), recursive = TRUE)
}

## --------- ASAN part

files <- Sys.glob("*.Rcheck/00check.log")
pat <- '(ASan internal:|^ *SUMMARY: AddressSanitizer:)'
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep(pat, l, value = TRUE, useBytes = TRUE)
    ll <- grep('SUMMARY: AddressSanitizer: (SEGV|bad-fre)', ll, value = TRUE, invert = TRUE)
    if(any(grepl("(tcltk_init|Rplot_Init|RinitJVM_jsw)", l, useBytes = TRUE))) next
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
##        if(ff %in% c("alphashape3d", "icosa", "qpcR", "rgl")) next
	f2 <- dirname(f)
        dir.create(file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff),
                             showWarnings = FALSE, recursive = TRUE)
        file.copy(f, file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff, "00check.log"),
                  overwrite=TRUE, copy.date = TRUE)
    }
}
cat("\n")


files <- Sys.glob("*.Rcheck/tests/*.Rout.fail")
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep(pat, l, value = TRUE, useBytes = TRUE)
    ll <- grep('SUMMARY: AddressSanitizer: (SEGV|bad-free)', ll, value = TRUE, invert = TRUE)
    if(any(grepl("(tcltk_init|Rplot_Init|RinitJVM_jsw)", l, useBytes = TRUE))) next
    if(length(ll)) {
	cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dir.create(d <- file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff, "tests"),
                             showWarnings = FALSE, recursive = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", f)
        file.copy(f,file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff, f2), overwrite=TRUE, copy.date = TRUE)
	Sys.setFileTime(d, file.info(dirname(f))$mtime)

    }
}
cat("\n")

files <- c(Sys.glob("*.Rcheck/*.[RSrs]nw.log"),
           Sys.glob("*.Rcheck/*.[RSrs]tex.log"))
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep(pat, l, value = TRUE, useBytes = TRUE)
    ll <- grep('SUMMARY: AddressSanitizer: (SEGV|bad-free)', ll, value = TRUE, invert = TRUE)
    if(any(grepl("(tcltk_init|Rplot_Init|RinitJVM_jsw)", l))) next
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dir.create(file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff),
                             showWarnings = FALSE, recursive = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", f)
        file.copy(f,file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff, f2), overwrite=TRUE, copy.date = TRUE)
    }
}
cat("\n")

files <- Sys.glob("*.Rcheck/00install.out")
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep('(ASan internal:|AddressSanitizer: odr-violation)', l, value = TRUE, useBytes = TRUE)
    if(any(grepl("(tcltk_init|Rplot_Init|RinitJVM_jsw|TkpOpenDisplay)",
                  l, useBytes = TRUE))) next
    ll2 <- grep(': undefined symbol:', l, value = TRUE, useBytes = TRUE)
    ll <- c(ll, ll2)
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dir.create(d <- file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff),
                   showWarnings = FALSE, recursive = TRUE)
        file.copy(f,file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff),
                  overwrite = TRUE, copy.date = TRUE)
        file.copy(sub("00install.out", "00check.log", f),
                  file.path("/data/ftp/pub/bdr/memtests/gcc-ASAN", ff),
			      overwrite = TRUE, copy.date = TRUE)
        Sys.setFileTime(d, file.info(dirname(f))$mtime)
    }
}
cat("\n")

for(d in list.dirs('/data/ftp/pub/bdr/memtests/gcc-ASAN', TRUE, FALSE)) {
    dpath <- paste0(basename(d), ".Rcheck")
    if(file.exists(dpath)) Sys.setFileTime(d, file.info(dpath)$mtime)
}

## --------- UBSAN part

pat <- '/R-devel/src'

files <- Sys.glob("*.Rcheck/*.Rout")

for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep('runtime error:', l, value = TRUE, useBytes = TRUE)
    ll <- grep('(Fortran runtime error|object in runtime error messages)', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep('tbb/parallel_reduce.h', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
#    ll <- grep('division by zero', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep(pat, ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    if(length(ll)) {
	cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dest <- file.path("/data/ftp/pub/bdr/memtests/gcc-UBSAN", ff)
        dir.create(dest, showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        file.copy(f, dest, overwrite = TRUE, copy.date = TRUE)
        Sys.setFileTime(file.path("/data/ftp/pub/bdr/memtests/gcc-UBSAN",
                                  basename(f)), file.info(f)$mtime)
    }
}
cat("\n")

files <- Sys.glob(c("*.Rcheck/tests/*.Rout", "*.Rcheck/tests/*.Rout.fail"))
for(f in files) {
    if(f == "robustbase.Rcheck/tests/tmcd.Rout") next
    l <- readLines(f, warn = FALSE)
    ll <- grep('runtime error:', l, value = TRUE, useBytes = TRUE)
    ll <- grep('tbb/parallel_reduce.h', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep(pat, ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    if(length(ll)) {
	cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dest <- file.path("/data/ftp/pub/bdr/memtests/gcc-UBSAN", ff)
        dir.create(d <- file.path(dest, "tests"),
                   showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", f)
        file.copy(f, file.path(dest, f2), overwrite = TRUE, copy.date = TRUE)
	Sys.setFileTime(d, file.info(dirname(f))$mtime)
    }
}
cat("\n")

files <- c(Sys.glob("*.Rcheck/*.[RSrs]nw.log"),
           Sys.glob("*.Rcheck/*.[RSrs]tex.log"),
           Sys.glob("*.Rcheck/build_vignettes.log"))
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep('runtime error:', l, value = TRUE, useBytes = TRUE)
    ll <- grep('tbb/parallel_reduce.h', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep(pat, ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dest <- file.path("/data/ftp/pub/bdr/memtests/gcc-UBSAN", ff)
        dir.create(dest, showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", f)
        file.copy(f, file.path(dest, f2), overwrite = TRUE, copy.date = TRUE)
    }
}
cat("\n")


for(d in list.dirs('/data/ftp/pub/bdr/memtests/gcc-UBSAN', TRUE, FALSE)) {
    dpath <- paste0(basename(d), ".Rcheck")
    if(file.exists(dpath)) Sys.setFileTime(d, file.info(dpath)$mtime)
}


