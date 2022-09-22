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
    cat(sprintf('installing %s', f))
    opt <- character()
    if (f %in% biarch) opt <- "--force-biarch"
    if (f %in% multi) opt <- "--merge-multiarch"
    args <- c("-f", '"Time %E"',
              "rcmd INSTALL --pkglock", opt, tars[f, "path"])
    logfile <- paste(f, ".log", sep = "")
    res <- system2("time", args, logfile, logfile, env = '')
    if(res) cat("  failed\n") else cat("\n")
}

DL <- utils:::.make_dependency_list(nm, available)
nm <- utils:::.find_install_order(nm, DL)
for(f in nm) do_one(f)
