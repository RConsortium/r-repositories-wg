#! /usr/local/bin/Rscript

patt <-  "[.](log|out)$"
files <- list.files("/data/ftp/pub/bdr/donttest", pattern = patt, full.names = TRUE)
Package <- sub(patt, "", basename(files))
Versions <- character()
for(f in files) {
    ver <- grep("^[*] this is package", readLines(f, 8), value = TRUE)
    ver <- sub(".*version ‘([^’]+)’.*", "\\1", ver)
    if(!length(ver)) ver <- NA_character_
    Versions <- c(Versions, ver)
}
DF <- data.frame(Package = Package,
		 Version = Versions,
#                  Version = rep_len(NA_character_, length(files)),
                  kind = rep_len("donttest", length(files)),
                  href = paste0("https://www.stats.ox.ac.uk/pub/bdr/donttest/", basename(files)),
                  stringsAsFactors = TRUE)

ind <- is.na(DF$Version)
h <- DF$href[ind]
hh <- sub("[.]log", ".out", h)
ind2 <- match(hh, DF$href)
OK <- !is.na(ind2)
DF$Version[ind][OK] <- DF$Version[ind2[OK]]

write.csv(DF, "/data/gannet/Rlogs/memtests/donttest.csv", row.names = FALSE, quote = FALSE)

