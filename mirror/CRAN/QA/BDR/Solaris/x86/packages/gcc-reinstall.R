chooseBioCmirror(ind = 1)
setRepositories(ind = 2)
Sys.setenv(DISPLAY = ':5', MAKE="gmake", GREP = "ggrep")

options(timeout = 600)
source('BioCgcc.R')
install.packages(gcc, Ncpus=20)
