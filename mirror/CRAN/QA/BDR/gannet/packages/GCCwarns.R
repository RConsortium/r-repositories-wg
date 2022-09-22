getWarns <- function()
{
    foo <- system("gcc -Q --help=warning", intern = TRUE)
    foo <- foo[grepl("-W", foo)]
    foo <- sub("^ *", "", foo)
    foo <- sub(" .*", "", foo)
    foo <- sub("[=<].*", "", foo)
    unique(foo)[-1]
}

foo  <- getWarns()

checkOne <- function(w)
{
  cmd <- sprintf("clang %s -c foo.cc", w)
  res <- system2("clang", c(w, "-c foo.cc"), stdout = TRUE, stderr = TRUE)
  any(grepl("-Wunknown-warning-option", res))
}

foo3 <- foo[sapply(foo, checkOne)]
writeLines(deparse(foo3), stdout())

