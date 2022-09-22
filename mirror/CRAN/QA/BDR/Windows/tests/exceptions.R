stoplist <-
    c(# recommended
      "KernSmooth", "MASS", "Matrix", "boot", "class", "cluster",
      "codetools", "foreign", "lattice",  "mgcv", "nlme", "nnet",
      "rpart", "spatial", "survival",
# Missing external software
      "CARrampsOcl", "OpenCL", "RcppOctave", "RDieHarder", "RMongo",
      "ROAuth", "ROracle", "RSAP", "Rcplex", "RcppRedis", "cplexAPI", "gpuR",
      "localsolver", "ora", "rLindo", "rmongodb", "rzmq",
      "CARramps", "HiPLARM", "WideLM", "cudaBayesreg", "gmatrix", "gputools",
      "iFes", "magma", "permGPU", "rpud", # cuda
      "qtbase", "qtpaint", "qtutils", "ProgGUIinR", # qt
      "bcool", "doRNG", "simsalapar", # mpi
      "Rmosek", "REBayes", # "cqrReg",
      "nFCA", # Ruby
#      "rchallenge", # pandoc
      "maGUI", "deconstructSigs", # too many BioC deps
# Unix-only (and undeclared)
      "OmicKriging", "PopGenome", "RProtoBuf", "Rdsm",
      "SGP", "cit", "doMC", "fdasrvf", "gemmR", "gpmap",
      "JAGUAR", "PAGWAS", "dcGOR", "ptycho", # doMC
# don't work
      "excel.link", # RDCOMClient
      "RWinEdt", # needs Rgui
      "rJavax", # horrible Java things
      "SACOBRA", "Storm", # runs forever
      "caRpools", "nbconvertR", "Rblpapi", "switchr", "switchrGist", "rcrypt",
      "parallelize.dynamic", "translate", "RCMIP5"
      )

biarch <- c("PKI", "RSclient", "R2SWF", "compLasso", "icd9")

multi <- c("BayesXsrc", "C50", "Cairo", "Cubist", "FastRWeb", "GWAtoolbox",
           "JavaGD", "RCA", "RCurl", "RInside", "RJSONIO", "RMySQL",
           "RPostgreSQL", "Rserve", "Rssa", "RxODE", "SWATmodel", "dbarts",
           "excursions", "gaselect", "jsonlite", "maps", "ore",
           "rJava", "rgl", "tth")

extras <- c("XMLRPC", "yags", "INLA")
