## parallel will not work as make is involved
foo <- row.names(installed.packages(.libPaths()[1]))

setRepositories(ind = c(2:4, 7))
foo2 <- row.names(available.packages())
foo <- intersect(foo, foo2)
foo <- setdiff(foo, c("RCurl", "RJSONIO", "XML", "muscle")) # Omegahat duplicates

Sys.setenv(DISPLAY = ':5', MAKE = 'gmake')

gcc <- c("ChemmineR", "DESeq2", "GOSemSim", "RBGL", "Rdisop", "Rgraphviz", "Rsamtools", "ShortRead", "affxparser", "edgeR", "flowCore", "flowWorkspace", "ncdfFlow", "pcaMethods", "qpgraph", "rtracklayer", "survcomp")
gcc <- c(gcc, "GLAD", "ShortRead", "minet")

foo <- setdiff(foo, gcc)

install.packages(foo, Ncpus = 1)
