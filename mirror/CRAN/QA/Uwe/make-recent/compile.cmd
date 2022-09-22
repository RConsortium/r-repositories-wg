set targetname=R
set name=R32
set version=3.7
set state=devel

set Path=.;d:\Compiler\gcc-4.9.3\mingw_32\bin;d:\compiler\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;D:\compiler\texmf\miktex\bin;D:\compiler\texmf\miktex\bin\x64;d:\compiler\perl-basic\bin
rem set R_INSTALL_TAR=tar.exe
set CYGWIN=nodosfilewarning
set TAR_OPTIONS=--no-same-owner --no-same-permissions

set R_LIBS=
set LANGUAGE=en

d:
cd \Rcompile\recent

rem svn.exe update R-%state%
robocopy R-%state% %name% /MIR /NC /NS /NFL /NDL /NP /NJS  /R:1 /W:1 > NUL

copy /Y d:\RCompile\r-compiling\MkRules.dist-%version%new d:\RCompile\recent\%name%\src\gnuwin32\MkRules.local

robocopy d:\RCompile\r-compiling\bitmap d:\Rcompile\recent\%name%\src\gnuwin32\bitmap /MIR /NC /NS /NFL /NDL /NP /NJS  /R:1 /W:1 > NUL
robocopy d:\RCompile\r-compiling\tcl86 .\%name%\tcl  /MIR /NC /NS /NFL /NDL /NP /NJS  /R:1 /W:1 > NUL


rem ######## make it!
set Path=%PATH%;d:\Rcompile\recent\%name%\bin
cd %name%\src\gnuwin32
make -j8 all
make cairodevices

rem ### recommended packages ...
make rsync-recommended
make -j8 recommended
rem make vignettes
rem make manuals

rem ## fix permissions
cd \Rcompile\recent
cacls %name% /T /E /G VORDEFINIERT\Benutzer:R > NUL

mkdir c:\Inetpub\wwwroot\Rdevelcompile

rem ### 32 bit checks
rem cd \Rcompile\recent\%name%\src\gnuwin32
rem make check-all > check0-32.log 2>&1 
rem diff ..\..\..\check0-32.log check0a.log > check0-32dif.log
rem copy /y check0-32.log c:\Inetpub\wwwroot\Rdevelcompile\
rem copy /y check0-32dif.log c:\Inetpub\wwwroot\Rdevelcompile\

rem ########################
rem # finished 32-bit
rem ########################

set name=R64
set Path=.;d:\Compiler\gcc-4.9.3\mingw_64\bin;d:\compiler\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;D:\compiler\texmf\miktex\bin;D:\compiler\texmf\miktex\bin\x64;d:\compiler\perl-basic\bin

d:
cd \Rcompile\recent

robocopy R-%state% %name% /MIR /NC /NS /NFL /NDL /NP /NJS  /R:1 /W:1 > NUL

copy /Y d:\RCompile\r-compiling\MkRules.dist64-%version%new d:\RCompile\recent\%name%\src\gnuwin32\MkRules.local
robocopy d:\RCompile\r-compiling\bitmap d:\Rcompile\recent\%name%\src\gnuwin32\bitmap /MIR /NC /NS /NFL /NDL /NP /NJS  /R:1 /W:1 > NUL
robocopy d:\RCompile\r-compiling\tcl86_64 .\%name%\tcl  /MIR /NC /NS /NFL /NDL /NP /NJS  /R:1 /W:1 > NUL

rem ######## make it!
set Path=%PATH%;d:\Rcompile\recent\%name%\bin
cd %name%\src\gnuwin32
make -j8 all
make cairodevices

rem ### recommended packages ...
make rsync-recommended
make -j8 recommended
make vignettes
make manuals

cd installer
make imagedir
make fixups
make 32bit

rm -rf d:/RCompile/recent/%targetname%
rem mv R-%version%.0dev d:/RCompile/recent/%targetname%
mv R-devel d:/RCompile/recent/%targetname%
sed -i -r 's/^BINPREF.\?.*/BINPREF=d:\/Compiler\/gcc-4.9.3\/mingw_64\/bin\//' d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r 's/^BINPREF.\?.*/BINPREF=d:\/Compiler\/gcc-4.9.3\/mingw_32\/bin\//' d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^CFLAGS *= */CFLAGS = -pedantic /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^CFLAGS *= */CFLAGS = -pedantic /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^CXXFLAGS *= */CXXFLAGS = -pedantic /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^CXXFLAGS *= */CXXFLAGS = -pedantic /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^CXX1XFLAGS *= */CXX1XFLAGS = -pedantic /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^CXX1XFLAGS *= */CXX1XFLAGS = -pedantic /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^FFLAGS *= */FFLAGS = -pedantic -fbounds-check /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^FFLAGS *= */FFLAGS = -pedantic -fbounds-check /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^FCFLAGS *= */FCFLAGS = -pedantic -fbounds-check /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^FCFLAGS *= */FCFLAGS = -pedantic -fbounds-check /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^CXX14 *= */CXX14 = $(BINPREF)g++ $(M_ARCH) /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^CXX14 *= */CXX14 = $(BINPREF)g++ $(M_ARCH) /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^CXX14FLAGS *= */CXX14FLAGS = -O2 -Wall $(DEBUGFLAG) -mtune=core2 /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^CXX14FLAGS *= */CXX14FLAGS = -O2 -Wall $(DEBUGFLAG) -mtune=core2 /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf
sed -i -r "s/^CXX14STD *= */CXX14STD = -std=gnu++14 /" d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r "s/^CXX14STD *= */CXX14STD = -std=gnu++14 /" d:/RCompile/recent/%targetname%/etc/i386/Makeconf


cd ..
make rinstaller
make crandir

copy /Y d:\RCompile\r-compiling\Makevars.site32new d:\RCompile\recent\%targetname%\etc\i386\Makevars.site
copy /Y d:\RCompile\r-compiling\Renviron.site32new d:\RCompile\recent\%targetname%\etc\i386\Renviron.site

copy /Y d:\RCompile\r-compiling\Makevars.site64new d:\RCompile\recent\%targetname%\etc\x64\Makevars.site
copy /Y d:\RCompile\r-compiling\Renviron.site64new d:\RCompile\recent\%targetname%\etc\x64\Renviron.site

rem ## fix permissions of library and update library
cd d:\Rcompile\CRANpkg\lib\%version%
FOR %%a IN (KernSmooth base cluster grDevices lattice nlme spatial stats4 tools MASS boot datasets graphics methods nnet splines survival utils class foreign grid mgcv rpart stats tcltk codetools compiler Matrix parallel) DO SubInACL /subdirectories %%a\*.* /setowner=fb05\ligges /grant=fb05\ligges=F > NUL
FOR %%a IN (KernSmooth base cluster grDevices lattice nlme spatial stats4 tools MASS boot datasets graphics methods nnet splines survival utils class foreign grid mgcv rpart stats tcltk codetools compiler Matrix parallel) DO rm -r -f %%a
rem ### manuell:
rem FOR %a IN (KernSmooth base cluster grDevices lattice nlme spatial stats4 tools MASS boot datasets graphics methods nnet splines survival utils class foreign grid mgcv rpart stats tcltk codetools compiler Matrix parallel) DO SubInACL /subdirectories %a\*.* /setowner=fb05\ligges /grant=fb05\ligges=F > NUL
rem FOR %a IN (KernSmooth base cluster grDevices lattice nlme spatial stats4 tools MASS boot datasets graphics methods nnet splines survival utils class foreign grid mgcv rpart stats tcltk codetools compiler Matrix parallel) DO rm -r -f %a

cd \Rcompile\recent

mkdir d:\RCompile\CRANpkg\check\%version% 
copy /y d:\Rcompile\recent\%name%\VERSION d:\RCompile\CRANpkg\check\%version%
robocopy d:\Rcompile\recent\%targetname%\library d:\RCompile\CRANpkg\lib\%version% /E /NC /NS /NFL /NDL /NP /NJS  /R:1 /W:1 > NUL
rem ## fix permissions of R
cd \Rcompile\recent
cacls %targetname% /T /E /G VORDEFINIERT\Benutzer:R > NUL

cd \Rcompile\recent\%name%\src\gnuwin32


set _R_CHECK_ALL_NON_ISO_C_=TRUE
set _R_CHECK_CODE_ASSIGN_TO_GLOBALENV_=TRUE
set _R_CHECK_CODE_ATTACH_=TRUE
set _R_CHECK_CODE_DATA_INTO_GLOBALENV_=TRUE
set _R_CHECK_CODETOOLS_PROFILE_=suppressPartialMatchArgs=false
set _R_CHECK_DOC_SIZES2_=TRUE
set _R_CHECK_DOT_INTERNAL_=TRUE
set _R_CHECK_INSTALL_DEPENDS_=TRUE
set _R_CHECK_LICENSE_=TRUE
set _R_CHECK_NO_RECOMMENDED_=TRUE
set _R_CHECK_RD_EXAMPLES_T_AND_F_=TRUE
set _R_CHECK_SRC_MINUS_W_IMPLICIT_=TRUE
set _R_CHECK_SUBDIRS_NOCASE_=TRUE
set _R_CHECK_SUGGESTS_ONLY_=TRUE
set _R_CHECK_UNSAFE_CALLS_=TRUE
set _R_CHECK_WALL_FORTRAN_=TRUE
set _R_CHECK_RD_LINE_WIDTHS_=TRUE
set _R_CHECK_REPLACING_IMPORTS_=TRUE
set _R_CHECK_TOPLEVEL_FILES_=TRUE
set _R_CHECK_FF_DUP_=TRUE
set _R_SHLIB_BUILD_OBJECTS_SYMBOL_TABLES_=TRUE
set _R_CHECK_CODE_USAGE_WITHOUT_LOADING_=TRUE
set _R_CHECK_S3_METHODS_NOT_REGISTERED_=TRUE



make check-all > check0.log 2>&1 
diff ..\..\..\check0.log check0.log > check0dif.log
copy /y check0.log c:\Inetpub\wwwroot\Rdevelcompile\
copy /y check0dif.log c:\Inetpub\wwwroot\Rdevelcompile\
copy /y d:\RCompile\recent\compile0.log c:\Inetpub\wwwroot\Rdevelcompile\
blat d:\Rcompile\recent\blat.txt -to ligges@statistik.tu-dortmund.de -subject "R-devel"


rem ########################
rem # finished!
rem ########################
