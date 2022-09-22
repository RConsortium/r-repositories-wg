source('../common.R')

#-------------------- functions ---------------------

av <- function(ver = "4.1.0")
{
    ## setRepositories(ind = 1) # CRAN
    options(available_packages_filters =
            c("R_version", "OS_type", "CRAN", "duplicates"))
    av <- available.packages()[, c("Package", "Version", "Repository", "NeedsCompilation")]
    av <- as.data.frame(av, stringsAsFactors = FALSE)
    path <- with(av, paste0(Repository, "/", Package, "_", Version, ".tar.gz"))
    av$Repository <- NULL
    av$Path <- sub(".*contrib/", "../contrib/", path)
    av$mtime <- file.info(av$Path)$mtime
    ans <- av[order(av$Package), ]
    ## Now merge in Recommended packages
    inst <- installed.packages(.Library)
    inst <- inst[inst[, "Priority"] == "recommended",
                 c("Package", "Version", "NeedsCompilation")]
    inst <- as.data.frame(inst, stringsAsFactors = FALSE)
    dpath <- file.path("..", "contrib", ver, "Recommended")
    rec <- dir(dpath, patt = "[.]tar[.]gz$")
    rec <- sub("[.]tar[.]gz$", "", rec)
    inst$Version <- sub("[[:alnum:]]*_([0-9_-]*)", "\\1", rec)
    inst$Path <- with(inst, paste0("../contrib/", ver, "/Recommended/",
                                   Package, "_", Version, ".tar.gz"))
    inst$mtime <- file.info(inst$Path)$mtime
    rec <- ans$Package %in% inst$Package
    rbind(tools:::.remove_stale_dups(rbind(inst, ans[rec, ])), ans[!rec, ])
}

### NB: this assumes UTF-8 quotes
get_vers <- function(nm) {
    ## read already-checked versions
    vers <- sapply(nm, function(n) {
        if (file.exists(f <- paste0(n, ".out"))) {
            ver <- grep("^[*] this is package", readLines(f, warn = FALSE),
                        value = TRUE,  useBytes = TRUE)
            if(length(ver)) sub(".*version ‘([^’]+)’.*", "\\1", ver) else "10000.0.0"
        } else "10000.0.0"
    })
    package_version(vers)
}

do_it <- function(dolist, compilation = FALSE, ...) {
    Ver <- R.Version()
    ver <-
        if (Ver$status == "Patched") {
	    paste0(Ver$major, ".", substr(Ver$minor, 1, 1), "-patched")
	} else paste(Ver$major, Ver$minor, sep = ".")
    tars <-  av(ver)
    tars <- tars[tars$Package %in% dolist, ]
    if(compilation) tars <- tars[tars$NeedsCompilation %in% "yes", ]
    nm <- tars$Package
    time0 <- file.info(paste0(nm, ".in"))$mtime
    vers <- get_vers(nm)
    unpack <- is.na(time0) | (tars$mtime > time0) | (tars$Version > vers)
    for(i in which(unpack)) {
        if(nm[i] %in% stoplist) next
        cat(nm[i], "\n", sep = "")
        unlink(nm[i], recursive = TRUE)
        unlink(paste0(nm[i], ".out"))
        system(paste("tar -zxf", tars[i, "Path"]))
        system(paste("touch -r", tars[i, "Path"], paste0(nm[i], ".in")))
    }
}

dolist <- "BayesVarSel"

do_it(dolist)

