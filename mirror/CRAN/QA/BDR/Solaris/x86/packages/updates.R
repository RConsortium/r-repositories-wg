stoplist <- c("rggobi", "PKgraph", "beadarrayMSV", "SeqGrapheR",
              "demi", # oligo
      "Rcell", "RockFab", "gitter", # EBImage
      "MSeasy", "MSeasyTkGUI",
      "RMySQL", "TSMySQL", "dbConnect", "Causata", 
      "BRugs","CARramps", "CARrampsOcl", "GridR", "OpenCL",
      "RBerkeley", "RDieHarder", "RMark", "RMongo",  "ROAuth", "ROracle",
      "RProtoBuf", "RQuantLib", "RScaLAPACK", "Rcplex", "Rhpc",
      "Rmosek", "VBmix", "WideLM", "cmprskContin",
      "cplexAPI", "cudaBayesreg", "gputools", "gmatrix", "magma", "permGPU",
      "qtbase", "qtpaint", "qtutils", "rJavax", "rmongodb",
      "rpud", "rpvm", "rscproxy", "rzmq", "twitteR",
      "Rpoppler",
      "RcppOctave", "HiPLARM", "RAppArmor", "RSAP", "REBayes", "ora", "rLindo")

options(repos=c(CRAN="http://cran.r-project.org"))
#options(BioC_mirror="http://bioconductor.statistik.tu-dortmund.de")

setRepositories(ind=1)
update.packages(ask=FALSE)
new <- new.packages()
new <- new[! new %in% stoplist]
if(length(new)) install.packages(new)
