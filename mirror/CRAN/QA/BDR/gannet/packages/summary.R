packages <- sub("\\.Rcheck$", "", dir(".", pattern = "\\.Rcheck$"))
ans <- matrix("", length(packages), 6)
colnames(ans) <- c("Package", "Version", "Priority", "Maintainer", "Status","Comment")
ans[,1] <- packages
rownames(ans) <- packages
for(p in packages) {
    df <- file.path(paste0(p,".Rcheck"),  "00package.dcf")
    if(!file.exists(df)) df <- file.path(p, "DESCRIPTION")
    desc <- read.dcf(df, c("Version", "Priority", "Maintainer", "Encoding"))[1L, ]
    if(!is.na(desc[4])) desc[3] <- iconv(desc[3], from = desc[4])
    ## remove double quotes in Maintainer field
    desc[3] <- gsub('"', "", desc[3])
    ans[p, 2:4] <- desc[1:3]
    l <- readLines(file.path(paste(p, "Rcheck", sep="."), "00check.log"), warn=FALSE)
    ll <- grepl("^Status: ", l)
    if (any(ll)) {
	ll <- l[ll]
        if(length(ll) > 1) ll <- ll[length(ll)]
        ans[p, 5] <- if(grepl("ERROR", ll)) "ERROR" else if(grepl("WARNING", ll)) "WARN" else "OK"
    } else ans[p, 5] <- "FAIL"
    opts <- grep('^\\* using options', l)
    if(length(opts)) {
        opts <- l[opts[1L]]
        ans[p, 6] <- sub("\\* using options '([^']*)'", "\\1", opts)
    }
}
ans[is.na(ans)] <- ""
ans[,4] <- paste('"', gsub("\n", " ", ans[,4]), '"', sep="")
write.csv(ans, 'check.csv', quote=FALSE, row.names=FALSE)
