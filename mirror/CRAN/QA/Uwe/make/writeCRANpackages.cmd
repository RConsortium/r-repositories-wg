call d:\RCompile\CRANpkg\make\set_Env_new.bat 
call d:\RCompile\CRANpkg\make\set_recent_Env.bat 

rem set maj.version=2.13+2.14+2.15+3.0+3.1+3.2+3.3+3.4
set maj.version=3.1+3.2+3.3+3.4

d:
cd d:\Rcompile\CRANpkg\make
R CMD BATCH --no-restore --no-save writeCRANpackages.R log\writeCRANpackages.Rout
exit
