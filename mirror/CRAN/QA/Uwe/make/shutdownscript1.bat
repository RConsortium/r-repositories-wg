rem Usage:
rem shutdownscript1.bat minutes tempa tempb
rem Example:
rem shutdownscript1.bat 5 26 32

set PATH=%PATH%;D:\Compiler\bin

d:
cd d:\Rcompile\CRANpkg\make

wget -O %TEMP%/temperature.txt --quiet --no-check-certificate https://admin/temp.txt
set SICHERSHUT=99
gawk "{if(($1 > systime() - (%1 * 60)) && ($2 > maxta)) maxta = $2; if(($1 > systime() - (%1 * 60)) && ($3 > maxtb)) maxtb = $3}; END {if((maxta > %2) && (maxtb > %3)) print \"shutdownscript2.bat\", maxta, maxtb}" %TEMP%/temperature.txt | cmd /k
