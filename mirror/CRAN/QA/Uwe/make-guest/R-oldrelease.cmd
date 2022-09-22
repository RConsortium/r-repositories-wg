call d:\RCompile\CRANpkg\make\set_Env.bat 
call d:\RCompile\CRANpkg\make\set_oldrelease64_Env.bat 
call d:\RCompile\CRANpkg\make\incoming_env.bat 
set R_LIBS=d:/Rcompile/CRANguest/R-oldrelease/lib;%R_LIBS%

d:
cd d:\RCompile\CRANguest\make
mkdir d:\RCompile\CRANguest\R-oldrelease
xcopy c:\Inetpub\ftproot\R-oldrelease\*.tar.gz d:\RCompile\CRANguest\R-oldrelease\ /Y
rm c:/Inetpub/ftproot/R-oldrelease/*
rm c:/Inetpub/ftproot/R-oldrelease/.*

R CMD BATCH --no-restore --no-save Auto-Pakete.R log\Auto-Pakete-R-oldrelease.Rout

exit
