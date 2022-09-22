pause
call d:\RCompile\CRANpkg\make\set_Env.bat 
call d:\RCompile\CRANpkg\make\set_oldrelease64_Env.bat 
set mailMaintainer=no
pause

d:
cd d:\Rcompile\CRANpkg\make
R CMD BATCH --no-restore --no-save Auto-Pakete-recompile.R log\Auto-Pakete-old-recompile.Rout
call check_diffs_send
exit
