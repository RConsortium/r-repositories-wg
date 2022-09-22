options(warn = 1L)
dest <- "/data/ftp/pub/bdr/LTO"
files <- dir(patt = "[.]out$")
for(f in files) {
   d <- file.path(dest, f)
   if(any(grepl("-W(lto|odr)", readLines(f), useBytes = TRUE)))
	file.copy(f, dest, overwrite = TRUE, copy.date = TRUE)
   else if (any(grepl("(lto-wrapper failed|plugin needed to handle lto object)", 
		      readLines(f), useBytes = TRUE)))
        file.copy(f, dest, overwrite = TRUE, copy.date = TRUE)
   else if (file.exists(d)) file.remove(d)
}


