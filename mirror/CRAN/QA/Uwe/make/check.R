foo <- function(temp){
    flags <- temp[1]
    lib <- temp[2]
    packagefile <- temp[3]
    temp <- strsplit(packagefile, "_")[[1]][1]
    pidtime <- paste(Sys.getpid(), format(Sys.time(), "%Y-%m-%d-%H-%M-%S"), temp, sep="_")
    filename <- file.path("d:/RCompile/CRANpkg/make/ps", pidtime)
    file.create(filename)
    
#    pkglib <- paste(temp, "lib", sep=".")
#    if(!file.exists(pkglib)) 
#        system(paste("cmd /c mkdir", pkglib))
#    load("depends_rec.RData")
#    requiredpkg <- unique(c(temp, depends_rec[[temp]]))
#
#    batchfile <- paste(temp, "libgen.bat", sep="_")
#    writeLines(paste("mklink /J", file.path(pkglib, requiredpkg, fsep="\\"), gsub("/", "\\\\", file.path(lib, requiredpkg))),
#        con = batchfile) 
#    system(paste("cmd /c", batchfile, "> NUL 2>&1"))
#    on.exit({
#        writeLines(paste("rd", file.path(pkglib, requiredpkg, fsep="\\")), con = batchfile) 
#        system(paste("cmd /c", batchfile, "> NUL 2>&1"))
#        file.remove(batchfile)
#        system(paste("cmd /c rd", pkglib, "> NUL 2>&1")) 
#    })
#
#    pkglibabs <- tools:::file_path_as_absolute(pkglib)
#    Sys.setenv(R_LIBS=pkglibabs)
#    lib <- pkglibabs

    systime <- system.time(
        checkerror <- system(paste('cmd /c R CMD check --library="',
                lib, if(as.numeric(R.version$minor) >= 15) '" --force-multiarch ' else '" --multiarch ',
                if(flags=="fake") '--install=fake --install-args=--pkglock ' else paste('--install="check:', temp, '-install.out" ', sep=""),
                if(flags=="time") '--no-examples --no-tests --no-vignettes ',
                if(flags=="novignette") '--no-vignettes ',
                if(flags=="fake") packagefile else temp, 
                sep = ""), 
            invisible = TRUE)
    )[3]

    write(as.logical(checkerror), file=paste(temp, ".error", sep=""))
    write(systime, file=paste(temp, ".time", sep=""))
    file.remove(filename)
}
foo(commandArgs(trailingOnly = TRUE))
