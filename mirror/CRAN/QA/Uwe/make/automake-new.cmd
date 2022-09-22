call d:\RCompile\CRANpkg\make\set_ENV.bat 
call d:\RCompile\CRANpkg\make\set_devel64_Env.bat 
set mailMaintainer=no

d:
cd d:\Rcompile\CRANpkg\make
R CMD BATCH --no-restore --no-save Auto-Pakete.R log\Auto-Pakete-new.Rout
rem exit
