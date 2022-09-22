#! /usr/local/bin/Rscript

dir <- commandArgs(TRUE)
## was directory used in the last 5 mins?
InUse <- function(dir)
{
    newest <- max(file.mtime(list.files(dir, full.names = TRUE, include.dirs = TRUE)), na.rm = TRUE)
    newest + 300 > Sys.time()
}
res <- InUse(dir)
if(res) {
    message(sprintf("directory %s is in use", sQuote(dir)))
    q("no", status = 1)
}

