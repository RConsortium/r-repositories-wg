set Path=d:\compiler\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem
set HOME=/cygdrive/c/Users/ligges

rem rsync -a --delete --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/win/3.7 ligges@shell:/home/ligges/CRAN
rsync -a --delete --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/check/3.7/ ligges@shell:/home/ligges/CRANcheck/3.7

rsync -a --delete --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/win/3.6 ligges@shell:/home/ligges/CRAN
rsync -a --delete --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/check/3.6/ ligges@shell:/home/ligges/CRANcheck/3.6

rsync -a --delete --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/win/3.5 ligges@shell:/home/ligges/CRAN
rsync -a --delete --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/check/3.5/ ligges@shell:/home/ligges/CRANcheck/3.5

rsync --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/win/checkSummaryWin.html ligges@shell:/home/ligges/CRAN/checkSummaryWin.html
rsync --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/win/ReadMe ligges@shell:/home/ligges/CRAN/ReadMe
rsync --chmod g+rx --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/id_rsa" /cygdrive/d/RCompile/CRANpkg/win/ThirdPartySoftware.html ligges@shell:/home/ligges/CRAN/ThirdPartySoftware.html

rsync -a -og --exclude=examples_and_tests/ --chmod g+rwxs --chmod o+rx -e "ssh -o NumberOfPasswordPrompts=0 -i /cygdrive/c/Users/ligges/rforge_dsa" /cygdrive/c/inetpub/wwwroot/incoming_pretest/ ligges@CRAN.R-project.org:/home/cranadmin/var/log/incoming
