setRepositories(ind = 1)
av <- row.names(available.packages())
inst <- row.names(installed.packages(.libPaths()[1]))
extra <- setdiff(inst, av)
library(tools)
foo <- lapply(extra, function(p) dependsOnPkgs(p, 'all', F))
names(foo) <- extra
unused <- names(Filter(function(x) !length(x), foo))
unused
