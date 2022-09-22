ex <- dir("/data/ftp/pub/bdr/noOMP", patt = "[.]log")

for(f in ex) {
    if(!file.exists(f)) next
    lines <- readLines(f)
    if(!any(grepl("ERROR:", lines, useBytes = TRUE))) {
        message("removing ", f)
        unlink(file.path("/data/ftp/pub/bdr/noOMP", f))
    }
}

ex <- dir("/data/ftp/pub/bdr/noOMP", patt = "[.]out")

for(f in ex) {
    if(!file.exists(f)) next
    lines <- readLines(f)
    if(!any(grepl("Status.*ERROR", lines, useBytes = TRUE))) {
        message("removing ", f)
        unlink(file.path("/data/ftp/pub/bdr/noOMP", f))
    }
}

