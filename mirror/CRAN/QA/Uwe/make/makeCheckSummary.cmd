call d:\RCompile\CRANpkg\make\set_Env.bat 
call d:\RCompile\CRANpkg\make\set_recent_Env.bat 

d:
cd d:\Rcompile\CRANpkg\make
R CMD BATCH --no-restore --no-save makeCheckSummary.R log\makeCheckSummary.Rout
exit
