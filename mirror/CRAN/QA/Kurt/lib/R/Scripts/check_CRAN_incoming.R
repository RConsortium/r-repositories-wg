check_dir <- file.path(normalizePath("~"), "tmp", "CRAN")

user <- Sys.info()["user"]
if(user == "unknown") user <- Sys.getenv("LOGNAME")
Sys.setenv("R_USER_DATA_DIR" =
               sprintf("/tmp/check-CRAN-incoming-%s/data", user),
           "R_USER_CACHE_DIR" =
               sprintf("/tmp/check-CRAN-incoming-%s/cache", user),
           "R_USER_CONFIG_DIR" =
               sprintf("/tmp/check-CRAN-incoming-%s/config", user))

Sys.setenv("_R_CHECK_INSTALL_DEPENDS_" = "true")

Sys.setenv("R_GC_MEM_GROW" = "2",
           "R_C_BOUNDS_CHECK" = "yes")

## <FIXME>
## Need OMP thread limit as 3 instead of 4 when using OpenBLAS.
Sys.setenv("OMP_NUM_THREADS" = 3,      # 4?
           "OMP_THREAD_LIMIT" = 3,     # 4?
           "RCPP_PARALLEL_NUM_THREADS" = 4,
           "POCL_KERNEL_CACHE" = 0,
           "OMPI_MCA_btl_base_warn_component_unused" = 0
           )
## Or maybe instead just
Sys.setenv("OPENBLAS_NUM_THREADS" = 1)
## ???
## </FIXME>

Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "false",
           "_R_CHECK_PACKAGE_DEPENDS_IGNORE_MISSING_ENHANCES_" = "true")

if(dir.exists(path <- file.path(normalizePath("~"), "tmp", "scratch")))
    Sys.setenv("TMPDIR" = path)

check_args <- character()               # No longer "--as-cran" ...
update_check_dir <- TRUE
use_check_stoplists <- FALSE
Ncpus <- 6

hostname <- system2("hostname", "-f", stdout = TRUE)
if(hostname == "xmanduin.wu.ac.at") {
    Sys.setenv("_R_CHECK_EXAMPLE_TIMING_THRESHOLD_" = "10")
    Ncpus <- 10
}
if(hostname %in% c("anduin2.wu.ac.at", "anduin3.wu.ac.at")) {
    Ncpus <- 28
}

Sys.setenv("_R_S3_METHOD_LOOKUP_BASEENV_AFTER_GLOBALENV_" =
               Sys.getenv("_R_S3_METHOD_LOOKUP_BASEENV_AFTER_GLOBALENV_",
                          "true"))

## <FIXME>
## Change eventually ...
Sys.setenv("_R_CHECK_NATIVE_ROUTINE_REGISTRATION_" =
               Sys.getenv("_R_CHECK_NATIVE_ROUTINE_REGISTRATION_",
                          "false"))
## </FIXME>

## <FIXME>
## Remove eventually ...
Sys.setenv("_R_S3_METHOD_LOOKUP_USE_TOPENV_AS_DEFENV_" =
               Sys.getenv("_R_S3_METHOD_LOOKUP_USE_TOPENV_AS_DEFENV_",
                          "true"))
## </FIXME>

## <FIXME>
## Remove eventually ..
Sys.setenv("_R_STOP_ON_XTFRM_DATA_FRAME_" =
               Sys.getenv("_R_STOP_ON_XTFRM_DATA_FRAME_",
                          "true"))
## </FIXME>

reverse <- NULL

## <FIXME>
## Perhaps add a -p argument to be passed to getIncoming?
## Currently, -p KH/*.tar.gz is hard-wired.
## </FIXME>

usage <- function() {
    cat("Usage: check_CRAN_incoming [options]",
        "",
        "Run KH CRAN incoming checks.",
        "",
        "Options:",
        "  -h, --help      print short help message and exit",
        "  -n              do not update check dir",
        "  -s              use stop lists",
        "  -c              run CRAN incoming feasibility checks",
        "  -r              also check strong reverse depends",
        "  -r=WHICH        also check WHICH reverse depends",
        "  -N=N            use N CPUs",
        "  -f=FLAVOR       use flavor FLAVOR ('g' or 'c' for the GCC or Clang",
        "                  defaults, 'g/v' or 'c/v' for the version 'v' ones)",
        "  -d=DIR          use DIR as check dir (default: ~/tmp/CRAN)",
        "  -l              run local incoming checks only",
        "  -a=ARGS         pass ARGS to R CMD check",
        "",
        "The CRAN incoming feasibility checks are always used for CRAN",
        "incoming checks (i.e., unless '-n' is given), and never when",
        "checking the reverse dependencies.",
        sep = "\n")
}

check_args_db_from_stoplist_sh <-
function()
{
    x <- system(". ~/lib/bash/check_R_stoplists.sh; set", intern = TRUE)
    x <- grep("^check_args_db_", x, value = TRUE)
    db <- sub(".*='(.*)'$", "\\1", x)
    names(db) <-
        chartr("_", ".", sub("^check_args_db_([^=]*)=.*", "\\1", x))
    db
}

args <- commandArgs(trailingOnly = TRUE)
if(any(ind <- (args %in% c("-h", "--help")))) {
    usage()
    q("no", runLast = FALSE)
}
if(any(ind <- (args == "-n"))) {
    update_check_dir <- FALSE
    args <- args[!ind]
}
if(any(ind <- (args == "-s"))) {
    use_check_stoplists <- TRUE
    args <- args[!ind]
}
run_CRAN_incoming_feasibility_checks <- update_check_dir
if(any(ind <- (args == "-c"))) {
    run_CRAN_incoming_feasibility_checks <- TRUE
    args <- args[!ind]
}
if(any(ind <- (args == "-r"))) {
    reverse <- list()
    args <- args[!ind]
}
if(any(ind <- (args == "-l"))) {
    Sys.setenv("_R_CHECK_CRAN_INCOMING_SKIP_URL_CHECKS_IF_REMOTE_" = "true",
               "_R_CHECK_CRAN_INCOMING_SKIP_DOI_CHECKS_" = "true")
    args <- args[!ind]
}    
if(any(ind <- startsWith(args, "-r="))) {
    which <- substring(args[ind][1L], 4L)
    reverse <- if(which == "most") {
        list(which = list(c("Depends", "Imports", "LinkingTo"),
                          "Suggests"),
             reverse = c(TRUE, FALSE))
    } else {
        list(which = which)
    }
    args <- args[!ind]
}
if(any(ind <- startsWith(args, "-N="))) {
    Ncpus <- list(which = substring(args[ind][1L], 4L))
    args <- args[!ind]
}
if(any(ind <- startsWith(args, "-d="))) {
    check_dir <- substring(args[ind][1L], 4L)
    args <- args[!ind]
}
if(any(ind <- startsWith(args, "-a="))) {
    check_args <- substring(args[ind][1L], 4L)
    args <- args[!ind]
}
if(length(args)) {
    stop(paste("unknown option(s):",
               paste(sQuote(args), collapse = ", ")))
}

if(update_check_dir) {
    unlink(check_dir, recursive = TRUE)
    if(system2("getIncoming",
               c("-p KH/*.tar.gz", "-d", check_dir),
               stderr = FALSE)) {
        message("no packages to check")
        q("no", status = 1, runLast = FALSE)
    }
    message("")
}

check_args_db <- if(use_check_stoplists) {
    check_args_db_from_stoplist_sh()    
} else {
    list()
}
check_env_common <-
    c(paste0("LANG=", Sys.getenv("_R_CHECK_LANG_", "en_US.UTF-8")),
      ## (allow checking with LANG different from en_US.UTF-8)
      "LC_COLLATE=C",
      "LANGUAGE=en@quot",
      sprintf("_R_CHECK_CRAN_STATUS_SUMMARY_=%s",
              Sys.getenv("_R_CHECK_CRAN_STATUS_SUMMARY_", "true")),
      "_R_TOOLS_C_P_I_D_ADD_RECOMMENDED_MAYBE_=true",
      ## These could be conditionalized according to hostname.
      ##   "R_SESSION_TIME_LIMIT_CPU=900",
      ##   "R_SESSION_TIME_LIMIT_ELAPSED=1800",
      ## <FIXME>
      ## Currently, tools::check_packages_in_dir() only uses
      ## _R_INSTALL_PACKAGES_ELAPSED_TIMEOUT_ when installing
      ## dependencies.
      "_R_INSTALL_PACKAGES_ELAPSED_TIMEOUT_=90m",
      ## </FIXME>
      "_R_CHECK_ELAPSED_TIMEOUT_=30m",
      "_R_CHECK_INSTALL_ELAPSED_TIMEOUT_=90m",
      character()
      )
check_env <-
    list(c(check_env_common,
           "_R_CHECK_WARN_BAD_USAGE_LINES_=TRUE",
           sprintf("_R_CHECK_CRAN_INCOMING_SKIP_VERSIONS_=%s",
                   !run_CRAN_incoming_feasibility_checks),
           sprintf("_R_CHECK_CRAN_INCOMING_SKIP_DATES_=%s",
                   !run_CRAN_incoming_feasibility_checks),
           "_R_CHECK_CODOC_VARIABLES_IN_USAGES_=true",
           "_R_CHECK_CONNECTIONS_LEFT_OPEN_=true",
           "_R_CHECK_CRAN_INCOMING_=true",
           "_R_CHECK_CRAN_INCOMING_NOTE_GNU_MAKE_=true",
           "_R_CHECK_CRAN_INCOMING_REMOTE_=true",
           "_R_CHECK_CRAN_INCOMING_USE_ASPELL_=true",
           "_R_CHECK_CRAN_INCOMING_CHECK_FILE_URIS_=true",
           "_R_CHECK_DATALIST_=true",
           if(run_CRAN_incoming_feasibility_checks)
               c("_R_CHECK_LENGTH_1_CONDITION_=package:_R_CHECK_PACKAGE_NAME_,abort,verbose",
                 ## "_R_CHECK_LENGTH_1_LOGIC2_=package:_R_CHECK_PACKAGE_NAME_,abort,verbose",
                 character()),
           ## "_R_CHECK_ORPHANED_=true",
           "_R_CHECK_PACKAGE_DEPENDS_IGNORE_MISSING_ENHANCES_=true",
           "_R_CHECK_PACKAGES_USED_CRAN_INCOMING_NOTES_=true",
           "_R_CHECK_RD_CONTENTS_KEYWORDS_=true",
           "_R_CHECK_R_DEPENDS_=warn",
           "_R_CHECK_THINGS_IN_TEMP_DIR_=true",
           "_R_CHECK_BASHISMS_=true",
           ## "_R_CHECK_XREFS_MIND_SUSPECT_ANCHORS_=true",
           "_R_CHECK_URLS_SHOW_301_STATUS_=true",
           "_R_CHECK_CODE_CLASS_IS_STRING_=true",
           "_R_CHECK_NEWS_IN_PLAIN_TEXT_=true",
           character()),
         c(check_env_common,
           ## <FIXME>
           ## Remove eventually ...
           "_R_CHECK_CRAN_INCOMING_=false",
           ## </FIXME>
           "_R_CHECK_CONNECTIONS_LEFT_OPEN_=false",
           "_R_CHECK_THINGS_IN_TEMP_DIR_=false",
           ## "_R_CHECK_XREFS_MIND_SUSPECT_ANCHORS_=false",
           ## <FIXME>
           character())
         )

if(!is.null(reverse))
    reverse$repos <- getOption("repos")["CRAN"]

pfiles <-
    tools::check_packages_in_dir(check_dir,
                                 check_args = check_args,
                                 check_args_db = check_args_db,
                                 reverse = reverse,
                                 xvfb = TRUE,
                                 check_env = check_env,
                                 Ncpus = Ncpus)

if(length(pfiles)) {
    writeLines("\nDepends:")
    tools::summarize_check_packages_in_dir_depends(check_dir)
    writeLines("\nTimings:")
    tools::summarize_check_packages_in_dir_timings(check_dir)
    writeLines("\nResults:")
    tools::summarize_check_packages_in_dir_results(check_dir)
}
