files <- list.files("/data/ftp/pub/bdr/LENGTH1_self", pattern = "[.]out$", full.names = TRUE)
Package <- sub("[.]out$", "", basename(files))
Versions <- character()
for(f in files) {
    ver <- grep("^[*] this is package", readLines(f,8), value = TRUE, useBytes = TRUE)
    ver <- sub(".*version ‘([^’]+)’.*", "\\1", ver)
    Versions <- c(Versions, ver)
}
DF <- data.frame(Package = Package, Version = Versions,
                 kind = rep_len("LENGTH1", length(files)),
                 href = paste0("https://www.stats.ox.ac.uk/pub/bdr/LENGTH1_self/", basename(files)),
                 stringsAsFactors = TRUE)

files <- list.files("/data/ftp/pub/bdr/LENGTH1", pattern = "[.]out$", full.names = TRUE)
Package <- sub("[.]out$", "", basename(files))
Versions <- character()
for(f in files) {
    ver <- grep("^[*] this is package", readLines(f,8), value = TRUE, useBytes = TRUE)
    ver <- sub(".*version ‘([^’]+)’.*", "\\1", ver)
    Versions <- c(Versions, ver)
}
DF2 <- data.frame(Package = Package, Version = Versions,
                 kind = rep_len("LENGTH1", length(files)),
                 href = paste0("https://www.stats.ox.ac.uk/pub/bdr/LENGTH1/", basename(files)),
                 stringsAsFactors = TRUE)


write.csv(rbind(DF,DF2), "/data/gannet/Rlogs/memtests/LENGTH1.csv", row.names = FALSE, quote = FALSE)

