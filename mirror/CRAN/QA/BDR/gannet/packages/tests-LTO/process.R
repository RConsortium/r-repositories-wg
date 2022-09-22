files <- list.files("/data/ftp/pub/bdr/LTO", pattern = "[.]out$", full.names = TRUE)
Package <- sub("[.]out$", "", basename(files))
DF <- data.frame(Package = Package,
		 Version = rep_len(NA_character_, length(files)),
                 kind = rep_len("LTO", length(files)),
                 href = paste0("https://www.stats.ox.ac.uk/pub/bdr/LTO/", basename(files), recycle0 = TRUE))
for (i in seq_along(Package)) {
    f <- paste0(Package[i], ".ver")
    if(file.exists(f)) DF[i, "Version"] <- readLines(f)
}
write.csv(DF, "/data/gannet/Rlogs/memtests/LTO.csv", row.names = FALSE, quote = FALSE)

