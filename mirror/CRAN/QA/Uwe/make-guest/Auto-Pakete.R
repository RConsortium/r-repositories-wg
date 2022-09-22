maj.version <- Sys.getenv("maj.version")
if(maj.version == "") stop("env.var maj.version is missing!!!")

flavour <- paste(
    "R", 
    switch(maj.version,
        "3.5" = "-oldrelease",
        "3.6" = "-release",
    "4.0gcc8" = "-devel_gcc8",
        "-devel"),
    sep = "")

source("d:/RCompile/CRANguest/make/CRANguest.R")
source("d:/RCompile/CRANguest/make/maintainers.R")

options(warn=1)

CRANguest(
    workdir = file.path("d:\\RCompile\\CRANguest", flavour, fsep="\\"),
    uploaddir = "C:\\Inetpub\\wwwroot",
    maj.version = maj.version,
    mailMaintainer = TRUE,
    email = "ligges@statistik.tu-dortmund.de")


q("no")
