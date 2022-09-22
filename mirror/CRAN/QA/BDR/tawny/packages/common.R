stoplist <-
    c("BRugs",
      "ROracle", "RQuantLib", "ora",
      "Rcplex", "Rpoppler", "rLindo", "ROI.plugin.cplex", "cplexAPI",
      "localsolver", "permGPU", 'kmcudaR', "gpuR",
      "IRATER", # ADMB
      'mssqlR',
      'N2R', 'sccore', 'leidenAlg', 'pagoda2', 'conos', 'dendsort', 'gapmap',
      'cronR',
      ## memory issues
      'cbq', 'ctsem', 'pcFactorStan',
      ## hence
      "ctsemOMX", "CoTiMA",
      ## external tools
      "rcrypt",
      "RcppMeCab", "RmecabKo",
      "RMark", #"R2ucare", "multimark",
      "caRpools", # MAGeCK
      "rGEDI", # geotiff, szip
      'rrd', # need rrdtool libraries
      'tmuxr')

BH <- c("TDA", "TreeLS", "archiDART", "leafR", "lidR", "mapr", "pflamelet", "pterrace", "topsa","viewshed3d", "wicket")

noinstall <- c('dodgr', 'melt')

ex <- c('BayesVarSel', 'BullsEyeR', 'LDATS', 'textmineR',
         'textmining', 'tidytext', 'topicdoc', 'topicmodels', 'udpipe')

