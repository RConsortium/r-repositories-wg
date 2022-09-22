d:
cd d:\RCompile\CRANpkg\make
net use t: \\store\software
t:\R\bin\i386\R CMD BATCH --no-save --no-restore updateStoreR.R log\updateStoreR.Rout
rem pause