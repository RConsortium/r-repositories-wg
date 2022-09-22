#! /usr/local/bin/Rscript

files <- list.files("/data/ftp/pub/bdr/donttest", pattern = "[.]out$", full.names = TRUE)
Package <- sub("[.]out$", "", basename(files))
Versions <- character()
for(f in files) {
    ver <- grep("^[*] this is package", readLines(f, n = 100), value = TRUE, useBytes = TRUE)
    ver <- sub(".*version ‘([^’]+)’.*", "\\1", ver)
    Versions <- c(Versions, ver)
}
DF <- data.frame(Package = Package,
		 Version = Versions,
#                  Version = rep_len(NA_character_, length(files)),
                  kind = rep_len("donttest", length(files)),
                  href = paste0("https://www.stats.ox.ac.uk/pub/bdr/donttest/", basename(files)),
                  stringsAsFactors = TRUE)
write.csv(DF, "/data/gannet/Rlogs/memtests/donttest.csv", row.names = FALSE, quote = FALSE)

