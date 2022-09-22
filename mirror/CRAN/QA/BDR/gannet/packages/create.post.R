mail.report <- function(subject = "",
                        address = "the relevant mailing list",
                        body = character(),
                        filename = "R.post")
{
    if(missing(address)) stop("must specify 'address'")
    if(!nzchar(subject)) stop("'subject' is missing")

    cat(body, file = filename, sep = "\n")

    cmdargs <- paste("-s", shQuote(subject),
                     "-b ripley@stats.ox.ac.uk",
                     shQuote(address),
                     "<", filename, "2>/dev/null")
    status <- 1L
    cat("Sending email ...to", address, "\n")
    status <- system(paste("mailx", cmdargs), , TRUE, TRUE)
    if(status == 0L) unlink(filename)
    else {
        cat("Sending email failed!\n")
        cat("The unsent", description, "can be found in file",
            sQuote(filename), "\n")
    }
    invisible()
}

pkgs <- scan("","")
DoseFinding ICSNP MixSim OpenCL QCA SDMTools SpatialTools TSP VPdtw arules bdsmatrix colorspace coxphf coxphw extracat fields flashClust gcmr jointDiag lfe magnets mcmc parser proxy sp treethesh


for(pkg in pkgs) {
    addr <- maintainer(pkg)
    pat <- "^.*<(.*)>$"
    if(grepl(pat, addr)) addr <- gsub(pat, "\\1", addr)
    mail.report(subject =
                paste("Unconditional use of Suggest-ed packages in CRAN package", pkg),
                address = addr,
                body = readLines("report37"))
}
