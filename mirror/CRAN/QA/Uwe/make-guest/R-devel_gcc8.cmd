call d:\RCompile\CRANpkg\make\set_Envv3.bat 
call d:\RCompile\CRANpkg\make\set_devel64_Envv3.bat
call d:\RCompile\CRANpkg\make\incoming_env.bat 
set R_LIBS=d:/Rcompile/CRANguest/R-devel_gcc8/lib;%R_LIBS%
set _R_OPTIONS_STRINGS_AS_FACTORS_=false


d:
cd d:\RCompile\CRANguest\make
mkdir d:\RCompile\CRANguest\R-devel_gcc8
xcopy c:\Inetpub\ftproot\R-devel_gcc8\*.tar.gz d:\RCompile\CRANguest\R-devel_gcc8\ /Y
rm c:/Inetpub/ftproot/R-devel_gcc8/*
rm c:/Inetpub/ftproot/R-devel_gcc8/.*

R CMD BATCH --no-restore --no-save Auto-Pakete.R log\Auto-Pakete-R-devel_gcc8.Rout

exit
