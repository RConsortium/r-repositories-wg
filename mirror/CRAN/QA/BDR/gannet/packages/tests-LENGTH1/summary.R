options(warn = 1L)
dest <- "/data/ftp/pub/bdr/LENGTH1_self"
files <- basename(dir(dest, patt = "[.]out$"))
files <- files[file.exists(files)]
for(f in files) {
   d <- file.path(dest, f)
   if(!any(grepl("FAILURE REPORT", readLines(f), useBytes = TRUE))) {
           message("removing ", f)
           file.remove(d)
   }
}

av <- row.names(available.packages())

ll <- dir("/data/ftp/pub/bdr/LENGTH1_self", patt = "[.]out$")
ll <- intersect(sub("[.]out$", '', ll), av)
writeLines(ll, "/data/ftp/pub/bdr/LENGTH1_self/ls.txt")

do_one <- function(f)
{
    pkg <- sub("[.]out$", "", basename(f))
    lines <- readLines(f)
    l <- grep("--- package (from environment) ---", lines, fixed = TRUE)
    if(!length(l)) return(c(pkg, NA))
    n <- lines[l+1L]
    n <- unique(sub("^ *", "", n))
    cbind(pkg, n)
}

d <- "/data/ftp/pub/bdr/LENGTH1"
files <- dir(d, patt = "[.]out$", full.names = TRUE)

A <- matrix(NA_character_, 0, 2)
colnames(A) <- c("pkg", "cause")
for(f in files) A <- rbind(A, do_one(f))
XX <- as.data.frame(A)
XX <- XX[XX$pkg %in% av, ]
write.csv(XX, file.path(d, "ls.csv"), row.names = FALSE)
