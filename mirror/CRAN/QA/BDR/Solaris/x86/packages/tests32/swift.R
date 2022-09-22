source("common.R")

CRAN <- 'file:///home/ripley/R/packages/contrib'

Sys.unsetenv("R_HOME")

options(warn = 1)

rlib <- "/home/ripley/R/Lib32"
Rver <- "R"
Rgcc <- "Rgcc"

tars <- av()

logs <- list.files('.', pattern = "\\.log$")
logs <- logs[logs != "script.log"]
fi <- file.info(logs)
nm <- sub("\\.log$", "", logs)
logs <- data.frame(name = nm, mtime = fi$mtime, stringsAsFactors = FALSE)
old <- nm[! nm %in% tars$name]
for(f in old) {
    cat('removing ', f, '\n', sep='')
    unlink(c(f, Sys.glob(paste(f, ".*", sep=""))), recursive = TRUE)
    unlink(file.path(rlib, f),  recursive = TRUE)
}

in0 <- installed.packages(.libPaths()[1])
inst <- data.frame(name = in0[,1], Version = package_version(in0[,3]))

foo0 <- merge(logs, tars, by='name', all.y = TRUE)
foo <- merge(foo0, inst, by='name', all.x = TRUE)
row.names(foo) <- foo$name
keep <- with(foo, mtime.x < mtime.y | Version.x > Version.y)
old <- foo[keep %in% TRUE, ]

new <- foo[is.na(foo$mtime.x), ]
nm <- unique(c(row.names(old), row.names(new)))
nm <- nm[! nm %in% stoplist]
nmr <- nm[nm %in% recommended]
nm <- nm[!nm %in% recommended]

#nm <- setdiff(nm, c('httpuv'))

if(length(nm)) {
available <- available.packages(contriburl = CRAN, filters = list())
DL <- utils:::.make_dependency_list(nm, available)
nm <- utils:::.find_install_order(nm, DL)
}

Sys.setenv(R_LIBS = rlib,
           DISPLAY=':5',
           CPPFLAGS='-I/usr/local/include',
           "_R_CHECK_INSTALL_DEPENDS_" = "TRUE",
	   "_R_CHECK_NO_RECOMMENDED_" = "TRUE",
           "_R_SHLIB_BUILD_OBJECTS_SYMBOL_TABLES_" = "TRUE",
	   PKG_CONFIG_PATH = "/opt/csw/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig",
           RMPI_TYPE="OPENMPI",
           RMPI_INCLUDE="/opt/SUNWhpc/HPC8.2.1c/sun/include",
           RMPI_LIB_PATH="/opt/SUNWhpc/HPC8.2.1c/sun/lib")

for(f in nm) {
    unlink(f, recursive = TRUE)
    unlink(file.path(rlib, f), recursive = TRUE)
    unlink(file.path(rlib, paste0("00LOCK-", f)), recursive = TRUE)
    try(system2("gtar", c("-xf", tars[f, "path"]))) # in case it changes in //
    cat(sprintf('installing %s', f))
    opt <- ""; env <- ""
    if(f == "Rserve") opt <- '--configure-args=--without-server'
    if(f == "stringi") opt <- '--configure-args=--disable-cxx11'
    if(f == "magick") opt <- '--no-test-load'
    if(f == "git2r") opt <- '--configure-args=--without-libgit2'
    desc <- read.dcf(file.path(f, "DESCRIPTION"), "SystemRequirements")[1L, ]
    if(grepl("GNU make", desc, ignore.case = TRUE)) env <- "MAKE=gmake"
    if(f == "libproj") env <- "PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"
    if(f %in% fakes) opt <- "--fake"
    opt <- c("--pkglock", opt)
    desc <- read.dcf(file.path(f, "DESCRIPTION"), "LinkingTo")[1L, ]
    cmd <- ifelse(grepl("(Rcpp|cpp11|StanHeaders)", desc) || f %in% gcc, Rgcc, Rver)
    args <- c(cmd, "CMD", "INSTALL", opt, tars[f, "path"])
    logfile <- paste(f, ".log", sep = "")
    res <- system2("time", args, logfile, logfile, env = env)
    if(res) cat("  failed\n") else cat("\n")
}

Sys.setenv(LC_CTYPE="en_GB.UTF-8")

## used for recommended packages
do_one_r <- function(f, tars)
{
    unlink(f, recursive = TRUE)
    logfile <- paste(f, ".log", sep = "")
    system2("touch", logfile)
    system2("gtar", c("-xf", tars[f, "path"]))
    args <- c(Rver, "CMD", "check", "--check-subdirs=yes-maybe",tars[f, "path"])
    outfile <- paste(f, ".out", sep = "")
    system2("time", args, outfile, outfile, wait = FALSE)
}

Sys.setenv("_R_CHECK_VIGNETTES_SKIP_RUN_MAYBE_" = "TRUE")
for(f in nmr) do_one_r(f, tars)
