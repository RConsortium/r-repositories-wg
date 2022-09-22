type <- 'MKL'
files <- list.files(file.path("/data/ftp/pub/bdr/Rblas", type),
		    pattern = "[.](out|log)$", full.names = TRUE)
Package <- sub("[.](out|log)$", "", basename(files))
Versions <- character()
for(f in files) {
    f <- sub("log$", "out", f)
    ver <- grep("^[*] this is package", readLines(f, 8), value = TRUE, useBytes = TRUE)
    ver <- sub(".*version ‘([^’]+)’.*", "\\1", ver)
    if(!length(ver)) ver <- NA
    Versions <- c(Versions, ver)
}
DF <- data.frame(Package = Package, Version = Versions,
                 kind = rep_len(type, length(files)),
                 href = paste0("https://www.stats.ox.ac.uk/pub/bdr/Rblas/",
 			       type, "/", basename(files)),
                 stringsAsFactors = TRUE)
write.csv(DF, paste0("/data/gannet/Rlogs/memtests/", type, ".csv"),
	  row.names = FALSE, quote = FALSE)

