options(warn=1)
do.one <- function(fn, na=NA_real_)
{
    if(!file.exists(fn)) return(na)
    conv <- function(x)
    {
        ## s or m:s or h:m:s
        xx <- as.numeric(strsplit(x, ":", fixed=TRUE)[[1]])
        xx <- if(length(xx) == 3) xx %*% c(3600,60,1)
        else if(length(xx) == 2) xx %*% c(60,1) else xx
        c(xx)
    }
    lines <- try(readLines(fn, warn = FALSE), silent=TRUE)
    if(inherits(lines, "try-error")) return(na)
    ul <- grep("^user", lines, useBytes = TRUE)
    if(length(ul) != 1) return(NA_real_)
    user <- conv(sub("^user\\s*", "", lines[ul]))
    sys <- conv(sub("^sys\\s*", "", lines[ul+1]))
    user+sys
}
packages <- sub("\\.Rcheck$", "", dir(".", pattern = "\\.Rcheck$"))
ans <- matrix("", length(packages), 2)
colnames(ans) <- c("Package", "T.total")
ans[,1] <- packages
rownames(ans) <- packages
for(p in packages) {
    ans[p, 2] <- do.one(paste(p, ".out", sep="")) +
     do.one(paste(p, ".log", sep=""), 0)
}
write.table(ans, "timings.tab", quote=FALSE, row.names=FALSE)
