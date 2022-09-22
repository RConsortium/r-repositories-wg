## Could make these customizable via command line options.
wrk <- path.expand(file.path("~/tmp/CRAN"))
top <- path.expand(file.path("~/tmp/autocheck.d"))

## FIXME: how can we be notified about problems?

file_age <- function(paths) {
    as.numeric(Sys.Date() - as.Date(file.mtime(paths)))
}

file_age_in_hours <- function(paths) {
    as.numeric(difftime(Sys.time(), file.mtime(paths),
                        units = "hours"))
}

summarize <- function(dir, reverse = FALSE) {
    log <- file.path(dir, "package", "00check.log")
    results <- tools:::check_packages_in_dir_results(logs = log)
    status <- results$package$status
    out <- sprintf("Package check result: %s\n", status)
    if(status != "OK") {
        details <- tools:::check_packages_in_dir_details(logs = log)
        out <- c(out,
                 sprintf("Check: %s, Result: %s\n  %s\n",
                         details$Check,
                         details$Status,
                         gsub("\n", "\n  ", details$Output, perl = TRUE)))
    }
    if(reverse) {
        changes <- readLines(file.path(dir, "changes.txt"))
        out <- c(out,
                 if(length(changes))
                     c("Changes to worse in reverse depends:\n",
                       changes)
                 else
                     "No changes to worse in reverse depends.")
    }
    out
}

run <- function(reverse = FALSE) {
    if(dir.exists(wrk)) {
        if(file_age_in_hours(wrk) < 6)
            return(0)
        else
            unlink(wrk, recursive = TRUE)
    }
    if(!dir.exists(top))
        dir.create(top)
    ## Allow to disable from "outside":
    if(file.exists(file.path(top, "disable")))
        return(0)
    
    if(file.exists(lck <- file.path(top, ".lock"))) {
        if(file_age_in_hours(lck) < 6)
            return(0)
        else
            file.remove(lck)
    }
    file.create(lck)
    on.exit(file.remove(lck))
    ## From now on we have a lock in place.
    
    ## General idea is the following.
    ## Check results for package tarball
    ##   sources/PACKAGE_VERSION.tar.gz
    ## are put into directory
    ##   results/PACKAGE_VERSION_DATE_TIME
    ## Determine the oldest tarball without corresponding results dir,
    ## and run the check.
    sources.d <- file.path(top, "sources")
    results.d <- file.path(top, "results")
    outputs.d <- file.path(top, "outputs")

    if(!dir.exists(sources.d))
        dir.create(sources.d)
    if(!dir.exists(results.d))
        dir.create(results.d)
    if(!dir.exists(outputs.d))
        dir.create(outputs.d)

    ## Clean up results.
    results <- list.dirs(results.d,
                         full.names = TRUE, recursive = FALSE)
    old <- results[file_age(results) > 14]
    if(length(old))
        unlink(old, recursive = TRUE)
    
    ## Populate sources: this could also be done by someone else.
    system2("rsync",
            c("-aqz --recursive --delete",
              if(reverse)
                  "cran.wu.ac.at::CRAN-incoming/recheck/"
              else
                  "cran.wu.ac.at::CRAN-incoming/pretest/",
              sources.d),
            stdout = FALSE, stderr = FALSE)

    sources <- Sys.glob(file.path(sources.d, "*.tar.gz"))

    outputs <- list.dirs(outputs.d,
                         full.names = FALSE, recursive = FALSE)
    
    if(!length(sources)) {
        if(length(outputs)) {
            old <- file.path(outputs.d, outputs)
            if(!reverse)
                old <- old[file_age(old) > 7]
            if(length(old))
                unlink(old, recursive = TRUE)
        }
        return(0)
    }

    results <- list.dirs(results.d,
                         full.names = FALSE, recursive = FALSE)
    dts <- format(file.mtime(sources), "%Y%m%d_%H%M%S")
    pos <- order(dts)
    ids <- sprintf("%s_%s",
                   sub("[.]tar[.]gz$", "", basename(sources)[pos]),
                   dts[pos])

    old <- file.path(outputs.d, outputs[is.na(match(outputs, ids))])
    if(!reverse)
        old <- old[file_age(old) > 7]
    if(length(old))
        unlink(old, recursive = TRUE)
    
    new <- ids[is.na(match(ids, results))]
    if(!length(new)) {
        return(0)
    }
    out <- new[1L]
    writeLines(out, lck)
    dir.create(wrk)
    file.copy(file.path(sources.d,
                        paste0(sub("^([^_]+_[^_]+)_.*", "\\1", out),
                               ".tar.gz")),
              wrk)

    ## Avoid 'WARNING: ignoring environment value of R_HOME' ...
    on.exit(Sys.setenv(R_HOME = Sys.getenv("R_HOME")), add = TRUE)
    Sys.unsetenv("R_HOME")
    
    cmd <- path.expand(file.path("~/bin", "check-CRAN-incoming"))
    val <- system2(cmd,
                   paste0("-c -n -s", if(reverse) " -r"),
                   env = c("_R_CHECK_CRAN_STATUS_SUMMARY_=false"),
                   stdout = file.path(wrk, "outputs.txt"),
                   stderr = file.path(wrk, "outputs.txt"))
    ## Should we check the value returned?

    if(reverse) {
        ## Create a summary of the changes in reverse depends.
        cmd <- path.expand(file.path("~/bin",
                                     "summarize-check-CRAN-incoming-changes"))
        system2(cmd, "-m -w", stdout = file.path(wrk, "changes.txt"))
    }

    if(dir.exists(file.path(results.d, out)))
        unlink(file.path(results.d, out), recursive = TRUE)
    file.rename(wrk, file.path(results.d, out))

    ## Populate outputs for rsync from cran master.
    if(dir.exists(file.path(outputs.d, out)))
        unlink(file.path(outputs.d, out), recursive = TRUE)
    dir.create(file.path(outputs.d, out))
    file.copy(file.path(results.d, out, "outputs.txt"),
              file.path(outputs.d, out))
    if(reverse)
        file.copy(file.path(results.d, out, "changes.txt"),
                  file.path(outputs.d, out))
    package <- sub("_.*", "", out)
    if(dir.exists(from <- file.path(results.d, out,
                                    paste0(package, ".Rcheck")))) {
        dir.create(to <- file.path(outputs.d, out, "package"))
        file.copy(file.path(from, "00check.log"), to)
        if(file.exists(fp <- file.path(from, "00install.out")))
            file.copy(fp, to)
        writeLines(summarize(file.path(outputs.d, out), reverse),
                   file.path(outputs.d, out, "summary.txt"))
    }

    return(0)
}

if(!interactive()) {
    reverse <- FALSE
    args <- commandArgs(trailingOnly = TRUE)
    if(any(startsWith(args, "-r")))
        reverse <- TRUE
    val <- run(reverse)
}

if(FALSE) {
    while(TRUE) {
        run()
        Sys.sleep(1)
    }
}
