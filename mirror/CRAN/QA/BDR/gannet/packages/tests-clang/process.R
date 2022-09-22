files <- dir(".", patt = "[.]out$")

for (f in files) {
    lines <- readLines(f)
    warn <- grep("\\[-Wbitwise-instead-of-logical|absolute-value\\]", lines,
                 useBytes = TRUE)
    ff <- file.path("/data/ftp/pub/bdr/clang14", f)
    if(length(warn))
        file.copy(f, "/data/ftp/pub/bdr/clang14",
                  overwrite = TRUE, copy.date = TRUE)
    else if(file.exists(ff)) file.remove(ff)
}

files <- list.files("/data/ftp/pub/bdr/clang14", pattern = "[.]out$", full.names = TRUE)
Package <- sub("[.]out$", "", basename(files))
DF <- data.frame(Package = Package,
                 Version = rep_len(NA_character_, length(files)),
                 kind = rep_len("clang14", length(files)),
                 href = paste0("https://www.stats.ox.ac.uk/pub/bdr/clang14/", basename(files), recycle0 = TRUE))
for (i in seq_along(Package)) {
    f <- paste0(Package[i], ".ver")
    if(file.exists(f)) DF[i, "Version"] <- readLines(f)
}
write.csv(DF, "/data/gannet/Rlogs/memtests/clang14.csv", row.names = FALSE, quote = FALSE)
