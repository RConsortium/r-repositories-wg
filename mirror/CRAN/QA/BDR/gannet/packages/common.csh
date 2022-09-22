setenv DISPLAY :5
limit cputime 30m
limit stacksize 20M
setenv OMP_THREAD_LIMIT 2

setenv _R_CHECK_FORCE_SUGGESTS_ false
setenv LC_CTYPE en_GB.utf8
setenv MYSQL_USER ripley
setenv POSTGRES_USER ripley
setenv POSTGRES_DATABASE ripley
setenv RMPI_INCLUDE /usr/include/openmpi-x86_64
setenv RMPI_LIB_PATH /usr/lib64/openmpi/lib
setenv RMPI_TYPE OPENMPI
setenv R_BROWSER false
setenv R_PDFVIEWER false
setenv _R_CHECK_INSTALL_DEPENDS_ true
#setenv _R_CHECK_SUGGESTS_ONLY_ true
setenv _R_CHECK_NO_RECOMMENDED_ true
setenv _R_CHECK_DOC_SIZES2_ true
#setenv R_C_BOUNDS_CHECK yes
setenv _R_CHECK_DEPRECATED_DEFUNCT_ true
setenv _R_CHECK_SCREEN_DEVICE_ warn
setenv _R_CHECK_REPLACING_IMPORTS_ true
setenv _R_CHECK_TOPLEVEL_FILES_ true
setenv _R_CHECK_DOT_FIRSTLIB_ true
setenv _R_CHECK_RD_LINE_WIDTHS_ true
setenv _R_CHECK_S3_METHODS_NOT_REGISTERED_ true
setenv _R_CHECK_OVERWRITE_REGISTERED_S3_METHODS_ true
setenv _R_CHECK_CODE_USAGE_WITH_ONLY_BASE_ATTACHED_ TRUE
setenv _R_CHECK_NATIVE_ROUTINE_REGISTRATION_ true
setenv _R_CHECK_FF_CALLS_ registration
setenv _R_CHECK_PRAGMAS_ true
setenv _R_CHECK_COMPILATION_FLAGS_ true
setenv _R_CHECK_R_DEPENDS_ true
setenv _R_CHECK_PACKAGES_USED_IN_TESTS_USE_SUBDIRS_ true
#setenv _R_CHECK_PKG_SIZES_ false
setenv _R_CHECK_SHLIB_OPENMP_FLAGS_ true

#setenv _R_CHECK_CODE_ATTACH_ true
#setenv _R_CHECK_CODE_ASSIGN_TO_GLOBALENV_ true
#setenv _R_CHECK_CODE_DATA_INTO_GLOBALENV_ true

setenv _R_CHECK_VIGNETTES_SKIP_RUN_MAYBE_ true
setenv _R_CHECK_VIGNETTES_NLINES_ 0
setenv _R_CHECK_TESTS_NLINES_ 0

setenv _R_CHECK_LIMIT_CORES_ true
#setenv _R_CHECK_LENGTH_1_CONDITION_ "package:_R_CHECK_PACKAGE_NAME_,verbose"
#setenv _R_CHECK_LENGTH_1_CONDITION_ package:_R_CHECK_PACKAGE_NAME_,abort,verbose
#setenv _R_CHECK_LENGTH_1_LOGIC2_ "package:_R_CHECK_PACKAGE_NAME_,verbose"

setenv _R_S3_METHOD_LOOKUP_BASEENV_AFTER_GLOBALENV_ true
setenv _R_CHECK_COMPILATION_FLAGS_KNOWN_ "-Wno-deprecated-declarations -Wno-ignored-attributes -Wno-parentheses -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fanalyzer -Werror=implicit-function-declaration"
setenv _R_CHECK_AUTOCONF_ true
setenv _R_CHECK_THINGS_IN_CHECK_DIR_ true
setenv _R_CHECK_THINGS_IN_TEMP_DIR_ true
setenv _R_CHECK_THINGS_IN_TEMP_DIR_EXCLUDE_ "^ompi.gannet"
setenv _R_CHECK_BASHISMS_ true
setenv _R_CHECK_DEPENDS_ONLY_DATA_ true
setenv _R_CHECK_BOGUS_RETURN_ true
setenv _R_CHECK_MATRIX_DATA_ TRUE

setenv _R_CHECK_ELAPSED_TIMEOUT_ 30m
setenv _R_CHECK_INSTALL_ELAPSED_TIMEOUT_ 120m
setenv _R_CHECK_TESTS_ELAPSED_TIMEOUT_ 90m
setenv _R_CHECK_BUILD_VIGNETTES_ELAPSED_TIMEOUT_ 90m

setenv _R_CHECK_XREFS_USE_ALIASES_FROM_CRAN_ TRUE

setenv _R_CHECK_RD_VALIDATE_RD2HTML_ true
setenv _R_CHECK_RD_MATH_RENDERING_ true

setenv WNHOME /usr/share/wordnet-3.0

setenv R_CRAN_WEB file:///data/gannet/ripley/R

