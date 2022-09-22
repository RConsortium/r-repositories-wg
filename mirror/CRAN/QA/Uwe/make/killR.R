killR <- function(minutes = 25, path = "d:/RCompile/CRANpkg/make/ps"){
    owd <- setwd(path)
    on.exit(setwd(owd))
    files <- list.files(path)
    if(!length(files)) 
        return("Nothing to do.")
    temp <- strsplit(files, "_")
    pids <- sapply(temp, "[", 1)
    pkg <-  sapply(temp, "[", 3)
    temp <- strptime(sapply(temp, "[", 2), "%Y-%m-%d-%H-%M-%S")
    temp <- difftime(Sys.time(), temp, units = "mins")
    temp <- which(temp > minutes)
    if(!length(temp)) 
        return("R is running in its limits, nothing to do.")
    for(i in temp){
        file.remove(files[i])
        system(paste("dc killchildren", pids[i]))
    }
    filename <- tempfile()
    writeLines(pkg[temp], con = filename)
    shell(paste("blat", filename, "-to Uwe.Ligges@R-Project.org -subject PSkilled -f Uwe.Ligges@R-Project.org"), 
            intern = TRUE)
}

killR(25)
