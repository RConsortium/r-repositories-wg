## <NOTE>
## This is no longer used by check-R, as the facilities for creating a
## PACKAGES file from a directory with unpacked package sources has been
## integrated into tools::write_PACKAGES().
## </NOTE>

write_PACKAGES_from_source_dirs <-
function(dir)
{
    desc <- .build_repository_package_db_from_source_dirs(dir)

    if(length(desc)) {
        fields <- colnames(desc[[1]])
        desc <- matrix(unlist(desc), ncol = length(fields), byrow = TRUE)
        colnames(desc) <- fields
        ## Bundles do not have a Package entry in the DESCRIPTION,
        ## hence replace non-existing Package entries by Bundle
        ## entries.
        noPack <- is.na(desc[,"Package"])
        desc[noPack, "Package"] <- desc[noPack, "Bundle"]

        ## Writing PACKAGES file from matrix desc linewise in order to
        ## omit NA entries appropriately:
        out <- file(file.path(dir, "PACKAGES"), "wt")
        for(i in seq(length = nrow(desc))) {
            desci <- desc[i, !(is.na(desc[i, ]) | (desc[i, ] == "")),
                          drop = FALSE]
            write.dcf(desci, file = out)
            cat("\n", file = out)
        }
        close(out)
    }
}

.build_repository_package_db_from_source_dirs <-
function(dir)
{
    dir <- tools::file_path_as_absolute(dir)
    fields <- tools:::.get_standard_repository_db_fields()
    paths <- list.files(dir, full = TRUE)
    paths <- paths[file_test("-d", paths) &
                   file_test("-f", file.path(paths, "DESCRIPTION"))]
    db <- vector(length(paths), mode = "list")
    for(i in seq(along = paths)) {
        temp <- try(read.dcf(file.path(paths[i], "DESCRIPTION"),
                             fields = fields),
                    silent = TRUE)
        if(!inherits(temp, "try-error"))
            db[[i]] <- temp
    }
    names(db) <- basename(paths)
    db
}
