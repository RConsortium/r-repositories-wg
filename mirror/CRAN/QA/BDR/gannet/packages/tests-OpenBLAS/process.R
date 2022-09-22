type <- 'OpenBLAS'
files <- list.files(file.path("/data/ftp/pub/bdr/Rblas", type),
		    pattern = "[.]out$", full.names = TRUE)
Package <- sub("[.]out$", "", basename(files))
Versions <- character()
for(f in files) {
    ver <- grep("^[*] this is package", readLines(f, 8), value = TRUE, useBytes = TRUE)
    ver <- sub(".*version ‘([^’]+)’.*", "\\1", ver)
    Versions <- c(Versions, ver)
}
DF <- data.frame(Package = Package, Version = Versions,
                 kind = rep_len(type, length(files)),
                 href = paste0("https://www.stats.ox.ac.uk/pub/bdr/Rblas/",
			       type, "/", basename(files)),
                 stringsAsFactors = TRUE)
write.csv(DF, paste0("/data/gannet/Rlogs/memtests/", type, ".csv"),
	  row.names = FALSE, quote = FALSE)

