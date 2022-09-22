source('../common.R')

todo <- readLines('TODO')

do_it <- function(do) {
    Ver <- R.Version()
    ver <-
        if(Ver$status == "Under development (unstable)") {
            paste(Ver$major, Ver$minor, sep = ".")
        } else if (Ver$status == "Patched") {
            paste0(Ver$major, ".", substr(Ver$minor, 1, 1), "-patched")
        } else paste(Ver$major, Ver$minor, sep = ".")
    tars <-  av(ver)
    tars <- tars[tars$Package %in% todo, ]
    nm <- tars$Package
    time0 <- file.info(paste0(nm, ".in"))$mtime
#    vers <- get_vers(nm)
    unpack <- is.na(time0) | (tars$mtime > time0) #| (tars$Version > vers)
    for(i in which(unpack)) {
        if(nm[i] %in% stoplist) next
        cat(nm[i], "\n", sep = "")
        unlink(nm[i], recursive = TRUE)
        unlink(paste0(nm[i], ".out"))
        system(paste("tar -zxf", tars[i, "Path"]))
        system(paste("touch -r", tars[i, "Path"], paste0(nm[i], ".in")))
    }
}

do_it(do)
