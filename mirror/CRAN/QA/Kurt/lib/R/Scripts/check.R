check_log_URL <- "https://www.R-project.org/nosvn/R.check/"

## r_patched_is_prelease <- TRUE
## r_p_o_p <- if(r_patched_is_prelease) "r-prerel" else "r-patched"

GCC_12_compilers_KH <- "GCC 12.1.0 (Debian 12.1.0-7)"
GCC_11_compilers_KH <- "GCC 11.3.0 (Debian 11.3.0-4)"

## Adjust as needed, in particular for prerelease stages.
## <NOTE>
## Keeps this in sync with
##   lib/bash/check_R_cp_logs.sh
##   lib/bash/cran_daily_check_results.sh
## (or create a common data base eventually ...)
## </NOTE>

check_flavors_db <- local({
    fields <-
        list(c("r-devel-linux-x86_64-debian-clang",
               "r-devel", "Linux", "x86_64", "(Debian Clang)",
               "Debian GNU/Linux testing",
               "2x 8-core Intel(R) Xeon(R) CPU E5-2690 0 @ 2.90GHz",
               paste("clang version 14.0.6-2;",
                     "GNU Fortran (GCC)",
                     substring(GCC_11_compilers_KH, 5)),
               "en_US.iso885915",
               NA_character_
               ),
             c("r-devel-linux-x86_64-debian-gcc",
               "r-devel", "Linux", "x86_64", "(Debian GCC)",
               "Debian GNU/Linux testing",
               "2x 8-core Intel(R) Xeon(R) CPU E5-2690 0 @ 2.90GHz",
               GCC_12_compilers_KH,
               "C.UTF-8",
               NA_character_
               ),
             c("r-devel-linux-x86_64-fedora-clang",
               "r-devel", "Linux", "x86_64", "(Fedora Clang)",
               "Fedora 34",
               "2x 6-core Intel Xeon E5-2440 0 @ 2.40GHz",
               "clang version 14.0.0; GNU Fortran 11.3",
               "en_GB.UTF-8",
               "https://www.stats.ox.ac.uk/pub/bdr/Rconfig/r-devel-linux-x86_64-fedora-clang"
               ),
             c("r-devel-linux-x86_64-fedora-gcc",
               "r-devel", "Linux", "x86_64", "(Fedora GCC)",
               "Fedora 34",
               "2x 6-core Intel Xeon E5-2440 0 @ 2.40GHz",
               "GCC 11.3",
               "en_GB.UTF-8",
               "https://www.stats.ox.ac.uk/pub/bdr/Rconfig/r-devel-linux-x86_64-fedora-gcc"),
             c("r-devel-windows-x86_64",
               "r-devel", "Windows", "x86_64", "",
               "Windows Server 2022",
               "2x Intel Xeon E5-2680 v4 (14 core) @ 2.4GHz",
               "GCC 10.3.0 (built by MXE, MinGW-W64 project)",
               "German_Germany.utf8",
               NA_character_
               ),
             ## c("r-devel-windows-x86_64-new-TK",
             ##   "r-devel", "Windows", "x86_64", "(new-TK)",
             ##   "Windows Server 2022",
             ##   "2x Intel Xeon Gold 5118 (12 core) @ 2.3GHz",
             ##   "GCC 10.3.0 (built by MXE, MinGW-W64 project)",
             ##   "English_United States.utf8",
             ##   "https://www.r-project.org/nosvn/winutf8/ucrt3/CRAN/checks/gcc10-UCRT/README.txt"),
             ## c("r-devel-windows-x86_64-old",
             ##   "r-devel", "Windows", "x86_64", "(old)",
             ##   "Windows Server 2008 (64-bit)",
             ##   "2x Intel Xeon E5-2670 (8 core) @ 2.6GHz",
             ##   "GCC 8.3.0 (built by MSYS2, MinGW-W64 project)"),
             c("r-patched-linux-x86_64",
               "r-patched", "Linux", "x86_64", "",
               "Debian GNU/Linux testing",
               "2x 8-core Intel(R) Xeon(R) CPU E5-2690 0 @ 2.90GHz",
               GCC_11_compilers_KH,
               "C.UTF-8",
               NA_character_
               ),
             ## c("r-patched-solaris-x86",
             ##   "r-patched", "Solaris", "x86", "",
             ##   "Solaris 10",
             ##   "8x Opteron 8218 (dual core) @ 2.6 GHz",
             ##   "Oracle Developer Studio 12.6",
             ##   "https://www.stats.ox.ac.uk/pub/bdr/Rconfig/r-patched-solaris-x86"
             ##   ),
             c("r-release-linux-x86_64",
               "r-release", "Linux", "x86_64", "",
               "Debian GNU/Linux testing",
               "2x 8-core Intel(R) Xeon(R) CPU E5-2690 0 @ 2.90GHz",
               GCC_11_compilers_KH,
               "C.UTF-8",
               NA_character_               
               ),
             c("r-release-macos-arm64",
               "r-release", "macOS", "arm64", "",
               "macOS 11.2.1 (20D74)",
               "Mac mini",
               "Apple clang version 13.0.0 (clang-1300.0.29.30); GNU Fortran (GCC) 12.0.1 20220312 (experimental)",
               "en_US.UTF-8",
               NA_character_
               ),
             c("r-release-macos-x86_64",
               "r-release", "macOS", "x86_64", "",
               "macOS 10.13.6 (17G11023)",
               "Mac mini, 3 GHz",
               "Apple LLVM version 10.0.0 (clang-1000.10.44.4); GNU Fortran (GCC) 8.2.0",
               "en_US.UTF-8",
               NA_character_
               ),
             c("r-release-windows-x86_64",
               "r-release", "Windows", "x86_64", "",
               "Windows Server 2022",
               "2x Intel Xeon E5-2680 v4 (14 core) @ 2.4GHz",
               "GCC 10.3.0 (built by MXE, MinGW-W64 project)",
               "German_Germany.utf8",
               NA_character_
               ),
             c("r-oldrel-macos-arm64",
               "r-oldrel", "macOS", "arm64", "",
               "macOS 11.2.1 (20D74)",
               "Mac mini",
               "Apple clang version 12.0.0 (clang-1200.0.32.29); GNU Fortran (GCC) 11.0.0 20201219 (experimental)",
               "en_US.UTF-8",
               NA_character_
               ),
             c("r-oldrel-macos-x86_64",
               "r-oldrel", "macOS", "x86_64", "",
               "macOS 10.13.6 (17G11023)",
               "Mac mini, 3 GHz",
               "Apple LLVM version 10.0.0 (clang-1000.10.44.4); GNU Fortran (GCC) 8.2.0",
               "en_US.UTF-8",
               NA_character_
               ),
             c("r-oldrel-windows-ix86+x86_64",
               "r-oldrel", "Windows", "ix86+x86_64", "",
               "Windows Server 2008 (64-bit)",
               "2x Intel Xeon E5-2670 (8 core) @ 2.6GHz",
               "GCC 8.3.0 (built by MSYS2, MinGW-W64 project)",
               "German_Germany.1252",
               NA_character_
               )
             )

    cns <- c("Label", "Flavor", "OS_type", "CPU_type",
             "Spec", "OS_kind", "CPU_info", "Compilers", "LC_CTYPE",
             "Details")
    ind <- lengths(fields) < length(cns)
    if(any(ind))
        fields[ind] <- Map(c, fields[ind], NA_character_)
    db <- do.call(rbind, fields)
    dimnames(db) <- list(db[, 1L], cns)
    as.data.frame(db[, -1L], stringsAsFactors = FALSE)
})

## Even more ugliness ...
## <NOTE>
## In principle this could now easily be merged into check_flavors_db,
## as nowadays we only check on gimli (and ix86 checks are gone).  [In
## principle, we could also record both the local hostname and flavor,
## of course.]
check_flavors_map <-
    switch(EXPR = system2("hostname", stdout = TRUE),
           gimli = {
               c("r-devel-clang" = "r-devel-linux-x86_64-debian-clang",
                 "r-devel-gcc" = "r-devel-linux-x86_64-debian-gcc",
                 "r-patched-gcc" = "r-patched-linux-x86_64",
                 "r-release-gcc" = "r-release-linux-x86_64",
                 "r-prerel-gcc" = "r-prerel-linux-x86_64")
           },
           xmgyges = {
               c("r-release-gcc" = "r-release-linux-ix86")
           },
           NULL)

## </NOTE>

check_issue_kinds_db <- local({
    fields <-
        list(c("ATLAS",
               "Tests with alternative BLAS/LAPACK implementations",
               "https://www.stats.ox.ac.uk/pub/bdr/Rblas/README.txt"),
             c("BLAS",
               "Use of BLAS/LAPACK from C/C++ code",
               "https://www.stats.ox.ac.uk/pub/bdr/BLAS/README.txt"),
             c("LTO",
               "Tests for link-time optimization type mismatches",
               "https://www.stats.ox.ac.uk/pub/bdr/LTO/README.txt"),
             c("M1mac",
               "Checks on a M1 (arm64) Mac",
               "https://www.stats.ox.ac.uk/pub/bdr/M1mac/README.txt"),
             c("MKL",
               "Tests with alternative BLAS/LAPACK implementations",
               "https://www.stats.ox.ac.uk/pub/bdr/Rblas/README.txt"),
             c("OpenBLAS",
               "Tests with alternative BLAS/LAPACK implementations",
               "https://www.stats.ox.ac.uk/pub/bdr/Rblas/README.txt"),
             c("clang-ASAN",
               "Tests of memory access errors using AddressSanitizer",
               "https://www.stats.ox.ac.uk/pub/bdr/memtests/README.txt"),
             c("clang-UBSAN",
               "Tests of memory access errors using Undefined Behavior Sanitizer",
               "https://www.stats.ox.ac.uk/pub/bdr/memtests/README.txt"),
             c("clang14",
               "Check logs for packages with compilation warnings wich clang 14.0.0",
               "https://www.stats.ox.ac.uk/pub/bdr/clang14/README.txt"),
             c("donttest",
               "Tests including \\donttest examples",
               "https://www.stats.ox.ac.uk/pub/bdr/donttest/README.txt"),
             c("gcc-ASAN",
               "Tests of memory access errors using AddressSanitizer",
               "https://www.stats.ox.ac.uk/pub/bdr/memtests/README.txt"),
             c("gcc-UBSAN",
               "Tests of memory access errors using Undefined Behavior Sanitizer",
               "https://www.stats.ox.ac.uk/pub/bdr/memtests/README.txt"),
             c("gcc11",
               "Checks with gcc trunk aka 11.0",
               "https://www.stats.ox.ac.uk/pub/bdr/gcc11/README.txt"),
             c("noLD",
               "Tests without long double",
               "https://www.stats.ox.ac.uk/pub/bdr/noLD/README.txt"),
             c("noOMP",
               "Tests without OpenMP support",
               "https://www.stats.ox.ac.uk/pub/bdr/noOMP/README.txt"),
             c("noSuggests",
               "Tests without suggested packages",
               "https://www.stats.ox.ac.uk/pub/bdr/noSuggests/README.txt"),
             c("valgrind",
               "Tests of memory access errors using valgrind",
               "https://www.stats.ox.ac.uk/pub/bdr/memtests/README.txt"),
             ## TK
             c("rchk",
               "Checks of native code (C/C++) based on static code analysis",
               "https://raw.githubusercontent.com/kalibera/cran-checks/master/rchk/README.txt"),
             c("rcnst",
               "Checks of corruption of constants",
               "https://raw.githubusercontent.com/kalibera/cran-checks/master/rcnst/README.txt"),
             c("rlibro",
               "Checks with read-only user library",
               "https://raw.githubusercontent.com/kalibera/cran-checks/master/rlibro/README.txt")
             )
    cns <- c("Kind", "Description", "Details")
    delta <- length(cns) - lengths(fields)
    ind <- (delta > 0L)
    if(any(ind)) {
        fields[ind] <-
            Map(c, fields[ind], Map(rep.int, NA_character_, delta[ind]))
    }
    db <- do.call(rbind, fields)
    dimnames(db) <- list(db[, 1L], cns)
    as.data.frame(db[, -1L], stringsAsFactors = FALSE)
})


## Cannot use 'r-devel-windows-ix86+x86_64' as HTML id attribute as
## these should not contain a plus.
.valid_HTML_id_attribute <-
function(s)
    gsub("[^[:alnum:]_:.-]", "_", s)

## Obfuscate email addresses, see
## <http://labnol.blogspot.com/2006/03/hide-your-email-address-on-websites.html>.
obfuscate <- function(s)
    sapply(s,
           function(e)
           paste(sprintf("&#x%x;", as.integer(charToRaw(e))),
                 collapse = ""))

write_check_flavors_db_as_HTML <-
function(db = check_flavors_db, out = "")
{
    if(out == "") 
        out <- stdout()
    else if(is.character(out)) {
        out <- file(out, "wt")
        on.exit(close(out))
    }
    if(!inherits(out, "connection")) 
        stop("'out' must be a character string or connection")

    ## <FIXME>
    ## Drop Spec for now ...
    db$Spec <- NULL
    ## </FIXME>

    flavors <- rownames(db)

    db$Details <-
        ifelse(is.na(db$Details),
               "",
               sprintf("<a href=\"%s\"> Details </a>", db$Details))

    writeLines(c("<!DOCTYPE html>",
                 "<html>",
                 "<head>",
                 "<title>CRAN Package Check Flavors</title>",
                 "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
                 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
                 "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
                 "</head>",
                 "<body lang=\"en\">",
                 "<div class=\"container\">",
                 "<h2>CRAN Package Check Flavors</h2>",
                 "<p>",
                 sprintf("Last updated on %s.",
                         format(Sys.time(), usetz = TRUE)),
                 "</p>",
                 "<p>",
                 "Systems used for CRAN package checking.",
                 "</p>",
                 "<table border=\"1\">",
                 paste("<tr>",
                       paste(sprintf("<th> %s </th>",
                                     gsub(" ", "&nbsp;",
                                          c("Flavor", "R Version",
                                            "OS Type", "CPU Type",
                                            "OS Info", "CPU Info",
                                            "Compilers", "LC_CTYPE",
                                            ""))),
                             collapse = " "),
                       "</tr>"),
                 do.call(sprintf,
                         c(list(paste("<tr id=\"%s\">",
                                      paste(rep.int("<td> %s </td>",
                                                    ncol(db) + 1L),
                                            collapse = " "),
                                      "</tr>")),
                           list(.valid_HTML_id_attribute(flavors)),
                           list(flavors),
                           db)),
                 "</table>",
                 "</div>",
                 "</body>",
                 "</html>"),
               out)
}

write_check_issue_kinds_db_as_HTML <-
function(db = check_issue_kinds_db, out = "")
{
    if(out == "") 
        out <- stdout()
    else if(is.character(out)) {
        out <- file(out, "wt")
        on.exit(close(out))
    }
    if(!inherits(out, "connection")) 
        stop("'out' must be a character string or connection")

    kinds <- rownames(db)

    db$Details <-
        ifelse(is.na(db$Details),
               "",
               sprintf("<a href=\"%s\"> Details </a>", db$Details))

    writeLines(c("<!DOCTYPE html>",
                 "<html>",
                 "<head>",
                 "<title>CRAN Package Check Issue Kinds</title>",
                 "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
                 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
                 "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
                 "</head>",
                 "<body lang=\"en\">",
                 "<div class=\"container\">",
                 "<h2>CRAN Package Check Issue Kinds</h2>",
                 "<p>",
                 sprintf("Last updated on %s.",
                         format(Sys.time(), usetz = TRUE)),
                 "</p>",
                 "<table border=\"1\">",
                 paste("<tr>",
                       paste(sprintf("<th> %s </th>",
                                     c("Kind", "Description",
                                       "Details")),
                             collapse = " "),
                       "</tr>"),
                 do.call(sprintf,
                         c(list(paste("<tr id=\"%s\">",
                                      paste(rep.int("<td> %s </td>",
                                                    ncol(db) + 1L),
                                            collapse = " "),
                                      "</tr>")),
                           list(.valid_HTML_id_attribute(kinds)),
                           list(kinds),
                           db)),
                 "</table>",
                 "</div>",
                 "</body>",
                 "</html>"),
               out)
}

check_flavor_summary <-
function(dir =
         file.path("~", "tmp", "R.check",
                   "r-devel-linux-x86_64-debian-gcc"),
         check_dirs_root = file.path(dir, "PKGS"))
{
    if(!file_test("-d", check_dirs_root)) return()

    ## Just making sure ...
    lc_ctype <- Sys.getlocale("LC_CTYPE")
    Sys.setlocale("LC_CTYPE", "en_US.UTF-8")
    on.exit(Sys.setlocale("LC_CTYPE", lc_ctype))

    get_description_fields_as_utf8 <-
    function(dfile, fields = c("Version", "Priority", "Maintainer")) {
        ## Mimick tools:::.read_description(), but always re-encode to
        ## UTF-8.
        meta <- if(file.exists(dfile))
            try(read.dcf(dfile,
                         fields = unique(c(fields, "Encoding")))[1L, ],
                silent = TRUE)
        else
            NULL
        ## What if this fails?  Grr ...
        if(inherits(meta, "try-error") || is.null(meta)) {
            meta <- rep.int("", length(fields))
            names(meta) <- fields
            return(meta)
        }
        if(!is.na(encoding <- meta["Encoding"]))
            meta <- iconv(meta, encoding, "UTF-8", sub = "byte")
        meta[fields]
    }
    
    check_dirs <- list.files(path = check_dirs_root,
                             pattern = "\\.Rcheck", full.names = TRUE)
    check_logs <- file.path(check_dirs, "00check.log")
    if(!all(ind <- file.exists(check_logs))) {
        check_dirs <- check_dirs[ind]
        check_logs <- check_logs[ind]
    }
    ## Want Package, Version, Priority, Maintainer, Status, Flags.    
    summary <- matrix(character(), nrow = length(check_dirs), ncol = 6L)
    fields <- c("Version", "Priority", "Maintainer")
    for(i in seq_along(check_dirs)) {
        check_dir <- check_dirs[i]
        meta <- get_description_fields_as_utf8(file.path(check_dir,
                                                         "00package.dcf"))
        meta["Maintainer"] <-
            trimws(gsub("\n", " ", meta["Maintainer"]))

        lines <- read_check_log(check_logs[i], FALSE)

        ## Alternatives for left and right quotes.
        lqa <- "'|\u2018"
        rqa <- "'|\u2019"
        ## Group when used ...

        ## Re-encode to UTF-8 using the session charset info.
        re <- "^\\* using session charset: "
        pos <- grep(re, lines, perl = TRUE, useBytes = TRUE)
        enc <- if(length(pos))
                   sub(re, "", lines[pos[1L]], useBytes = TRUE)
               else ""
        lines <- iconv(lines, enc, "UTF-8", sub = "byte")
        if(any(bad <- !validUTF8(lines)))
            lines[bad] <- iconv(lines[bad], to = "ASCII", sub = "byte")

        ## Get header.
        re <- sprintf("^\\* this is package (%s)(.*)(%s) version (%s)(.*)(%s)$",
                      lqa, rqa, lqa, rqa)
        pos <- grep(re, lines, perl = TRUE)
        if(!length(pos)) {
            ## This really should not happen ...
            status <- flags <- NA_character_
            ## Perhaps drop at the end?
        } else {
            pos <- pos[1L]
            header <- lines[seq_len(pos - 1L)]
            lines <- lines[-seq_len(pos)]
            flags <- if(any(startsWith(header,
                                       "* this is a Windows-only package, skipping installation"))) {
                "--install=no"
            } else {
                re <- sprintf("^\\* using options? (%s)(.*)(%s)$", lqa, rqa)
                if(length(pos <- grep(re, header, perl = TRUE))) {
                    sub(re, "\\2", header[pos[1L]], perl = TRUE)
                } else ""
            }
            ## See tools:::check_packages_in_dir_results().
            pos <- which(startsWith(lines, "* loading checks for arch"))
            pos <- pos[pos < length(lines)]
            pos <- pos[startsWith(lines[pos + 1L], "** checking")]
            if(length(pos))
                lines <- lines[-pos]
            pos <- which(startsWith(lines, "* checking examples"))
            pos <- pos[pos < length(lines)]
            pos <- pos[startsWith(lines[pos + 1L],
                                  "** running examples for arch")]
            if(length(pos))
                lines <- lines[-pos]
            pos <- which(startsWith(lines, "* checking tests"))
            pos <- pos[pos < length(lines)]
            pos <- pos[startsWith(lines[pos + 1L],
                                  "** running tests for arch")]
            if(length(pos))
                lines <- lines[-pos]
            re <- "^\\*\\*? ((checking|creating|running examples for arch|running tests for arch) .*) \\.\\.\\.( (\\[[^ ]*\\]))?( (NOTE|WARNING|ERROR)|)$"
            m <- regexpr(re, lines, perl = TRUE)
            ind <- (m > 0L)
            status <-
                if(any(ind)) {
                    status <- sub(re, "\\6", lines[ind], perl = TRUE)
                    if(any(status == "")) "FAILURE"
                    else if(any(status == "ERROR")) "ERROR"
                    else if(any(status == "WARNING")) "WARNING"
                    else "NOTE"
                } else {
                    "OK"
                }
        }
        summary[i, ] <-
            cbind(tools::file_path_sans_ext(basename(check_dir)),
                  rbind(meta, deparse.level = 0),
                  status, flags)
    }
    colnames(summary) <- c("Package", fields, "Status", "Flags")

    ## <FIXME>
    ## Short term fix to ensure more consistency in the summaries,
    ## remove eventually.
    summary[, "Flags"] <-
        trimws(sub(" *--no-stop-on-test-error", "", summary[, "Flags"]))
    ## </FIXME>
    
    data.frame(summary, stringsAsFactors = FALSE)
}

check_flavor_timings <-
function(dir =
         file.path("~", "tmp", "R.check",
                   "r-devel-linux-x86_64-debian-gcc"))
{
    if(length(grep("windows", basename(dir)))) {
        status <- file.path(dir, "PKGS", "Status")
        if(!file.exists(status)) return()
        status <- read.table(status, header = TRUE)
        timings <- status[c("packages", "insttime", "checktime")]
    }
    else if(length(tfile <- Sys.glob(file.path(dir, "*-times.tab")))) {
        ## Only get total time in this case, hence return right away.
        timings <- read.table(tfile[1L], header = TRUE,
                              stringsAsFactors = FALSE)
        names(timings) <- c("Package", "T_total")
        timings$T_install <- NA_real_
        timings$T_check <- NA_real_
        return(timings)
    }
    else if(length(grep("macos|osx", basename(dir)))) {
        chkinfo_file <- file.path(dir, "PKGS", "00_summary_chkinfo")
        if(!file.exists(chkinfo_file)) return()
        chkinfo <- read.table(chkinfo_file, sep = "|", header = FALSE)
        ## For the record ...
        names(chkinfo) <-
            c("Package", "Version", "chk_result", "has_error",
              "has_warnings", "has_notes", "check_start",
              "check_duration", "flags")
        timings <- list2DF(list(Package = chkinfo$Package,
                                T_total = chkinfo$check_duration))
        timings$T_install <- NA_real_
        timings$T_check <- NA_real_
        return(timings)
    }
    else if(file.exists(tfile <- file.path(dir, "timings.csv"))) {
        return(read.csv(tfile))
    }
    else {
        t_c <- get_timings_from_timings_files(file.path(dir,
                                                        "time_c.out"))
        t_i <- get_timings_from_timings_files(file.path(dir,
                                                        "time_i.out"))
        if(is.null(t_i) || is.null(t_c)) return()
        ## <NOTE>
        ## We get error information ('Command exited with non-zero
        ## status') from both timings files, but currently do not use
        ## this further.
        ## </NOTE>
        timings <- merge(t_i[c("Package", "T_total")],
                         t_c[c("Package", "T_total")],
                         by = "Package", all = TRUE)
    }
    names(timings) <- c("Package", "T_install", "T_check")
    timings$T_total <-
        rowSums(timings[, c("T_install", "T_check")], na.rm = TRUE)
    timings
}

get_timings_from_timings_files <-
function(tfile)
{
    timings_files <- c(tfile, paste(tfile, "prev", sep = "."))
    timings_files <- timings_files[file.exists(timings_files)]
    if(!length(timings_files)) return()
    x <- paste(readLines(timings_files[1L], warn = FALSE),
               collapse = "\n")
    ## Safeguard against possibly incomplete entries.
    ## (Could there be incomplete ones not at eof?)
    is_complete <- grepl("swaps$", x)
    x <- unlist(strsplit(x, "swaps(\n|$)"))
    if(!is_complete) x <- x[-length(x)]
    x <- paste(x, "swaps", sep = "")
    ## Eliminate 'Command exited with non-zero ...'
    bad <- rep("OK", length(x))
    bad[grep(": Command (exited|terminated)[^\n]*\n", x)] <- "ERROR"
    x <- sub(": Command (exited|terminated)[^\n]*\n", ": ", x)
    x <- sub("([0-9])system .*", "\\1", x)
    x <- sub("([0-9])user ", "\\1 ", x)
    x <- sub(": ", " ", x)
    ## <NOTE>
    ## This fails when for some reason there are duplicated entries, so
    ## let's be nice ...
    ##   con <- textConnection(c("User System", x))
    ##   x <- read.table(con)
    ## </NOTE>
    con <- textConnection(x)
    y <- tryCatch(scan(con, list("", 0, 0), quiet = TRUE),
                  error = function(e) return(NULL))
    close(con)
    if(is.null(y)) return()
    ind <- !duplicated(y[[1L]])
    t_u <- y[[2L]][ind]
    t_s <- y[[3L]][ind]
    data.frame(Package = y[[1L]][ind], Status = bad[ind],
               T_user = t_u, T_system = t_s, T_total = t_u + t_s,
               stringsAsFactors = FALSE)
}

check_results_db <-
function(dir = file.path("~", "tmp", "R.check"), flavors = NULL)
{
    if(is.null(flavors))
        flavors <- row.names(check_flavors_db)
    flavors <- flavors[file.exists(file.path(dir, flavors))]

    verbose <- interactive()
    
    results <- vector("list", length(flavors))
    names(results) <- flavors

    for(flavor in flavors) {
        if(verbose)
            message(sprintf("Getting check summary for flavor %s", flavor))
        summary <- check_flavor_summary(file.path(dir, flavor))
        if(verbose)
            message(sprintf("Getting check timings for flavor %s", flavor))
        timings <- check_flavor_timings(file.path(dir, flavor))
        ## Sanitize: if there are no results, skip this flavor.
        if(!NROW(summary)) next
        results[[flavor]] <- if(is.null(timings))
            cbind(Flavor = flavor,
                  summary, T_check = NA, T_install = NA, T_total = NA)
        else
            cbind(Flavor = flavor,
                  merge(summary,
                        timings[, c("Package", "T_install",
                                    "T_check", "T_total")],
                        by = "Package", all.x = TRUE))
    }
    names(results) <- NULL
    do.call(rbind, results)
}

check_summary_summary <-
function(results)
{
    flavor <- results$Flavor
    flavor <- factor(flavor, levels = unique(flavor))
    status <- results$Status
    ## status[status == "NOTE"] <- "OK"
    status <- factor(status,
                     levels = c("OK", "NOTE", "WARN", "ERROR", "FAIL"))
    tab <- table(flavor, status)
    cbind(tab, Total = rowSums(tab, na.rm = TRUE))
}

check_timings_summary <-
function(results)
{
    tab <- aggregate(results[, c("T_check", "T_install", "T_total")],
                     list(Flavor = results$Flavor), sum, na.rm = TRUE)
    out <- as.matrix(tab[, -1L])
    rownames(out) <- tab$Flavor
    out
}

write_check_results_db_as_HTML <-
function(results, dir = file.path("~", "tmp", "R.check", "web"),
         details = NULL, issues = NULL)
{
    if(is.null(results)) return()

    dir <- path.expand(dir)
    if(!file_test("-d", dir))
        dir.create(dir, recursive = TRUE)

    verbose <- interactive()

    ## HTMLify checks results.
    ## First, create a version with hyperlinked *and* commented status
    ## info (in case a full check was not performed).
    ## Also add hyperlinked package variable.
    ## Extract maintainer addresses from Maintainer and create unique
    ## maintainer ids (valid as HTML ids) from these; replace Maintainer
    ## by a hmlified version which has the address part obfuscated.
    re <- "^[[:space:]]*([^[:space:]].*[^[:space:]])[[:space:]]*(<([^<>@]+)@([^<>@]+)>) *$"
    ind <- grepl(re, results$Maintainer)
    address <- sub(re, "\\3 at \\4", results$Maintainer)
    ## Note that this gives an empty address for maintainer 'ORPHANED',
    ## so that we use 'check_results_.html' for the results page for
    ## that maintainer.
    results$Maintainer_address <- ifelse(ind, address, "")
    ## Local parts of email addresses are case sensitive in principle,
    ## but HTML id attribute values are case insensitive.  Hence use
    ## lower case for the ids, and hope for the best.
    results$Maintainer_id <-
        ifelse(ind,
               tolower(.valid_HTML_id_attribute(sprintf("address:%s",
                                                        address))),
               "")
    results$Maintainer <- sub(re, "\\1", results$Maintainer)
    results$Maintainer <-
        gsub("&", "&amp;", results$Maintainer, fixed = TRUE) 
    results$Maintainer <- 
        gsub("<", "&lt;", results$Maintainer, fixed = TRUE)
    results$Maintainer <-
        gsub(">", "&gt;", results$Maintainer, fixed = TRUE)
    results$Maintainer <-
        gsub(" ", "&nbsp;", results$Maintainer, fixed = TRUE)
    results$Maintainer[ind] <-
        sprintf("%s&nbsp;&lt;%s&gt;",
                results$Maintainer[ind],
                obfuscate(results$Maintainer_address[ind]))

    package <- results$Package
    status <-
        ifelse(is.na(results$Status) | is.na(results$Flags), "",
               paste(results$Status,
                     ifelse(nzchar(results$Flags), "*", ""),
                     sep = ""))
    if(length(ind <- grep("^OK", status)))
        status[ind] <- sprintf("<span class=\"check_ok\">%s</span>",
                               status[ind])
    if(length(ind <- grep("^(WARN|ERROR)", status)))
        status[ind] <- sprintf("<span class=\"check_ko\">%s</span>",
                               status[ind])
    if(length(ind <- nzchar(status)))
        status[ind] <-
            paste("<a href=\"",
                  check_log_URL, results$Flavor[ind],
                  "/",
                  package[ind],
                  "-00check.html\">",
                  status[ind],
                  "</a>",
                  sep = "")
    ## <FIXME 2.7.0>
    ## sprintf() now is optimized for a length one format string.
    ## <NOTE>
    ## Using
    ##         sprintf("<a href=\"%s%s/%s-00check.html\">%s</a>",
    ##                 check_log_URL, results$Flavor[ind],
    ##                 package[ind], status[ind])
    ## is much clearer, but apparently also much slower ...
    ## <FIXME>
    ## This is because sprintf() is vectorized in its fmt argument, and
    ## hence coerces its argument for each line.  When using factors,
    ## coerce them to character right away:
    ##         sprintf("<a href=\"%s%s/%s-00check.html\">%s</a>",
    ##                 check_log_URL, as.character(results$Flavor[ind]),
    ##                 package[ind], status[ind])
    ## </FIXME>
    ## </NOTE>
    ## </FIXME>
    results <-
        cbind(results,
              Hyperpack =
              sprintf("<a href=\"../packages/%s/index.html\">%s</a>",
                      package, package),
              Hyperstat = status)

    ## Create a "flat" check summary db with one column per flavor.
    ## Do this here for efficiency in case we want to provide a flat
    ## summary by maintainer as well.
    ind <- !is.na(results$Status)
    db <- split(results[ind,
                        c("Package", "Version",
                          "Hyperpack", "Hyperstat", "Priority",
                          "Maintainer",
                          "Maintainer_address",
                          "Maintainer_id")],
                results$Flavor[ind])
    ## Eliminate the entries with no check status right away for
    ## simplicity.
    for(i in seq_along(db)) names(db[[i]])[4L] <- names(db)[i]
    db <- Reduce(function(x, y) merge(x, y, all = TRUE), db)
    ## And replace NAs and turn to character.
    db[] <- lapply(db,
                   function(s) {
                       ifelse(is.na(s), "",
                              if(is.numeric(s)) sprintf("%.2f", s)
                              else as.character(s))
                   })

    ## Start by creating the check summary HTML file.
    out <- file(file.path(dir, "check_summary.html"), "w")
    writeLines(check_summary_html_header(), out)
    if(verbose) message("Writing check results summary")
    writeLines(c("<p>Status summary:</p>",
                 check_summary_html_summary(results)),
               out)
    writeLines(paste("<p>",
                     "<a href=\"check_summary_by_maintainer.html#summary_by_maintainer\">",
                     "Results by maintainer",
                     "</a>",
                     "</p>"),
               out)
    writeLines(paste("<p>",
                     "<a href=\"check_summary_by_package.html#summary_by_package\">",
                     "Results by package",
                     "</a>",
                     "</p>"),
               out)
    writeLines(check_summary_html_footer(), out)
    close(out)

    ## Create check summary details by maintainer.
    out <- file(file.path(dir, "check_summary_by_maintainer.html"), "w")
    if(verbose) message("Writing check results summary by maintainer")
    writeLines(c(check_summary_html_header(),
                 paste("<p>",
                       "<a href=\"check_summary_by_package.html\">",
                       "Results by package",
                       "</a>",
                       "</p>"),
                 "<p id=\"summary_by_maintainer\">Results by maintainer:</p>",
                 paste("<p>",
                       "Maintainers can directly adress their results via",
                       "<code>https://CRAN.R-project.org/web/checks/check_summary_by_maintainer.html#address:<var>id</var></code>,",
                       "where <var>id</var> is obtained from the shown email address",
                       "with all characters different from letters, digits, hyphens,",
                       "underscores, colons, and periods replaced by underscores.",
                       "</p>",
                       "<p>",
                       "Alternatively, they can use the individual maintainer",
                       "results pages linked to from the maintainer fields.",
                       "</p>",
                       "<p>",
                       "Results with asterisks (*) indicate that checking",
                       "was not fully performed.",
                       "</p>"),
                 check_results_html_details_by_maintainer(db),
                 check_summary_html_footer()),
               out)
    close(out)

    ## Create check summary details by package.
    out <- file(file.path(dir, "check_summary_by_package.html"), "w")
    if(verbose) message("Writing check results summary by package")
    writeLines(c(check_summary_html_header(),
                 paste("<p>",
                       "<a href=\"check_summary_by_maintainer.html\">",
                       "Results by maintainer",
                       "</a>",
                       "</p>"),
                 "<p id=\"summary_by_package\">Results by package:</p>",
                 paste("<p>",
                       "Results with asterisks (*) indicate that checking",
                       "was not fully performed.",
                       "</p>"),
                 check_results_html_details_by_package(db),
                 check_summary_html_footer()),
               out)
    close(out)

    ## Remove the comment/flag info from hyperstatus.
    results$Hyperstat <- sub("\\*", "", results$Hyperstat)

    ## Overall check timings summary.
    out <- file.path(dir, "check_timings.html")
    if(verbose) message(sprintf("Writing %s", out))
    write_check_timings_summary_as_HTML(results, out)

    ## Individual timings for flavors.
    for(flavor in levels(results$Flavor)) {
        out <- file.path(dir, sprintf("check_timings_%s.html", flavor))
        if(verbose) message(sprintf("Writing %s", out))
        write_check_timings_for_flavor_as_HTML(results, flavor, out)
    }

    ## Older code had this split according to package ...
    issues <- split(issues[-1L], issues[[1L]])

    ## Results for each package.
    write_check_results_for_packages_as_HTML(results, dir, details,
                                             issues)

    ## Results for each address.
    write_check_results_for_addresses_as_HTML(results, dir, details,
                                              issues)

    ## And finally, a little index.
    write_check_index(file.path(dir, "index.html"))
}

check_summary_html_header <-
function()
    c("<!DOCTYPE html>",
      "<html lang=\"en\">",
      "<head>",
      "<title>CRAN Package Check Results</title>",
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
      "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
      "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
      "<style type=\"text/css\">",
      "  .r { text-align: right; }",
      "</style>",
      "</head>",
      "<body lang=\"en\">",
      "<div class=\"container\">",
      "<h1>CRAN Package Check Results</h1>",
      "<p>",
      sprintf("Last updated on %s.",
              format(Sys.time(), usetz = TRUE)),
      "</p>",
      "<p>",
      "Results for installing and checking packages",
      "using the three current flavors of R on systems running",
      "Debian GNU/Linux, Fedora, macOS and Windows.",
      "</p>")
    
check_summary_html_summary <-
function(results)
{
    tab <- check_summary_summary(results)
    tab <- tab[ , colSums(tab) > 0, drop = FALSE]
    flavors <- rownames(tab)
    fmt <- paste("<tr>",
                 "<td> <a href=\"check_flavors.html#%s\"> %s </a> </td>",
                 paste(rep.int("<td class=\"r\"> %s </td>",
                               ncol(tab)),
                       collapse = " "),
                 "<td> <a href=\"check_details_%s.html\"> Details </a> </td>",
                 "</tr>")
    c("<table border=\"1\">",
      paste("<tr>",
            paste("<th>",
                  c("Flavor", colnames(tab), ""),
                  "</th>",
                  collapse = " "),
            "</tr>"),
      do.call(sprintf,
              c(list(fmt,
                     .valid_HTML_id_attribute(flavors),
                     flavors),
                split(tab, col(tab)),
                list(flavors))),
      "</table>")
}

check_results_html_details_by_package <-
function(db)
{
    flavors <- intersect(names(db), row.names(check_flavors_db))
    fmt <- paste("<tr>",
                 paste(rep.int("<td> %s </td>", length(flavors) + 4L),
                       collapse = " "),
                 "</tr>")
    package <- db$Package
    db <- db[order(package), ]

    ## Prefer to link to package check results pages (rather than
    ## package web pages) from the check summaries.  To change back, use
    ##   hyperpack <- db[, "Hyperpack"]
    hyperpack <- sprintf("<a href=\"check_results_%s.html\">%s</a>",
                         package, package)

    db$Maintainer <-
        sprintf("<a href=\"check_results_%s.html\">%s</a>",
                sub("^address:", "", db$Maintainer_id),
                db$Maintainer)
    
    flavors_db <-
        check_flavors_db[flavors,
                         c("Flavor", "OS_type", "CPU_type", "Spec")]
    flavors_db$OS_type <- gsub(" ", "&nbsp;", flavors_db$OS_type)
    c("<table border=\"1\">",
      paste("<tr>",
            "<th> Package </th>",
            "<th> Version </th>",
            paste(do.call(sprintf,
                          c(list(paste("<th>",
                                       "<a href=\"check_flavors.html#%s\">",
                                       "%s<br/>%s<br/>%s<br/>%s",
                                       "</a>",
                                       "</th>"),
                                 .valid_HTML_id_attribute(flavors)),
                            flavors_db)),
                  collapse = " "),
            "<th> Maintainer </th>",
            "<th> Priority </th>",
            "</tr>"),
      do.call(sprintf,
              c(list(fmt, hyperpack),
                db[c("Version", flavors, "Maintainer", "Priority")])),
      "</table>")
}

check_results_html_details_by_maintainer <-
function(db)
{
    ## Very similar to the above.
    ## Obviously, this could be generalized ...
    flavors <- intersect(names(db), row.names(check_flavors_db))
    fmt <- paste("<tr%s>",
                 paste(rep.int("<td> %s </td>", length(flavors) + 4L),
                       collapse = " "),
                 "</tr>")

    ## Drop entries with missing maintainer address.
    db <- db[nzchar(db$Maintainer_address), ]
    ## FIXME:
    ## Drop entries for orphaned packages.
    ##   db <- db[db$Maintainer != "ORPHANED", ]
    ## And sort according to maintainer.
    db <- db[order(db$Maintainer_address, db$Maintainer), ]

    ind <- split(seq_along(db$Maintainer_id), db$Maintainer_id)
    nms <- names(ind)

    package <- db$Package    
    ## Prefer to link to package check results pages (rather than
    ## package web pages) from the check summaries.  To change back, use
    ##   hyperpack <- db[, "Hyperpack"]
    hyperpack <- sprintf("<a href=\"check_results_%s.html\">%s</a>",
                         package, package)

    flavors_db <-
        check_flavors_db[flavors,
                         c("Flavor", "OS_type", "CPU_type", "Spec")]
    flavors_db$OS_type <- gsub(" ", "&nbsp;", flavors_db$OS_type)

    c("<table border=\"1\">",
      paste("<tr>",
            "<th> Maintainer </th>",
            "<th> Package </th>",
            "<th> Version </th>",
            paste(do.call(sprintf,
                          c(list(paste("<th>",
                                       "<a href=\"check_flavors.html#%s\">",
                                       "%s<br/>%s<br/>%s<br/>%s",
                                       "</a>",
                                       "</th>"),
                                 .valid_HTML_id_attribute(flavors)),
                            flavors_db)),
                  collapse = " "),
            "<th> Priority </th>",
            "</tr>"),
      unlist(Map(function(n, i) {
          l <- length(i)
          do.call(sprintf,
                  c(list(fmt,
                         c(sprintf(" id=\"%s\"", n),
                           rep_len("", l - 1L)),
                         c(sprintf("<a href=\"check_results_%s.html\">%s</a>",
                                   sub("^address:", "", n),
                                   sub("&nbsp;&lt;", " &lt;",
                                       db[i[1L], "Maintainer"],
                                       fixed = TRUE)),
                           rep_len("", l - 1L)),
                         hyperpack[i]),
                    db[i, c("Version",
                            flavors,
                            "Priority")]))
      },
                 nms,
                 ind),
             use.names = FALSE),
      "</table>")
}

check_summary_html_footer <-
function()
    c("</div>",
      "</body>",
      "</html>")

write_check_timings_summary_as_HTML <-
function(results, out = "")
{
    if(!length(results)) return()

    if(out == "") 
        out <- stdout()
    else if(is.character(out)) {
        out <- file(out, "wt")
        on.exit(close(out))
    }
    if(!inherits(out, "connection")) 
        stop("'out' must be a character string or connection")
    
    writeLines(c("<!DOCTYPE html>",
                 "<html lang=\"en\">",
                 "<head>",
                 "<title>CRAN Package Check Timings</title>",
                 "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
                 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
                 "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",                 
                 "<style type=\"text/css\">",
                 "  .r { text-align: right; }",
                 "</style>",
                 "</head>",
                 "<body lang=\"en\">",
                 "<div class=\"container\">",
                 "<h1>CRAN Package Check Timings</h1>",
                 "<p>",
                 sprintf("Last updated on %s.",
                         format(Sys.time(), usetz = TRUE)),
                 "</p>",
                 "<p>",
                 "Available overall timings (in seconds) for installing and checking all CRAN packages.",
                 "</p>"),
               out)

    tab <- check_timings_summary(results)
    tab <- tab[tab[, "T_total"] > 0, ]
    flavors <- rownames(tab)
    fmt <- paste("<tr>",
                 "<td> <a href=\"check_flavors.html#%s\"> %s </a> </td>",
                 "<td class=\"r\"> %.2f </td>",
                 "<td class=\"r\"> %.2f </td>",
                 "<td class=\"r\"> %.2f </td>",
                 "<td> <a href=\"check_timings_%s.html\"> Details </a> </td>",
                 "</tr>")
    ## For some flavors we only have the total time: show nothing
    ## instead of 0.00 for the install or check times in this case.
    tab <- sprintf(fmt,
                   .valid_HTML_id_attribute(flavors), flavors,
                   tab[, "T_check"],
                   tab[, "T_install"],
                   tab[, "T_total"],
                   flavors)
    tab <- gsub(" 0.00", " ", tab)
    writeLines(c("<table border=\"1\">",
                 paste("<thead>",
                       "<tr>",
                       "<th> Flavor </th>",
                       "<th> T<sub>check</sub> </th>",
                       "<th> T<sub>install</sub> </th>",
                       "<th> T<sub>total</sub> </th>",
                       "<th> </th>",
                       "</tr>",
                       "</thead>"),
                 "<tbody>",
                 tab,
                 "</tbody>",
                 "</table>",
                 "</div>",
                 "</body>",
                 "</html>"),
               out)
}

write_check_timings_for_flavor_as_HTML <-
function(results, flavor, out = "")
{
    db <- results[results$Flavor == flavor, ]
    if(nrow(db) == 0L || all(is.na(db$T_total))) return()

    db <- db[order(db$T_total, decreasing = TRUE), ]

    if(out == "") 
        out <- stdout()
    else if(is.character(out)) {
        out <- file(out, "wt")
        on.exit(close(out))
    }
    if(!inherits(out, "connection")) 
        stop("'out' must be a character string or connection")

    ## Need to efficiently replace missings in timings and flags.
    ## (Could we have a missing check time?)
    fields <- c("T_check", "T_install", "Flags")
    db[fields] <-
        lapply(db[fields],
               function(s)
               ifelse(is.na(s), "",
                      if(is.numeric(s)) sprintf("%.2f", s)
                      else as.character(s)))
    
    writeLines(c("<!DOCTYPE html>",
                 "<html>",
                 "<head>",
                 "<title>CRAN Package Check Timings</title>",
                 "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
                 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
                 "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
                 "<style type=\"text/css\">",
                 "  .r { text-align: right; }",
                 "</style>",
                 "</head>",
                 "<body lang=\"en\">",
                 "<div class=\"container\">",
                 sprintf("<h2>CRAN Package Check Timings for %s</h2>",
                         flavor),
                 "<p>",
                 sprintf("Last updated on %s.",
                         format(Sys.time(), usetz = TRUE)),
                 "</p>",
                 "<p>",
                 "Timings for installing and checking packages",
                 sprintf("for %s on a system running %s (CPU: %s).",
                         check_flavors_db[flavor, "Flavor"],
                         check_flavors_db[flavor, "OS_kind"],
                         check_flavors_db[flavor, "CPU_info"]),
                 "</p>",                 
                 "<p>",
                 sprintf("Total seconds: %.2f (%.2f hours).",
                         sum(db$T_total, na.rm = TRUE),
                         sum(db$T_total, na.rm = TRUE) / 3600),
                 "</p>",
                 "<table border=\"1\">",
                 paste("<tr>",
                       "<th> Package </th>",
                       "<th> T<sub>total</sub> </th>",
                       "<th> T<sub>check</sub> </th>",
                       "<th> T<sub>install</sub> </th>",
                       "<th> Status </th>",
                       "<th> Flags </th>",
                       "</tr>"),
                 do.call(sprintf,
                         c(list(paste("<tr>",
                                      "<td> %s </td>",
                                      "<td class=\"r\"> %.2f </td>",
                                      "<td class=\"r\"> %s </td>",
                                      "<td class=\"r\"> %s </td>",
                                      "<td> %s </td>",
                                      "<td> %s </td>",
                                      "</tr>")),
                           db[c("Hyperpack", "T_total", "T_check",
                                "T_install", "Hyperstat", "Flags")])),
                 "</table>",
                 "</div>",
                 "</body>",
                 "</html>"),
               out)
}

write_check_results_for_packages_as_HTML <-
function(results, dir, details = NULL, issues = NULL)
{
    verbose <- interactive()

    ## Drop entries with no status.
    results <- results[!is.na(results$Status), ]
    ## Simplify results.
    results[] <-
        lapply(results,
               function(s) {
                   ifelse(is.na(s), "",
                          if(is.numeric(s)) sprintf("%.2f", s)
                          else as.character(s))
               })

    ind <- split(seq_len(nrow(results)), results$Package)
    nms <- names(ind)
    details <- split(details, factor(details$Package, nms))
    for(i in seq_along(ind)) {
        package <- nms[i]
        out <- file.path(dir, sprintf("check_results_%s.html", package))
        if(verbose) message(sprintf("Writing %s", out))
        write_check_results_for_package_as_HTML(package,
                                                results[ind[[i]], ,
                                                        drop = FALSE],
                                                details[[package]],
                                                issues[[package]],
                                                out)
    }
}

write_check_results_for_package_as_HTML <-
function(package, entries, details, issues, out = "")
{
    lines <-
        c("<!DOCTYPE html>",
          "<html lang=\"en\">",
          "<head>",
          sprintf("<title>CRAN Package Check Results for Package %s</title>",
                  package),
          "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
          "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
          "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
          "</head>",
          "<body lang=\"en\">",
          "<div class=\"container\">",
          sprintf(paste("<h2>CRAN Package Check Results for Package",
                        "<a href=\"../packages/%s/index.html\"> %s </a>",
                        "</h2>"),
                  package, package),
          "<p>",
          sprintf("Last updated on %s.",
                  format(Sys.time(), usetz = TRUE)),
          "</p>",
          "<table border=\"1\">",
          paste("<tr>",
                "<th> Flavor </th>",
                "<th> Version </th>",
                "<th> T<sub>install</sub> </th>",
                "<th> T<sub>check</sub> </th>",
                "<th> T<sub>total</sub> </th>",                
                "<th> Status </th>",
                "<th> Flags </th>",
                "</tr>"),
          do.call(sprintf,
                  c(list(paste("<tr>",
                               "<td>",
                               " <a href=\"check_flavors.html#%s\"> %s </a>",
                               "</td>",
                               "<td> %s </td>",
                               "<td class=\"r\"> %s </td>",
                               "<td class=\"r\"> %s </td>",
                               "<td class=\"r\"> %s </td>",
                               "<td> %s </td>",
                               "<td> %s </td>",
                               "</tr>")),
                    list(.valid_HTML_id_attribute(entries$Flavor)),
                    entries[c("Flavor", "Version",
                              "T_install", "T_check", "T_total",
                              "Hyperstat", "Flags")])),
          "</table>",
          ## FIXME issues
          ## memtest_notes_for_package_as_HTML(mtnotes),
          issues_for_package_as_HTML(issues),
          if(length(s <- check_details_for_package_as_HTML(details))) {
              c("<h3>Check Details</h3>",
                "",
                tryCatch(paste(unlist(s), collapse = "\n\n"),
                         error = function(e) NULL),
                "")
          },
          "</div>",
          "</body>",
          "</html>")
    
    writeLines(lines, out)
}

check_details_for_package_as_HTML <-
function(d)
{
    if(!NROW(d)) return(character())

    htmlify <- function(s) {
        s <- iconv(s, sub = "byte")
        s <- tools:::.replace_chars_by_hex_subs(s, tools:::invalid_HTML_chars_re)
        s <- gsub("&", "&amp;", s, fixed = TRUE)
        s <- gsub("<", "&lt;", s, fixed = TRUE)
        s <- gsub(">", "&gt;", s, fixed = TRUE)
        s
    }
    
    pof <- which(names(d) == "Flavor")
    poo <- which(names(d) == "Output")
    ## Outputs from checking "whether package can be installed" will
    ## have a machine-dependent final line
    ##    See ....... for details.
    ind <- d$Check == "whether package can be installed"
    if(any(ind)) {
        d[ind, poo] <-
            sub("\nSee[^\n]*for details[.]$", "", d[ind, poo])
    }
    txt <- apply(d[-pof], 1L, paste, collapse = "\r")
    ## Outputs from checking "installed package size" will vary
    ## according to system.
    ind <- d$Check == "installed package size"
    if(any(ind)) {
        txt[ind] <-
            apply(d[ind, - c(pof, poo)],
                  1L, paste, collapse = "\r")
    }

    ## Regularize fancy quotes.
    ## Could also try using iconv(to = "ASCII//TRANSLIT"))
    txt <- gsub("(\u2018|\u2019)", "'", txt, perl = TRUE)
    txt <- gsub("(\u201c|\u201d)", '"', txt, perl = TRUE)
    lapply(split(seq_len(NROW(d)), match(txt, unique(txt))),
           function(e) {
               tmp <- d[e[1L], ]
               flags <- tmp$Flags
               flavors <- d$Flavor[e]
               c("<p>",
                 htmlify(sprintf("Version: %s\n", tmp$Version)),
                 "<br/>",
                 if(nzchar(flags)) {
                     c(htmlify(sprintf("Flags: %s\n", flags)), "<br/>")
                 },
                 htmlify(sprintf("Check: %s\n", tmp$Check)),
                 "<br/>",
                 htmlify(sprintf("Result: %s\n", tmp$Status)),
                 "<br/>",
                 if(nzchar(tmp$Output)) {
                     c(sprintf("&nbsp;&nbsp;&nbsp;&nbsp;%s",
                               gsub("\n",
                                    "<br/>\n&nbsp;&nbsp;&nbsp;&nbsp;",
                                    htmlify(tmp$Output),
                                    perl = TRUE)),
                       "<br/>")
                 },
                 sprintf("%s: %s",
                         if(length(flavors) == 1L) "Flavor"
                         else "Flavors",
                         paste(sprintf("<a href=\"https://www.r-project.org/nosvn/R.check/%s/%s-00check.html\">%s</a>",
                                       flavors, tmp$Package, flavors),
                               collapse = ", ")),
                 "</p>")
           })
}

memtest_notes_for_package_as_HTML <-
function(m)
{
    if(!length(m)) return(character())
    
    tests <- m[, "Test"]
    paths <- m[, "Path"]
    isdir <- !grepl("-Ex.Rout$", paths)
    if(any(isdir))
        paths[isdir] <- sprintf("%s/", paths[isdir])

    c("<p>",
      "Memtest notes:",
      paste(sprintf("<a href=\"https://www.stats.ox.ac.uk/pub/bdr/memtests/%s/%s\">%s</a>",
                    tests, paths, tests),
            collapse = "\n"),
      "</p>")
}

## FIXME issues
## issues_for_package_as_HTML <-
## function(x)
## {
##     if(!length(x)) return(character())
##    
##     tests <- x[, "Test"]
##     paths <- x[, "Path"]
##     ## isdir <- !grepl("-Ex.Rout$", paths)
##     ## if(any(isdir))
##     ##     paths[isdir] <- sprintf("%s/", paths[isdir])
##
##     c("<p>",
##       "Additional issues:",
##       paste(sprintf("<a href=\"https://www.stats.ox.ac.uk/pub/bdr/%s/%s\">%s</a>",
##                     tests, paths, tests),
##             collapse = "\n"),
##       "</p>")
## }

issues_for_package_as_HTML <-
function(x)
{
    if(!length(x)) return(character())

    c("<h3><a href=\"check_issue_kinds.html\">Additional issues</a></h3>",
      "<p>",
      paste(sprintf("<a href=\"%s\"><span class=\"check_ko\">%s</span></a>", x$href, x$kind),
            collapse = "\n"),
      "</p>")
}
    
write_check_results_for_addresses_as_HTML <-
function(results, dir, details, issues)
{
    verbose <- interactive()
    
    packages <- lapply(split(results$Package,
                             sub("^address:", "", results$Maintainer_id)),
                       function(e) sort(unique(e)))
    results <- split(results, factor(results$Package))
    details <- split(details, factor(details$Package, names(results)))
    addresses <- names(packages)
    for(i in seq_along(packages)) {
        address <- addresses[i]
        out <- file.path(dir, sprintf("check_results_%s.html", address))
        if(verbose) message(sprintf("Writing %s ...", out))
        packages_for_address <- packages[[i]]
        write_check_results_for_address_as_HTML(address,
                                                packages_for_address,
                                                results[packages_for_address],
                                                details[packages_for_address],
                                                issues[packages_for_address],
                                                out)
    }
}
    
write_check_results_for_address_as_HTML <-
function(address, packages, results, details, issues, out = "")
{
    maintainer <- results[[1L]][1L, "Maintainer"]
    
    ## Summaries.
    tab <- do.call(rbind,
                   lapply(results,
                          function(r) {
                              categories <-
                                  c("FAIL", "ERROR", "WARN", "NOTE", "OK")
                              table(factor(r$Status, categories))
                          }))
    tab <- tab[, colSums(tab) > 0, drop = FALSE]
    tab[tab == 0] <- ""
    
    lines <-
        c("<!DOCTYPE html>",
          "<html lang=\"en\">",
          "<head>",
          sprintf("<title>CRAN Package Check Results for Maintainer %s</title>",
                  maintainer),
          "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
          "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
          "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
          "<style type=\"text/css\">",
          "  .r { text-align: right; }",
          "</style>",
          "</head>",
          "<body lang=\"en\">",
          "<div class=\"container\">",
          "",
          sprintf("<h2> CRAN Package Check Results for Maintainer &lsquo;%s&rsquo; </h2>",
                  maintainer),
          "<p>",
          sprintf("Last updated on %s.",
                  format(Sys.time(), usetz = TRUE)),
          "</p>")

    ## <FIXME>
    ## This used to conditionalize on length(package) > 1L.
    ## Scott Chamberlain <myrmecocystus@gmail.com> suggests to always
    ## provide the summary table.
    if(length(packages) > 0L) {
        fmt <- paste("<tr>",
                     "<td> <a href=\"#%s\">%s</a> </td>",
                     paste(rep.int("<td class=\"r\"> %s </td>",
                                   ncol(tab)),
                           collapse = " "),
                     "</tr>")
        lines <-
            c(lines,
              "<table border=\"1\">",
              paste("<tr>",
                    paste("<th>",
                          c("Package", colnames(tab)),
                          "</th>",
                          collapse = " "),
                    "</tr>"),
              do.call(sprintf,
                      c(list(fmt,
                             packages,
                             packages),
                        split(tab, col(tab)))),
              "</table>")
    }
    ## </FIXME>

    for(package in packages) {
        tabp <- tab[package, ]
        tabp <- tabp[tabp != ""]
        lines <-
            c(lines,
              sprintf("<h3 id=\"%s\"> Package <a href=\"check_results_%s.html\">%s</a> </h3>",
                      package,
                      package,
                      package),
              "<p>",
              "Current CRAN status:",
              paste(sprintf("%s: %s", names(tabp), tabp),
                    collapse = ", "),
              "</p>",
              ## FIXME issues
              ## memtest_notes_for_package_as_HTML(mtnotes[[package]]),
              issues_for_package_as_HTML(issues[[package]]),
              if(length(s <-
                        check_details_for_package_as_HTML(details[[package]]))) {
                  c(## "<h4>Check Details</h4>",
                    "",
                    tryCatch(paste(unlist(s), collapse = "\n\n"),
                             error = function(e) NULL),
                    "")
              })
    }
              
    lines <-
        c(lines,
          "</div>",
          "</body>",
          "</html>")

    writeLines(lines, out)
}

write_check_index <-
function(out = "")
{
    writeLines(c(check_summary_html_header(),
                 paste("<p>",
                       "<a href=\"check_summary.html\">",
                       "Package check summary",
                       "</a>",
                       "</p>",
                       sep = ""),
                 paste("<p>",
                       "<a href=\"check_summary_by_package.html\">",
                       "Package check results by package",
                       "</a>",
                       "</p>",
                       sep = ""),
                 paste("<p>",
                       "<a href=\"check_summary_by_maintainer.html\">",
                       "Package check results by maintainer",
                       "</a>",
                       "</p>",
                       sep = ""),
                 paste("<p>",
                       "<a href=\"check_timings.html\">",
                       "Package check timings",
                       "</a>",
                       "</p>",
                       sep = ""),
                 paste("<p>",
                       "<a href=\"check_flavors.html\">",
                       "Package check flavors",
                       "</a>",
                       "</p>",
                       sep = ""),
                 "</div>",
                 "</body>",
                 "</html>"),
               out)
}

write_check_log_as_HTML <-
function(log, out = "", subsections = FALSE)
{
    if(out == "") 
        out <- stdout()
    else if(is.character(out)) {
        out <- file(out, "wt")
        on.exit(close(out))
    }
    if(!inherits(out, "connection")) 
        stop("'out' must be a character string or connection")
    
    lines <- read_check_log(log)[-1L]
    ## The first line says
    ##   using log directory '/var/www/R.check/......"
    ## which is really useless ...

    ## Encoding ...
    ## Get the session charset from the log (added in R 2.7.0).
    pos <- grep("^[*] using session charset:", lines, useBytes = TRUE)
    charset <- if(length(pos))
        sub("^[*] using session charset: *([^ ]*) *$", "\\1",
            lines[pos[1L]], useBytes = TRUE)
    else ""
    ## Re-encode to UTF-8.
    lines <- iconv(lines, from = charset, to = "UTF-8", sub = "byte")
    if(any(bad <- !validEnc(lines)))
        lines[bad] <- iconv(lines[bad], to = "ASCII", sub = "byte")
    
    ## HTML charset:
    codepoints <- c(1L : 8L, 11L, 12L, 14L : 31L, 127L : 159L)
    lines <- gsub(sprintf("[%s]", intToUtf8(codepoints)), " ", lines,
                  perl = TRUE)
    ## HTML escapes:
    lines <- gsub("&", "&amp;", lines, fixed = TRUE)
    lines <- gsub("<", "&lt;", lines, fixed = TRUE)
    lines <- gsub(">", "&gt;", lines, fixed = TRUE)

    ## Make leading spaces preserved somehow.
    m <- regexpr("^[[:space:]]+", lines)
    pos <- (m > -1L)
    if(length(pos)) {
        times <- attr(m, "match.length")[pos]
        lines[pos] <-
            paste0(unlist(lapply(times,
                                 function(e)
                                     paste(rep.int("&nbsp;", e),
                                           collapse = ""))),
                   substring(lines[pos], times + 1L))
    }

    ## Fancy stuff:
    ind <- grep("^\\*\\*? ", lines)
    lines[ind] <- sub("(\\.\\.\\.( \\[.*\\])?) (WARNING|ERROR)$",
                      "\\1 <span class=\"boldred\">\\3</span>",
                      lines[ind])

    ## Convert pointers to install.log:
    ind <- grep("^See ['‘]https://.*['’] for details.$", lines)
    if(length(ind))
        lines[ind] <- sub("^See ['‘](.*)['’] for details.$",
                          "See <a href=\"\\1\">\\1</a> for details.",
                          lines[ind])

    ## Handle footers.
    footer <- character()
    len <- length(lines)

    ## SU seems to add refs and notes about elapsed time.
    if(startsWith(lines[len], "* elapsed time")) {
        len <- len - 1L
        lines <- lines[seq_len(len)]
    }
    if(all(lines[c(len - 2L, len)] == c("See", "for details."))) {
        len <- len - 3L
        lines <- lines[seq_len(len)]
    }

    ## Handle summary footers.
    if(startsWith(lines[len], "Status: ")) {
        ## New-style status summary.
        footer <- sprintf("<p>\n%s\n</p>",
                          lines[len])
        lines <- lines[-len]
    } else {
        ## Old-style status summary.
        num <- length(grep("^(NOTE|WARNING): There",
                           lines[c(len - 1L, len)]))
        if(num > 0L) {
            pos <- seq.int(len - num + 1L, len)
            footer <- sprintf("<p>\n%s\n</p>",
                              paste(lines[pos], collapse = "<br/>\n"))
            lines <- lines[-pos]
        }
    }
    
    ## The check log format is based on the idea that (like Emacs
    ## outlines), heading lines are started with one or two asterisks,
    ## and everything else is body lines.  Clearly, this needs ensuring
    ## that body lines do *not* start with asterisks (e.g. by escaping
    ## these), but as of 2020-06, this is not ensured (still not, after
    ## all these years).  Hence, for now narrow done to the "known"
    ## headings.
    seems_level_one_heading <- function(x) {
        ((x == "* DONE") |
         startsWith(x, "* using") |
         startsWith(x, "* checking") |
         startsWith(x, "* this is package") |
         startsWith(x, "* package encoding:") |
         startsWith(x, "* loading checks for arch"))
    }
    seems_level_two_heading <- function(x) {
        (startsWith(x, "** checking") |
         startsWith(x, "** running"))
    }
    
    if(subsections) {
        ## In the old days, we had bundles.
        ## Now, we have multiarch ...
        ## Sectioning.
        ## Somewhat tricky as we like to append closing </li> to the
        ## lines previous to new section starts, so that we can easily
        ## identify the "uninteresting" OK lines (see below).
        count <- rep.int(0L, length(lines))
        count[seems_level_one_heading(lines)] <- 1L
        count[seems_level_two_heading(lines)] <- 2L
        ## Hmm, using substring() might be faster than grepping.
        ind <- (count > 0L)
        ## Lines with count zero are "continuation" lines, so the ones
        ## before these get a line break.
        pos <- which(!ind) - 1L
        if(length(pos))
            lines[pos] <- paste(lines[pos], "<br/>", sep = "")
        ## Lines with positive count start a new section.
        pos <- which(ind)
        lines[pos] <- sub("^\\*{1,2} ", "<li>", lines[pos])
        ## What happens to the previous line depends on whether a new
        ## subsection is started (bundles), and old same-level section
        ## or subsection is closed, or both a subsection and section are
        ## closed: these cases can be distinguished by looking at the
        ## count differences (values 1, 0, and -1, respectively).
        delta <- c(0, diff(count[pos]))
        pos <- pos - 1L
        if(length(p <- pos[delta > 0]))
            lines[p] <- paste(lines[p], "\n<ul>", sep = "")
        if(length(p <- pos[delta == 0]))
            lines[p] <- paste(lines[p], "</li>", sep = "")
        if(length(p <- pos[delta < 0]))
            lines[p] <- paste(lines[p], "</li>\n</ul></li>", sep = "")
        ## The last line always ends a section, and maybe also a
        ## subsection.
        len <- length(lines)
        lines[len] <- sprintf("%s</li>%s", lines[len],
                              if(count[pos[length(pos)] + 1L] > 1L)
                              "\n</ul></li>" else "")
    } else {
        ind <- seems_level_one_heading(lines)
        if(!any(ind))
            lines <- character()
        ## Lines not starting with '* ' are "continuation" lines, so the
        ## ones before these get a line break.
        pos <- which(!ind) - 1L
        if(length(pos))
            lines[pos] <- paste(lines[pos], "<br/>", sep = "")
        ## Lines starting with '* ' start a new block, and end the old
        ## one unless first.
        pos <- which(ind)
        if(length(pos)) {
            ## Replace star by <li>.
            lines[pos] <- sprintf("<li>%s", substring(lines[pos], 3L))
            ## Append closing </li> to previous line unless first.
            pos <- (pos - 1L)[-1L]
            lines[pos] <- sprintf("%s</li>", lines[pos])
        }
        ## The last line always ends the last block.
        len <- length(lines)
        lines[len] <- paste(lines[len], "</li>", sep = "")
    }

    grayify <- function(lines, subsections = FALSE) {
        ## Turn all non-noteworthy parts into gray.

        ## Handle 'checking extension type ... Package' directly.
        ind <- lines == "<li>checking extension type ... Package</li>"
        if(any(ind))
            lines[ind] <-
                "<li class=\"gray\">checking extension type ... Package</li>"
        ## Same for 'DONE'
        ind <- lines == "<li>DONE</li>"
        if(any(ind))
            lines[ind] <-
                "<li class=\"gray\">DONE</li>"

        foo_simple <- function(lines) {
            chunks <-
                split(lines, cumsum(substring(lines, 1L, 4L) == "<li>"))
            unlist(lapply(chunks, function(s) {
                s <- paste(s, collapse = "\n")
                sub("^<li>( *([^\n]*)\\.\\.\\.( \\[.*\\])? OK(<br/>.*)?)</li>",
                    "<li class=\"gray\">\\1</li>",
                    s)
            }),
                   use.names = FALSE)
        }

        foo_tricky <- function(lines) {
            chunks <-
                split(lines, cumsum(substring(lines, 1L, 3L) == "<li"))
            unlist(lapply(chunks, function(s) {
                s <- paste(s, collapse = "\n")
                s <- sub("^<li class=\"black\">( *([^\n]*)\\.\\.\\.( \\[.*\\])? OK(<br/>.*)?)</li>\n/ul></li>$",
                         "<li class=\"gray\">\\1</li>\n</ul></li>",
                         s)
                sub("^<li class=\"black\">( *([^\n]*)\\.\\.\\.( \\[.*\\])? OK(<br/>.*)?)</li>",
                    "<li class=\"gray\">\\1</li>",
                    s)
            }),
                   use.names = FALSE)
        }
        
        if(!subsections) {
            foo_simple(lines)
        } else {
            ## Determine lines starting and ending subsections.
            ind_ss_s <- grepl("\n<ul>$", lines)
            ind_ss_e <- grepl("</li>\n</ul></li>$", lines)
            ## The former (currently?) give subsection titles only, and
            ## hence always get grayified.  However, apparently this
            ## results in nested <li> to be grayified as well: hence,
            ## tag everthing as black first.
            lines[ind_ss_s] <-
                sub("<li>(.*)(\n<ul>)$",
                    "<li class=\"gray\">\\1\\2",
                    lines[ind_ss_s])
            lines <- sub("^<li>", "<li class=\"black\">", lines)
            ## Split into subsection-related blocks.
            blocks <- split(lines,
                            cumsum(ind_ss_s +
                                   c(0L, head(ind_ss_e, -1L))))
            unlist(lapply(blocks, foo_tricky), use.names = FALSE)
        }
    }

        lines <- grayify(lines, subsections)

    ## Header.
    writeLines(c("<!DOCTYPE html>",
                 "<html>",
                 "<head>",
                 sprintf("<title>Check results for '%s'</title>",
                         sub("-00check.(log|txt)$", "", basename(log))),
                 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
                 "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
                 "<link rel=\"stylesheet\" type=\"text/css\" href=\"../R_check_log.css\"/>",
                 "</head>",
                 "<body>",
                 "<div class=\"container\">"),
               out)
    ## Body.
    if(!length(lines))
        writeLines("<p>\ncheck results unavailable\n</p>", out)
    else
        writeLines(c("<ul>", lines, "</ul>", footer), out)
    ## Footer.
    writeLines(c("</div>",
                 "</body>",
                 "</html>"),
               out)
}

write_install_log_as_HTML <-
function(log, out, encoding = "")
{
    if(out == "") 
        out <- stdout()
    else if(is.character(out)) {
        out <- file(out, "wt")
        on.exit(close(out))
    }
    if(!inherits(out, "connection")) 
        stop("'out' must be a character string or connection")
    
    lines <- readLines(log, warn = FALSE, skipNul = TRUE)

    lines <- iconv(lines, from = encoding, to = "UTF-8", sub = "byte")
    if(any(bad <- !validEnc(lines)))
        lines[bad] <- iconv(lines[bad], to = "ASCII", sub = "byte")
    

    ## HTML charset:
    codepoints <- c(1L : 8L, 11L, 12L, 14L : 31L, 127L : 159L)
    lines <- gsub(sprintf("[%s]", intToUtf8(codepoints)), " ", lines,
                  perl = TRUE)
    ## HTML escapes:
    lines <- gsub("&", "&amp;", lines, fixed = TRUE)
    lines <- gsub("<", "&lt;", lines, fixed = TRUE)
    lines <- gsub(">", "&gt;", lines, fixed = TRUE)

    writeLines(c("<!DOCTYPE html>",
                 "<html>",
                 "<head>",
                 sprintf("<title>Install log for '%s'</title>",
                         sub("-00install.(log|txt)$", "", basename(log))),
                 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
                 "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
                 "</head>",
                 "<body>",
                 "<div class=\"container\">",
                 "<pre>",
                 lines,
                 "</pre>",
                 "</div>",
                 "</body>",
                 "</html>"),
               out)
}

check_results_diff_db <-
function(dir, files = NULL)
{
    if(is.null(files)) {
        ## Assume that both check.csv.prev and check.csv exist in dir.
        files <- file.path(dir, c("check.csv.prev", "check.csv"))
    }
    x <- read.csv(files[1L], colClasses = "character")
    x <- x[names(x) != "Maintainer"]
    y <- read.csv(files[2L], colClasses = "character")
    y <- y[names(y) != "Maintainer"]
    z <- merge(x, y, by = 1, all = TRUE)
    row.names(z) <- z$Package
    z
}

check_results_diffs <-
function(dir, files = NULL)
{
    db <- check_results_diff_db(dir, files)
    db <- db[, c("Version.x", "Status.x", "Version.y", "Status.y")]
    ## Old-style: Show packages with one status missing (removed or
    ## added) as status change only.
    ##   is_na_x <- is.na(db$Status.x)
    ##   is_na_y <- is.na(db$Status.y)
    ##   isc <- (is_na_x | is_na_y | (db$Status.x != db$Status.y))
    ##                                     # Status change.
    ##   ivc <- (!is_na_x & !is_na_y & (db$Version.x != db$Version.y))
    ##                                     # Version change.
    ## New-style:
    isc <- (is.na(db$Status.x) |
            is.na(db$Status.y) |
            (db$Status.x != db$Status.y)) # Status change.
    ivc <- (is.na(db$Version.x) |
            is.na(db$Version.y) |
            (db$Version.x != db$Version.y)) # Version change.
    names(db) <- c("V_Old", "S_Old", "V_New", "S_New")
    db <- cbind("S" = ifelse(isc, "*", ""),
                "V" = ifelse(ivc, "*", ""),
                db)
    db[c(which(isc & !ivc), which(isc & ivc), which(!isc & ivc)),
       c("S", "V", "S_Old", "S_New", "V_Old", "V_New")]
}

write_check_summary_diffs_to_con <-
function(dir, con = stdout())
{
    files <- c("summary.csv.prev", "summary.csv")
    db <- check_results_diffs(files = file.path(dir, files))
    lines <-
        c("Changes in check status (S) and/or version (V)",
          do.call(sprintf,
                  c(list("using R %s.%s (%s-%s-%s r%s):"),
                    R.version[c("major", "minor", "year",
                                "month", "day", "svn rev")])),
          "",
          do.call(paste,
                  c(list(format(c("", rownames(db)),
                                justify = "left")),
                    lapply(Map(c,
                               names(db),
                               lapply(db,
                                      function(e) {
                                          e <- as.character(e)
                                          e[is.na(e)] <- "<NA>"
                                          e
                                      })),
                           format,
                           justify = "right"))))
    writeLines(lines, con)
}

filter_results_by_status <-
function(results, status)
{
    status <- match.arg(status,
                        c("FAILURE", "ERROR", "WARNING", "NOTE", "OK"))
    ind <- logical(NROW(results))
    flavors <- intersect(names(results), row.names(check_flavors_db))
    for(flavor in grep("linux", flavors, value = TRUE))
        ind <- ind | grepl(status, results[[flavor]])
    results[ind, ]
}

find_diffs_in_results <-
function(results, pos = c("r-devel-linux-ix86", "r-patched-linux-ix86"))
{
    ## Compare linux ix86 between versions.
    if(is.numeric(pos))
        pos <- names(results)[pos]
    results <- results[, c("Package", "Version", pos)]
    results[results[[3L]] != results[[4L]], ]
}

## <FIXME 4.3.0>
## tools:::analyze_check_log() was updated for 4.3.0 to handle encodings
## correctly ...
## Change to use tools:::analyze_check_log() once 4.3,0 is out.
analyze_check_log <-
function(log, drop_ok = TRUE)
{
    make_results <- function(package, version, flags, chunks)
        list(Package = package, Version = version,
             Flags = flags, Chunks = chunks)

    ## Alternatives for left and right quotes.
    lqa <- "'|\u2018"
    rqa <- "'|\u2019"
    ## Group when used ...

    drop_ok_status_tags <- c("OK", "NONE", "SKIPPED")

    ## Start by reading in.
    lines <- read_check_log(log)

    ## Re-encode to UTF-8 using the session charset info.
    re <- "^\\* using session charset: "
    pos <- grep(re, lines, perl = TRUE, useBytes = TRUE)
    if(length(pos)) {
        enc <- sub(re, "", lines[pos[1L]], useBytes = TRUE)
        lines <- iconv(lines, enc, "UTF-8", sub = "byte")
        ## If the check log uses ASCII, there should be no non-ASCII
        ## characters in the message lines: could check for this.
        if(any(bad <- !validUTF8(lines)))
            lines[bad] <- iconv(lines[bad], to = "ASCII", sub = "byte")
    } else return()

    ## Get header.
    re <- sprintf("^\\* this is package (%s)(.*)(%s) version (%s)(.*)(%s)$",
                  lqa, rqa, lqa, rqa)
    pos <- grep(re, lines, perl = TRUE)
    if(length(pos)) {
        pos <- pos[1L]
        txt <- lines[pos]
        package <- sub(re, "\\2", txt, perl = TRUE)
        version <- sub(re, "\\5", txt, perl = TRUE)
        header <- lines[seq_len(pos - 1L)]
        lines <- lines[-seq_len(pos)]
        ## Get check options from header.
        re <- sprintf("^\\* using options? (%s)(.*)(%s)$", lqa, rqa)
        flags <- if(length(pos <- grep(re, header, perl = TRUE))) {
                     sub(re, "\\2", header[pos[1L]], perl = TRUE)
                 } else ""
    } else return()

    ## Get footer.
    len <- length(lines)
    pos <- which(lines == "* DONE")
    if(length(pos) &&
       ((pos <- pos[length(pos)]) < len) &&
       startsWith(lines[pos + 1L], "Status: "))
        lines <- lines[seq_len(pos - 1L)]
    else {
        ## Not really new style, or failure ... argh.
        ## Some check systems explicitly record the elapsed time in the
        ## last line:
        if(startsWith(lines[len], "* elapsed time ")) {
            lines <- lines[-len]
            len <- len - 1L
            while(grepl("^[[:space:]]*$", lines[len])) {
                lines <- lines[-len]
                len <- len - 1L
            }
        }
        ## Summary footers.
        if(startsWith(lines[len], "Status: ")) {
            ## New-style status summary.
            lines <- lines[-len]
            len <- len - 1L
        } else {
            ## Old-style status summary.
            num <- length(grep("^(NOTE|WARNING): There",
                               lines[c(len - 1L, len)]))
            if(num > 0L) {
                pos <- seq.int(len - num + 1L, len)
                lines <- lines[-pos]
                len <- len - num
            }
        }
        if(lines[len] == "* DONE")
            lines <- lines[-len]
    }
    
    analyze_lines <- function(lines) {
        ## Windows has
        ##   * loading checks for arch
        ##   * checking examples ...
        ##   * checking tests ...
        ## headers: drop these unless not followed by the appropriate
        ## 'subsection', which indicates failure.
        pos <- which(startsWith(lines, "* loading checks for arch"))
        pos <- pos[pos < length(lines)]
        pos <- pos[startsWith(lines[pos + 1L], "** checking")]
        if(length(pos))
            lines <- lines[-pos]
        pos <- which(startsWith(lines, "* checking examples"))
        pos <- pos[pos < length(lines)]
        pos <- pos[startsWith(lines[pos + 1L],
                              "** running examples for arch")]
        if(length(pos))
            lines <- lines[-pos]
        pos <- which(startsWith(lines, "* checking tests"))
        pos <- pos[pos < length(lines)]
        pos <- pos[startsWith(lines[pos + 1L],
                              "** running tests for arch")]
        if(length(pos))
            lines <- lines[-pos]
        ## We might still have
        ##   * package encoding:
        ## entries for packages declaring a package encoding.
        ## Hopefully all other log entries we still have are
        ##   * checking
        ##   * creating
        ## ones ... apparently, with the exception of
        ##   ** running examples for arch
        ##   ** running tests for arch
        ## So let's drop everything up to the first such entry.
        re <- "^\\*\\*? ((checking|creating|running examples for arch|running tests for arch) .*) \\.\\.\\.( (\\[[^ ]*\\]))?( (.*)|)$"
        ind <- grepl(re, lines, perl = TRUE)
        csi <- cumsum(ind)
        ind <- (csi > 0)
        chunks <- 
            lapply(split(lines[ind], csi[ind]),
                   function(s) {
                       ## Note that setting
                       ##   _R_CHECK_TEST_TIMING_=yes
                       ##   _R_CHECK_VIGNETTE_TIMING_=yes
                       ## will result in a different chunk format ...
                       line <- s[1L]
                       check <- sub(re, "\\1", line, perl = TRUE)
                       status <- sub(re, "\\6", line, perl = TRUE)
                       if(status == "") status <- "FAILURE"
                       list(check = check,
                            status = status,
                            output = paste(s[-1L], collapse = "\n"))
                   })

        status <- vapply(chunks, `[[`, "", "status")
        if(identical(drop_ok, TRUE) ||
           (is.na(drop_ok)
               && all(is.na(match(c("ERROR", "FAILURE"), status)))))
            chunks <- chunks[is.na(match(status, drop_ok_status_tags))]
        
        chunks
    }

    chunks <- analyze_lines(lines)
    if(!length(chunks) && !identical(drop_ok, FALSE)) {
        chunks <- list(list(check = "*", status = "OK", output = ""))
    }

    make_results(package, version, flags, chunks)
}

read_check_log <-
function(log, drop = TRUE)
{
    lines <- readLines(log, warn = FALSE)

    if(drop) {
        ## Drop CRAN check status footer.
        ## Ideally, we would have a more general mechanism to detect
        ## footer information to be skipped (e.g., a line consisting of
        ## a single non-printing control character?)
        pos <- grep("^Current CRAN status:", lines,
                    perl = TRUE, useBytes = TRUE)
        if(length(pos) && lines[pos <- (pos[1L] - 1L)] == "") {
            lines <- lines[seq_len(pos - 1L)]
        }
    }

    ## ## <FIXME>
    ## ## Remove eventually.
    ## len <- length(lines)
    ## end <- lines[len]
    ## if(length(end) &&
    ##    grepl(re <- "^(\\*.*\\.\\.\\.)(\\* elapsed time.*)$", end,
    ##          perl = TRUE, useBytes = TRUE)) {
    ##     lines <- c(lines[seq_len(len - 1L)],
    ##                sub(re, "\\1", end, perl = TRUE, useBytes = TRUE),
    ##                sub(re, "\\2", end, perl = TRUE, useBytes = TRUE))
    ## }
    ## ## </FIXME
    
    lines
}
## </FIXME>

check_details_db <-
function(dir = "/data/rsync/R.check", flavors = NA_character_,
         drop_ok = TRUE)
{
    ## Build a data frame with columns
    ##   Package Version Flavor Check Status Output Flags
    ## and some optimizations.

    db_from_logs <- function(logs, flavor) {
        out <- lapply(logs, analyze_check_log, drop_ok)
        out <- out[sapply(out, length) > 0L]
        if(!length(out)) return(NULL)
        chunks <- lapply(out, `[[`, "Chunks")
        package <- sapply(out, `[[`, "Package")
        lens <- sapply(chunks, length)
        cbind(rep.int(package, lens),
              rep.int(sapply(out, `[[`, "Version"), lens),
              flavor,
              matrix(unlist(chunks), ncol = 3L,
                     byrow = TRUE),
              rep.int(sapply(out, `[[`, "Flags"),
                      lens))
    }

    if(identical(flavors, NA_character_)) {
        logs <- Sys.glob(file.path(dir, "*.Rcheck", "00check.log"))
        db <- db_from_logs(logs, NA_character_)
    } else {
        db <- NULL
        if(is.null(flavors))
            flavors <- row.names(check_flavors_db)
        flavors <- flavors[file.exists(file.path(dir, flavors))]
        for(flavor in flavors) {
            if(interactive())
                message(sprintf("Getting check details for flavor %s",
                                flavor))
            logs <- Sys.glob(file.path(dir, flavor, "PKGS", "*",
                                       "00check.log"))
            logs <- logs[!is.na(size <- file.size(logs)) &
                         (size <= 10000000)]
            db <- rbind(db, db_from_logs(logs, flavor))
        }
    }
    if(is.null(db)) return(db)
    colnames(db) <- c("Package", "Version", "Flavor", "Check", "Status",
                      "Output", "Flags")
    ## Now some cleanups.
    checks <- db[, "Check"]
    checks <- sub("checking whether package ['‘].*['’] can be installed",
                  "checking whether package can be installed", checks)
    checks <- sub("creating .*-Ex.R",
                  "checking examples creation", checks)
    checks <- sub("creating .*-manual\\.tex",
                  "checking manual creation", checks)
    checks <- sub("checking .*-manual\\.tex", "checking manual", checks)
    checks <- sub("checking package vignettes in ['‘]inst/doc['’]",
                  "checking package vignettes", checks)
    ## The "checking ..." messages are generated using checkingLog(),
    ## which in turn uses printLog() which does
    ##   quotes <- function(x) gsub("'([^']*)'", sQuote("\\1"), x)
    ##   args <- lapply(list(...), quotes)
    ## Let's canonicalize (to UTF-8) using the same:
    checks <-  gsub("'([^']*)'", sQuote("\\1"), checks)
    checks <- sub("^checking *", "", checks)
    db[, "Check"] <- checks
    ## In fact, for tabulation purposes it would even be more convenient
    ## to shorten the check names ...
    db[, "Output"] <- sub("[[:space:]]+$", "", db[, "Output"])

    ## <FIXME>
    ## Short term fix to ensure more consistency in the summaries,
    ## remove eventually.
    db[, "Flags"] <-
        trimws(sub(" *--no-stop-on-test-error", "", db[, "Flags"]))
    ## </FIXME>
    
    db <- as.data.frame(db, stringsAsFactors = FALSE)
    class(db) <- c("CRAN_check_details", "check_details", "data.frame")
    
    db
}

## <FIXME 3.3.0>
## Package 'tools' now has a format() method for 'check_details':
## Use this accordingly.
format_check_details_db <-
function(db)
{
    flags <- db$Flags
    flavor <- db$Flavor
    if(is.null(flavor))
        flavor <- NA_character_
    paste(sprintf("Package: %s Version: %s%s\n",
                  db$Package, db$Version,
                  ifelse(is.na(flavor), "",
                         sprintf(" Flavor: %s", flavor))),
          ifelse(nzchar(flags),
                 sprintf("Flags: %s\n", flags),
                 ""),
          sprintf("Check: %s ... %s\n", db$Check, db$Status),
          sprintf("  %s", gsub("\n", "\n  ", db$Output)),
          sep = "")
}
## </FIXME>

inspect_check_details_db <-
function(db, con = stdout()) {
    writeLines(paste(format_check_details_db(db), collapse = "\n\n"),
               con)
}

write_check_details_db_as_HTML <-
function(details, dir)
{
    for(flavor in unique(details$Flavor)) {
        out <- file.path(dir, sprintf("check_details_%s.html", flavor))
        write_check_details_for_flavor_as_HTML(details, flavor, out)
    }
}

write_check_details_for_flavor_as_HTML <-
function(details, flavor, con = stdout())
{
    tab <- table(details[details$Flavor == flavor,
                         c("Check", "Status")])
    ## Drop empty rows.
    tab <- tab[rowSums(tab) > 0, , drop = FALSE]
    ## And add totals.
    tab <- rbind(tab, Total = colSums(tab))

    writeLines(c("<!DOCTYPE html>",
                 "<html>",
                 "<head>",
                 "<title>CRAN Package Check Details</title>",
                 "<link rel=\"stylesheet\" type=\"text/css\" href=\"../CRAN_web.css\"/>",
                 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>",
                 "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"/>",
                 "<style type=\"text/css\">",
                 "  .r { text-align: right; }",
                 "</style>",
                 "</head>",
                 "<body lang=\"en\">",
                 "<div class=\"container\">",
                 sprintf("<h2>CRAN Package Check Problem Summary for %s</h2>",
                         flavor),
                 "<p>",
                 sprintf("Last updated on %s.",
                         format(Sys.time(), usetz = TRUE)),
                 "</p>",
                 "<p>",
                 sprintf("Check problems summary by check and status for %s on a system running %s (CPU: %s).",
                         check_flavors_db[flavor, "Flavor"],
                         check_flavors_db[flavor, "OS_kind"],
                         check_flavors_db[flavor, "CPU_info"]),
                 "</p>",                 
                 check_details_html_summary(tab),
                 "</div>",
                 "</body>",
                 "</html>"),
               con)
}

check_details_html_summary <-
function(tab)
{
    tab <- tab[ ,
               match(c("FAIL", "ERROR", "WARN", "NOTE"),
                     colnames(tab),
                     nomatch = 0L),
               drop = FALSE]
    tab <- tab[ , colSums(tab) > 0, drop = FALSE]
    fmt <- paste("<tr>",
                 "<td> %s </td>",
                 paste(rep.int("<td class=\"r\"> %s </td>",
                               ncol(tab)),
                       collapse = " "),
                 "</tr>")
    c("<table border=\"1\">",
      paste("<tr>",
            paste("<th>",
                  c("Check", colnames(tab)),
                  "</th>",
                  collapse = " "),
            "</tr>"),
      do.call(sprintf,
              c(list(fmt,
                     rownames(tab)),
                split(tab, col(tab)))),
      "</table>"
      )
}

check_details_diff_db <-
function(dir, files = NULL)
{
    if(is.null(files)) {
        files <- file.path(dir, c("details.csv.prev", "details.csv"))
    }
    x <- read.csv(files[1L], colClasses = "character")
    y <- read.csv(files[2L], colClasses = "character")
    z <- merge(x, y, by = c("Package", "Check"), all = TRUE)
    names(z) <-
        c("Package", "Check", "V_old", "S_old", "V_new", "S_new")
    row.names(z) <- NULL
    z
}

check_details_diffs <-
function(dir, files = NULL)
{
    db <- check_details_diff_db(dir, files)

    ## Split into package chunks, and process.
    chunks <- 
        lapply(split(db, db$Package),
               function(e) {
                   len <- nrow(e)
                   ## Complete missing entries.
                   ## If one check failed, we have the status of all
                   ## other checks that were run as well.
                   if(length(pos <- which(!is.na(e$V_old))))
                       e$V_old <- rep.int(e[pos[1L], "V_old"], len)
                   if(any(ind <- !is.na(e$S_old)) &&
                      (all(is.na(match(c("ERROR", "FAILURE"),
                                       e$S_old[ind])))))
                       e$S_old[!ind] <- "OK"
                   if(length(pos <- which(!is.na(e$V_new))))
                       e$V_new <- rep.int(e[pos[1L], "V_new"], len)
                   if(any(ind <- !is.na(e$S_new)) &&
                      (all(is.na(match(c("ERROR", "FAILURE"),
                                       e$S_new[ind])))))
                       e$S_new[!ind] <- "OK"
                   e
               })

    ## Put back together, and drop all stubs, details for packages only
    ## checked in old, and entries with no change.
    ## For packages only checked in new, keep all non-OK details.
    db <- do.call(rbind, chunks)
    db[((db$Check != "*") &
        !is.na(db$S_new) &
        ((is.na(db$S_old) & (db$S_new != "OK")) |
         (!is.na(db$S_old) & (db$S_old != db$S_new)))), ]
}

write_check_details_diffs_to_con <-
function(dir, con = stdout(), flavor = NULL)
{
    db <- check_details_diffs(dir)
    db$S_old[is.na(db$S_old)] <- "<NA>"
    chunks <- 
        split(sprintf("  %-s: %s => %s", db$Check, db$S_old, db$S_new),
              sprintf("Package %s%s:",
                      db$Package,
                      ifelse(!is.na(db$V_old) & (db$V_old != db$V_new),
                             sprintf(" [V_old: %s, V_new: %s]",
                                     db$V_old, db$V_new),
                             "")))
    writeLines(paste(sapply(Map(c,
                                names(chunks),
                                chunks,
                                if(!is.null(flavor)) {
                                    sprintf("See <https://www.R-project.org/nosvn/R.check/%s/%s-00check.html>",
                                            flavor,
                                            sub("^Package ([^ :]+).*", "\\1",
                                                names(chunks)))
                                } else rep.int(list(NULL), length(chunks))
                                ),
                            paste,
                            collapse = "\n"),
                     collapse = "\n\n"),
               con)
}

write_check_details_for_new_problems_to_con <-
function(dir, con = stdout())
{
    db <- check_details_diff_db(dir)
    ## Want the checks giving *new* problems:
    ind <- (!is.na(sn <- db$S_new)
            & (sn != "OK")
            & (is.na(so <- db$S_old) | (sn != so)))
    
    details <- readRDS(file.path(dir, "details.rds"))
    ## Now match new problems and the check details db.
    pos <- match(paste(db$Package[ind], db$Check[ind], sep = "\r"),
                 paste(details$Package, details$Check, sep = "\r"),
                 nomatch = 0L)
    ## And write out the details.
    writeLines(paste(format_check_details_db(details[pos, ]),
                     collapse = "\n\n"),
               con = con)
}

get_run_time_test_timings_from_log_file <-
function(con)
{
    lines <- readLines(con, warn = FALSE)
    timings <- integer()
    for(check in
        c("examples",
          "running R code from vignettes",
          "re-building of vignette PDFs")) {
        re <- sprintf("^\\* checking %s \\.\\.\\. \\[(.*)\\].*", check)
        timings <-
            c(timings,
              if(length(ind <- grep(re, lines))) {
                  as.integer(sub("s$", "",
                                 unlist(strsplit(sub(re, "\\1", lines[ind]),
                                                 "/", fixed = TRUE))))
              } else {
                  rep.int(NA, 2L)
              })
    }
    timings
}

check_run_time_test_timings_db <-
function(dir = "/data/rsync/R.check",
         flavors = "r-devel-linux-x86_64-debian-gcc")
{
    db <- NULL
    if(is.null(flavors))
        flavors <- row.names(check_flavors_db)
    flavors <- flavors[file.exists(file.path(dir, flavors))]
    
    for(flavor in flavors) {
        if(interactive())
            message(sprintf("Getting run time tests timings for flavor %s",
                            flavor))
        logs <- Sys.glob(file.path(dir, flavor, "PKGS", "*",
                                   "00check.log"))
        out <- lapply(logs, get_run_time_test_timings_from_log_file)
        db <- rbind(db,
                    data.frame(flavor,
                               sub("\\.Rcheck$", "",
                                   basename(dirname(logs))),
                               do.call(rbind, out),
                               stringsAsFactors = FALSE))
    }

    colnames(db) <- c("Flavor", "Package",
                      "Ex_T", "Ex_E", "VR_T", "VR_E", "VB_T", "VB_E")
    db
}

cache_check_results <-
function(dir, flavor)
{
    cpath <- file.path(dir, ".cache", flavor)
    if(!file_test("-d", cpath))
        dir.create(cpath, recursive = TRUE)
    
    ## Get mtimes of check log files.
    files <-
        Sys.glob(file.path(dir, flavor, "PKGS", "*", "00check.log"))
    times <- if(length(files))  {
        file.mtime(files)
    } else {
        ISOdatetime(1970, 1, 1, 0, 0, 0)
    }
    t_max <- max(times)
    rds <- file.path(cpath, "t_all.rds")
    saveRDS(times, rds)
    Sys.setFileTime(rds, t_max)
    rds <- file.path(cpath, "t_max.rds")
    saveRDS(t_max, rds)
    Sys.setFileTime(rds, t_max)

    ## If necessary, update check results db.
    if(!file_test("-f", rds <- file.path(cpath, "results.rds")) ||
       t_max > file.mtime(rds)) {
        saveRDS(check_results_db(dir, flavor), rds)
    }

    ## If necessary, update check details db.
    if(!file_test("-f", rds <- file.path(cpath, "details.rds")) ||
       t_max > file.mtime(rds)) {
        saveRDS(check_details_db(dir, flavor), rds)
    }
}

## FIXME issues
## update_memtest_notes <-
## function(dir)
## {
##     cpath <- file.path(dir, ".cache", "bdr-memtests")
##     if(!file_test("-d", cpath))
##         dir.create(cpath, recursive = TRUE)
##
##     paths <- Sys.glob(file.path(dir, "bdr-memtests", "*", "*"))
##     tests <- Sys.glob(file.path(dir, "bdr-memtests", "*"))
##     times <- c(file.info(paths)$mtime, file.info(tests)$mtime)
##     t_max <- max(times)
##     rds <- file.path(cpath, "t_max.rds")
##     saveRDS(t_max, rds)
##     Sys.setFileTime(rds, t_max)
##
##     if(!file_test("-f", rds <- file.path(cpath, "notes.rds")) ||
##        t_max > file.info(rds)$mtime) {
##         tests <- basename(dirname(paths))
##         paths <- basename(paths)
##         notes <- split.data.frame(cbind(Test = tests, Path = paths),
##                                   sub("-Ex\\.Rout$", "", paths))
##         saveRDS(notes, rds)
##     }
## }

## FIXME issues
## update_issues_db <-
## function(dir)
## {
##     cpath <- file.path(dir, ".cache", "issues")
##     if(!file_test("-d", cpath))
##         dir.create(cpath, recursive = TRUE)
##
##     paths <- Sys.glob(file.path(dir, "issues", "*", "*"))
##     tests <- Sys.glob(file.path(dir, "issues", "*"))
##     times <- c(file.info(paths)$mtime, file.info(tests)$mtime)
##     t_max <- max(times)
##     rds <- file.path(cpath, "t_max.rds")
##     saveRDS(t_max, rds)
##     Sys.setFileTime(rds, t_max)
##
##     if(!file_test("-f", rds <- file.path(cpath, "issues.rds")) ||
##        t_max > file.info(rds)$mtime) {
##         tests <- basename(dirname(paths))
##         paths <- basename(paths)
##         ## <FIXME>
##         ## This is really specific to noLD ...
##         ## </FIXME>
##         ind <- endsWith(paths, ".out")
##         issues <-
##             split.data.frame(cbind(Test = tests[ind],
##                                    Path = paths[ind]),
##                              sub("\\.out$", "", paths[ind]))
##         saveRDS(issues, rds)
##     }
## }

update_check_issues_db <-
function(dir)
{
    cpath <- file.path(dir, ".cache", "issues")
    if(!file_test("-d", cpath))
        dir.create(cpath, recursive = TRUE)

    files <- Sys.glob(file.path(dir, "issues", "*.csv"))
    times <- file.mtime(files)
    t_max <- max(times)
    rds <- file.path(cpath, "t_max.rds")
    saveRDS(t_max, rds)
    Sys.setFileTime(rds, t_max)

    if(!file_test("-f", rds <- file.path(cpath, "issues.rds")) ||
       t_max > file.mtime(rds)) {
        issues <- do.call(rbind, lapply(files, read_issues_csv))
        saveRDS(issues, rds, version = 2)
    }
}

read_issues_csv <-
function(file)
{
    x <- tryCatch(read.csv(file, colClasses = "character"),
                  error = identity)
    if(inherits(x, "error")) {
        ## E.g., when one of the .csv is empty, as happened on
        ## 2018-08-12 ...
        return()
    }
    if(any(is.na(match(c("Package", "kind", "href"), colnames(x)))))
        return()
    if(all(colnames(x) != "Version"))
        x <- cbind(x, Version = rep.int(NA_character_, nrow(x)))
    x[, c("Package", "Version", "kind", "href")]
}
         
.check_R_summary <-
function(cdir, wdir, tdir)
{
    flavors <- row.names(check_flavors_db)

    ## FIXME issues
    ## This is now incorporated into the new encompassing 'issues'
    ## mechanism, so in principle could be changed to
    ##   notes <- NULL
    ## and eventually stop using this in the local code, and creating
    ## 'memtest_notes.rds' [used by tools::CRAN_memtest_notes()].
    ## Of course, we need a suitable replacement for the this: perhaps
    ##   tools::CRAN_check_issues()
    ## ???
    ## ## Update memtest notes db.
    ## update_memtest_notes(cdir)
    ## notes <- file.path(cdir, ".cache", "bdr-memtests", "notes.rds")

    ## Update issues db.
    update_check_issues_db(cdir)

    ## Update the cache.
    parallel::mcmapply(cache_check_results, cdir, flavors, mc.cores = 6L)

    ## Get the time stamps for each check flavor and the issues.
    files <- file.path(cdir, ".cache", c(flavors, "issues"), "t_max.rds")
    timestamps <- do.call(c, lapply(files, readRDS))

    ## If there are no check results to update, update the non-cached
    ## materials (flavors db, ...) material directly in tdir.

    mtime <- file.mtime(file.path(tdir, "index.html"))
    if(!is.na(mtime) && (max(timestamps) <= mtime)) {
        saveRDS(check_flavors_db,
                file = file.path(tdir, "check_flavors.rds"),
                version = 2)
        out <- file.path(tdir, "check_flavors.html")
        write_check_flavors_db_as_HTML(out = out)
        out <- file.path(tdir, "check_issue_kinds.html")
        write_check_issue_kinds_db_as_HTML(out = out)
        ## FIXME issues
        ## file.copy(notes, file.path(tdir, "memtest_notes.rds"),
        ##           overwrite = TRUE)
        ## file.copy(issues, file.path(tdir, "issues.rds"),
        ##           overwrite = TRUE)
        unlink(wdir, recursive = TRUE)
    } else {
        saveRDS(check_flavors_db,
                file = file.path(wdir, "check_flavors.rds"),
                version = 2)
        out <- file.path(wdir, "check_flavors.html")
        write_check_flavors_db_as_HTML(out = out)
        out <- file.path(wdir, "check_issue_kinds.html")
        write_check_issue_kinds_db_as_HTML(out = out)
        ## FIXME issues
        ## file.copy(notes, file.path(wdir, "memtest_notes.rds"),
        ##           overwrite = TRUE)
        saveRDS(list(), file.path(wdir, "memtest_notes.rds"),
                version = 2)
        ## The caches for results details issues could include archived
        ## packages: try filtering these out if possible.
        current <- NULL
        if(file.exists(pfile <- file.path(dirname(tdir),
                                          "packages", "packages.rds"))) {
            ## Note that tools::CRAN_package_db() calls as.data.frame()
            ## too.
            current <- as.data.frame(readRDS(pfile),
                                     stringsAsFactors = FALSE)
        }
        issues <-
            readRDS(file.path(cdir, ".cache", "issues", "issues.rds"))
        if(!is.null(current))
            issues <- issues[!is.na(match(issues$Package,
                                          current$Package)), ]
        saveRDS(issues,
                file.path(wdir, "check_issues.rds"),
                version = 2)
        results <-
            lapply(file.path(cdir, ".cache", flavors, "results.rds"),
                   read_RDS_or_unlink)
        results <- do.call(rbind, results)
        if(!is.null(current)) {
            pos <- match(results$Package, current$Package, 0L)
            ## Always use current maintainer and current packages only.
            results$Maintainer[pos > 0L] <-
                enc2utf8(current$Maintainer[pos])
            results <- results[pos > 0L, ]
        }
        results$Status <-
            ordered(results$Status,
                    c("OK", "NOTE", "WARNING", "ERROR", "FAILURE"))
        saveRDS(results,
                file = file.path(wdir, "check_results.rds"),
                version = 2)
        details <-
            lapply(file.path(cdir, ".cache", flavors, "details.rds"),
                   read_RDS_or_unlink)
        details <- do.call(rbind, details)
        if(!is.null(current)) {
            pos <- match(details$Package, current$Package, 0L)
            ## Always use current maintainer and current packages only.
            details$Maintainer[pos > 0L] <-
                enc2utf8(current$Maintainer[pos])
            details <- details[pos > 0L, ]
        }
        details$Status <-
            ordered(details$Status,
                    c("OK", "NOTE", "WARNING", "ERROR", "FAILURE"))
        saveRDS(details,
                file = file.path(wdir, "check_details.rds"),
                version = 2)
        details <- details[details$Check != "*", ]

        ## For the web pages, prefer WARN/FAIL to save space ...
        results$Status <- sub("WARNING", "WARN",
                              sub("FAILURE", "FAIL", results$Status))
        details$Status <- sub("WARNING", "WARN",
                              sub("FAILURE", "FAIL", details$Status))
        write_check_results_db_as_HTML(results, wdir, details, issues)
        write_check_details_db_as_HTML(details, wdir)
    }
}

## Sometimes caching results or details gives files for which readRDS()
## fails: in this case, return NULL from reading and unlink so that the
## cache file will be regenerated in the next round.
read_RDS_or_unlink <-
function(f)
{
    x <- tryCatch(readRDS(f), error = identity)
    if(inherits(x, "error")) {
        x <- NULL
        unlink(f)
    }
    x
}

available_check_results <-
function(package)
{
    db <- tools:::CRAN_check_results()
    db[db$Package == package, ]
}

available_check_details <-
function(package)
{
    db <- tools:::CRAN_check_details()
    db[db$Package == package, ]
}

inspect_check_results_db <-
function(db)
{
    db <- db[c("Flavor", "Version", "Status", "T_total")]
    rownames(db) <- NULL
    format(db, justify = "left")
}
