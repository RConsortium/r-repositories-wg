options(timeout=300)
chooseBioCmirror(ind=1)
setRepositories(ind=2:4)
update.packages(.libPaths()[1], ask=F)
