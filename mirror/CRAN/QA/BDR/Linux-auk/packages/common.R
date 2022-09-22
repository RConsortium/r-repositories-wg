stoplist <-
    c("HiPLARM", "RAppArmor", "RDieHarder",
      "REBayes", "RMark", "RMongo", "ROI.plugin.cplex", "ROracle", "RQuantLib",
      "RSAP", "Rcplex", "Rhpc", "Rmosek", 
      "cplexAPI", "cudaBayesreg", "gputools", "gmatrix", "magma", "ora",
      "permGPU", "rLindo", "sprint",
      "localsolver", "RcppAPT", "caRpools", "gpuR", "littler",
      "CARrampsOcl", "OpenCL", 'kmcudaR',
      "Boom", "BoomSpikeSlab", "bsts",
      "csp", # too much memory
      "rbi", "IRATER", "tesseract", "sybilSBML")

stoplist <- c(stoplist, 'BiplotGUI', 'MDSGUI', 'R2MLwiN', 'R2PPT', 'R2wd',
              'RPyGeo', 'RWinEdt', 'excel.link', 'installr')

noinstall <- c('kmcudaR', 'Rcriticor', 'ProjectionBasedClustering')
