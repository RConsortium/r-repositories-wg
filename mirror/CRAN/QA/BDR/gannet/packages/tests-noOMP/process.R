files <- list.files("/data/ftp/pub/bdr/noOMP", pattern = "[.](out|log)$", full.names = TRUE)
Package <- sub("[.](out|log)$", "", basename(files))
Versions <- character()
for(f in files) {
    ver <- grep("^[*] this is package", readLines(f, 8), value = TRUE, useBytes = TRUE)
    ver <- if(length(ver)) sub(".*version ‘([^’]+)’.*", "\\1", ver) else NA
    Versions <- c(Versions, ver)
}
DF <- data.frame(Package = Package,
                  Version = Versions, #rep_len(NA_character_, length(files)),
                  kind = rep_len("noOMP", length(files)),
                  href = paste0("https://www.stats.ox.ac.uk/pub/bdr/noOMP/", basename(files), recycle0 = TRUE),
                  stringsAsFactors = FALSE)
ind <- is.na(DF$Version)
h <- DF$href[ind]
hh <- sub("[.]log", ".out", h)
ind2 <- match(hh, DF$href)
OK <- !is.na(ind2)
DF$Version[ind][OK] <- DF$Version[ind2[OK]]

write.csv(DF, "/data/gannet/Rlogs/memtests/noOMP.csv", row.names = FALSE, quote = FALSE)

