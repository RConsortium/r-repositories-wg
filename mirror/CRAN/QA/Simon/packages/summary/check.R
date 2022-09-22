require("tools", quiet = TRUE)

check_log_URL <- "http://www.R-project.org/nosvn/R.check/"

r_patched_is_prelease <- FALSE
r_p_o_p <- if(r_patched_is_prelease) "r-prerelease" else "r-patched"

## Adjust as needed, in particular for prerelease stages.
R_flavors_db <- local({
## modified BEGIN
    db <- c("Flavor|OS_type|CPU_type|OS_kind|CPU_info",
            paste("R-2.5-macosx",
                  "R 2.5 branch", "Mac OS X", "universal",
                  "Mac OS X 10.4.10",
                  "Mac Pro",
                  sep = "|"),
            paste("R-2.6-macosx",
                  "R 2.6 branch", "Mac OS X", "universal",
                  "Mac OS X 10.4.10",
                  "Mac Pro",
                  sep = "|")            
            )
## modified END
    con <- textConnection(db)
    db <- read.table(con, header = TRUE, sep = "|")
    close(con)
    db
})

check_summarize_flavor <-
function(dir = file.path("~", "tmp", "R.check"), flavor = "r-devel",
         check_dirs_root = file.path(dir, flavor, "PKGS"))
{
    if(!file_test("-d", check_dirs_root)) return()

    get_description_fields_as_utf8 <-
        function(dfile, fields = c("Version", "Priority", "Maintainer"))
    {
        lc_ctype <- Sys.getlocale("LC_CTYPE")
        Sys.setlocale("LC_CTYPE", "en_US.utf8")
        on.exit(Sys.setlocale("LC_CTYPE", lc_ctype))

        meta <- if(file.exists(dfile))
            try(read.dcf(dfile,
                         fields = unique(c(fields, "Encoding")))[1, ],
                silent = TRUE)
        else
            NULL
        ## What if this fails?  Grr ...
        if(inherits(meta, "try-error") || is.null(meta))
            return(rep.int("", length(fields)))
        else if(any(i <- !is.na(meta) & is.na(nchar(meta, "c")))) {
            ## Try converting to UTF-8.
            from <- meta["Encoding"]
            if(is.na(from)) from <- "latin1"
            meta[i] <- iconv(meta[i], from, "utf8")
        }
        meta[fields]
    }
    
    check_dirs <- list.files(path = check_dirs_root,
                             pattern = "\\.Rcheck", full = TRUE)
    results <- matrix(character(), nr = 0, nc = 5)
    fields <- c("Version", "Priority", "Maintainer")
    ## (Want Package, Version, Priority, Maintainer, Status.)
    for(check_dir in check_dirs) {
        dfile <- file.path(check_dir, "00package.dcf")
        ## <FIXME>
        ## Remove eventually ...
        if(!file.exists(dfile))
            dfile <- file.path(file_path_sans_ext(check_dir),
                               "DESCRIPTION")
        ## </FIXME>
        meta <- get_description_fields_as_utf8(dfile)
        logfile <- file.path(check_dir, "00check.log")
        if(!file.exists(logfile))
            next
        log <- readLines(logfile)
        status <- if(any(grep("ERROR$", log)))
            "ERROR"
        else if(any(grep("WARNING$", log)))
            "WARN"
        else
            "OK"
        comment <- if(any(grep("^\\*+ checking examples ", log))
                      || (status == "ERROR"))
            ""
        else if(any(grep("^\\*+ checking.*can be installed ", log)))
            " [*]"
        else
            " [**]"
        status <- paste(status, comment, sep = "")
        results <- rbind(results,
                         cbind(file_path_sans_ext(basename(check_dir)),
                               rbind(meta, deparse.level = 0),
                               status))
    }
    colnames(results) <- c("Package", fields, "Status")
    idx <- grep("^(WARN|ERROR)", results[, "Status"])
    if(any(idx))
        results[idx, "Status"] <-
            paste("<A href=\"", check_log_URL, flavor, "/",
                  results[idx, "Package"], "-00check.html\">",
                  results[idx, "Status"], "</A>",
                  sep = "")

    ## .saveRDS(results, file.path(dir, flavor, "summary.rds"))
    results
}
             
check_summary <-
function(dir = file.path("~", "tmp", "R.check"), R_flavors = NULL)
{
    if(is.null(R_flavors)) {
        R_flavors <- row.names(R_flavors_db)
    }
    R_flavors <- R_flavors[file.exists(file.path(dir, R_flavors))]

    results <- vector("list", length(R_flavors))
    names(results) <- R_flavors
    for(flavor in R_flavors) {
        results[[flavor]] <- check_summarize_flavor(dir, flavor)
        ind <- which(colnames(results[[flavor]]) == "Status")
        if(length(ind))
            colnames(results[[flavor]])[ind] <- flavor
    }

    ## Now merge results.
    idx <- which(sapply(results, NROW) > 0)
    if(!any(idx)) return()
    summary <- as.data.frame(results[[idx[1]]],
                             stringsAsFactors = FALSE)
    for(i in seq(along = R_flavors)[-idx[1]]) {
        new <- as.data.frame(results[[i]], stringsAsFactors = FALSE)
	if(NROW(new))
            summary <- merge(summary, new, all = TRUE)
	else {
	    summary <- cbind(summary, rep.int("", NROW(summary)))
	    names(summary)[NCOL(summary)] <- R_flavors[i]
	}
    }
    summary[] <- lapply(summary,
                        function(x) {
                            x <- as.character(x)
                            x[is.na(x)] <- ""
                            x
                        })
    summary <- summary[c("Package", "Version", "Priority",
                         R_flavors, "Maintainer")]
    summary[order(summary$Package), ]
}

write_check_summary_as_HTML <-
function(summary, file = file.path("~", "tmp", "checkSummary.html"))
{
    if(is.null(summary)) return()

    ## Executive summary.
    tab <- check_summary_table(summary)
    ## Improve appearance.
    pos <- match(row.names(R_flavors_db), rownames(tab), nomatch = 0)
    tab <- cbind(as.matrix(R_flavors_db[pos > 0,
                                        c("Flavor", "OS_type",
                                          "CPU_type")]),
                 tab)
    colnames(tab)[1 : 3] <- c("Flavor", "OS", "CPU")
    rownames(tab) <- NULL

    ## Improve column names for the per-package table.
    pos <- match(row.names(R_flavors_db), names(summary), nomatch = 0)
    names(summary)[pos] <-
        do.call(sprintf,
                c(list("%s\n%s\n%s"),
                  R_flavors_db[pos > 0,
                               c("Flavor", "OS_type", "CPU_type")]))

    library("xtable")
    out <- file(file, "w")
    writeLines(c("<HTML lang=\"en\"><HEAD>",
                 "<TITLE>CRAN Daily Package Check</TITLE>",
                 "<META http-equiv=\"Content-Type\" content=\"text/html; charset=utf8\">",
                 
                 "</HEAD>",
                 "<BODY lang=\"en\">",
                 "<H1>CRAN Daily Package Check Results</H1>",
                 "<P>",
                 paste("Last updated on", format(Sys.time())),
                 "<P>",
                 "Results for installing and checking packages",
                 "using the three current flavors of R",
                 "on systems running Debian GNU/Linux testing",
                 "(r-devel ix86: AMD Athlon(tm) XP 2400+ (2GHz),",
                 "r-devel x86_64: Dual Core AMD Opteron(tm) Processor 280,",
                 sprintf("%s/r-release:", r_p_o_p),
                 "Intel(R) Pentium(R) 4 CPU 2.66GHz),",
                 "MacOS X 10.4.7 (iMac, Intel Core Duo 1.83GHz),",
                 "and Windows Server 2003 SP1 (AMD Athlon64 X2 5000+).",
                 "<P>"),
               out)

    print(xtable(tab,
                 align = c("r", rep("l", 3), rep("r", 4)),
                 digits = rep(0, NCOL(tab) + 1)),
          type = "html", file = out, append = TRUE)
    writeLines("<P/>Results per package:<P/>", out)
    
    ## Older versions of package xtable needed post-processing as
    ## suggested by Uwe Ligges, reducing checkSummary.html from 370 kB
    ## to 120 kB ...
    ##    lines <- capture.output(print(xtable(summary), type = "html"),
    ##                            file = NULL)
    ##    lines <- gsub("  *", " ", lines)
    ##    lines <- gsub(" align=\"left\"", "", lines)
    ##    writeLines(lines, out)
    ## (Oh no, why does print.xtable() want to write to a *file*?)
    ## Seems that this is no longer necessary in 1.2.995 or better, so
    ## let's revert to the original code.
    print(xtable(summary), type = "html", file = out, append = TRUE)
    writeLines(c("<P>",
                 "Results with [*] or [**] were obtained by checking",
                 "with <CODE>--install=fake</CODE>",
                 "and <CODE>--install=no</CODE>, respectively.",
                 "</BODY>",
                 "</HTML>"),
               out)
    close(out)
}

check_summary_table <-
function(summary)
{
    ## Create an executive summary of the summaries.
    pos <- grep("^r-", names(summary))
    out <- matrix(0, length(pos), 4)
    for(i in seq_along(pos)) {
        status <- summary[[pos[i]]]
        totals <- c(length(grep("OK( \\[\\*{1,2}\\])?$", status)),
                    length(grep("WARN( \\[\\*{1,2}\\])?</A>$", status)),
                    length(grep("ERROR( \\[\\*{1,2}\\])?</A>$", status)))
        out[i, ] <- c(totals, sum(totals))
    }
    dimnames(out) <- list(names(summary)[pos],
                          c("OK", "WARN", "ERROR", "Total"))
    out
}

get_timings_from_timings_files <-
function(tfile)
{
    timings_files <- c(tfile, paste(tfile, "prev", sep = "."))
    timings_files <- timings_files[file.exists(timings_files)]
    if(!length(timings_files)) return()
    x <- paste(readLines(timings_files[1]), collapse = "\n")
    ## Safeguard against possibly incomplete entries.
    x <- sub("(.*swaps(\n|$))*.*", "\\1", x)
    x <- paste(unlist(strsplit(x, "swaps(\n|$)")), "swaps", sep = "")
    ## Eliminate 'Command exited with non-zero ...'
    bad <- rep("OK", length(x))
    bad[grep(": Command exited[^\n]*\n", x)] <- "ERROR"
    x <- sub(": Command exited[^\n]*\n", ": ", x)
    x <- sub("([0-9])system .*", "\\1", x)
    x <- sub("([0-9])user ", "\\1 ", x)
    x <- sub(": ", " ", x)
    x <- read.table(textConnection(c("User System", x)))
    x <- cbind(Total = rowSums(x), x, Status = bad)
    x <- x[order(x$Total, decreasing = TRUE), ]
    x
}

check_timings <-
function(dir = file.path("~", "tmp", "R.check"),
         flavor = "r-devel-linux-ix86")
{
    t_c <- get_timings_from_timings_files(file.path(dir, flavor,
                                                    "time_c.out"))
    t_i <- get_timings_from_timings_files(file.path(dir, flavor,
                                                    "time_i.out"))
    if(is.null(t_i) || is.null(t_c)) return()
    db <- merge(t_c[c("Total", "Status")], t_i["Total"],
                by = 0, all = TRUE)
    db$Total <- rowSums(db[, c("Total.x", "Total.y")], na.rm = TRUE)
    out <- db[, c("Total", "Total.x", "Total.y", "Status")]
    names(out) <- c("Total", "Check", "Install", "Status")
    rownames(out) <- db$Row.names    
    ## Add information on check mode.  If possible, use the summary.
    summary_files <- file.path(dir, flavor,
                               c("summary.rds", "summary.rds.prev"))
    summary_files <- summary_files[file.exists(summary_files)]
    if(length(summary_files)) {
        s <- .readRDS(summary_files[1])
        s <- as.data.frame(s[, -1], row.names = s[, 1])
        ## <FIXME>
        ## This should not be necessary for R 2.4.0 or later.
        s$Status <- as.character(s$Status)
        ## Need to recreate comments about install/check type.
        comment <- rep.int("", nrow(s))
        comment[grep("\\[\\*\\]", s$Status)] <- "[--install=fake]"
        comment[grep("\\[\\*\\*\\]", s$Status)] <- "[--install=no]"
        out <- merge(out,
                     data.frame(Comment = comment,
                                row.names = row.names(s)),
                     by = 0)
        rownames(out) <- out$Row.names
        out$Row.names <- NULL
    } else {
        comment <- ifelse(is.na(out$Install), "[--install=no]", "")
        out <- cbind(out, Comment = comment)
    }
    out[order(out$Total, decreasing = TRUE), ]
}

write_check_timings_as_HTML <-
function(db, file = file.path("~", "tmp", "checkTimings.html"))
{
    if(is.null(db)) return()
    library("xtable")
    out <- file(file, "w")
    writeLines(c("<HTML><HEAD>",
                 "<TITLE>CRAN Daily Package Check Timings</TITLE>",
                 "</HEAD>",
                 "<BODY lang=\"en\">",
                 "<H1>CRAN Daily Package Check Timings</H1>",
                 "<P>",
                 paste("Last updated on", format(Sys.time())),
                 "<P>",
                 paste("Timings for installing and checking packages",
                       "using the current development version of R",
                       "on an AMD Athlon(tm) XP 2400+ (2GHz) system",
                       "running Debian GNU/Linux testing."),
                 "<P>",
                 paste("Total CPU seconds: ", sum(db$Total),
                       " (", round(sum(db$Total) / 3600, 2),
                       " hours)", sep = ""),
                 "<P>"),
               out)
    print(xtable(db), type = "html", file = out, append = TRUE)
    writeLines(c("</BODY>", "</HTML>"), out)
    close(out)
}

check_timings_summary <-
function(dir = file.path("~", "tmp", "R.check"))
{
    ## Overall timings for all flavors.
    R_flavors <- row.names(R_flavors_db)
    timings <- vector("list", length = length(R_flavors))
    names(timings) <- R_flavors
    for(flavor in R_flavors)
        timings[[flavor]] <- check_timings(dir, flavor)
    timings <- timings[sapply(timings, NROW) > 0]
    if(!length(timings)) return(NULL)
    out <- sapply(timings,
                  function(x) colSums(x[, c("Check", "Install")],
                                      na.rm = TRUE))
    out <- rbind(out, Total = colSums(out))
    t(out)
}

write_check_log_as_HTML <-
function(log, out = "")
{
    if(out == "") 
        out <- stdout()
    else if(is.character(out)) {
        out <- file(out, "wt")
        on.exit(close(out))
    }
    if(!inherits(out, "connection")) 
        stop("'out' must be a character string or connection")
    
    lines <- readLines(log)[-1]
    ## The first line says
    ##   using log directory '/var/www/R.check/......"
    ## which is really useless ...
    
    ## HTML escapes:
    lines <- gsub("&", "&amp;", lines)
    lines <- gsub("<", "&lt;", lines)
    lines <- gsub(">", "&gt;", lines)

    ## Fancy stuff:
    ind <- grep("^\\*\\*? ", lines)
    lines[ind] <- sub("\\.\\.\\. (WARNING|ERROR)",
                      "... <FONT color=\"red\"><B>\\1</B></FONT>",
                      lines[ind])
##     ind <- grep("^\\*\\*? (.*)\\.\\.\\. OK$", lines)
##     lines[ind] <- sub("^(\\*\\*?) (.*)",
##                       "\\1 <FONT color=\"gray\">\\2</FONT>",
##                       lines[ind])

    ## Convert pointers to install.log:
    ind <- grep("^See 'http://.*' for details.$", lines)
    if(length(ind))
        lines[ind] <- sub("^See '(.*)' for details.$",
                          "See <A href=\"\\1\">\\1</A> for details.",
                          lines[ind])

    ind <- regexpr("^\\*\\*? ", lines) > -1
    pos <- c((which(ind) - 1)[-1], length(lines))
    lines[pos] <- sprintf("%s</LI>", lines[pos])
    pos <- which(!ind) - 1
    if(any(pos))
        lines[pos] <- sprintf("%s<BR>", lines[pos])
    
    ## Handle list items.
    count <- rep(0, length(lines))
    count[grep("^\\* ", lines)] <- 1
    count[grep("^\\*\\* ", lines)] <- 2
    pos <- which(count > 0)
    ## Need to start a new <UL> where diff(count[pos]) > 0, and to close
    ## it where diff(count[pos]) < 0.  Substitute the <LI>s first.
    ind <- grep("^\\*{1,2} ", lines)
    lines[ind] <- sub("^\\*{1,2} ", "<LI>", lines[ind])
    ind <- diff(count[pos]) > 0 
    lines[pos[ind]] <- paste(lines[pos[ind]], "\n<UL>")
    ind <- diff(count[pos]) < 0
    lines[pos[ind]] <- paste(lines[pos[ind]], "\n</UL>")
    if(sum(diff(count[pos])) > 0)
        lines <- c(lines, "</UL>")

    ## Make things look nicer: ensure gray bullets as well.
    ## Maybe we could also do the first <FONT> substitution later and
    ## match for
    ##   "^<LI> (.*)\\.\\.\\. OK($|\n)"
    ## lines <- sub("^(<LI>) *(<FONT color=\"gray\">)", "\\2 \\1", lines)
    lines <- sub("^(<LI> *(.*)\\.\\.\\. OK</LI>)",
                 "<FONT color=\"gray\">\\1</FONT>",
                 lines)

    ## Header.
    writeLines(c("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">",
                 "<HTML>",
                 "<HEAD>",
                 sprintf("<TITLE>Check results for '%s'</TITLE>",
                         sub("-00check.(log|txt)$", "", basename(log))),
                 "</HEAD>",
                 "<BODY>",
                 "<UL>"),
               out)
    ## Body.
    cat(lines, sep = "\n", file = out)
    ## Footer.
    writeLines(c("</BODY>",
                 "</HTML>"),
               out)
}

check_results_diff_db <-
function(dir)
{
    ## Assume that we know that both check.csv.prev and check.csv exist
    ## in dir.
    x <- read.csv(file.path(dir, "check.csv.prev"),
                  colClasses = "character")
    x <- x[names(x) != "Maintainer"]
    y <- read.csv(file.path(dir, "check.csv"),
                  colClasses = "character")
    y <- y[names(y) != "Maintainer"]
    z <- merge(x, y, by = 1, all = TRUE)
    row.names(z) <- z$Package
    z
}

check_results_diffs <-
function(dir) {
    db <- check_results_diff_db(dir)
    db <- db[, c("Version.x", "Status.x", "Version.y", "Status.y")]
    ## Show packages with one status missing (removed or added) as
    ## status change only.
    is_na_x <- is.na(db$Status.x)
    is_na_y <- is.na(db$Status.y)
    isc <- (is_na_x | is_na_y | (db$Status.x != db$Status.y))
                                        # Status change.
    ivc <- (!is_na_x & !is_na_y & (db$Version.x != db$Version.y))
                                        # Version change.
    names(db) <- c("V_Old", "S_Old", "V_New", "S_New")
    db <- cbind("S" = ifelse(isc, "*", ""),
                "V" = ifelse(ivc, "*", ""),
                db)
    db[c(which(isc & !ivc), which(isc & ivc), which(!isc & ivc)),
       c("S", "V", "S_Old", "S_New", "V_Old", "V_New")]
}
