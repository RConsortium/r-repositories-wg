temp <- commandArgs(trailingOnly = TRUE)
lib <- temp[1]
temp <- temp[2]
pidtime <- paste(Sys.getpid(), format(Sys.time(), "%Y-%m-%d-%H-%M-%S"), temp, "guest", sep="_")
filename <- file.path("d:/RCompile/CRANpkg/make/ps", pidtime)
file.create(filename)
systime <- system.time(
    checkerror <- system(paste('cmd /c R CMD check --timings --force-multiarch ',
        '--install="check:', 
        temp, '-install.out" --library="', lib, '" ', temp, sep = ""), 
        invisible = TRUE)
)[3]
write(as.logical(checkerror), file=paste(temp, ".error", sep=""))
write(systime, file=paste(temp, ".time", sep=""))
file.remove(filename)
