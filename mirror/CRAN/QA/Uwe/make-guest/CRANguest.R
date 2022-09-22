CRANguest <- function(
    workdir = "d:\\RCompile\\CRANguest\\R-release",
    uploaddir = "C:\\Inetpub\\wwwroot",
    maj.version = maj.version,
    mailMaintainer = FALSE,
    nomultiarch = "d:/Rcompile/CRANpkg/make/config/NoMultiarch",
    mergemultiarch = "d:/Rcompile/CRANpkg/make/config/MergeMultiarch",
    forcebiarch = "d:/Rcompile/CRANpkg/make/config/ForceBiarch",    
    email = NULL){

############################################################################################
## Requisites:
# - Installation of current version of R, preferrably compiled on this machine
# - Complete compiler set, perl, Help Workshop, ..., and tools as mentioned in the docs
# - blat (command line e-mail send tool) if(!is.null(email))
############################################################################################
## Arguments:
# workdir:      sources, working directory, temp library
# maj.version:  We are building binaries for this major R version 
# mailMaintainer: If TRUE, notification of failed Rcmd check will be send to the 
#               corresponding package maintainer; requires "email" to be specified
# email:        Address used to send results of compiling from *and* to
############################################################################################
    scanExclusion <- function(exclusion, comment.char = "#"){
        if(file.exists(exclusion))
            scan(exclusion, what = character(0), comment.char = comment.char) 
        else ""   
    }    
    nomultiarch <- scanExclusion(nomultiarch)
    mergemultiarch <- scanExclusion(mergemultiarch)
    forcebiarch <- scanExclusion(forcebiarch)
    library("utils")
    library("tools")
    # Hard-coding fields (we are indexing by number, so hard-coding is important here!)
    fields <- c("Package", "Bundle", "Priority", "Version", "Depends", 
        "Suggests", "Imports", "Contains")

    libdir <- file.path(workdir, "lib", fsep = "\\")
    if(!file.exists(libdir)) shell(paste("mkdir", libdir))
    archivedir <- file.path(workdir, "Archiv", fsep = "\\")
    if(!file.exists(archivedir)) shell(paste("mkdir", archivedir))
    
    unlink(file.path(libdir, "00LOCK", fsep="\\"), recursive = TRUE)
    Infofile <- file.path(workdir, "_Info.txt", fsep = "\\")    
    file.copy("check.R", workdir, overwrite = TRUE)
    setwd(workdir)

    brandnew <- list.files(pattern = "\\.tar\\.gz$")
    if(!length(brandnew)) return("No packages to compile: exit!")
    on.exit(shell("mv *.tar.gz Archiv"))  # clean up

    ## Generating an information file that will collect all interesting changes and problems
    write(c(paste("Version:", maj.version, "\tDate/Time:", 
            format(Sys.time(), "%A, %d.%m.%Y / %H:%M"))), file = Infofile)
    subject <- paste("winbuilder: ERROR", maj.version, sep=".")
    if(!is.null(email))
        on.exit(print(shell(
                paste("blat", Infofile, "-to", email, "-subject", shQuote(subject), "-f", email), 
            intern = TRUE)), add = TRUE)
            
    splitted <- strsplit(brandnew, "_")
    packages <- sapply(splitted, "[", 1)
    versno <- unlist(strsplit(sapply(splitted, "[", 2), ".tar.gz"))
   
    status <- character(0)
    insttime <- checktime <- numeric(0)
    
    on.exit(shell("rm -r -f *.zip *.time *.error *-install.out"), add = TRUE)
    
    for(i in seq(along=brandnew)){
        temp <- packages[i]
        instoutfile <- paste(temp, "-install.out", sep = "")
        ## clean up:
        on.exit(shell(paste("rm -r -f", temp, paste(temp, ".Rcheck", sep = ""))), 
                add = TRUE)
        insttime <- c(insttime, system.time({
            shell(paste("tar xfz", brandnew[i]))
            if(temp %in% mergemultiarch){
                shell(paste("Rcmd INSTALL --build --merge-multiarch",
                        "-l", libdir, brandnew[i], ">", instoutfile, "2>&1"), invisible = TRUE)
            } else {
                if(temp %in% forcebiarch){
                    shell(paste("Rcmd INSTALL --build --force-biarch",
                            "-l", libdir, brandnew[i], ">", instoutfile, "2>&1"), invisible = TRUE)
                } else {            
                    shell(paste("Rcmd INSTALL --build",
                            if(temp %in% nomultiarch)
                                '--no-multiarch' else ' ',
                            "-l", libdir, brandnew[i], ">", instoutfile, "2>&1"), invisible = TRUE)
                }
            }
        })[3])

        ## check
        writeCheckMakefile(pkgnames0 = temp, libdir = libdir, checkScript = "check.R") 
        checkdir <- file.path(workdir, paste(temp, ".Rcheck", sep = ""), fsep = "\\")
        checklog <- file.path(checkdir, "00check.log", fsep = "\\")
        instlog <- file.path(checkdir, "00install.out", fsep = "\\")
        checkerrorlog <- file.path(workdir, paste(temp, ".error", sep = ""))
        checkerror <- try(scan(checkerrorlog, what = logical(0), quiet = TRUE), silent = TRUE)
        if(inherits(checkerror, "try-error")){
            checkerror <- TRUE
            exRout <- try(readLines(file.path(checkdir, paste(temp, "-Ex.Rout", sep=""), fsep = "\\")))
            cat(" ERROR\n",
                "Check process probably crashed or hung up for 20 minutes ... killed\n",
                "Most likely this happened in the example checks (?),\n",
                "if not, ignore the following last lines of example output:\n",
                if(!inherits(exRout, "try-error")) 
                    paste(tail(exRout, 30), collapse = "\n"),
                "\n======== End of example output (where/before crash/hang up occured ?) ========\n",
                sep = "", file = checklog, append = TRUE)
        }
        checktimelog <- file.path(workdir, paste(temp, ".time", sep = ""))
        checktimetemp <- try(scan(checktimelog, what = numeric(0), quiet = TRUE), silent = TRUE)
        if(inherits(checktimetemp, "try-error")) 
            checktimetemp <- 0
        checktime <- c(checktime, checktimetemp)
        checklines <- readLines(checklog)
        tempstatus <- grep("^Status: ", checklines, value=TRUE)
        status <- c(status, tempstatus)

        
        ## Upload
        random <- paste(sample(c(0:9, 0:9, letters, LETTERS), 12, replace = TRUE), collapse="")
        upload <- file.path(uploaddir, random, fsep = "\\")
        shell(paste("mkdir", upload))
        file.copy(paste(temp, "_", versno[i], ".zip", sep = ""), upload)
        if(file.exists(instlog)){
            inst <- readLines(instlog)
            instrm <- grep("cannot update HTML package index", inst)
            if(length(instrm)) inst <- inst[-(instrm+(-1:0))]
            instrm <- grep("^  cannot create file .*packages.html', reason 'Permission denied'$", inst)
            if(length(instrm)) inst <- inst[-(instrm+(-2:0))]
            writeLines(inst, con=instlog)
            file.copy(c(checklog, instlog), upload)
        }
        else file.copy(checklog, upload)
        upload <- file.path(upload, "examples_and_tests", fsep = "\\")
        dir.create(upload)
        file.copy(file.path(checkdir, "examples_i386", fsep = "\\"), upload, recursive = TRUE)
        file.copy(file.path(checkdir, "examples_x64", fsep = "\\"), upload, recursive = TRUE)
        file.copy(file.path(checkdir, "tests_i386", fsep = "\\"), upload, recursive = TRUE)
        file.copy(file.path(checkdir, "tests_x64", fsep = "\\"), upload, recursive = TRUE)        
        file.copy(file.path(checkdir, dir(checkdir, pattern = "-Ex_.*\\.Rout$")), upload)
        
        ## Sending an e-mail to the maintainer
        if(mailMaintainer && !is.null(email)){
            write(c("Dear package maintainer,", " ",
                    "this notification has been generated automatically.",
                    paste("Your package", brandnew[i], 
                          "has been built (if working) and checked for Windows."),
                    "Please check the log files and (if working) the binary package at:",
                    paste("https://win-builder.r-project.org/", random, sep = ""),
                    "The files will be removed after roughly 72 hours.",
                    paste("Installation time in seconds:", round(insttime[i])),
                    paste("Check time in seconds:", round(checktime[i])),
                    tempstatus,
                    R.version.string,
                     " ", "All the best,", "Uwe Ligges", 
                     "(CRAN maintainer of binary packages for Windows)"),
                   file = "mailfile.tmp")
            ## package maintainer's e-mail address
            maintainer <- packageDescription(temp, getwd(), fields = "Maintainer")
            maintainer <- if(is.na(maintainer)) email else 
                strsplit(strsplit(maintainer, "<")[[1]][2], ">")[[1]][1]
            shell(paste("blat mailfile.tmp",
                    "-to", maintainer,
                    "-cc", email,
                    "-subject \"winbuilder: Package", brandnew[i], "has been checked and built\"",
                    "-f", email))
        }
    }
    ## Info to Info file:
    write(c(" ", "STATUS:", "=======", 
            paste(status, brandnew, round(insttime), 
                  round(checktime), sep = "\t")), 
          file = Infofile, append = TRUE)

    ## Finally, let's get the Info file by e-mail
    subject <- paste("winbuilder: OK", maj.version, sep=".")    
    return("finished!")        
}



writeCheckMakefile <- function(pkgnames0, libdir, checkScript){
    if(length(pkgnames0)){
        write(c(paste("PKG :=", paste(pkgnames0, collapse = "\\\n")),
                      "PKG_CHECK := $(PKG:=.Rcheck/00check.log)",
                      "all: $(PKG_CHECK)",
                      "%.Rcheck/00check.log: %",
                paste("\tMAKE=make MAKEFLAGS= R -f", checkScript, "--no-site-file --no-environ --no-restore --no-Rconsole --quiet --args", 
                      gsub("\\\\", "/", libdir), 
                      "$< R_default_packages=NULL")),
            file = "Makefile")
        shell("make -k", invisible = TRUE)
    }
}
