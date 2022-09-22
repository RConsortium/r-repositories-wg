foo1 <- row.names(available.packages())
foo2 <- row.names(installed.packages(.libPaths()[1]))
extra <- setdiff(foo2, foo1)
res <- lapply(extra, tools::dependsOnPkgs,
             c("Depends", "Imports", "LinkingTo", "Suggests"),
	     recursive = FALSE)
names(res) <- extra
str(res)
