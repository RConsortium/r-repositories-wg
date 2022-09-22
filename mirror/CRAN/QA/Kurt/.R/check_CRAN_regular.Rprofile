if(getRversion() >= "2.7.0") {
    setHook(packageEvent("grDevices", "onLoad"),
            function(...) {
                grDevices::X11.options(type = "Cairo")
            })
} else {
    options(X11colortype = "pseudo.cube")
}

## See check_repository_URLs() in check_CRAN_regular.R.
local({
    if(nzchar(s <- Sys.getenv("_CHECK_CRAN_REGULAR_REPOSITORIES_"))) {
        s <- unlist(strsplit(s, "[=;]"))
        ind <- as.logical(seq_along(s) %% 2L)
        repos <- s[!ind]
        names(repos) <- s[ind]

        options(repos = repos)
    }
})

## Maximally possible truncation limit for error and warning messages:
options(warning.length = 8170)

## Timeout for cURL et al in seconds (default: 60).
options(timeout = 10)

options(stringsAsFactors = FALSE)
