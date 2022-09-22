## keep results for any packages which have been archived
CRAN <- 'file:///data/gannet/ripley/R/packages/contrib'
av <- row.names(available.packages(contriburl = CRAN))
av <- setdiff(av, "rcss")
for(type in c("ASAN", "UBSAN")) {
    bpath <- paste0("/data/ftp/pub/bdr/memtests/clang-", type)
    Packages <- list.dirs(bpath, FALSE, FALSE)
    Av <- Packages[Packages %in% av]
    unlink(file.path(bpath, Av), recursive = TRUE)
}

## --------- ASAN part

files <- Sys.glob("*.Rcheck/00check.log")
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep('(ASan internal:|AddressSanitizer: negative-size-param|SUMMARY: AddressSanitizer: alloc-dealloc-mismatch|SUMMARY: AddressSanitizer: memcpy-param-overlap)', l, value = TRUE, useBytes = TRUE)
    if(any(grepl("(tcltk_init|Rplot_Init|__kmp_)", l, useBytes = TRUE))) next
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
	## if(ff %in% c("alphashape3d", "icosa", "qpcR", "rgl")) next
	f2 <- dirname(f)
        dir.create(file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff),
                             showWarnings = FALSE, recursive = TRUE)
        file.copy(f, file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff, "00check.log"),
                  overwrite=TRUE, copy.date = TRUE)
    }
}
cat("\n")


files <- Sys.glob("*.Rcheck/tests/*.Rout.fail")
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep('ASan internal:', l, value = TRUE, useBytes = TRUE)
    if(any(grepl("(tcltk_init|Rplot_Init|__kmp_)", l, useBytes = TRUE))) next
    if(length(ll)) {
	cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dir.create(d <- file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff, "tests"),
                             showWarnings = FALSE, recursive = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", f)
        file.copy(f,file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff, f2), overwrite=TRUE, copy.date = TRUE)
	Sys.setFileTime(d, file.info(dirname(f))$mtime)
    }
}
cat("\n")

files <- c(Sys.glob("*.Rcheck/*.[RSrs]nw.log"),
           Sys.glob("*.Rcheck/*.[RSrs]tex.log"))
for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep('ASan internal:', l, value = TRUE, useBytes = TRUE)
    ## __kmp_invoke no longer needed (clang 6.0.0)
    if(any(grepl("(tcltk_init|Rplot_Init|__kmp_)", l, useBytes = TRUE))) next
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dir.create(file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff),
                             showWarnings = FALSE, recursive = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", f)
        file.copy(f,file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff, f2),
                  overwrite = TRUE, copy.date = TRUE)
    }
}
cat("\n")

files <- Sys.glob("*.Rcheck/00install.out")
for(f in files) {
    l <- readLines(f, warn = FALSE)
    if(any(grepl("(tcltk_init|Rplot_Init|TkpOpenDisplay|__kmp_)",
                 l, useBytes = TRUE))) next
    ll <- grep('(ASan internal:|AddressSanitizer: odr-violation)', l, value = TRUE, useBytes = TRUE)
    ll2 <- grep(': undefined symbol:', l, value = TRUE, useBytes = TRUE)
## seems to be missing -fopemp in link
##    ll2 <- ll2[!all(grepl("omp_in_parallel", ll2, useBytes = TRUE))]
    ll <- c(ll, ll2)
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dir.create(d <- file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff),
                                  showWarnings = FALSE, recursive = TRUE)
        file.copy(f, file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff),
			      overwrite = TRUE, copy.date = TRUE)
        file.copy(sub("00install.out", "00check.log", f),
                  file.path("/data/ftp/pub/bdr/memtests/clang-ASAN", ff),
			      overwrite = TRUE, copy.date = TRUE)
        Sys.setFileTime(d, file.info(dirname(f))$mtime)
    }
}
cat("\n")


for(d in list.dirs('/data/ftp/pub/bdr/memtests/clang-ASAN', TRUE, FALSE)) {
    dpath <- paste0(basename(d), ".Rcheck")
    if(file.exists(dpath))
         Sys.setFileTime(d, file.info(dpath)$mtime)
}

## --------- UBSAN part

## do not seem to get up/downcast any more
#pat <- '(/R-devel/src|c[+][+]/v1.*downcast of address|c[+][+]/v1.*upcast of address)'
#pat <- 'MatrixOps/t_cholmod_sdmult.c'
pat <- '(MatrixOps/t_cholmod_sdmult.c|applying zero offset to null pointer)'
pat2 <- 'nlmefit.c.*runtime error: applying zero offset to null pointer'
pat3 <- 'gini.c.*runtime error: applying zero offset to null pointer'

files <- Sys.glob("*.Rcheck/*.Rout")

for(f in files) {
    l <- readLines(f, warn = FALSE)
    ll <- grep('runtime error:', l, value = TRUE, useBytes = TRUE)
    ll <- grep('runtime error.*tbb', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep('(Fortran runtime error|object in runtime error messages)', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep(pat, ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    if(length(ll)) {
	cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dest <- file.path("/data/ftp/pub/bdr/memtests/clang-UBSAN", ff)
        dir.create(dest, showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        file.copy(f, dest, overwrite = TRUE, copy.date = TRUE)
    }
}
cat("\n")

files <- Sys.glob(c("*.Rcheck/tests/*.Rout", "*.Rcheck/tests/*.Rout.fail"))
for(f in files) {
    if(f == "robustbase.Rcheck/tests/tmcd.Rout") next
    l <- readLines(f, warn = FALSE)
    ll <- grep('runtime error:', l, value = TRUE, useBytes = TRUE)
    ll <- grep('runtime error.*tbb', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep(pat, ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    if(length(ll)) {
	cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dest <- file.path("/data/ftp/pub/bdr/memtests/clang-UBSAN", ff)
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
    ll <- grep('runtime error.*tbb', ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    ll <- grep(pat, ll, invert = TRUE, value = TRUE, useBytes = TRUE)
    if(length(ll)) {
        cat(".")
        ff <- sub("[.]Rcheck/.*", "", f)
        dest <- file.path("/data/ftp/pub/bdr/memtests/clang-UBSAN", ff)
        dir.create(dest, showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", f)
        file.copy(f, file.path(dest, f2), overwrite = TRUE, copy.date = TRUE)
    }
}
cat("\n")

for(d in list.dirs('/data/ftp/pub/bdr/memtests/clang-UBSAN', TRUE, FALSE)) {
        dpath <- paste0(basename(d), ".Rcheck")
	if(file.exists(dpath))
	     Sys.setFileTime(d, file.info(dpath)$mtime)
}

