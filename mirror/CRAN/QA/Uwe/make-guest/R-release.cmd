call d:\RCompile\CRANpkg\make\set_Env.bat 
call d:\RCompile\CRANpkg\make\set_recent64_Env.bat 
call d:\RCompile\CRANpkg\make\incoming_env.bat 
set R_LIBS=d:/Rcompile/CRANguest/R-release/lib;%R_LIBS%

d:
cd d:\RCompile\CRANguest\make
mkdir d:\RCompile\CRANguest\R-release
xcopy c:\Inetpub\ftproot\R-release\*.tar.gz d:\RCompile\CRANguest\R-release\ /Y
rm c:/Inetpub/ftproot/R-release/*
rm c:/Inetpub/ftproot/R-release/.*

R CMD BATCH --no-restore --no-save Auto-Pakete.R log\Auto-Pakete-R-release.Rout

exit
