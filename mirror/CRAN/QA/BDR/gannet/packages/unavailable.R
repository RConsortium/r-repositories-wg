#chooseBioCmirror(ind=1)
setRepositories(ind=c(1:4))
av <- row.names(available.packages())
av <- c(av, 'INLA', 'XMLRPC')
## BioC 3.10 not in 3.11
#av <- c(av, 'Heatplus','missMethyl', 'oligo', 'oligoClasses', 'topGO', 'ArrayExpress', 'pdInfoBuilder')
av <- c(av, tools:::.get_standard_package_names()$base)
inst <- row.names(installed.packages(.libPaths()[1]))
ex <- setdiff(inst, av)
if(length(ex) > 500) q()
if(length(ex)) {
    message ("removing ", paste(sQuote(ex), collapse =" "))
    remove.packages(ex, .libPaths()[1])
    paths <- c(file.path("~/R/packages/*", ex),
	       file.path("~/R/test-*", ex),
               file.path("~/R/packages/*", paste0(ex, ".in")),
               file.path("~/R/packages/*", paste0(ex, ".out")),
	       file.path("~/R/packages/*", paste0(ex, ".log")),
               file.path("~/R/packages/*", paste0(ex, ".Rcheck")))
    unlink(Sys.glob(paths), recursive = TRUE)
}
