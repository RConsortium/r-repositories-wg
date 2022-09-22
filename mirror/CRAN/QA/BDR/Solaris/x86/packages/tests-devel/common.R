source("../stoplist.R")

## gfortran
gcc <- c("glasso", "glmnet")

## C++ linkage
gcc <- c(gcc, "RProtoBuf", "V8", "magick", "rgdal", "sf")

gcc <- c(gcc, "Rcpp") # packages LinkingTo it automatically use gcc

## compile stan models
gcc <- c(gcc, "BANOVA", "prophet")

gcc <- c(gcc,
         "BayesFM", # CC gives compilation error
         "DMMF", # f95 gives a compilation error
         "LibOPF",
         "PhyloMeasures", # CC gives compilation error
         "QCA", # segfaults with cc
         "RandomFields", "RandomFieldsUtils",
         "RGtk2", # OpenCSW headers
         "RcppSimdJson", # needs C++17
         "Rrdrand", # segfaults
         "RcppParallel", # stated requirement
	 "bayesSurv", "smoothSurv", # Scythe issues
         "bigalgebra", # munmap in BH
         "dbarts",
         "deSolve", # installs with CC but changes results
	 "duckdb",
         "float", # linked to by rsparse which uses gcc
         "freetypeharfbuzz", # Error: Narrowing conversion
         "fs",
         "gwsem", # ropey C++
         "jqr", # syntax error in libjq C header
	 "libgeos", # does not compile with CC
	 "libproj",
	 "lmSubsets", # does not compile with CC
	 "ribiosUtils",
         "rgeos", # compiles with CC but does not work
         "rzmq", # configure fails, no explanation
         "sass",
         "seqminer", # nunmap
	 "stringi", # fewer issues, e.g. in quanteda
         "subprocess", # does not compile with CC
         "symengine", # ditto
         "tgstat",
	 "tidyr", "vroom", ## cpp11
         "tuneR", # inline gcc-style asm in C
         "xgboost"
         )

stoplist <- c(stoplist, "beadplexr", "cyanoFilter", "flowDiv") # RProtoBufLib woes

Sys.setenv("OPENSSL_INCLUDES" = "/opt/csw/include", CURL_INCLUDES = "/opt/csw/include", "V8_INCLUDES" = "/opt/csw/include")

av <- function()
{
    ## setRepositories(ind = 1) # CRAN
    options(available_packages_filters =
            c("R_version", "OS_type", "CRAN", "duplicates"))
    av <- available.packages(contriburl = CRAN)[, c("Package", "Version", "Repository")]
    av <- as.data.frame(av, stringsAsFactors = FALSE)
    path <- with(av, paste0(Repository, "/", Package, "_", Version, ".tar.gz"))
    av$Repository <- NULL
    av$Path <- sub(".*contrib/", "../contrib/", path)
    av$mtime <- file.info(av$Path)$mtime
    names(av) <- c("name", "Version", "path", "mtime")
    av[order(av$name), ]
}
