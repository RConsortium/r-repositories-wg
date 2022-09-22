reverse_dependencies_with_maintainers <-
function(packages, which = c("Depends", "Imports", "LinkingTo"),
         recursive = FALSE)
{
    contrib.url(getOption("repos")["CRAN"], "source")
    ## trigger chooseCRANmirror() if required, so it's usable here:
    description <- sprintf("%s/web/packages/packages.rds",
                           getOption("repos")["CRAN"])
    con <- if(substring(description, 1L, 7L) == "file://")
        file(description, "rb")
    else
        url(description, "rb")
    on.exit(close(con))
    db <- readRDS(gzcon(con))
    rownames(db) <- NULL

    rdepends <- tools::package_dependencies(packages, db, which,
					    recursive = recursive,
					    reverse = TRUE)
    rdepends <- sort(unique(unlist(rdepends)))
    pos <- match(rdepends, db[, "Package"], nomatch = 0L)

    db[pos, c("Package", "Version", "Maintainer")]
}
