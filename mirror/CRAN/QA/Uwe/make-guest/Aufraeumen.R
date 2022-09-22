setwd("c:/inetpub/wwwroot")
x <- file.info(list.files())
x <- x[x$isdir,]
timediff <- difftime(x$ctime, Sys.time(), units = "days")
old <- rownames(x[ceiling(as.numeric(timediff)) < -3,])
unlink(old, recursive = TRUE)
q("no")
