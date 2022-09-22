writeReadMe <- function(maj.version = "3.0",
    configdir = "D:/RCompile/CRANpkg/make/config",
    windir = "D:/RCompile/CRANpkg/win",
    configfiles = c("Recommended", "Brian", "Databases", "Unix", "Dependencies", "Unstable"))
{

shell(paste("cat", paste(file.path(configdir, maj.version, configfiles), collapse=" "), 
            ">", file.path(configdir, paste("DoNotCompile", maj.version, sep=""))))

readme <- file.path(windir, maj.version, "@ReadMe")

rewrap <- function(file){
    paste(strwrap(paste(readLines(file), collapse=", "), 70, prefix="\t"), collapse="\n")
}

cat(
paste(
"Pre-compiled binary packages for R-",

maj.version,

".x for Windows
=====================================================

This collection is unsupported. Please compile from sources yourself 
in case of any problems. Please ask the package maintainer in case of 
any questions.

Building binary versions of the contributed packages on CRAN has been
automated. Binary packages will be available on CRAN about 1-3 days
after the sources have been published. Please do *not* submit binary
versions of any packages, because that needs manual intervention by
this collection's maintainer (hence it is time consuming).

Some packages have been working in a former version, but do no longer
compile on Windows or do not pass \"R CMD check\". The last `working'
versions are still available in the repository, but outdated.

Packages that do not compile out of the box or do not pass 
\"R CMD check\" with \"OK\" or at least a \"WARNING\" will *not* be
published. The results of \"R CMD check\" are given in
CRAN/bin/windows/contrib/checkSummaryWin.html
In case of a \"WARNING\" or an \"ERROR\", please check the 
corresponding check.log files in subdirectory ./check.

Possible reasons for not-compiling or not-passing the checks:
 - I do not have some other software the package depends on
 - The package needs manual configuration
 - Any other reason I do not want to discover

Packages\n",

rewrap(file.path(configdir, maj.version, "Brian")),

"
do not build out of the box or other special in other circumstances.
Nevertheless these are available at
\thttps://www.stats.ox.ac.uk/pub/RWin/bin/windows/contrib/", 

maj.version, 

"/
kindly provided by Professor Brian D. Ripley.

Packages
",

rewrap(file.path(configdir, "NoMultiarch")),


"
are only available for 32-bit installations and R < 2.15.0.

Packages
",

rewrap(file.path(configdir, "DoNotCheck")),


"
are checked with \"--install:fake\" for various reasons - most of them 
due to GUI interactions.

Packages
",

rewrap(file.path(configdir, "DoNotCheckVignette")),

"
are checked with \"--no-vignettes\" due to their long-running checks 
or (for SHARE) non-reproducible vignette issues.

Packages
",

rewrap(file.path(configdir, "DoNotCheckLong")),

"
are checked with \"--no-tests --no-examples --no-vignettes\" due to 
their long-running checks, strange buffering issues, or due to other 
dependencies I do not have.

Packages
",

rewrap(file.path(configdir, maj.version, "Unstable")),

"
are not checked nor distributed due to crashes under Windows or 
extremely unstable check results that switch forth and back between OK 
and ERROR or WARNING.

Some package are Unix only, including
",

rewrap(file.path(configdir, maj.version, "Unix")),

"\n
Packages related to many database system must be linked to the exact 
version of the database system the user has installed, hence it does 
not make sense to provide binaries for packages
",

rewrap(file.path(configdir, maj.version, "Databases")),

"
although it is possible to install such packages from sources by
\tinstall.packages('packagename', type='source')
after reading the manual 'R Installation and Administration'.

Packages
",

rewrap(file.path(configdir, maj.version, "Dependencies")),

"
or their dependencies also require additional libraries / software to
build on Windows I do not have (and may not even exist in versions 
for Windows).

For some packages, additional third party libraries or programs are
required in your path, these are (at least!):
- for package BRugs: OpenBUGS >= 3.2.1
- for package dataframes2xls: Python
- for package rggobi: ggobi >= 2.1.10
- for package rjags: JAGS >= 3.1.0
- for package WriteXLS: ActivePerl
- Package RGtk2 requires an an installation of Gtk+ aka Gtk2 >= 2.20.
  For 32-bit R, version 2.20 or later from
    http://www.gtk.org/download/win32.php, e.g. 
    http://ftp.gnome.org/pub/gnome/binaries/win32/gtk+/2.22/gtk+-bundle_2.22.0-20101016_win32.zip
  For 64-bit R, version 2.20 or later from
    http://www.gtk.org/download/win64.php, e.g. 
    http://ftp.gnome.org/pub/gnome/binaries/win64/gtk+/2.22/gtk+-bundle_2.22.0-20101016_win64.zip
  In each case, unpack the zip file in a suitable empty directory and
    put the 'bin' directory in your path.  NB: the 32-bit and 64-bit
    distributions contain DLLs of the same names, and so you must ensure
    that you have the 32-bit version in your path when running 32-bit R
    and the 64-bit version when running 64-bit R - and the error messages
    you get with the wrong version are confusing.
- please drop me a note for additional requirements

Some packages include additional binary components that need
additional third party sources in order to compile. For license
(such as GPL) compliance (and completeness), we are hosting the
sources as follows:
- for the standardized software in file local300.zip made available by 
  Professor Brian D. Ripley:
  https://www.stats.ox.ac.uk/pub/Rtools/goodies/sources/
- for other third party sources, please see
  https://win-builder.R-project.org/GPLcompliance/

Uwe Ligges
Uwe.Ligges@R-project.org\n",

sep=""),
file=readme
)
}

writeReadMe("3.4")
writeReadMe("3.5")
writeReadMe("3.6")
