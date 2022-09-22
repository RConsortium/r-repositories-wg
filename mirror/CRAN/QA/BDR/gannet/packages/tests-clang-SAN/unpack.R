source('../common.R')
## forensim infinite-loops in tcltk
## pdc takes forever to compile
## RcppSMC used 60GB
stoplist <- c(stoplist, noclang, "sanitizers", "pdc", "forensim", "rcss", "RcppSMC")
do_it(stoplist, TRUE)
