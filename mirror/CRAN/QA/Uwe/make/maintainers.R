maintainers <- function(dir) {
    
    ## @file{dir} should be a CRAN style package directory with a
    ## @file{Descriptions} subdirectory with all the package DESCRIPTION
    ## files.
    
    descriptions <- list.files(file.path(dir, "Descriptions"),
                               pattern = "\\.DESCRIPTION$",
                               full.names = TRUE)
    out <- character(length = length(descriptions))
    names(out) <- sub("\\.DESCRIPTION$", "", basename(descriptions))
    for(i in seq(along = descriptions)) {
        meta <-
            try(read.dcf(descriptions[i],
                         fields = c("Maintainer", "Encoding"))[1, ],
                silent = TRUE)
        if(inherits(meta, "try-error")) next
        maintainer <- meta["Maintainer"]
        encoding <- meta["Encoding"]
        if(!is.na(encoding) && nchar(encoding) && Sys.getlocale("LC_CTYPE") != "C")
            maintainer <- iconv(maintainer, encoding, "")
        if(is.na(nchar(maintainer, "c")))
            maintainer <- iconv(maintainer, "latin1", "")
        out[i] <- maintainer
    }
    out
}
