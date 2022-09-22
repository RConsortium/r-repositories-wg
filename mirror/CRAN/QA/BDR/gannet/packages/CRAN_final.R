#! /usr/local/bin/Rscript
mailx <-
function(subject = "", address, body = character(),
         cc, bcc, from, replyto, verbose = FALSE)
{
    #if(missing(address)) stop("must specify 'address'")
    if(missing(address) || is.na(address)) stop("must specify 'address'")
    if(!nzchar(subject)) stop("'subject' is missing")

    args <- c("-s", shQuote(subject))
    env <- character()
    ## For cc and bcc, use command line options -c and -b:
    ## -c address
    ##    Send carbon copies to list of users.
    ## -b address
    ##    Send blind carbon copies to list.  List should be a
    ##    comma-separated list of names.
    if(!missing(cc))
        args <- c(args, "-c", shQuote(paste(cc, collapse = ",")))
    if(!missing(bcc))
        args <- c(args, "-b", shQuote(paste(bcc, collapse = ",")))
    ## Argh.
    ## We really want to be able to specify the 'From' and 'Reply-to'
    ## fields in the messages.
    ## POSIX mailx
    ## <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/mailx.html>
    ## has nothing for those.
    ## BSD mailx
    ## <http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/usr.bin/mail/>
    ## has command line option '-r' for the former, and env var REPLYTO
    ## for the latter.
    ## S-nail <https://www.sdaoden.eu/code.html> has command line option
    ## for the former, and env var replyto (as well as additional
    ## command line mechanisms) for the latter.
    ## Hence, for now use '-r' for 'From', and both env vars for
    ## 'Reply-To'.
    if(!missing(from))
        args <- c(args, "-r", shQuote(from))
    ##      env <- c(env, sprintf("from=%s", shQuote(from)))
    if(!missing(replyto)) {
        env <- c(env, sprintf("replyto=%s", shQuote(replyto)))
        env <- c(env, sprintf("REPLYTO=%s", shQuote(replyto)))
    }

    address <- paste(shQuote(address), collapse = " ")

    filename <- sprintf("R_post_%s", format(Sys.time(), "%FT%T"))
    cat(body, file = filename, sep = "\n")

    ## <NOTE>
    ## To avoid reading the user's configuration files for general
    ## purpose use, the man page suggests using
    ##   MAILRC=/dev/null mailx -n
    ## and create a configuration file for the script.
    ## </NOTE>

    if(verbose)
        message(sprintf("Sending email to %s", address))

    ## <FIXME>
    ## This hard-wires mailx: we may prefer to use s-nail if available,
    ## or to allow to specify to command line MUA.
    ## </FIXME>

    status <- system2("mailx", c(args, address), env = env,
                      stdin = filename, stdout = "", stderr = "")
    if(status == 0L) unlink(filename)
    else {
        message(sprintf("Sending email failed!\nThe unsent msg can be found in file %s.",
                        sQuote(filename)))
    }

    invisible()
}

if(FALSE) {
    mailx("test1",
          "ripley@stats.ox.ac.uk",
          c("This is a test.  Bye!"),
          cc = "Brian.Ripley@R-project.org",
          from = "Brian.Ripley@R-project.org",
          replyto = "CRAN@R-project.org")
}

CRAN_package_maintainers_addresses <-
function(packages, db = NULL)
{
    if(is.null(db))
        db <- tools:::CRAN_package_maintainers_db()
    ind <- match(packages, db[, "Package"])
    addresses <- db[ind, "Address"]
    names(addresses) <- packages
    addresses
}


mailx_CRAN_package_problems <-
function(packages, cran = TRUE, verbose = TRUE, before = NULL,
         details = character(), final = FALSE)
{
    addresses <-
        CRAN_package_maintainers_addresses(packages)
    ind <- is.na(addresses) | (addresses == "orphaned")
    if(any(ind))
        message(c("Found no maintainer addresses for packages:",
                  strwrap(paste(packages[ind], collapse = " "),
                          indent = 2L, exdent = 2L)))
    addresses <- addresses[!ind]
    packages <- names(addresses)

    before <- if(is.null(before))
                  Sys.Date() + 14
              else
                  as.Date(before)
    before <- max(Sys.Date() + 14, as.Date("2022-08-08"))

    fmt <- c("Dear maintainer,",
             "",
             "Please see the problems shown on",
             "<https://cran.r-project.org/web/checks/check_results_%s.html>.",
             "",
             if(length(details)) c(details, ""),
             paste("Please correct before",
                   format(before),
                   "to safely retain your package on CRAN."),
             "",
             if(final)
                 c("Note that this will be the *final* reminder.",
                   ""),
             "The CRAN Team"
             )

    cc <- if(cran) "CRAN@R-project.org" else "Brian.Ripley@R-project.org"

    Map(function(a, p) {
            mailx(paste("CRAN package", p),
                  a,
                  ## "Kurt.Hornik@wu.ac.at",
                  body = sprintf(fmt, p),
                  cc = cc,
                  replyto = cc,
                  verbose = verbose)
        },
        addresses,
        packages)

    message(c("Sent messages to maintainer of packages:\n",
              strwrap(paste(packages, collapse = " "),
                      indent = 2L, exdent = 2L)))

    ## Ideally, this would also create log comments in CRAN.csv,
    ## defaulting to
    ##   [QUERIED:Sys.Date():KH]
    ## but perhaps settable.

    invisible()
    }


wrapper <- function()
{
    args <- commandArgs(TRUE)
    if (!length(args)) stop("no arguments")
    mailx_CRAN_package_problems(args, final = TRUE)
}

wrapper()
