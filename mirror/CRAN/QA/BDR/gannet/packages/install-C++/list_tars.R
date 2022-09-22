list_tars <- function(dir='.')
{
    files <- list.files(dir, pattern="\\.tar\\.gz", full.names=TRUE)
    pkgs <- sub("_.*", "", basename(files))
    versions <- sub("[^_]+_([0-9.-]+)[.]tar.gz", "\\1", basename(files))
    dup_pkgs <- pkgs[duplicated(pkgs)]
    stale_dups <- integer(length(dup_pkgs))
    i <- 1L
    for (dp in dup_pkgs) {
        wh <- which(dp == pkgs)
        vers <- package_version(versions[wh])
        keep_ver <- max(vers)
        keep_idx <- which.max(vers == keep_ver)
        wh <- wh[-keep_idx]
        end_i <- i + length(wh) - 1L
        stale_dups[i:end_i] <- wh
        i <- end_i + 1L
    }
    if (length(stale_dups)) {
        pkgs <- pkgs[-stale_dups]
        files <- files[-stale_dups]
    }
    data.frame(name = pkgs, path = files, mtime = file.info(files)$mtime,
               row.names = pkgs, stringsAsFactors = FALSE)
}
