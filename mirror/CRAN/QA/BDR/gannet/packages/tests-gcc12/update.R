foo <- dir('/data/ftp/pub/bdr/gcc11', patt="[.](log|out)")
foo <- unique(sub("[.](log|out)", "", foo))
unlink(paste0(foo, '.*'))
