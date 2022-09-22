temp <- commandArgs(trailingOnly = TRUE)
lib <- temp[1]
build <- temp[2]
scanExclusion <- function(exclusion, comment.char = "#"){
   if(file.exists(exclusion))
       scan(exclusion, what = character(0), comment.char = comment.char) 
   else ""   
}

doresavedata <- scanExclusion(temp[3])
dodatacompress <- scanExclusion(temp[4])


nomultiarch <- scanExclusion(temp[5])
mergemultiarch <- scanExclusion(temp[6])
forcebiarch <- scanExclusion(temp[7])



temp <- temp[8]
Rcall <- paste('cmd /c R CMD INSTALL --pkglock ', 
            #'--compact-docs '
            if(build=="build") '--build ' else ' ', 
            if(temp %in% doresavedata) '--resave-data ' else ' ',
            if(temp %in% dodatacompress) '--data-compress=xz ' else ' ',
            if(temp %in% nomultiarch) '--no-multiarch ' else ' ',
            if(temp %in% mergemultiarch) '--merge-multiarch ' else ' ',
            if(temp %in% forcebiarch) '--force-biarch ' else ' ',
            '--library="', lib, '" ', temp, 
            #if(temp %in% mergemultiarch) '_*.tar.gz ' else ' ',
            '_*.tar.gz ',
            '> ', temp, '-install.out 2>&1', sep = "")

systime <- system.time(system(Rcall, invisible = TRUE))[3]
write(systime, file=paste(temp, ".itime", sep=""))
