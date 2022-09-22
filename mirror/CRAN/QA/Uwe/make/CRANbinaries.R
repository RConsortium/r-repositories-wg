CRANbinaries <- function(srcdir = "d:\\Rcompile\\CRANpkg\\sources",
    cran.url = "https://cran.r-project.org/src/contrib",
    localdir = "d:\\Rcompile\\CRANpkg\\local",
    checkdir = "d:\\Rcompile\\CRANpkg\\check", 
    libdir = "d:\\Rcompile\\CRANpkg\\lib",
    windir = "d:\\Rcompile\\CRANpkg\\win",
    donotcheck = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotCheck", 
    donotchecklong = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotCheckLong",
    donotcheckvignette = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotCheckVignette",
    donotcompile = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotCompile",
    donotnotify = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotNotify",
    doresavedata = "d:/Rcompile/CRANpkg/make/config/DoResaveData",
    dodatacompress = "d:/Rcompile/CRANpkg/make/config/DoDataCompress",
    nomultiarch = "d:/Rcompile/CRANpkg/make/config/NoMultiarch",
    mergemultiarch = "d:/Rcompile/CRANpkg/make/config/MergeMultiarch",
    forcebiarch = "d:/Rcompile/CRANpkg/make/config/ForceBiarch",
    check = TRUE, check.only = FALSE, install.only = FALSE, rebuild = FALSE,
    maj.version = maj.version, npar = 16,
    mailMaintainer = c("no", "error", "yes"),
    email = NULL,
    securityNROW = 12000, recursiveChecks = FALSE, recursivePackages = NA){

############################################################################################
## Requisites:
# - Installation of current version of R, preferrably compiled on this machine
# - Complete compiler set, perl, Help Workshop, ..., and tools as mentioned in the docs
# - blat (command line e-mail send tool) if(!is.null(email))
############################################################################################
## Arguments:
# srcdir:         CRAN sources, required to check for changes on CRAN 
#                 (new / updated / withdrawn packages)
# cran.url:       location CRAN source packages can be mirrored from
# localdir:       later working directory for compilation etc.
# checkdir:       directory that contains the checks
# libdir:         directory that conatins the library
# windir:         directory used to store CRAN binaries locally
# donotcheck:     Packages forced to "Rcmd check --install=fake"
# donotchecklong: Packages forced to "Rcmd check --no-examples --no-tests --no-vignettes"
# donotcheckvignette: Packages forced to "Rcmd check --no-vignettes"
# donotcompile:   do not compile Packages listed in here
# donotnotify:    these maintainers do not want to be notified
# doresavedata:   Use --resave-data to reduce package size
# dodatacompress: Use --data-compress=bzip2 to reduce package size
# check:          Whether Rcmd check should be executed for each package
# check.only:     Installs and checks all packages from *local* repository
# install.only:   only installs locally in order to set up an appropriate environment;
#                 forces check=FALSE
# rebuild:
# maj.version:    We are building binaries for this major R version 
#                 (and name of corresponding subdirectory)
# npar:           Number of parallel make processes (make -j npar)
# mailMaintainer: If "error", notification of failed Rcmd check will be send to the 
#                 corresponding package maintainer; requires "email" to be specified;
#                 if "yes", notification will be send in any case;
#                 if "no", default, no message will be send.
# email:          Address used to send results of compiling from *and* to
# securityNROW:   If CRAN thinks it has less than this number of packages, 
#                 stop for security reasons: CRAN is broken
# recursiveChecks:Indicates if this run is to check recursive inverse dependencies
############################################################################################
    subject <- paste("ERROR", "CRANpkgAUTO", maj.version, if(recursiveChecks) "recursive", sep=".")
    if(!is.null(email))
        on.exit(print(shell(
                paste("blat", Infofile, "-to", email, 
                      "-subject", subject, "-f", email), 
            intern = TRUE)))

    owd <- getwd()
    on.exit(setwd(owd), add=TRUE)
    mailMaintainer <- match.arg(mailMaintainer)
    library("utils")
    library("tools")
    # Hard-coding fields (we are indexing by number, so hard-coding is important here!)
    fields <- c("Package", "Priority", "Version", 
                "Depends", "Suggests", "Imports", "Contains", "Enhances", "LinkingTo", "Archs")
    if(install.only) check <- FALSE
    if(check.only) check <- TRUE
    libdir <- file.path(libdir, maj.version, fsep = "\\")
    if(!file.exists(libdir)) shell(paste("mkdir", libdir))
    localdir <- file.path(localdir, maj.version, fsep = "\\")
    if(!file.exists(localdir)) shell(paste("mkdir", localdir))
    windir <- file.path(windir, maj.version, fsep = "\\")
    if(!file.exists(windir)) shell(paste("mkdir", windir))
    windircheck <- file.path(windir, "check", fsep = "\\")
    if(!file.exists(windircheck)) shell(paste("mkdir", windircheck))
    srcdiro <- srcdir
    srcdir <- file.path(srcdir, maj.version, fsep = "\\")
    if(!file.exists(srcdir)) shell(paste("mkdir", srcdir))
    if(check){
        checklogpath <- file.path(checkdir, maj.version, fsep = "\\")
        if(!file.exists(checklogpath)) shell(paste("mkdir", checklogpath))
        file.copy("check.R", localdir, overwrite = TRUE)
    }
    file.copy("install.R", localdir, overwrite = TRUE)
    Infofile <- file.path(windir, "_Info.txt", fsep = "\\")    
    donotcompile <- scanExclusion(donotcompile)
    donotcheck <- scanExclusion(donotcheck)
    donotchecklong <- scanExclusion(donotchecklong)
    donotcheckvignette <- scanExclusion(donotcheckvignette)
    donotnotify <- scanExclusion(donotnotify)

    setwd(srcdir)

    p.local.res <- p.local()
    packages <- p.local.res$packages
    versno <- p.local.res$versno

    ## Looking for source packages and their version numbers on CRAN
    packcon <- url(file.path(cran.url, "PACKAGES"))
    cranpackages <- read.dcf(packcon, fields = c(fields, "Path", "OS_type"))
    close(packcon)
    
    ## required for individual check libraries:
    checkfields <- c("Package", "Version", "Depends", "Suggests", "Imports", "Enhances", "LinkingTo")
    checkpackages <- cranpackages[,checkfields]

    if(nrow(cranpackages) < securityNROW)
        stop("PACKAGES file from CRAN is smaller than securityNROW")

    normalP <- cranpackages[which(is.na(cranpackages[,"Path"])),,drop=FALSE]
    specialP <- cranpackages[grep(maj.version, cranpackages[,"Path"]),,drop=FALSE]
    cranpackages <- rbind(normalP[!(normalP[,1] %in% specialP[,1]),], specialP)
    notOnWindows <- cranpackages[setdiff(which(!is.na(cranpackages[,"OS_type"])), 
                                         grep("windows", cranpackages[,"OS_type"])),1]
    notThisRversion <- cranpackages[!sapply(cranpackages[,"Depends"], Rdepends), 1]
    rownames(cranpackages) <- cranpackages[,1]
    cranpackages <- cranpackages[order(cranpackages[,1]), ]
    cran.packages <- cranpackages[,1]
    cran.versno <- cranpackages[,"Version"]

    ## Generating an information file that will collect all interesting changes and problems
    write(paste("Version:", maj.version, "\tDate/Time:", 
            format(Sys.time(), "%A, %d.%m.%Y / %H:%M")), file = Infofile)

    if(check.only || rebuild || recursiveChecks){
        if(recursiveChecks)
            brandnew <- as.vector(sapply(paste("^", recursivePackages, "_", sep=""), 
                                         grep, dir(srcdir, pattern="\\.tar\\.gz$"), value=TRUE))
        else
            brandnew <- paste(packages, "_", versno, ".tar.gz", sep = "")
        for(i in brandnew)
            shell(paste("cp -l", i, localdir))
        setwd(localdir) # Change WD!!!
        writeInfofilePart(Infofile, if(recursiveChecks) "RECURSIVE BUILD / CHECK:" else "CHECKING:", brandnew)
    }else{
        ## Brandnew packages on CRAN (detecting, downloading, copying to later WD)
        brandnew <- !(cran.packages %in% packages)
        cranurl <- ifelse(is.na(cranpackages[,"Path"]), 
                        cran.url, 
                        file.path(cran.url, cranpackages[,"Path"]))[brandnew]
        brandnew <- paste(cran.packages, "_", cran.versno, ".tar.gz", sep = "")[brandnew]
        if(length(brandnew)){
            from <- file.path(cranurl, brandnew)
            for(i in seq(along = brandnew)){
                download.file(from[i], destfile = brandnew[i], mode ="wb")
                shell(paste("cp -l", brandnew[i], localdir))
            }
        }
        
        ## Withdrawn from CRAN (and deleting on local mirror)
        oldp <- !(packages %in% cran.packages)
        old <- paste(packages, "_", p.local.res$versno, ".tar.gz", sep = "")[oldp]
        for(i in seq(along = old)){
            unlink(old[i])
            unlink(file.path(checklogpath, paste(packages[oldp][i], ".Rcheck", sep="")), recursive = TRUE)
            unlink(file.path(windir, "check", paste(packages[oldp][i], "check.log", sep = "-"), fsep = "\\"))
        }
        if(length(brandnew)) 
            writeInfofilePart(Infofile, "NEW:", brandnew)
        if(length(old))
            writeInfofilePart(Infofile, "WITHDRAWN:", old)
    
        ## After downloading, we need to check the local mirror again
        p.local.res <- p.local()
        packages <- p.local.res$packages
        versno <- p.local.res$versno
    
        ## Downloading updates from CRAN, 
        ## as well as sorting out replaced files on local mirror
        if(length(versno) != length(cran.versno))
            stop("Number of packages in local repository and packages on CRAN is different")
        else 
            temp <- as.logical(abs(mapply(compareVersion, versno, cran.versno)))
        
        updates.old <- paste(packages, "_", versno, ".tar.gz", sep = "")[temp]
        for(i in seq(along = updates.old)){
            unlink(updates.old[i])
        }
        if(length(updates.old))
            writeInfofilePart(Infofile, "UPDATES REPLACED:", updates.old)        
        updates <- paste(cran.packages, "_", cran.versno, ".tar.gz", sep = "")[temp]
        cranurl <- ifelse(is.na(cranpackages[,"Path"]), 
                            cran.url, 
                            file.path(cran.url, cranpackages[,"Path"]))[temp]
        if(length(updates)){
            from <- file.path(cranurl, updates)
            for(i in seq(along = updates)){
                download.file(from[i], destfile = updates[i], mode ="wb")
                shell(paste("cp -l", updates[i], localdir))
            }
        }
        setwd(localdir) ### Change WD!!!
        if(length(updates))
            writeInfofilePart(Infofile, "UPDATES:", updates)
        ## These files have to be removed:
        oldzip <- sub("\\.tar\\.gz$", ".zip", c(old, updates.old))
    
        ## New packages and updates can be handled equally from now on:
        brandnew <- c(brandnew, updates)
    }
    
    ## Sort out packages that is on the exclude list
    sdn <- sapply(strsplit(brandnew, "_"), "[", 1) %in% c(donotcompile, notOnWindows, notThisRversion)
    if(length(brandnew[sdn])) 
        writeInfofilePart(Infofile, "DoNotCompile:", brandnew[sdn])
    brandnew <- brandnew[!sdn]

    ## These packages have not been checked / special checked:
    specialcheck <- brandnew[sapply(strsplit(brandnew, "_"), "[", 1) %in% donotcheck]
    if(length(specialcheck))
        writeInfofilePart(Infofile, "Rcmd check --install=fake", specialcheck)
    specialcheck <- brandnew[sapply(strsplit(brandnew, "_"), "[", 1) %in% donotchecklong]
    if(length(specialcheck))
        writeInfofilePart(Infofile, "Rcmd check --no-examples --no-tests --no-vignettes", specialcheck)
    specialcheck <- brandnew[sapply(strsplit(brandnew, "_"), "[", 1) %in% donotcheckvignette]
    if(length(specialcheck))
        writeInfofilePart(Infofile, "Rcmd check --no-vignettes", specialcheck)

    ## We only need more action if new packages have been downloaded from CRAN
    if(length(brandnew)){
        status <- character(0)
        insttime <- checktime <- numeric(0)
        
        CheckLimitCores <- Sys.getenv("_R_CHECK_LIMIT_CORES_", unset = NA)
        if(!is.na(CheckLimitCores)) 
            Sys.unsetenv("_R_CHECK_LIMIT_CORES_")
        
        library("parallel")
        cl <- makeCluster(npar)
        parSapply(cl, brandnew, function(i, recursiveChecks, srcdir, srcdiro, localdir, writeInfofilePart, Infofile){
            temp <- strsplit(i, "_")[[1]][1]        
            if(!recursiveChecks){
                tar <- shell(paste("tar xfz", i))
                shell(paste("cacls", temp, "/T /E /P Administratoren:F CRAN:F > NUL")) # Workaround: some packages have wrong permissions
                if(tar==2) {
                    writeInfofilePart(Infofile, "BROKEN tar.gz:", i)            
                    stop(paste("Broken file:", i))
                }
                shell(paste("rm -r -f", file.path(srcdir, temp, fsep = "\\")))
                shell(paste("mv -f", temp, file.path(srcdir, temp, fsep = "\\")))
            }
            Sys.junction(file.path(srcdir, temp, fsep = "\\"), file.path(localdir, temp, fsep = "\\"))

            file.copy(file.path(temp, "DESCRIPTION"), 
                      file.path(srcdiro, "Descriptions", paste(temp, "DESCRIPTION", sep = ".")), 
                      overwrite = TRUE)
        },  recursiveChecks=recursiveChecks, srcdir=srcdir, srcdiro=srcdiro, localdir=localdir, 
            writeInfofilePart=writeInfofilePart, Infofile=Infofile)
        stopCluster(cl)
        if(!is.na(CheckLimitCores)) 
            Sys.setenv("_R_CHECK_LIMIT_CORES_" = CheckLimitCores)

#        
#        for(i in brandnew){
#            temp <- strsplit(i, "_")[[1]][1]        
#            if(!(recursiveChecks)){
#                tar <- shell(paste("tar xfz", i))
#                shell(paste("cacls", temp, "/T /E /P Administratoren:F CRAN:F > NUL")) # Workaround: some packages have wrong permissions
#                if(tar==2) {
#                    writeInfofilePart(Infofile, "BROKEN tar.gz:", i)            
#                    stop(paste("Broken file:", i))
#                }
#                shell(paste("rm -r -f", file.path(srcdir, temp, fsep = "\\")))
#                shell(paste("mv -f", temp, file.path(srcdir, temp, fsep = "\\")))
#            }
#            Sys.junction(file.path(srcdir, temp, fsep = "\\"), file.path(localdir, temp, fsep = "\\"))
#
#            file.copy(file.path(temp, "DESCRIPTION"), 
#                      file.path(srcdiro, "Descriptions", paste(temp, "DESCRIPTION", sep = ".")), 
#                      overwrite = TRUE)
#        }

        temp <- sapply(strsplit(brandnew, "_"), "[" , 1)
        names(brandnew) <- temp
        
        ## The following four lines specify the correct installation 
        ## order given there are depedencies.
        ## We do not need to care about it for checking, if everything is installed.

        brandnewResorted <- temp
        if(length(brandnewResorted)){
            dependencies <- utils:::.make_dependency_list(brandnewResorted, cranpackages,
                dependencies = c("Depends", "Imports", "LinkingTo")) # "Suggests", "Enhances"
            dependencies <- dependencies[sapply(dependencies, length) > 0]
            deps <- character(length(dependencies))
            dnames <- names(dependencies)
            for(i in seq(along = dependencies)){
                dependencies[[i]] <- intersect(dependencies[[i]], brandnewResorted)
                if(length(dependencies[[i]]))
                    deps[i] <- paste(dnames[i], ".itime: ", 
                                    paste(dependencies[[i]], ".itime", collapse = " ", sep = ""),
                                    sep = "")
            }
            
            write(c(paste("PKG :=", paste(brandnewResorted, collapse = "\\\n")),
                        "PKG_INST := $(PKG:=.itime)",
                        "all: $(PKG_INST)",
                        "%.itime: %",
                    paste("\tMAKE=make MAKEFLAGS= R --file=install.R --vanilla --quiet --args", 
                                gsub("\\\\", "/", libdir), 
                                if(install.only || check.only) "nobuild" else "build",
                                doresavedata,
                                dodatacompress,
                                nomultiarch,
                                mergemultiarch,
                                forcebiarch,
                                "$< R_default_packages=NULL"), 
                    deps
                ), file = "Makefile")              
    
            shell(paste("make -k -j", npar, sep=""), invisible = TRUE)
        }


        for(i in temp){
            insttimelog <- file.path(localdir, paste(i, ".itime", sep = ""))
            insttime <- c(insttime, scan(insttimelog, what = numeric(0), quiet = TRUE))
        }

        if(check){
            pkgnames <- sapply(strsplit(brandnew, "_"), "[", 1)

            ## required for individual check libraries:
            localBioCversion <- 
                if(is.function(tools:::.BioC_version_associated_with_R_version)) 
                    tools:::.BioC_version_associated_with_R_version() 
                else 
                    tools:::.BioC_version_associated_with_R_version
                
            URLS <- c(
                contrib.url("https://www.stats.ox.ac.uk/pub/RWin"),    
                paste("https://bioconductor.statistik.tu-dortmund.de/packages/", 
                    localBioCversion,
                    c("/bioc/", "/data/annotation/",  "/data/experiment/", "/extra/"), 
                    "src/contrib", sep=""),
                "http://www.omegahat.net/R/src/contrib")
            
            for(url in URLS){
                packcon <- url(file.path(url, "PACKAGES"))
                temppackages <- try(read.dcf(packcon, fields = checkfields))
                close(packcon)
                if(inherits(temppackages, "try-error")) next
                checkpackages <- rbind(checkpackages, temppackages)
            }
            checkpackages <- checkpackages[!duplicated(checkpackages[,1]),]
                
            pkgnames0 <- pkgnames[!(pkgnames %in% c(donotcheck, donotchecklong, donotcheckvignette))]
            writeCheckMakefile(pkgnames0 = pkgnames0, libdir = libdir, 
                npar = npar, flags = "regular") 
          
            pkgnames0 <- pkgnames[pkgnames %in% donotchecklong]
            writeCheckMakefile(pkgnames0 = pkgnames0, libdir = libdir, 
                npar = npar, flags = "time") 

            pkgnames0 <- pkgnames[pkgnames %in% donotcheckvignette]
            writeCheckMakefile(pkgnames0 = pkgnames0, libdir = libdir, 
                npar = npar, flags = "novignette") 
                                        
            pkgnames0 <- brandnew[pkgnames %in% donotcheck]
            writeCheckMakefile(pkgnames0 = pkgnames0, libdir = libdir, 
                npar = npar, flags = "fake") 
        }
        
        for(i in brandnew){        
            temp <- strsplit(i, "_")[[1]][1]
            instoutfile <- paste(temp, "-install.out", sep = "")
            if(check){
                checklog <- file.path(localdir,
                    paste(temp, ".Rcheck", sep = ""), "00check.log", fsep = "\\")
                instlog <- file.path(localdir, 
                    paste(temp, ".Rcheck", sep = ""), "00install.out", fsep = "\\")
                checkerrorlog <- file.path(localdir, paste(temp, ".error", sep = ""))
                checkerror <- try(scan(checkerrorlog, what = logical(0), quiet = TRUE), silent = TRUE)
                if(inherits(checkerror, "try-error")){
                    checkerror <- TRUE
                    exRout <- try(readLines(file.path(localdir, paste(temp, ".Rcheck", sep = ""), paste(temp, "-Ex.Rout", sep=""), fsep = "\\")))
                    cat("\n",
                        "Check process probably crashed or hung up for 20 minutes ... killed\n",
                        "Most likely this happened in the example checks (?),\n",
                        "if not, ignore the following last lines of example output:\n",
                        if(!inherits(exRout, "try-error")) 
                            paste(tail(exRout, 30), collapse = "\n"),
                        "\n======== End of example output (where/before crash/hang up occured ?) ========\n",
                        sep = "", file = checklog, append = file.exists(checklog))
                }
                checktimelog <- file.path(localdir, paste(temp, ".time", sep = ""))
                checktimetemp <- try(scan(checktimelog, what = numeric(0), quiet = TRUE), silent = TRUE)
                if(inherits(checktimetemp, "try-error")) 
                    checktimetemp <- 0
                checktime <- c(checktime, checktimetemp)
                checklines <- try(readLines(checklog))
                
                if(inherits(checklines, "try-error")){
                        checkerror <- TRUE
                        checklines <- "check log unavailable\n"
                    try({
                        dir.create(file.path(localdir, paste(temp, ".Rcheck", sep = "")))
                        Sys.sleep(1)
                        writeLines(checklines, con = checklog)
                    })
                }
                
                tempstatus <- if(checkerror || any(grep("ERROR$", checklines))){
                        "ERROR"
                    }else
                        if(any(grep("WARNING$", checklines))) "WARNING" else "OK"
                                                
                status <- c(status, tempstatus)
                checkpath <- file.path(checklogpath, paste(temp, ".Rcheck", sep = ""), fsep = "\\")
                if(!file.exists(checkpath)) 
                    shell(paste("mkdir", checkpath))
                
                ## Remove insensible WARNINGS from installation log:
                if(file.exists(instlog)) 
                    removeWARNINGSfromLog(instlog = instlog)

                file.copy(c(checklog, instlog), checkpath, overwrite = TRUE)
                file.copy(file.path(temp, "DESCRIPTION", fsep = "\\"), 
                          file.path(checkpath, "00package.dcf", fsep = "\\"), overwrite = TRUE)

                if(any(grep("^Installation failed.$", checklines)))
                    writeLines(c(checklines[1:(length(checklines)-1)], 
                            "The installation logfile:", readLines(instlog)), 
                        checklog)

                ## Sending an e-mail to the maintainer
#                if((((tempstatus %in% c("ERROR")) && (mailMaintainer == "error")) ||  
                if((((tempstatus %in% c("ERROR", "WARNING")) && (mailMaintainer == "error")) ||  
                    (mailMaintainer == "yes")) && !is.null(email)){
                        CRANemail(package = i, packagename = temp, tempstatus = tempstatus,
                              maj.version = maj.version, mailfile = "mailfile.tmp",
                              email = email, checklog = checklog, donotnotify = donotnotify)
                }
                
                try(file.rename(checklog, 
                        file.path(windir, "check", paste(temp, "check.log", sep = "-"), fsep = "\\")))
            }
            ## cleanup:
            shell(paste("rm -r -f", temp, instoutfile, 
                if(check) paste(temp, c(".error", ".itime", ".time", ".Rcheck"), sep = "", collapse = " ")))
        }
        if(check){
            writeInfofilePart(Infofile, "STATUS:", paste(status, brandnew, sep = ":\t"))

            ## Writing Status Information-File
            splitted <- strsplit(brandnew, "_")
            packages <- sapply(splitted, "[", 1)
            versno <- unlist(strsplit(sapply(splitted, "[", 2), "\\.tar\\.gz$"))

            statusfile <- file.path(windir, "Status", fsep = "\\")
            if(file.exists(statusfile)){
                statusdata <- read.table(statusfile, as.is = TRUE, header = TRUE)
                if((!check.only) && (!rebuild))
                    statusdata <- statusdata[(statusdata[ , 1] %in% cran.packages), ]
                statusdata <- statusdata[!(statusdata[ , 1] %in% packages), ]
                statusdata <- rbind(statusdata, 
                    cbind(packages = packages, version = versno, status = status, 
                        insttime = round(insttime), checktime = round(checktime)))
            }else
                statusdata <- data.frame(packages = packages, version = versno, status = status, 
                    insttime = round(insttime), checktime = round(checktime))

            write.table(statusdata[order(statusdata[,1]), ], file = statusfile, 
                        quote = FALSE, row.names = FALSE)

            brandnew <- brandnew[status != "ERROR"]
            file.copy(statusfile, checklogpath, overwrite = TRUE)
        }

        ## Copy all relevant files and packages to the local binary mirror:
        if((!install.only) && (!check.only)){
            brandnewzip <- sub("\\.tar\\.gz$", ".zip", brandnew)
            for(i in brandnewzip){
                file.copy(i, windir, overwrite = TRUE)
            }
        }
    }


    ## (Re)moving "oldzip" packages 
    if((!check.only) && (!rebuild) && (!recursiveChecks) && length(oldzip)){
        oldzip.split <- sapply(strsplit(oldzip, "_"), "[", 1)
        oldzip.split <- oldzip.split %in% 
            c(donotcompile, notOnWindows, notThisRversion, if(length(brandnew)) packages[status == "ERROR"])
        for(i in seq(along = oldzip)){
            if(!oldzip.split[i]){
                unlink(file.path(windir, oldzip[i], fsep = "\\"))
            }
        }
    }

    ## Determine existing packages and remove outdated leftovers:
    packages <- dir(windir, pattern = "\\.zip$")
    if(length(packages)){
        pck <- strsplit(unlist(strsplit(packages, "\\.zip$")), "_")
        pcknames <- sapply(pck, "[", 1)
        pckvers <- sapply(pck, "[", 2)
        pcknamesd <- unique(pcknames[duplicated(pcknames)])
        for(i in pcknamesd){
            pckv <- pckvers[pcknames %in% i]        
            pckv <- compareVersion(pckv[1], pckv[2])
            package <- packages[pcknames %in% i][-pckv]
            unlink(file.path(windir, package, fsep = "\\"))

        }
    }
    if((!install.only) && (!check.only) && (rebuild || length(brandnew) || (exists("oldzip") && length(oldzip)))){
        ## Write a new PACKAGES file
    if(maj.version > "3.3")
        write_PACKAGES(dir = windir, fields = fields, type = "win.binary", rds_compress = "xz")
    else
        write_PACKAGES(dir = windir, fields = fields, type = "win.binary")
        
                
    }      

    shell("rm -f *.zip *.tar.gz") # clean up
#    for(i in dir(pattern="\\.lib$")) 
#        system(paste("cmd /c rd", i), show.output.on.console=FALSE)
        
    ## Finally, let's get the Info file by e-mail
    if(length(readLines(Infofile)) > 3)
        subject <- paste("CRANpkgAUTO", maj.version, "OK", if(recursiveChecks) "recursive", sep=".")
    else
        subject <- paste("CRANpkgAUTO", maj.version, "ignore", if(recursiveChecks) "recursive", sep=".")

    if(recursiveChecks || check.only || install.only || rebuild)
        return(NULL)

    touchedPackages <- unique(sapply(strsplit(c(old, brandnew), "_"), "[", 1))
    if(!length(touchedPackages)) 
        return(NULL)

    return(tools:::dependsOnPkgs(touchedPackages, recursive = TRUE,
            dependencies = c("Depends", "Imports", "Suggests", "LinkingTo"), #"Enhances"
            installed = cranpackages))
}


writeInfofilePart <- function(Infofile, header, contents){
    write(c(" ", header, paste(rep("=", nchar(header)), collapse=""), contents), 
          file = Infofile, append = TRUE)        
}


scanExclusion <- function(exclusion, comment.char = "#"){
    if(file.exists(exclusion))
        scan(exclusion, what = character(0), comment.char = comment.char) 
    else ""   
}


p.local <- function(){
## Function, looking for source packages and their version numbers
##  in local CRAN mirror
    files <- dir()
    files <- files[grep("\\.tar\\.gz$", files)]
    if(length(files)){
        splitted <- strsplit(files, "_")
        packages <- sapply(splitted, "[", 1)
        versno <- unlist(strsplit(sapply(splitted, "[", 2), "\\.tar\\.gz$"))
        temp <- order(packages) # need Unix sorting for later CRAN comparisons
        return(list(packages = packages[temp], versno = versno[temp]))
    }else return(NULL)
}
    


writeCheckMakefile <- function(pkgnames0, libdir, flags, npar=8){
    if(length(pkgnames0)){
        write(c(paste("PKG :=", paste(pkgnames0, collapse = "\\\n")),
                      "PKG_CHECK := $(PKG:=.Rcheck/00check.log)",
                      "all: $(PKG_CHECK)",
                      "%.Rcheck/00check.log: %",
                paste("\tMAKE=make MAKEFLAGS= R -f check.R --vanilla --quiet --args", 
                          flags,
                          gsub("\\\\", "/", libdir), 
                          "$< R_default_packages=NULL")),
            file = "Makefile")
        shell(paste("make -k -j", npar, sep=""), invisible = TRUE)
    }
}



removeWARNINGSfromLog <- function(instlog){
    inst <- readLines(instlog)
    instrm1 <- grep("^ cannot update HTML package index$", inst)
    instrm2 <- grep("^  cannot create file .*packages.html', reason 'Permission denied'$", inst)
    instrm3 <- grep("^make.... warning. jobserver unavailable. using -j1.  Add ... to parent make rule.$", inst)
    instrm4 <- grep("^...In file.create.f.tg...$", inst)
    instrm5 <- grep("^...In tools...win.packages.html..Library...$", inst)
    instrm5 <- c(instrm1, instrm2, instrm3, instrm4, instrm5)
    instrm <- instrm5 - 1
    instrm1 <- grep("^Warning message", inst[instrm])
    instrm <- c(instrm5, instrm[instrm1])
    if(length(instrm)) inst <- inst[-instrm]
    writeLines(inst, con=instlog)
}



Rdepends <- function(Depends)
{
    if(is.na(Depends)) 
        return(TRUE)
    deps <- tools:::.split_dependencies(Depends)
    if("R" %in% names(deps)) {
        deps <- deps["R" == names(deps)]
        names(deps) <- NULL
    } else return(TRUE)
    status <- 0
    current <- getRversion()
    for(depends in deps) {
        if(length(depends) > 1L) {
            if(depends$op %in% c("<=", ">=", "<", ">", "==", "!="))
                status <- !do.call(depends$op,
                                   list(current, depends$version))
            if(status != 0) 
                return(FALSE)
        }
    }
    TRUE
}

   
   
CRANemail <- function(package, packagename, tempstatus, 
                      maj.version, mailfile = "mailfile.tmp",
                      email, checklog, donotnotify){

    ## package maintainer's e-mail address
    maintainer <- packageDescription(packagename, getwd(), fields = "Maintainer")
    maintainer <- if(is.na(maintainer)) email else 
        strsplit(strsplit(maintainer, "<")[[1]][2], ">")[[1]][1]

    if(tolower(maintainer) %in% tolower(donotnotify))
        maintainer <- email

    ## generate text
    write(c(
        #if(tempstatus == "ERROR" && maj.version!="3.0") maintainer,
        if(tempstatus == "ERROR") maintainer,
        "Dear package maintainer,", " ",
        "this notification has been generated automatically.",
        switch(tempstatus,
            "ERROR" = c(paste("Your package", package, "did *not* pass 'R CMD check' on"),
                "Windows and will be omitted from the corresponding CRAN directory."),
            "WARNING" = c(paste("Your package", package, "did pass 'R CMD check' only with WARNING(s).")),
            c(paste("Your package", package, "has been built for Windows and"),
                "will be published within 24 hours in the corresponding CRAN directory.")
        ),
        #paste("(CRAN/bin/windows/contrib/", maj.version, "/).", sep = ""),
        if(tempstatus == "ERROR")            
            c("Please check the attached log-file and submit a version",
            "with increased version number that passes R CMD check on Windows."),
#################
#        if(tempstatus %in% c("WARNING", "ERROR") && maj.version=="3.0")
#            c("", "Please note that we are talking about R-3.0.0 prerelease",
#              "(not the current release R-2.15.3).",
#              "R-3.0.0 will be released on April 3.",
#              "",
#              "Please submit a fixed version without any ERROR or WARNING",
#              "by March 22, otherwise your package will be archived.",
#              "",
#              "For details (and for results on other platforms) see",
#              "https://cran.r-project.org/web/checks/check_summary.html",
#              "",
#              "Please read and follow the CRAN policies",
#              "(https://cran.r-project.org/web/packages/policies.html)."),
#################
        R.version.string,
        "", 
        "All the best,", 
        "Uwe Ligges", 
        "(Maintainer of binary packages for Windows)"),
        file = mailfile)

    ## send
    shell(paste("blat mailfile.tmp",
            "-to", if(tempstatus == "ERROR") email else maintainer, 
            #maintainer,
            "-cc", email, 
            '-subject "Package', package,
            switch(tempstatus,
                "ERROR" = paste('did not pass R CMD check"', '-attacht', checklog),
                "WARNING" = paste('has been built for Windows - with a WARNING"', '-attacht', checklog),
                paste('has been built for Windows"')
            ),
            "-f", email))
}
