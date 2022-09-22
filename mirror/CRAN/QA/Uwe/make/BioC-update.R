Rver <- paste(strsplit(as.character(getRversion()), "\\.")[[1]][1:2], collapse=".")

BioCver <- switch(Rver,
    "3.7" = "3.9",
    "3.6" = "3.9",
    "3.5" = "3.8"
)

options(install.packages.check.source = "no")
options("install.packages.compile.from.source"="never")

options(BioC_mirror=list("Dortmund (Germany)"="http://bioconductor.statistik.tu-dortmund.de"))
options(repos = structure(c(
    file.path("http://bioconductor.statistik.tu-dortmund.de/packages", BioCver, "bioc"), 
    file.path("http://bioconductor.statistik.tu-dortmund.de/packages", BioCver, "data/annotation"), 
    file.path("http://bioconductor.statistik.tu-dortmund.de/packages", BioCver, "data/experiment"), 
    file.path("http://bioconductor.statistik.tu-dortmund.de/packages", BioCver, "extra")
), .Names = c("BioCsoft", "BioCann", "BioCexp", "BioCextra")))
op <- old.packages(type="binary")
op

repos=getOption("repos")
cu <- contrib.url(repos, "binary")
cu2 <- gsub("7$", 6, cu)
op <- old.packages(type="binary", contriburl=cu2)
update.packages(ask=FALSE, type="binary", contriburl=cu2)
 auf BioC:
cd /data/bioc/packages/3.9/bioc/bin/windows/contrib
ln -s 3.6 3.7


update.packages(ask=FALSE, type="binary")

options(repos = structure(c(
    file.path("http://bioconductor.statistik.tu-dortmund.de/packages", BioCver, "bioc")
), .Names = c("BioCsoft")))
np <- new.packages()
np

if(length(np)) install.packages(np)


###################

options(install.packages.check.source = "both")
options("install.packages.compile.from.source"="interactive")
op <- old.packages(type="binary")
op

update.packages(ask=FALSE)

np <- new.packages()
np

if(length(np)) install.packages(np)

#install.packages(c("RBGL", "mzR"), type="source", INSTALL_opts = "--merge-multiarch")
