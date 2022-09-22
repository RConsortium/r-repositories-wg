options(warn = 1L)
dest <- "/data/ftp/pub/bdr/gcc11"
files <- dir(patt = "[.]log$")
for(f in files) {
   d <- file.path(dest, f)
   if(any(grepl("multiple definition of", readLines(f, warn = FALSE), useBytes = TRUE)))
	file.copy(f, dest, overwrite = TRUE, copy.date = TRUE)
   else if (file.exists(d) && !file.exists(sub("log", "out", d)) &&
	    any(grepl("multiple definition of", readLines(d, warn = FALSE), useBytes = TRUE)))
       file.remove(d)
}


