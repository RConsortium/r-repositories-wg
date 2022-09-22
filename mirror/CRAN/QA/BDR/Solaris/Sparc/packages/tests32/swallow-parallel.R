source("common.R")

options(warn = 1)

rlib <- "/home/ripley/R/Lib32"
Rver <- "R"
Rgcc <- "Rgcc"

list_tars <- function(dir='.')
{
    files <- list.files(dir, pattern="\\.tar\\.gz", full.names=TRUE)
    nm <- sub("_.*", "", basename(files))
    data.frame(name = nm, path=files, mtime = file.info(files)$mtime,
               row.names = nm, stringsAsFactors = FALSE)
}

tars <- foo1 <- list_tars('../contrib')
foo <- list_tars('../contrib/3.4.0/Recommended')
foo0 <- list_tars('../contrib/3.4.0/Other')
foo <- rbind(foo, foo0, foo1)
tars <- foo[!duplicated(foo$name), ]


logs <- list.files('.', pattern = "\\.log$")
logs <- logs[logs != "script.log"]
fi <- file.info(logs)
nm <- sub("\\.log$", "", logs)
logs <- data.frame(name = nm, mtime = fi$mtime, stringsAsFactors = FALSE)
old <- nm[! nm %in% tars$name]
for(f in old) {
    cat('removing ', f, '\n', sep='')
    unlink(c(f, Sys.glob(paste(f, ".*", sep=""))), recursive = TRUE)
    unlink(file.path(rlib, f),  recursive = TRUE)
}

inst <- basename(dirname(Sys.glob(file.path(rlib, "*", "DESCRIPTION"))))

foo <- merge(logs, tars, by='name', all.y = TRUE)
row.names(foo) <- foo$name
keep <- with(foo, mtime.x < mtime.y)
old <- foo[keep %in% TRUE, ]

new <- foo[is.na(foo$mtime.x), ]
nm <- c(row.names(old), row.names(new))
nm <- nm[! nm %in% stoplist]
available <-
    available.packages(contriburl="file:///home/ripley/R/packages/contrib",
                       filters = list())
nm <- nm[nm %in% rownames(available)]
nmr <- nm[nm %in% recommended]
nm <- nm[!nm %in% recommended]
nm <- setdiff(nm, "rgl")

Sys.setenv(R_LIBS = rlib,
           DISPLAY=':5',
           CPPFLAGS='-I/usr/local/include',
           "_R_CHECK_INSTALL_DEPENDS_" = "TRUE",
           "_R_CHECK_NO_RECOMMENDED_" = "TRUE",
           "_R_SHLIB_BUILD_OBJECTS_SYMBOL_TABLES_" = "TRUE",
           RMPI_TYPE="OPENMPI",
           RMPI_INCLUDE="/opt/SUNWhpc/HPC8.2.1c/sun/include",
           RMPI_LIB_PATH="/opt/SUNWhpc/HPC8.2.1c/sun/lib")
Sys.setenv(LC_CTYPE="en_GB.UTF-8")

do_one <- function(f)
{
    unlink(f, recursive = TRUE)
    unlink(file.path("~/R/Lib32", f), recursive = TRUE)
    unlink(file.path("~/R/Lib32", paste0("00LOCK-", f)), recursive = TRUE)
    try(system2("gtar", c("xf", tars[f, "path"]))) # in case it changes in //
    cat(sprintf('installing %s\n', f))
    opt <- ""; env <- ""
    if(f == "Rserve") opt <- '--configure-args=--without-server'
    if(f == "pcaL1") opt <- '--configure-args=--enable-lapack=no'
    if(f == "stringi") opt <- '--configure-args=--disable-cxx11'
    desc <- read.dcf(file.path(f, "DESCRIPTION"), "SystemRequirements")[1L, ]
    if(grepl("GNU make", desc, ignore.case = TRUE)) env <- "MAKE=gmake"
    if(f %in% fakes) opt <- "--fake"
    opt <- c("--pkglock", opt)
    desc <- read.dcf(file.path(f, "DESCRIPTION"), "LinkingTo")[1L, ]
    cmd <- ifelse(grepl("Rcpp", desc) || f %in% gcc, Rgcc, Rver)
    args <- c(cmd, "CMD", "INSTALL", opt, tars[f, "path"])
    logfile <- paste(f, ".log", sep = "")
    Sys.unsetenv("R_HOME")
    res <- system2("time", args, logfile, logfile, env = env)
    if(res) cat(sprintf('  %s failed\n', f))
    else    cat(sprintf('  %s done\n', f))
}

M <- min(length(nm), 10)
library(parallel)
unlink("install_log")
cl <- makeCluster(M, outfile = "install_log")
clusterExport(cl, c("tars", "fakes", "gcc", "Rver", "Rgcc"))

if(length(nm)) {
    available2 <-
        available.packages(c("file:///home/ripley/R/packages/contrib",
"http://bioconductor.statistik.tu-dortmund.de/packages/3.3/bioc/src/contrib"),
                           filters=list())
    DL <- utils:::.make_dependency_list(nm, available2, recursive = TRUE)
    DL <- lapply(DL, function(x) x[x %in% nm])
    lens <- sapply(DL, length)
    if (all(lens > 0L)) stop("every package depends on at least one other")
    ready <- names(DL[lens == 0L])
    done <- character()
    n <- length(ready)
    submit <- function(node, pkg)
        parallel:::sendCall(cl[[node]], do_one, list(pkg), tag = pkg)
    for (i in 1:min(n, M)) submit(i, ready[i])
    DL <- DL[!names(DL) %in% ready[1:min(n, M)]]
    av <- if(n < M) (n+1L):M else integer()
    while(length(done) < length(nm)) {
        d <- parallel:::recvOneResult(cl)
        av <- c(av, d$node)
        done <- c(done, d$tag)
        OK <- unlist(lapply(DL, function(x) all(x %in% done) ))
        if (!any(OK)) next
        pkgs <- names(DL)[OK]
        m <- min(length(pkgs), length(av))
        for (i in 1:m) submit(av[i], pkgs[i])
        av <- av[-(1:m)]
        DL <- DL[!names(DL) %in% pkgs[1:m]]
    }
}

## used for recommended packages
do_one_r <- function(f, tars)
{
    unlink(f, recursive = TRUE)
    logfile <- paste(f, ".log", sep = "")
    system2("touch", logfile)
    system2("gtar", c("xf", tars[f, "path"]))
    args <- c(Rver, "CMD", "check", tars[f, "path"])
    outfile <- paste(f, ".out", sep = "")
    system2("time", args, outfile, outfile, wait = FALSE)
}

for(f in nmr) do_one_r(f, tars)
