set targetname=R-3.6.2
set filename=%targetname%
set name=R32
set version=3.6


set Path=.;d:\Compiler\gcc-4.9.3\mingw_32\bin;d:\compiler\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;D:\compiler\texmf\miktex\bin;D:\compiler\texmf\miktex\bin\x64;d:\compiler\perl-basic\bin
set R_INSTALL_TAR=tar.exe
set CYGWIN=nodosfilewarning
set TAR_OPTIONS=--no-same-owner --no-same-permissions

set R_LIBS=
set LANGUAGE=en

d:
cd \Rcompile\recent

rm R-latest.tar.gz
wget http://cran.r-project.org/src/base/R-3/%filename%.tar.gz
tar xfz %filename%.tar.gz
xxcopy %filename% %name% /CLONE /YY

copy /Y d:\RCompile\r-compiling\MkRules.dist-%version%new d:\RCompile\recent\%name%\src\gnuwin32\MkRules.local

xxcopy d:\RCompile\r-compiling\bitmap d:\Rcompile\recent\%name%\src\gnuwin32\bitmap  /Q1 /Q2 /Q3 /BU
xxcopy d:\RCompile\r-compiling\tcl86 .\%name%\tcl  /Q1 /Q2 /Q3 /BU


rem ######## make it!
set Path=%PATH%;d:\Rcompile\recent\%name%\bin
cd %name%\src\gnuwin32
make -j8 all
make cairodevices

rem ### recommended packages ...
make -j8 recommended

rem ## fix permissions
cd \Rcompile\recent
cacls %name% /T /E /G VORDEFINIERT\Benutzer:R > NUL

cd \Rcompile\recent\%name%\src\gnuwin32
mkdir c:\Inetpub\wwwroot\Rdevelcompile

rem make check-all > check2a.log 2>&1 
copy /y check2a.log c:\Inetpub\wwwroot\Rdevelcompile\


rem ########################
rem # finished 32-bit
rem ########################

set name=R64
set Path=.;d:\Compiler\gcc-4.9.3\mingw_64\bin;d:\compiler\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;D:\compiler\texmf\miktex\bin;d:\compiler\perl-basic\bin

d:
cd \Rcompile\recent

xxcopy %filename% %name% /CLONE /YY

copy /Y d:\RCompile\r-compiling\MkRules.dist64-%version%new d:\RCompile\recent\%name%\src\gnuwin32\MkRules.local
xxcopy d:\RCompile\r-compiling\bitmap d:\Rcompile\recent\%name%\src\gnuwin32\bitmap  /Q1 /Q2 /Q3 /BU
xxcopy d:\RCompile\r-compiling\Tcl86_64 .\%name%\tcl  /Q1 /Q2 /Q3 /BU

rem ######## make it!
set Path=%PATH%;d:\Rcompile\recent\%name%\bin
cd %name%\src\gnuwin32
make -j8 all
make cairodevices

rem ### recommended packages ...
make -j8 recommended
make vignettes
make manuals

cd installer
make imagedir
make fixups
make 32bit

rm -rf d:/RCompile/recent/%targetname%
mv %filename% d:/RCompile/recent/%targetname%
sed -i -r 's/^BINPREF.\?.*/BINPREF=d:\/Compiler\/gcc-4.9.3\/mingw_64\/bin\//' d:/RCompile/recent/%targetname%/etc/x64/Makeconf
sed -i -r 's/^BINPREF.\?.*/BINPREF=d:\/Compiler\/gcc-4.9.3\/mingw_32\/bin\//' d:/RCompile/recent/%targetname%/etc/i386/Makeconf
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
mkdir d:\RCompile\CRANpkg\check\%version%
copy /y d:\Rcompile\recent\%name%\VERSION d:\RCompile\CRANpkg\check\%version%
xxcopy d:\Rcompile\recent\%targetname%\library d:\RCompile\CRANpkg\lib\%version%  /Q1 /Q2 /Q3 /BU

rem ## fix permissions of R
cd \Rcompile\recent
cacls %targetname% /T /E /G VORDEFINIERT\Benutzer:R > NUL

cd \Rcompile\recent\%name%\src\gnuwin32
make check-all > check2.log 2>&1 
copy /y check2.log c:\Inetpub\wwwroot\Rdevelcompile\
copy /y d:\RCompile\recent\compile2.log c:\Inetpub\wwwroot\Rdevelcompile\
blat d:\Rcompile\recent\blat.txt -to ligges@statistik.tu-dortmund.de -subject "R-compile2"


rem ########################
rem # finished!
rem ########################
