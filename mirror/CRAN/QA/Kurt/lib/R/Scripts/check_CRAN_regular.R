R_scripts_dir <- normalizePath(file.path("~", "lib", "R", "Scripts"))

## Set as needed.
Ncpus_i <- Ncpus_c <- 1
## Set as needed.
check_repository_root <- "/srv/R/Repositories"
## Set as needed.
check_packages_via_parallel_make <- "no"
## Set as needed.
libdir <- Sys.getenv("_CHECK_CRAN_REGULAR_LIBRARY_DIR_",
                     file.path(R.home(), "Packages"))
## Set as needed.
env_session_time_limits <- character()
## <FIXME>
## This used to be
##     c("R_SESSION_TIME_LIMIT_CPU=600",
##       "R_SESSION_TIME_LIMIT_ELAPSED=1800")
## </FIXME>

xvfb_run <- "xvfb-run -a --server-args=\"-screen 0 1280x1024x24\""

if(dir.exists(path <- file.path(normalizePath("~"), "tmp", "scratch")))
    Sys.setenv("TMPDIR" = path)

Sys.setenv("R_GC_MEM_GROW" = "2")

## <FIXME>
## Need OMP thread limit as 3 instead of 4 when using OpenBLAS.
Sys.setenv("OMP_NUM_THREADS" = 3,       # 4?
           "OMP_THREAD_LIMIT" = 3,      # 4?
           "RCPP_PARALLEL_NUM_THREADS" = 4,
           "POCL_KERNEL_CACHE" = 0,
           "OMPI_MCA_btl_base_warn_component_unused" = 0
           )
## Or maybe instead just
Sys.setenv("OPENBLAS_NUM_THREADS" = 1)
## ???
## </FIXME>

Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "false",
           "_R_CHECK_SUGGESTS_ONLY_" = "true")

Sys.setenv("_R_CHECK_SCREEN_DEVICE_" = "warn",
           "_R_CHECK_SUPPRESS_RANDR_MESSAGE_" = "true")

## For experimenting only ...
if(Sys.getenv("_R_S3_METHOD_LOOKUP_REPORT_SEARCH_PATH_USES_") ==
   "true") {
    Sys.setenv("_R_S3_METHOD_LOOKUP_BASEENV_AFTER_GLOBALENV_" = "false")
} else {
    Sys.setenv("_R_S3_METHOD_LOOKUP_BASEENV_AFTER_GLOBALENV_" = "true")
}

## For experimenting only ...
Sys.setenv("_R_BIND_S3_DISPATCH_FORCE_IDENTICAL_METHODS_" = "false")

## <NOTE>
## This is set in the check environment file used, but the load check
## really happens at install time, hence needs special treatment for
## two-stage installs ...
Sys.setenv("_R_CHECK_INSTALL_DEPENDS_" = "true")
## </NOTE>

## <NOTE>
## To run checks in parallel using mclapply and more than 2 cores,
## we may need something like
##   Sys.setenv("_R_CHECK_LIMIT_CORES_" = "false")
## Currently not needed as we parallize via Make.
## </NOTE>

## <FIXME>
## Remove eventually ...
##   Sys.setenv("_R_S3_METHOD_REGISTRATION_NOTE_OVERWRITES_" = "true")
## </FIXME>

## <FIXME>
## Remove eventually ...
##   Sys.setenv("_R_S3_METHOD_LOOKUP_USE_TOPENV_AS_DEFENV_" = "true")
## </FIXME>

## <FIXME>
## Remove eventually ...
Sys.setenv("_R_STOP_ON_XTFRM_DATA_FRAME_" = "true")
## </FIXME>

wrkdir <- getwd()

if(!interactive()) {
    ## Command line handling.
    args <- commandArgs(trailingOnly = TRUE)
    pos <- which(args == "-j")
    if(length(pos)) {
        jobs <- args[pos + 1L]
        if(grepl("/", jobs)) {
            Ncpus_i <- as.integer(sub("/.*", "", jobs))
            Ncpus_c <- as.integer(sub(".*/", "", jobs))
        } else
            Ncpus_i <- Ncpus_c <- as.integer(jobs)
        args <- args[-c(pos, pos + 1L)]
    }
    pos <- which(args == "-m")
    if(length(pos)) {
        check_packages_via_parallel_make <- args[pos + 1L]
        args <- args[-c(pos, pos + 1L)]
    }
    ## That's all for now ...
    ## <NOTE>
    ## Could also add a command line argument for setting
    ## check_repository_root.
    ## </NOTE>
}

check_packages_via_parallel_make <-
    tolower(check_packages_via_parallel_make) %in% c("1", "yes", "true")

## Compute repository URLs to be used as repos option for checking,
## assuming local CRAN and BioC mirrors rooted at dir.
## Local Omegahat mirrors via rsync are no longer possible.
check_repository_URLs <-
function(dir)
{
    ## Could make this settable to smooth transitions ...
    BioC_version <-
        if(is.function(tools:::.BioC_version_associated_with_R_version)) {
            tools:::.BioC_version_associated_with_R_version()
        } else {
            tools:::.BioC_version_associated_with_R_version
        }
    BioC_names <- c("BioCsoft", "BioCann", "BioCexp")
    BioC_paths <- c("bioc", "data/annotation", "data/experiment")

    ## Assume that all needed src/contrib directories really exist.
    repos <- sprintf("file://%s/%s",
                     normalizePath(dir),
                     c("CRAN",
                       file.path("Bioconductor",
                                 BioC_version,
                                 BioC_paths)))
    names(repos) <- c("CRAN", BioC_names)
    ## To add Omegahat:
    ##   repos <- c(repos, Omegahat = "http://www.omegahat.net/R")
    repos
}

format_timings_from_ts0_and_ts1 <-
function(dir)
{
    ts0 <- Sys.glob(file.path(dir, "*.ts0"))
    ts1 <- Sys.glob(file.path(dir, "*.ts1"))
    ## These should really have the same length, but who knows.
    mt0 <- file.mtime(ts0)
    mt1 <- file.mtime(ts1)
    timings <-
        merge(data.frame(Package = sub("\\.ts0$", "", basename(ts0)),
                         mt0 = mt0, stringsAsFactors = FALSE),
              data.frame(Package = sub("\\.ts1$", "", basename(ts1)),
                         mt1 = mt1, stringsAsFactors = FALSE))
    sprintf("%s %f", timings$Package, timings$mt1 - timings$mt0)
}

format_timings_from_ts2 <-
function(dir, pnames = NULL)
{
    if(is.null(pnames))
        ts2 <- Sys.glob(file.path(dir, "*.ts2"))
    else {
        ts2 <- file.path(dir, paste0(pnames, ".ts2"))
        ts2 <- ts2[file.exists(ts2)]
    }
    sprintf("%s %f",
            sub("\\.ts2$", "", basename(ts2)),
            unlist(lapply(ts2,
                          get_CPU_seconds_used_from_time_output_file)))
}

get_CPU_seconds_used_from_time_output_file <-
function(f) {
    x <- readLines(f, warn = FALSE)
    p <- "(.*)user (.*)system"
    x <- x[grepl(p, x)][1L]
    if(is.na(x))
        return(0)
    m <- regexec(p, x)
    y <- regmatches(x, m)[[1L]][-1L]
    sum(vapply(parse(text = sub(":", "*60+", y)), eval, 0))
}
    
install_packages_with_timings <-
function(pnames, available, libdir, Ncpus = 1)
{
    ## If we only wanted to copy the CRAN install logs, we could record
    ##    the ones needed here, e.g. via
    ##    ilogs <- paste0(pnames, "_i.out")
    
    ## Use make -j for this.
    
    tmpd <- tempfile()
    dir.create(tmpd)
    conn <- file(file.path(tmpd, "Makefile"), "wt")

    ## Want to install the given packages and their available
    ## dependencies including Suggests.
    pdepends <- tools::package_dependencies(pnames, available,
                                            which = "most")
    pnames <- unique(c(pnames,
                       intersect(unlist(pdepends[pnames],
                                        use.names = FALSE),
                                 rownames(available))))
    ## Need to install these and their recursive dependencies.
    pdepends <- tools::package_dependencies(rownames(available),
                                            available,
                                            recursive = TRUE)
    ## Could also use utils:::.make_dependency_list(), which is a bit
    ## faster (if recursive = TRUE, this drops base packages).
    pnames <- unique(c(pnames,
                       intersect(unlist(pdepends[pnames],
                                        use.names = FALSE),
                                 rownames(available))))
    ## Drop base packages from the dependencies.
    pdepends <- lapply(pdepends, setdiff,
                       tools:::.get_standard_package_names()$base)

    ## Deal with remote dependencies (Omegahat these days ...)
    ind <- !startsWith(available[, "Repository"], "file://")
    rpnames <- intersect(pnames, rownames(available)[ind])
    if(length(rpnames)) {
        dir.create(file.path(tmpd, "Depends"))
        rppaths <- available[rpnames, "Path"]
        rpfiles <- file.path(tmpd, "Depends", basename(rppaths))
        for(i in seq_along(rpnames)) {
            download.file(rppaths[i], rpfiles[i], quiet = TRUE)
        }
        available[rpnames, "Path"] <- rpfiles
    }

    cmd0 <- sprintf("/usr/bin/env MAKEFLAGS= R_LIBS_USER=%s %s %s %s %s CMD INSTALL --pkglock",
                    shQuote(libdir),
                    paste(env_session_time_limits, collapse = " "),
                    xvfb_run,
                    paste(Sys.which("timeout"),
                          Sys.getenv("_R_INSTALL_PACKAGES_ELAPSED_TIMEOUT_",
                                     "3600")),
                    shQuote(file.path(R.home("bin"), "R")))
    deps <- paste(paste0(pnames, ".ts1"), collapse = " ")
    deps <- strwrap(deps, width = 75, exdent = 2)
    deps <- paste(deps, collapse=" \\\n")
    cat("all: ", deps, "\n", sep = "", file = conn)
    verbose <- interactive()
    for(p in pnames) {
        cmd <- paste(cmd0,
                     available[p, "Iflags"],
                     shQuote(available[p, "Path"]),
                     ">", paste0(p, "_i.out"),
                     "2>&1")
        deps <- pdepends[[p]]
        deps <- if(length(deps))
            paste(paste0(deps, ".ts1"), collapse=" ") else ""
        cat(paste0(p, ".ts1: ", deps),
            if(verbose) {
                sprintf("\t@echo begin installing package %s",
                    sQuote(p))
            },
            sprintf("\t@touch %s.ts0", p),
            sprintf("\t@-/usr/bin/time -o %s.ts2 %s", p, cmd),
            sprintf("\t@touch %s.ts1", p),
            "",
            sep = "\n", file = conn)
    }
    close(conn)

    cwd <- setwd(tmpd)
    on.exit(setwd(cwd))

    system2(Sys.getenv("MAKE", "make"),
            c("-k -j", Ncpus))

    ## Copy the install logs.
    file.copy(Sys.glob("*_i.out"), cwd, copy.date = TRUE)

    ## This does not work:
    ##   cannot rename file ........ reason 'Invalid cross-device link'
    ## ## Move the time stamps.
    ## ts0 <- Sys.glob("*.ts0")
    ## file.rename(ts0,
    ##             file.path(cwd,
    ##                       sub("\\.ts0$", "", ts0),
    ##                       ".install_timestamp"))

    ## Compute and return install timings.
    ##   timings <- format_timings_from_ts0_and_ts1(tmpd)
    timings <- format_timings_from_ts2(tmpd)

    timings
}

check_packages_with_timings <-
function(pnames, available, libdir, Ncpus = 1, make = FALSE)
{
    if(make)
        check_packages_with_timings_via_make(pnames, available,
                                             libdir, Ncpus)
    else
        check_packages_with_timings_via_fork(pnames, available,
                                             libdir, Ncpus)
}

check_packages_with_timings_via_fork <-
function(pnames, available, libdir, Ncpus = 1)
{
    ## Use mclapply() for this.

    verbose <- interactive()

    ## <FIXME 3.5.0>
    timeout <- Sys.which("timeout")
    tlim <- as.numeric(Sys.getenv("_R_CHECK_ELAPSED_TIMEOUT_", "1800"))

    do_one <- function(pname, available, libdir) {
        if(verbose) message(sprintf("checking %s ...", pname))
        ## Do not use stdout/stderr ...
        if(!is.na(match("timeout", names(formals(system2)))))
            system.time(system2(file.path(R.home("bin"), "R"),
                                c("CMD", "check", "--timings",
                                  "-l", shQuote(libdir),
                                  available[pname, "Cflags"],
                                  pname),
                                stdout = FALSE, stderr = FALSE,
                                env = c(sprintf("R_LIBS_USER=%s",
                                                shQuote(libdir)),
                                        env_session_time_limits,
                                        "_R_CHECK_LIMIT_CORES_=true"),
                                timeout = tlim))
        else
            system.time(system2(timeout,
                                c(tlim,
                                  file.path(R.home("bin"), "R"),
                                  "CMD", "check", "--timings",
                                  "-l", shQuote(libdir),
                                  available[pname, "Cflags"],
                                  pname),
                                stdout = FALSE, stderr = FALSE,
                                env = c(sprintf("R_LIBS_USER=%s",
                                                shQuote(libdir)),
                                        env_session_time_limits,
                                        "_R_CHECK_LIMIT_CORES_=true")
                                ))
    }
    ## <FIXME>

    timings <- parallel::mclapply(pnames, do_one, available,
                                  libdir, mc.cores = Ncpus)
    timings <- sprintf("%s %f", pnames, sapply(timings, `[[`, 3L))

    timings
}

check_packages_with_timings_via_make <-
function(pnames, available, libdir, Ncpus = 1)
{
    verbose <- interactive()

    ## Write Makefile for parallel checking.
    con <- file("Makefile", "wt")
    ## Note that using $(shell) is not portable:
    ## Alternatively, compute all sources from R and write them out.
    ## Using
    ##   SOURCES = `ls *.in`
    ## does not work ...
    lines <-
        c("SOURCES = $(shell ls *.in)",
          "OBJECTS = $(SOURCES:.in=.ts1)",
          ".SUFFIXES:",
          ".SUFFIXES: .in .ts1",
          "all: $(OBJECTS)",
          ".in.ts1:",
          if(verbose)
          "\t@echo checking $* ...",
          "\t@touch $*.ts0",
          ## <FIXME>
          ## Added temporarily to investigate leftover session dirs.
          ## Remove/comment eventually.
          "\t@ls /tmp > $*.ls0",
          ## </FIXME>
          ## <NOTE>
          ## As of Nov 2013, the Xvfb started from check-R-ng keeps
          ## crashing [not entirely sure what from].
          ## Hence, fall back to running R CMD check inside xvfb-run.
          ## Should perhaps make doing so controllable ...
          sprintf("\t@-/usr/bin/time -o $*.ts2 /usr/bin/env MAKEFLAGS= R_LIBS_USER=%s %s _R_CHECK_LIMIT_CORES_=true %s %s %s CMD check --timings -l %s $($*-cflags) $* >$*_c.out 2>&1",
                  shQuote(libdir),
                  paste(env_session_time_limits, collapse = " "),
                  xvfb_run,
                  paste(Sys.which("timeout"),
                        Sys.getenv("_R_CHECK_ELAPSED_TIMEOUT_", "1800")),
                  shQuote(file.path(R.home("bin"), "R")),
                  shQuote(libdir)),
          ## </NOTE>
          ## <FIXME>
          ## Added temporarily to investigate leftover session dirs.
          ## Remove/comment eventually.
          "\t@ls /tmp > $*.ls1",
          ## </FIXME>
          "\t@touch $*.ts1",
          sprintf("%s-cflags = %s",
                  pnames,
                  available[pnames, "Cflags"]))
    writeLines(lines, con)
    close(con)

    file.create(paste0(pnames, ".in"))

    system2(Sys.getenv("MAKE", "make"),
            c("-k -j", Ncpus))

    ## Compute check timings.
    ##   timings <- format_timings_from_ts0_and_ts1(getwd())
    timings <- format_timings_from_ts2(getwd(), pnames)
    
    ## Clean up (should this use wildcards?)
    file.remove(c(paste0(pnames, ".in"),
                  paste0(pnames, ".ts0"),
                  paste0(pnames, ".ts1"),
                  "Makefile"))

    timings
}

check_args_db_from_stoplist_sh <-
function()
{
    x <- system(". ~/lib/bash/check_R_stoplists.sh; set", intern = TRUE)
    x <- grep("^check_args_db_", x, value = TRUE)
    db <- sub("^check_args_db_([^=]*)=(.*)$", "\\2", x)
    db <- sub("'(.*)'", "\\1", db)
    names(db) <-
        chartr("_", ".", sub("^check_args_db_([^=]*)=.*", "\\1", x))
    db
}

## Compute available packages as used for CRAN checking:
## Use CRAN versions in preference to versions from other repositories
## (even if these have a higher version number)
## For now, also exclude packages according to OS requirement: to
## change, drop 'OS_type' from the list of filters below.
filters <- c("R_version", "OS_type", "CRAN", "duplicates")
repos <- check_repository_URLs(check_repository_root)
## Needed for CRAN filtering below.
options(repos = repos)
## Also pass this to the profile used for checking:
Sys.setenv("_CHECK_CRAN_REGULAR_REPOSITORIES_" =
           paste(sprintf("%s=%s", names(repos), repos), collapse = ";"))

curls <- contrib.url(repos)
available <- available.packages(contriburl = curls, filters = filters)
## Recommended packages require special treatment: the versions in the
## version specific CRAN subdirectories are not listed as available.  So
## create the corresponding information from what is installed in the
## system library, and merge this in by removing duplicates (so that for 
## recommended packages we check the highest "available" version, which
## for release/patched may be in the main package area).
installed <- installed.packages(lib.loc = .Library)
ind <- (installed[, "Priority"] == "recommended")
pos <- match(colnames(available), colnames(installed), nomatch = 0L)
nightmare <- matrix(NA_character_, sum(ind), ncol(available),
                    dimnames = list(installed[ind, "Package"],
                                    colnames(available)))
nightmare[ , pos > 0] <- installed[ind, pos]
## Compute where the recommended packages came from.
## Could maybe get this as R_VERSION from the environment.
R_version <- sprintf("%s.%s", R.version$major, R.version$minor)
if(R.version$status == "Patched")
    R_version <- sub("\\.[[:digit:]]*$", "-patched", R_version)
nightmare[, "Repository"] <-
    file.path(repos["CRAN"], "src", "contrib", R_version, "Recommended")

ind <- (!is.na(priority <- available[, "Priority"]) &
        (priority == "recommended"))

available <- 
    rbind(tools:::.remove_stale_dups(rbind(nightmare, available[ind, ])),
          available[!ind, ])

## Make sure we have the most recent versions of the recommended
## packages in .Library.
update.packages(lib.loc = .Library, available = available, ask = FALSE)

## Paths to package tarballs.
pfiles <- sub("^file://", "",
              sprintf("%s/%s_%s.tar.gz",
                      available[, "Repository"],
                      available[, "Package"],
                      available[, "Version"]))
available <- cbind(available, Path = pfiles)

## Unpack all CRAN packages to simplify checking via Make.
ind <- startsWith(available[, "Repository"], repos["CRAN"])
## <NOTE>
## In principle we could also check the e.g. BioC (software) packages by
## (optionally) doing
##    ind <- ind | startsWith(available[, "Repository"],
##                            repos["BioCsoft"])
## </NOTE>
results <-
    parallel::mclapply(pfiles[ind],
                       function(p)
                       system2("tar", c("zxf", p),
                               stdout = FALSE, stderr = FALSE),
                       mc.cores = Ncpus_i)
## <NOTE>
## * Earlier version also installed the CRAN packages from the unpacked
##   sources, to save the resources of the additional unpacking when
##   installing from the tarballs.  This complicates checking (and made
##   it necessary to use an .install_timestamp mechanism to identify
##   files in the unpacked sources created by installation): hence, we
##   no longer do so.
## * We could easily change check_packages_with_timings_via_fork() to
##   use the package tarballs for checking: simply replace 'pname' by
##   'available[pname, "Path"]' in the call to R CMD check.
##   For check_packages_with_timings_via_make(), we would need to change
##   '$*' in the Make rule by something like $(*-path), and add these
##   PNAME-path variables along the lines of adding the PNAME-cflags
##   variables.
## </NOTE>

## Add information on install and check flags.
## Keep things simple, assuming that the check args db entries are one
## of '--install=fake', '--install=no', or a combination of other
## arguments to be used for full installs.
check_args_db <- check_args_db_from_stoplist_sh()
pnames <- rownames(available)[ind]
pnames_using_install_no <-
    intersect(names(check_args_db)[check_args_db == "--install=no"],
              pnames)
pnames_using_install_fake <-
    intersect(names(check_args_db)[check_args_db == "--install=fake"],
              pnames)
pnames_using_install_full <-
    setdiff(pnames,
            c(pnames_using_install_no, pnames_using_install_fake))
## For simplicity, use character vectors of install and check flags.
iflags <- character(length(pfiles))
names(iflags) <- rownames(available)
cflags <- iflags
iflags[pnames_using_install_fake] <- "--fake"
## Packages using a full install are checked with '--install=check:OUT',
## where OUT is the full/fake install output file.
## <FIXME>
## Packages using a fake install are checked with '--install=fake'.
## Currently it is not possible to re-use the install output file, as we
## cannot give both --install=fake --install=check:OUT to R CMD check.
## However, in principle checking with --install=fake mostly only
## turns off the run time tests, so we check --install=fake packages
## with  --install=check:OUT --no-examples --no-vignettes --no-tests.
cflags[pnames_using_install_no] <- "--install=no"
##   cflags[pnames_using_install_fake] <- "--install=fake"
cflags[pnames_using_install_fake] <-
    sprintf(if((getRversion() >= "4.2.0") &&
               (as.integer(R.version[["svn rev"]]) >= 80722))
                "--install='check+fake:%s/%s_i.out' %s"
            else
                "--install='check:%s/%s_i.out' %s",
            wrkdir, pnames_using_install_fake,
            "--no-examples --no-vignettes --no-tests")
## </FIXME>
pnames <- intersect(pnames_using_install_full, names(check_args_db))
cflags[pnames] <- sprintf("--install='check:%s/%s_i.out' %s",
                          wrkdir, pnames, check_args_db[pnames])
pnames <- setdiff(pnames_using_install_full, names(check_args_db))
cflags[pnames] <- sprintf("--install='check:%s/%s_i.out'",
                          wrkdir, pnames)
## Now add install and check flags to available db.
available <- cbind(available, Iflags = iflags, Cflags = cflags)

## Should already have been created by the check-R-ng shell code.
if(!utils::file_test("-d", libdir)) dir.create(libdir)

## For testing purposes:
## pnames <-
##     c(head(pnames_using_install_full, 50),
##       pnames_using_install_fake,
##       pnames_using_install_no)
pnames <-
    c(pnames_using_install_full,
      pnames_using_install_fake,
      pnames_using_install_no)

## <FIXME>
## Some packages cannot be checked using the current timeouts (e.g., as
## of 2019-03 maGUI takes very long to perform the R code analysis,
## which cannot be disabled selectively).
## Hence, drop these ...
## There should perhaps be a way of doing this programmatically from the
## stoplists ...
pnames_to_be_dropped <- c("maGUI")
pnames <- setdiff(pnames, pnames_to_be_dropped)
## </FIXME>

timings <- 
    install_packages_with_timings(setdiff(pnames,
                                          pnames_using_install_no),
                                  available,
                                  libdir,
                                  Ncpus_i)
writeLines(timings, "timings_i.tab")

## Some packages fail when using SNOW to create socket clusters
## simultaneously, with
##   In socketConnection(port = port, server = TRUE, blocking = TRUE,  :
##     port 10187 cannot be opened
## These must be checked serially (or without run time tests).
## Others (e.g., gpuR) need enough system resources to be available when
## checking.
pnames_to_be_checked_serially <-
    c("MSToolkit", "MSwM", "gdsfmt", "geneSignatureFinder", "gpuR",
      "simFrame", "snowFT", "AFM", "AIG")

## Do not allow packages to modify their system files when checking.
## Ideally, this is achieved via a read-only bind (re)mount of libdir,
## which can be achieved in user space via bindfs, or in kernel space
## via dedicated '/etc/fstab' non-superuser mount point entries.
## (E.g.,
## <https://unix.stackexchange.com/questions/198590/what-is-a-bind-mount>
## for more information on bind mounts.)
## The user space variant adds a noticeable overhead: in 2018-01, about
## 30 minutes for check runs taking about 6.5 hours.
## Hence, do the kernel space variant if possible (as inferred by an
## entry for libdir in '/etc/fstab').
## For the user space variant, '--no-allow-other' seems to suffice, and
## avoids the need for enabling 'user_allow_other' in '/etc/fuse.conf'.
## However, it apparently has problems when (simultaneously) checking
## Rcmdr* packages, giving "too many open files" errors when using the
## default maximum number for open file descriptors of 1024: this can be
## fixed via ulimit -n 2048 in check-R-ng.

bind_mount_in_user_space <-
    ! any(startsWith(readLines("/etc/fstab", warn = FALSE), libdir))
if(bind_mount_in_user_space) {
    system2("bindfs",
            c("-r", "--no-allow-other",
              shQuote(libdir), shQuote(libdir)))
} else {
    system2("mount", shQuote(libdir))
}

## <FIXME>
## (We should really look at the return values of these calls.)
## </FIXME>

## Older variants explicitly removed write mode bits for files in libdir
## while checking: also possible, but a bit too much, given that using a
## umask of 222 seems "strange", and *copying* from the libdir, e.g.,
## using file.copy(), will by default copy the modes.
## <COMMENT>
## system2("chmod", c("-R", "a-w", shQuote(libdir)))
## ## <FIXME>
## ## See above for '--install=fake' woes and how we currently work
## ## around these.
## ##   But allow some access to libdir for packages using --install=fake.
## ##   system2("chmod", c("u+w", shQuote(libdir)))
## ##   for(p in pnames_using_install_fake) 
## ##       system2("chmod", c("-R", "u+w", shQuote(file.path(libdir, p))))
## ## </FIXME>
## </COMMENT>

timings <- 
    check_packages_with_timings(setdiff(pnames,
                                        pnames_to_be_checked_serially),
                                available, libdir, Ncpus_c,
                                check_packages_via_parallel_make)
if(length(pnames_to_be_checked_serially)) {
    timings <-
        c(timings,
          check_packages_with_timings(intersect(pnames,
                                                pnames_to_be_checked_serially),
                                      available, libdir, 1,
                                      check_packages_via_parallel_make))

}
writeLines(timings, "timings_c.tab")

if(bind_mount_in_user_space) {
    system2("fusermount", c("-u", shQuote(libdir)))
} else {
    system2("umount", shQuote(libdir))
}

## <FIXME>
## (We should really look at the return values of these calls.)
## </FIXME>

## Older variants case:
## <COMMENT>
## ## Re-enable write permissions.
## system2("chmod", c("-R", "u+w", shQuote(libdir)))
## </COMMENT>

## Copy the package DESCRIPTION metadata over to the directories with
## the check results.
dpaths <- file.path(sprintf("%s.Rcheck", pnames), "00package.dcf")
invisible(file.copy(file.path(pnames, "DESCRIPTION"), dpaths))
Sys.chmod(dpaths, "644")                # Avoid rsync permission woes.

## Summaries.

## Source to get check_flavor_summary() and check_details_db().
source(file.path(R_scripts_dir, "check.R"))

## FIXME: use 'wrkdir' instead?
cwd <- getwd()

## Check summary.
summary <- as.matrix(check_flavor_summary(check_dirs_root = cwd))
## Change NA priority to empty.
summary[is.na(summary)] <- ""
## Older versions also reported all packages with NOTEs as OK.
## But why should we not want to see new NOTEs?
write.csv(summary,
          file = "summary.csv", quote = 4L, row.names = FALSE)

## Check details.
dir <- dirname(cwd)
details <- check_details_db(dirname(dir), basename(dir), drop_ok = NA)
write.csv(details[c("Package", "Version", "Check", "Status")],
          file = "details.csv", quote = 3L, row.names = FALSE)
## Also saveRDS details without flavor column and and ok results left in
## from drop_ok = NA (but keep ok stubs).
details <-
    details[(details$Check == "*") |
                is.na(match(details$Status,
                            c("OK", "NONE", "SKIPPED"))), ]
details$Flavor <- NULL
saveRDS(details, "details.rds", version = 2)

## Check timings.
timings <- merge(read.table(file.path(cwd, "timings_i.tab")),
                 read.table(file.path(cwd, "timings_c.tab")),
                 by = 1L, all = TRUE)
names(timings) <- c("Package", "T_install", "T_check")
timings$"T_total" <-
    rowSums(timings[, c("T_install", "T_check")], na.rm = TRUE)
write.csv(timings,
          file = "timings.csv", quote = FALSE, row.names = FALSE)
