files <- list.files("/data/ftp/pub/bdr/noLD", pattern = "[.]out$", full.names = TRUE)
Package <- sub("[.]out$", "", basename(files))
Versions <- character()
for(f in files) {
    ver <- grep("^[*] this is package", readLines(f, 8), value = TRUE, useBytes = TRUE)
    ver <- sub(".*version ‘([^’]+)’.*", "\\1", ver)
    Versions <- c(Versions, ver)
}
DF <- data.frame(Package = Package, Version = Versions,
                 kind = rep_len("noLD", length(files)),
                 href = paste0("https://www.stats.ox.ac.uk/pub/bdr/noLD/", basename(files)),
                 stringsAsFactors = TRUE)
write.csv(DF, "/data/gannet/Rlogs/memtests/noLD.csv", row.names = FALSE, quote = FALSE)

