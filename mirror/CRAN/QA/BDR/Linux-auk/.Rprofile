options(show.signif.stars=FALSE)
setHook(packageEvent("grDevices", "onLoad"),
        function(...) {
            grDevices::ps.options(horizontal=FALSE)
        })
set.seed(1234)
#options(repos=c(CRAN="http://cran.r-project.org"))
options(repos=c(CRAN="file:///home/ripley/R"))
#options(BioC_mirror="http://bioconductor.statistik.tu-dortmund.de")
options(BioC_mirror="http://mirrors.ebi.ac.uk/bioconductor/")
options(Ncpus=8)

{
if(getRversion() >= "3.4.0") .libPaths(c("~/R/test-3.4"))
else if(getRversion() >= "3.3.0") .libPaths(c("~/R/test-3.3"))
else .libPaths(c("~/R/test-3.2"))
}
