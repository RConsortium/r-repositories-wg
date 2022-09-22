## keep results for any packages which have been archived
CRAN <- 'file:///data/blackswan/ripley/R/packages/contrib'
av0 <- available.packages(contriburl = CRAN)
av <- rownames(av0)
av1 <- av[av0[,'NeedsCompilation'] != "yes"]
bpath <- "/data/ftp/pub/bdr/memtests/valgrind"
Packages <- list.dirs(bpath, FALSE, FALSE)
Av <- Packages[Packages %in% av]
unlink(file.path(bpath, Av), recursive = TRUE)

## and now remove any results for packages which no longer have src dirs
Av <- Packages[Packages %in% av1]
unlink(file.path(bpath, Av), recursive = TRUE)

massageFile <- function(file)
{
    lines <- readLines(file, warn = FALSE)
    if(any(grepl('client switching stacks', lines, useBytes=TRUE))) return(NULL)
    if(any(grepl('Thread [1-9]:', lines, useBytes=TRUE))) return(NULL)
    if(any(grepl("LibVEX called failure_exit().", lines, useBytes=TRUE))) return(NULL)
    head <- gsub("(==[0-9]+==) .*", "\\1", lines[1])
    lines <- lines[-(1:6)]
    l <- grep("HEAP SUMMARY:$", lines, useBytes = TRUE)
    if(length(l) && l[1L] > 2L) lines <- lines[seq_len(l[1L] - 2L)]
    l <- grep("Process terminating", lines, useBytes = TRUE)
    if(length(l) && l[1L] > 2L) lines <- lines[seq_len(l[1L] - 2L)]
    lines <- grep(paste0("^", head), lines, value = TRUE, useBytes = TRUE)
    lines <- grep("Warning: set address range perms", lines,
                  value = TRUE, useBytes = TRUE, invert = TRUE)
    pat <- paste0("packages/tests-vg/",
                  sub("-Ex.Rout$", "", basename(file)),
                  "/")
    if(any(grepl(pat, lines)) ||
       (basename(file) != "ifultools" && any(grepl("ifultools/src", lines)))) {
        ff <- sub("[.]Rcheck/.*", "", file)
        dest <- file.path("/data/ftp/pub/bdr/memtests/valgrind", ff)
        dir.create(dest, showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        file.copy(file, file.path(dest, basename(file)),
                  overwrite = TRUE, copy.date = TRUE)
    }
    NULL
}

files <- Sys.glob("*.Rcheck/*.Rout")
#files <- grep("^(stringi|tesseract)", value = TRUE, invert =TRUE, files)
junk <- sapply(files, massageFile)

massageFile2 <- function(file)
{
    lines <- readLines(file, warn = FALSE)
    if(any(grep('client switching stacks', lines, useBytes=TRUE))) return(NULL)
    if(any(grepl('Thread [1-9]:', lines, useBytes=TRUE))) return(NULL)
    if(any(grepl("LibVEX called failure_exit().", lines, useBytes=TRUE))) return
(NULL)
    head <- gsub("(==[0-9]+==) .*", "\\1", lines[1])
    lines <- lines[-(1:6)]
    l <- grep("HEAP SUMMARY:$", lines, useBytes = TRUE)
    if(length(l) && l[1L] > 2L) lines <- lines[seq_len(l[1L] - 2L)]
    l <- grep("Process terminating", lines, useBytes = TRUE)
    if(length(l) && l[1L] > 2L) lines <- lines[seq_len(l[1L] - 2L)]
    lines <- grep(paste0("^", head), lines, value = TRUE, useBytes = TRUE)
    lines <- grep("Warning: set address range perms", lines,
                  value = TRUE, useBytes = TRUE, invert = TRUE)
    ff <- sub("[.]Rcheck/.*", "", file)
    pat <- paste0("packages/tests-vg/", ff, "/")
    if(any(grepl(pat, lines))) {
        ff <- sub("[.]Rcheck/.*", "", file)
        dest <- file.path("/data/ftp/pub/bdr/memtests/valgrind", ff)
        dir.create(file.path(dest, "tests"),
                             showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", file)
        file.copy(file, file.path(dest, f2), overwrite = TRUE, copy.date = TRUE)
    }
    NULL
}
files <- c(Sys.glob("*.Rcheck/tests/*.Rout"),
           Sys.glob("*.Rcheck/tests/*.Rout.fail"))
files <- grep("^rgl", value = TRUE, invert =TRUE, files)
junk <- sapply(files, massageFile2)

massageFile3 <- function(file)
{
    lines <- readLines(file)
    if(any(grep('client switching stacks', lines, useBytes=TRUE))) return(NULL)
    if(any(grepl('Thread [1-9]:', lines, useBytes=TRUE))) return(NULL)
    if(any(grepl("LibVEX called failure_exit().", lines, useBytes=TRUE))) return
(NULL)
    head <- gsub("(==[0-9]+==) .*", "\\1", lines[1])
    lines <- lines[-(1:6)]
    l <- grep("HEAP SUMMARY:$", lines, useBytes = TRUE)
    if(length(l) && l[1L] > 2L) lines <- lines[seq_len(l[1L] - 2L)]
    l <- grep("Process terminating", lines, useBytes = TRUE)
    if(length(l) && l[1L] > 2L) lines <- lines[seq_len(l[1L] - 2L)]
    lines <- grep(paste0("^", head), lines, value = TRUE, useBytes = TRUE)
    lines <- grep("Warning: set address range perms", lines,
                  value = TRUE, useBytes = TRUE, invert = TRUE)
    ff <- sub("[.]Rcheck/.*", "", file)
    pat <- paste0("packages/tests-vg/", ff, "/")
    if(any(grepl(pat, lines))) {
        ff <- sub("[.]Rcheck/.*", "", file)
        dest <- file.path("/data/ftp/pub/bdr/memtests/valgrind", ff)
        dir.create(dest, showWarnings = FALSE, recursive = TRUE)
        file.copy(paste0(ff, ".Rcheck/00check.log"), dest,
                  overwrite = TRUE, copy.date = TRUE)
        f2 <- sub(".*[.]Rcheck/", "", file)
        file.copy(file, file.path(dest, f2), overwrite = TRUE, copy.date = TRUE)
    }
    NULL
}
files <- c(Sys.glob("*.Rcheck/*.[RSrs]nw.log"),
           Sys.glob("*.Rcheck/*.[RSrs]tex.log"),
	   Sys.glob("*.Rcheck/*.Rmd.log"))
junk <- sapply(files, massageFile3)


for(d in list.dirs('/data/ftp/pub/bdr/memtests/valgrind', TRUE, FALSE)) {
    dpath <- paste0(basename(d), ".Rcheck")
    if(file.exists(dpath)) Sys.setFileTime(d, file.info(dpath)$mtime)
}
