#! /usr/local/bin/Rscript
p <- file.path("/home/ripley/R/packages/keep", Sys.Date())
dir.create(p)
setwd(file.path("/home/ripley/R/packages", "tests32"))
ff <- system("egrep 'Status.*(ERROR|WARN)' *.out", intern = TRUE)
ff <- sub(":.*$", "", ff)
fi <- file.mtime(ff)
ff <- ff[as.Date(fi) > Sys.Date() - 2]
junk <- file.copy(ff, p, copy.date = TRUE)
ff <- sub("out$", "log", ff)
junk <- file.copy(ff, p, copy.date = TRUE)
q()
p2 <- file.path("/home/ripley/R/packages/keep", Sys.Date() - 1)
z <- suppressWarnings(system(paste("diff -rs", p2, p),  intern = TRUE))
z <- grep("are identical$", z, value = TRUE)
z <- sub("Files ", "", z)
z <- sub(" and.*", "", z)

unlink(z)
