checkSummaryWin <- function(
        src = "d:\\Rcompile\\CRANpkg\\sources",
        cran = "cran.r-project.org",
        cran.url = "/src/contrib",
        checkLogURL = "./",
        windir = "d:\\Rcompile\\CRANpkg\\win",
        donotcheck = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotCheck",
        donotchecklong = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotCheckLong",
        donotcheckvignette = "d:\\Rcompile\\CRANpkg\\make\\config\\DoNotCheckVignette",
        maj.version = "3.2",
        maj.names = NULL){

    require("xtable")
    Sys.setlocale("LC_COLLATE", "C")

    maintainer <- sapply(strsplit(maintainers(src), " <"), "[", 1)
    maintainer <- data.frame(Package = names(maintainer), Maintainer = maintainer)
    
    cran.url <- paste("https://", cran, cran.url, sep="")
    if(is.null(maj.names)) maj.names <- maj.version
    fields <- c("Package", "Priority")
    globalcon <- url(file.path(cran.url, "PACKAGES"))
    global <-  read.dcf(globalcon, fields = fields)
    close(globalcon)

    donotcheck <- 
        if(file.exists(donotcheck)) 
            scan(donotcheck, what = character(0)) 
        else ""
    global[global[,1] %in% donotcheck, 2] <- "[--install=fake]"

    donotchecklong <- 
        if(file.exists(donotchecklong)) 
            scan(donotchecklong, what = character(0)) 
        else ""
    global[global[,1] %in% donotchecklong, 2] <- "[--no-examples --no-tests --no-vignettes]"

    donotcheckvignette <- 
        if(file.exists(donotcheckvignette)) 
            scan(donotcheckvignette, what = character(0)) 
        else ""
    global[global[,1] %in% donotcheckvignette, 2] <- "[--no-vignettes]"
    
    for(i in maj.version){
        pstatus <- read.table(file.path(windir, i, "Status", fsep = "\\"), 
            as.is = TRUE, header = TRUE)[,c(1,3,4,5)]
        names(pstatus)[1:2] <- c("Package", i)
        idx <- which(pstatus[, 2] %in% c("ERROR", "WARNING"))
        pstatus[idx, 2] <- paste('<a href=\"', checkLogURL, i, "/check/",
              pstatus[idx, 1], '-check.log\">',
              pstatus[idx, 2], "</a>", sep = "")
        srcdir <- dir(file.path(src, i), pattern="[.]tar[.]gz$")
        pinfo <- matrix(
            unlist(strsplit(sub(".tar.gz", "", srcdir), "_")), , 2, byrow = TRUE)
        colnames(pinfo) <- c("Package", "Version")
        pinfo <- as.matrix(merge(pinfo, pstatus[,1:2], all = TRUE))
        idx <- which(is.na(pinfo[, i]))
        pinfo[idx, i] <- paste('<a href=\"', checkLogURL, i, 
            '/ReadMe\">ReadMe</a>', sep = "")
        if(exists("results")) 
            results <- as.matrix(
                merge(results, pinfo, by = c("Package", "Version"), all = TRUE))
        else results <- pinfo
    }
    results <- as.matrix(merge(results, global, by = "Package", all.x = TRUE))
    results <- as.matrix(merge(results, pstatus[,c(1,3,4)], by = "Package", all.x = TRUE))
    results <- as.matrix(merge(results, maintainer, by = "Package", all.x = TRUE))

    results <- results[ , 
        c("Package", "Version", "Priority", "Maintainer", maj.version, "insttime", "checktime")]
    colnames(results) <- c("Package", "Version", "Priority / Comment", "Maintainer", 
                            maj.names, "Inst. timing", "Check timing")
    results <- rbind(results, c("SUM", "in hours (!)", "", "", rep("", length(maj.version)),
        paste(round(sum(as.numeric(results[,ncol(results)-1]), na.rm = TRUE)/3600, 2), "/ 16"),
        paste(round(sum(as.numeric(results[,ncol(results)]), na.rm = TRUE)/3600, 2), "/ 16")))

    outfile <- file.path(windir, "checkSummaryWin.html", fsep = "\\")
    out <- file(outfile, "w")
    writeLines(c('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
            "<html><head>", 
            "<title>CRAN Windows Binaries' Package Check</title>", "</head>",
            "<body>", paste("<h1>CRAN Windows Binaries' Package Check</h1>", sep=""),
            paste("<p> Last updated on", format(Sys.time()), "</p>"),
            '<p>You can make use of the facilities provided at 
                <a href="https://win-builder.r-project.org/">https://win-builder.r-project.org/</a>
                in order to build and check versions of your package under recent 
                versions of R for Windows. </p>',
            '<p>The binaries are compiled and checked on a Supermicro machine equipped with 2x Intel Xeon E5-2670 (8 cores each), 2.6 GHz, 32Gb RAM, running Microsoft Windows Server 2008 64-bit Standard.</p>'), 
        out)
    print(xtable(results, align = rep(c("r", "l", "r"), c(1, 4 + length(maj.version), 2))), 
        type = "html", file = out, append = TRUE, sanitize.text.function = function(x) x)
    writeLines(c("</body>", "</html>"), out)
    close(out)
    return("finished!")
}
