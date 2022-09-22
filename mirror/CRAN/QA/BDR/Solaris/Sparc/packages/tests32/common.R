stoplist <- c("rggobi", "PKgraph", "beadarrayMSV", "clusterfly", "SeqGrapheR",
      "Rcell", "RockFab", "gitter", "metagear", "bioimagetools", "nucim", "ggimage", "autothresholdr", "hexSticker",# EBImage
      "MSeasy", "MSeasyTkGUI", "specmine", "CorrectOverloadedPeaks",
      "MetaSKAT", # little-endian only 
      "RMySQL", "TSMySQL", "dbConnect", "Causata", "compendiumdb", "wordbankr", "gmDatabase", "MetaIntegrator", "toxboot", "mdsr",
      "BRugs", "CARrampsOcl", "GridR", "OpenCL", "gpuR",
      "RBerkeley", "RDieHarder", "RMark", "RMongo", "ROracle",
      "RProtoBuf", "RQuantLib", "RVowpalWabbit", 
      "RcppRedis", "Rcplex", "ROI.plugin.cplex", "Rhpc", "RiDMC",
      "Rmosek", "VBmix", "cmprskContin",
      "cplexAPI", "cudaBayesreg", "gputools", "gmatrix", "magma", "permGPU",
      "qtbase", "qtpaint", "qtutils", "rmongodb", "rpvm",
      "Rpoppler", "Rsymphony", "ROI.plugin.symphony", "fPortfolio", "BLCOP",
      "RcppOctave", "HiPLARM", "RAppArmor", "RSAP", "REBayes", "ora", 
      "permGPU", "rLindo", "Rrdrand", "localsolver", "Boom", "BoomSpikeSlab",
      "bsts", "iFes", "rSPACE",  "nFCA", "RcppAPT", "multimark", "h5",
      "iptools", "caRpools", "Rblpapi", "PythonInR", "Goslate",
      "sodium", "maGUI", "homomorpheR", "littler", "rsvg", "deconstructSigs",
      "GiNA", "multipanelfigure", "gkmSVM", "ionicons",
      "miscF", "agRee", "PottsUtils",
      "Sky", "remoter", "redland", "pdftools", "pdfsearch", "textreadr", "goldi",
      "MonetDBLite", "rbi", "IRATER", "textTinyR",
      "datapack", "dataone", "recordr", "tcpl", "magick", "PharmacoGx", "gpg",
      "tesseract", "rlo", "enviGCMS", "sybilSBML",
      "corehunter", "msgtools", "ForestTools", "WebGestaltR", "rpg", "kerasR",
      "V8", "minimist", "js", "rjade", "daff", "muir", "lawn", "geojsonio", "repijson", "rgbif", "spocc", "spoccutils", "rchess", "mapr", "DiagrammeRsvg", "dagitty", "randomcoloR", "curlconverter", "DOT", "jsonvalidate", "geojsonlint", "rmapshaper", "uaparserjs", "colormap", "fdq", "jpmesh", "jpndistrict", "jsonld", "gfer", "tmaptools", "tmap", "wallace", "cdcfluview")

WindowsOnly <- c("BiplotGUI", "MDSGUI", "R2MLwiN", "R2PPT", "R2wd", "RInno", "RPyGeo", "RWinEdt", "TinnR", "blatr", "excel.link", "installr", "spectrino", "taskscheduleR")

stoplist <- c(stoplist, WindowsOnly,
 "feather", # little-endian only
 "microbenchmark", "timeit", "BayesXsrc", "R2BayesX")


fakes <- "ROracle"

recommended <-
    c("KernSmooth", "MASS", "Matrix", "boot", "class", "cluster",
      "codetools", "foreign", "lattice", "mgcv", "nlme", "nnet",
      "rpart", "spatial", "survival")

gcc <- 
    c("BayesXsrc", "ElectroGraph", "GWAtoolbox", "LCMCR", "LDExplorer", "MCMCpack", 
      "MasterBayes", "OpenMx", "PKI", "PReMiuM", "RGtk2", "RJSONIO", "RSclient", 
      "Ratings", "Rcpp", "STARSEQ", "TDA", "bayesSurv", "bigalgebra", "biganalytics", "bigmemory", 
      "bigtabulate", "chords", "cldr", "dpmixsim", "fbati", "fts", "gdsfmt", "glasso", 
      "glmnet", "gnmf", "gof", "intervals", "mRm", "medSTC", "mixcat", 
      "phcfM", "phreeqc", "rbamtools", "rcppbugs", "repfdr", "rpf",
      "smoothSurv", "sparsenet", "tgp", "RJSONIO", "protViz", "SKAT",
      "climdex.pcic", "HDPenReg", "FunChisq", "DPpackage", "mapfit", "rgdal",
      "readxl", "icenReg", "mvabund", "stream", "FCNN4R", "Rsomoclu", "TMB",
      "funcy", "brms", "BMRV", "nimble", "RcppParallel")

## avoid issues with __F95_sign
gcc <- c(gcc, "deSolve", "fGarch", "quadprog", "quantreg", "robustbase", "svd",
"limSolve", "nleqslv")

## rstan
gcc <- c(gcc, "prophet")

## ODS 12.5
gcc <- c(gcc, "rgeos")

Sys.setenv("OPENSSL_INCLUDES" = "/opt/csw/include", CURL_INCLUDES = "/opt/csw/include", "V8_INCLUDES" = "/opt/csw/include")


