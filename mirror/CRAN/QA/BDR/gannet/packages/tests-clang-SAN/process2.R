do_one <- function(type)
{
    bpath <- paste0("/data/ftp/pub/bdr/memtests/", type)
    Package <- list.dirs(bpath, FALSE, FALSE)
    Versions <- character()
    for(p in Package) {
        f <- file.path(bpath, p, "00check.log")
#        if(file.exists(f))
#            f <- file.path("/data/gannet/ripley/R/packages/tests-clang-SAN",
#                           paste0(p, ".out"))
        ver <- if(file.exists(f)) {
            ver <- grep("^[*] this is package", readLines(f, warn = FALSE), value = TRUE,  useBytes = TRUE)
            sub(".*version ‘([^’]+)’.*", "\\1", ver)
        } else NA_character_
        if(!length(ver)) ver <- NA_character_
        Versions <- c(Versions, ver)
    }
    hpath <- paste0("https://www.stats.ox.ac.uk/pub/bdr/memtests/", type, "/")
    DF <- data.frame(Package = Package, Version = Versions,
                     kind = rep_len(type, length(Package)),
                     href = paste0(hpath, Package, recycle0 = TRUE))
    p <- paste0("/data/gannet/Rlogs/memtests/", type, ".csv")
    write.csv(DF, p, row.names = FALSE, quote = FALSE)
}

do_one("clang-ASAN")
do_one("clang-UBSAN")
