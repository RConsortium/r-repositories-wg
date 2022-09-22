#! /usr/local/bin/Rscript
mailx <-
function(subject = "", address, body = character(),
         cc, bcc, from, replyto, verbose = FALSE)
{
    #if(missing(address)) stop("must specify 'address'")
    if(any(missing(address) | is.na(address))) stop("must specify 'address'")
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

mailx_from_head_and_body_list <-
function(x, verbose = FALSE)
{
    h <- x$head
    mailx(h$Subject,
          h$To,
          body = x$body,
          from = "Prof Brian Ripley <ripley@stats.ox.ac.uk>",
          cc = h$CC,
          replyto = h$"Reply-To",
          verbose = verbose)
}


## If we have a package p with problems for which we know that the
## maintainer will not fix these, either implicitly by never following
## up on reminders, or explicitly by telling us so, and the package has
## reverse dependencies, we can either provide NMUs, or need to escalate
## the issue by informing the maintainers of the reverse depends.

## The code below generates the necessary materials.

CRAN_package_problem_escalation_message <-
function(p, i = TRUE, d = Sys.Date() + 14, recursive = FALSE,
         collapse = FALSE)
{
    d <- max(Sys.Date() + 14, as.Date("2022-08-08"))

    a <- available.packages()
    a <- a[startsWith(a[, "Repository"],
                      getOption("repos")["CRAN"]), ]
    r <- tools::package_dependencies(p, a, reverse = TRUE,
                                     recursive = recursive)

    info <- tools:::CRAN_package_maintainers_info(c(p, unlist(r)),
                                                  collapse = collapse)

    head <- info$head
    if(collapse) {
        head[startsWith(head, "Subject:")] <-
            sprintf("Subject: CRAN package %s and its reverse dependencies",
                    p)
    } else {
        head$Subject <-
            sprintf("CRAN package %s and its reverse dependencies",
                    p)
    }
    body <-
        c(info$body,
          "",
          "We have asked for an update fixing the check problems shown at",
          sprintf("  <https://cran.r-project.org/web/checks/check_results_%s.html>",
                  p),
          if(i)
              "with no update from the maintainer thus far."
          else
              "and been informed that the maintainer will not be able to fix these.",
          "",
          strwrap(paste(sprintf("Thus, package %s is now scheduled for archival on %s,",
                                p, d),
                        "and archiving this will necessitate also archiving its",
                        "CRAN strong reverse dependencies.")),
          "",
          "Please negotiate the necessary actions.",
          "",
          "The CRAN Team")

    list(head = head, body = body)
}

wrapper <- function()
{
    args <- commandArgs(TRUE)
    if (length(args) != 1L) stop("needs one argument")
    m <- CRAN_package_problem_escalation_message(args, recursive = TRUE)
    mailx_from_head_and_body_list(m)
}

wrapper()
