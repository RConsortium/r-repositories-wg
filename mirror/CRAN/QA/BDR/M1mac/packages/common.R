stoplist <-
    c(
      "permGPU", 'kmcudaR',
      ## need x86
      "BRugs", "Rrdrand",
      ## external tools
      "RMark",
      "ROracle", "ora",
      "Rblpapi",
      "Rcplex", "ROI.plugin.cplex",
      "RcppMeCab", "RmecabKo",
#      "Rpoppler", # poppler-glib
      "caRpools", # MAGeCK
      "gcbd",
      "localsolver",
      "rcrypt",   # GnuPG
      'ingres',
      'rrd') # needs rrdtool libraries


ban <- c("N2R", 'sccore', 'leidenAlg', 'pagoda2', 'conos')

stoplist <- c(stoplist, ban)

noinstall <- c(readLines('~/R/packages/noinstall'))
