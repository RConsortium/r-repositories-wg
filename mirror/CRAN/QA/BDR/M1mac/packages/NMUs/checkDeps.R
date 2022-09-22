checkDeps <- function(pkg)
{
    owd <- setwd(paste0(pkg, ".Rcheck"))
    on.exit(setwd(owd))
    deps <- unique(c(tools::dependsOnPkgs(pkg),
                     tools::dependsOnPkgs(pkg, 'all', FALSE)))
    if(!length(deps)) {
        message("No dependants")
        return(invisible(NULL))
    }
    deps <- sort(deps)
    message("Checking ", length(deps), " dependants ...")

    av <- available.packages()
    deps <- intersect(deps, av[, "Package"])
    files <- paste0(deps, "_", av[deps, "Version"], ".tar.gz")
    names(files) <- deps

##    Sys.setenv(R_LIBS = file.path(getwd(), ":~/R/test-dev"))

    cmds <- paste("R_HOME= Rdev CMD check", "--no-stop-on-test-error",
                     file.path("~/R/packages/contrib", files),
                     ">", paste0(deps, ".out"), "2>&1")
    parallel::mclapply(cmds, system, mc.cores = 10, mc.preschedule = FALSE)
    message("... Dependants checked")
    invisible(NULL)
}
pkg <- commandArgs(TRUE)
pkg <- basename(pkg)
pkg <- sub("_.*", "", pkg)
message("-- ", pkg)
checkDeps(pkg)


