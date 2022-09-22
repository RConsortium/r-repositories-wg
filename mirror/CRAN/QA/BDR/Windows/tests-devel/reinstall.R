source("../tests/exceptions.R")

list_tars <- function(dir='.')
{
    files <- list.files(dir, pattern="\\.tar\\.gz", full.names=TRUE)
    nm <- sub("_.*", "", basename(files))
    data.frame(name = nm, path = files, mtime = file.info(files)$mtime,
               row.names = nm, stringsAsFactors = FALSE)
}

foo1 <- list_tars('c:/R/packages/contrib')
#foo <- list_tars('c:/R/packages/3.3.0/Other')
#foo <- list_tars('c:/R/addlibs/dist')
#foo <- rbind(foo, foo1)
foo <- foo1
tars <- foo[!duplicated(foo$name), ]

logs <- list.files('.', pattern = "\\.log$")
logs <- logs[logs != "script.log"]
fi <- file.info(logs)
nm <- sub("\\.log$", "", logs)
logs <- data.frame(name = nm, mtime = fi$mtime, stringsAsFactors = FALSE)
old <- nm[! nm %in% c(tars$name, extras)]
for(f in old) {
    cat('removing ', f, '\n', sep='')
    unlink(c(f, Sys.glob(paste(f, ".*", sep=""))), recursive = TRUE)
    unlink(file.path(.libPaths()[1], f), recursive = TRUE)
}

foo <- merge(logs, tars, by = 'name', all.y = TRUE)
row.names(foo) <- foo$name
keep <- with(foo, mtime.x < mtime.y)
old <- foo[keep %in% TRUE, ]

new <- foo[is.na(foo$mtime.x), ]
nm <- c(row.names(old), row.names(new))
nm <- nm[! nm %in% stoplist]
available <-
    available.packages(contriburl="file:///R/packages/contrib")
nm <- nm[nm %in% rownames(available)]
if(!length(nm)) q('no')

Sys.setenv(R_INSTALL_TAR = "tar.exe",
           "_R_CHECK_INSTALL_DEPENDS_" = "TRUE",
           "_R_CHECK_NO_RECOMMENDED_" = "TRUE",
            "_R_SHLIB_BUILD_OBJECTS_SYMBOL_TABLES_" = "TRUE",
           R_LIBS = paste(.libPaths()[1:2], collapse = ";"))

do_one <- function(f)
{
    unlink(f, recursive = TRUE)
    system2("tar.exe", c("xf", tars[f, "path"]))
    cat(sprintf('installing %s\n', f))
    opt <- character()
    if (f %in% biarch) opt <- "--force-biarch"
    if (f %in% multi) opt <- "--merge-multiarch"
    args <- c("-f", '"Time %E"',
              "rcmd INSTALL --pkglock", opt, tars[f, "path"])
    logfile <- paste(f, ".log", sep = "")
    res <- system2("time", args, logfile, logfile, env = '')
    if(res) cat(sprintf('  %s failed\n', f))
    else    cat(sprintf('  %s done\n', f))
}

M <- min(4, length(nm))
library(parallel)
unlink("install_log")
cl <- makeCluster(M, outfile="install_log")
clusterExport(cl, c("tars", "biarch", "multi"))

## We need to know about dependencies via BioC packages
available2 <-
    available.packages(contriburl=c("file:///R/packages/contrib", "http://bioconductor.statistik.tu-dortmund.de/packages/3.3/bioc/bin/windows/contrib/3.3"))

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

if(FALSE) {
ex <- dir("/R/addlibs/extras", full.names = TRUE)
for(f in ex)
    system(paste("R CMD INSTALL --compact-docs", shQuote(f)))
}
