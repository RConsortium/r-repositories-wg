if(getRversion() >= "2.7.0") {
    setHook(packageEvent("grDevices", "onLoad"),
            function(...) {
                grDevices::X11.options(type = "Cairo")
            })
} else {
    options(X11colortype = "pseudo.cube")
}
