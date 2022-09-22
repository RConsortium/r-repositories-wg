X <- read.table("d:/RCompile/CRANpkg/win/3.6/Status", header=TRUE)
failing <- as.character(X[X[,3] %in% c("WARNING", "ERROR"),1])
setwd("d:/RCompile/CRANpkg/sources/3.6")
here <- list.files(pattern="[.]tar[.]gz$")
name <- sapply(strsplit(here, "_"), "[", 1)
failing2 <- paste(here[name %in%failing], collapse = " ")
system(paste("rm", failing2))



# here <- list.files(pattern="[.]tar[.]gz$")
#buildcommand <- 
#  paste("Rcmd INSTALL --build -l", "d:/RCompile/CRANpkg/lib/2.4")
#for(temp in here) 
#    system(paste(buildcommand, temp, ">", 
#        paste(temp, "-install.out", sep = ""), "2>&1"), invisible = TRUE)
#
#for(temp in here) {
#instoutfile <- paste("d:\\RCompile\\", temp, "-install.out", sep = "")
#temp <- strsplit(temp, "_")[[1]][1]
#checklog <- file.path(paste(temp, ".Rcheck", sep = ""), "00check.log", fsep = "\\")
#checkerror <- system(paste('Rcmd check --install="check:', 
#    instoutfile, '" --library="', "d:/RCompile/CRANpkg/lib/2.4", '" ', temp, sep = ""), 
#    invisible = TRUE)
#}
