library("tools")
maj.version <- Sys.getenv("maj.version")
maj.version <- unlist(strsplit(maj.version, "\\+"))
fields <- c("Package", "Priority", "Version", 
            "Depends", "Suggests", "Imports", "Contains", "Enhances", "LinkingTo", "Archs")
for(i in maj.version){
    windir <- file.path("d:\\Rcompile\\CRANpkg\\win", i, fsep="\\")
    if(i > "3.3")
        write_PACKAGES(dir = windir, fields = fields, type = "win.binary", rds_compress = "xz")
    else
        write_PACKAGES(dir = windir, fields = fields, type = "win.binary")    
}

#windir <- "d:\\Rcompile\\CRANpkg\\win64\\2.13"
#write_PACKAGES(dir = windir, fields = fields, type = "win.binary")
