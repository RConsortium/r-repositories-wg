save_results <- function(maj.version, windir = "d:\\Rcompile\\CRANpkg\\win"){
    windir <- file.path(windir, maj.version, fsep="\\")
    if(!file.exists(windir)) shell(paste("mkdir", windir))
    statusdir <- file.path(windir, "stats", fsep="\\")
    if(!file.exists(statusdir)) shell(paste("mkdir", statusdir))
    file.copy(file.path(windir, "Status"), file.path(statusdir, paste("Status", Sys.Date(), sep="_")), overwrite=TRUE)
}


check_results_diffs <- function(maj.version, date.new = Sys.Date(), 
                                date.old = Sys.Date()-1, 
                                windir = "d:\\Rcompile\\CRANpkg\\win", 
                                flavor = "devel"){
    library("utils")
    windir <- file.path(windir, maj.version, fsep="\\")
    statusdir <- file.path(windir, "stats", fsep="\\")
    stats.new <- read.table(file.path(statusdir, paste("Status", date.new, sep="_")), header=TRUE, as.is=TRUE)[,1:3]
    stats.old <- read.table(file.path(statusdir, paste("Status", date.old, sep="_")), header=TRUE, as.is=TRUE)[,1:3]    
    stats <- merge(stats.new, stats.old, by = "packages", all = TRUE)
    names(stats) <- c("packages", "V_New", "S_New", "V_Old", "S_Old")
    nas <- is.na(stats$S_New == stats$S_Old)
    stats$S <- ifelse(nas | (stats$S_New != stats$S_Old), "*", "") 
    stats$V <- ifelse(nas | (stats$V_New != stats$V_Old), "*", "") 
    stats <- stats[stats$S=="*" | stats$V=="*", c(1,6,7,5,3,4,2)]
    nas <- is.na(stats$S_New == stats$S_Old)
    stats1 <- stats[!nas,]
    stats <- rbind(stats1[stats1$S=="*" & stats1$V=="", ], 
                   stats1[stats1$S=="*" & stats1$V=="*", ], 
                   stats[is.na(stats$S_New), ], 
                   stats[is.na(stats$S_Old), ],
                   stats1[stats1$S==""  & stats1$V=="*", ])
#    stats <- stats[order(stats[,2], stats[,3]), ]
#    stats <- rbind(stats[is.na(stats$S_New),], stats[is.na(stats$S_Old),], stats[!nas,])

    URLs <- if(sum(stats$S=="*")) 
               paste(stats[stats$S=="*",1], " (", stats[stats$S=="*",4], " -> ", stats[stats$S=="*",5], "): ", 
                     "http://www.r-project.org/nosvn/R.check/r-", flavor, "-windows-ix86+x86_64/", stats[stats$S=="*",1], "-00check.html", sep="")
            else ""
    stats <- capture.output(print(stats, row.names = FALSE, right = FALSE))
    stats <- gsub(" *$", "", gsub("^ *", "", stats))
    stats <- c(stats, "", "##LINKS:", URLs)
    writeLines(text = stats, con = file.path(statusdir, paste("checkdiff-", date.new, "-", date.old, ".txt", sep="")))
}

send_checks <- function(maj.version, date.new = Sys.Date(), date.old = Sys.Date()-1, 
                        windir = "d:\\Rcompile\\CRANpkg\\win", 
                        send_external = Sys.getenv("Kurt") == "Kurt"){
    svnversion <- try(shell("svn info d:\\RCompile\\recent\\R-devel", intern=TRUE))
    if(inherits(svnversion, "try-error")) svnversion <- NA
    else svnversion <- strsplit(grep("^Revision: ", svnversion, value=TRUE), " ")[[1]][2]
    
    shell(paste("blat ", windir, "\\", maj.version, "\\stats\\checkdiff-", date.new, "-", date.old, ".txt ", 
        "-to ligges@statistik.tu-dortmund.de", 
        if(send_external) " -cc Kurt.Hornik@R-Project.org,Martin.Maechler@R-project.org", 
        " -subject checkdiffs_", maj.version,
        "_svn_", svnversion, "_", date.old, "_", date.new, " -f ligges@statistik.tu-dortmund.de", sep=""))
        
#    packages <- sapply(strsplit(readLines(paste(windir, "\\", maj.version, "\\stats\\checkdiff-", date.new, "-", date.old, ".txt", sep="")), " "), "[", 1)[-1]
#    if(packages == "<0") return("no packages")
#           
#    shell(paste("blat ", windir, "\\", maj.version, "\\stats\\checkdiff-", date.new, "-", date.old, ".txt ", 
#        "-to ligges@statistik.tu-dortmund.de", 
#        if(send_external) " -cc Kurt.Hornik@R-Project.org", #,Martin.Maechler@R-project.org", 
#        " -subject checkdiffs_", maj.version,
#        "_svn_", R.version[["svn rev"]], "_", date.old, "_", date.new, " -f ligges@statistik.tu-dortmund.de", sep=""))
}


#check_results_diffs("3.0", date.new = Sys.Date()-1, date.old = Sys.Date()-2, windir = "z:\\Rcompile\\CRANpkg\\win")
#check_results_diffs("2.15", date.new = Sys.Date(), date.old = Sys.Date()-26, windir = "z:\\Rcompile\\CRANpkg\\win")
