options(warn = 1L)
dest <- "/data/ftp/pub/bdr/BLAS"
files <- dir(patt = "[.]out$")
for(f in files) {
   d <- file.path(dest, f)
   if(any(grepl("R_ext/(BLAS|Lapack)[.]h", readLines(f), useBytes = TRUE)))
	file.copy(f, dest, overwrite = TRUE, copy.date = TRUE)
   else if (file.exists(d)) {
	   message("removing ", f)
	   file.remove(d)
   }
}


