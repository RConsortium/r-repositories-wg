call d:\RCompile\CRANpkg\make\set_Env.bat 
call d:\RCompile\CRANpkg\make\set_devel64_Env.bat 
call d:\RCompile\CRANpkg\make\incoming_env.bat 
set R_LIBS=d:/Rcompile/CRANguest/R-devel/lib;%R_LIBS%
set _R_OPTIONS_STRINGS_AS_FACTORS_=false

d:
cd d:\RCompile\CRANguest\make
mkdir d:\RCompile\CRANguest\R-devel
xcopy c:\Inetpub\ftproot\R-devel\*.tar.gz d:\RCompile\CRANguest\R-devel\ /Y
rm c:/Inetpub/ftproot/R-devel/*
rm c:/Inetpub/ftproot/R-devel/.*

R CMD BATCH --no-restore --no-save Auto-Pakete.R log\Auto-Pakete-R-devel.Rout

exit
