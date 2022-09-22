source('../common.R')
## forensim infinite-loops in tcltk
## BayesXsrc was killed using 31Gb for a compile, rmatio 12.5GB
## mpMap2 uses over 1h CPU time
stoplist <- c(stoplist, 'sanitizers', 'BayesXsrc', 'crs', 'forensim', "rmatio",'mpMap2', 'icamix', 'fdaPDE', 'gllvm', 'glmmTMB')
## blavaan uses 10GB, ctsem 19GB, rstanarm 8GB
stan <- c(stan0, tools::dependsOnPkgs('StanHeaders',,FALSE))
stoplist <- c(stoplist, stan)
do_it(stoplist, TRUE)
