read_one <- function(f)
{
    out <- readLines(f, warn=FALSE)
    z <- grepl("^Time ", out)
    if(!any(z)) return(NA)
    time <- out[z][1L] # to be sure
    time <- sub("^Time ", "", time)
    time <- as.numeric(strsplit(time, ":", fixed = TRUE)[[1L]])
    60*time[1] + time[2]
}

outs <- Sys.glob("*.out")
res <- sapply(outs, read_one)
#print(sum(res, na.rm=TRUE)/3600)
data.frame(secs=res)
