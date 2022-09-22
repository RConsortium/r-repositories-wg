call d:\RCompile\CRANpkg\make\set_Env.bat 
call d:\RCompile\CRANpkg\make\set_recent_Env.bat 
set LC_ALL=C

d:
cd d:\RCompile\CRANguest\make
R CMD BATCH --no-restore --no-save Aufraeumen.R log\Aufraeumen.Rout

exit
