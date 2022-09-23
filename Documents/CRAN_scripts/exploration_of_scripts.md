# Context

In August 2022, we received some links pointing to resources run by the CRAN team to (1) check incoming tar.gz packages, (2) regularly check all packages on CRAN.  
The answers are there: https://github.com/RConsortium/r-repositories-wg/blob/main/Documents/Proposal%20to%20CRAN.md

In this issue, we can discuss the test of the scripts received:

- What do we learn ?
- What is needed to make them work ?
- How are they usable on different OS flavours ?

# Scripts

Let's start with the incoming check as there are the first step to pass to go to CRAN.   
Then, we may explore regular checks.

## Incoming checks

- Incoming checks are run each time there is a new packages send to CRAN  

=> It seems that each member of CRAN runs a different set of test, depending on their OS

Scripts are:

- A Rscript that prepares the system and run the 'R CMD check" command: https://github.com/r-devel/r-dev-web/blob/master/CRAN/QA/Kurt/lib/R/Scripts/check_CRAN_incoming.R
- It is amended with env. variables: https://github.com/r-devel/r-dev-web/blob/master/CRAN/QA/Kurt/.R/check.Renviron

=> It seems that they do not use the `--as-cran` tag to run the check.

### :heavy_check_mark:  Tests on Ubuntu 22.04 LTS

Extra steps needed on local computer:
```sh
mkdir ~/tmp/
mkdir ~/tmp/scratch
mkdir ~/tmp/CRAN
```

- System function `getIncoming` is used in the R file but does not exist on my system.

=> Need to comment the `getIncoming` part (L173-182)
=> Put the tar.gz of your package inside the `check_dir`, which by default is "~/tmp/CRAN"
=> Run the R code
=> The output looks like what we receive by email

```r
Depends:
Package: fusen
  Depends: R (>= 3.5.0)
  Imports: attachment, cli, desc, devtools, glue, here (>= 1.0.0),
    magrittr, parsermd (>= 0.1.0), roxygen2, stats, stringi,
    tibble, tidyr, tools, usethis (>= 2.0.0), utils

Timings:
      utilisateur système  écoulé
fusen     107.585   9.573 143.396

Results:
Check status summary:
                  ERROR
  Source packages     1

Check results summary:
fusen ... ERROR
* checking CRAN incoming feasibility ... NOTE
* checking tests ... ERROR
* checking PDF version of manual ... WARNING
```

The full check directory is stored in the `check_dir`, which by default is "~/tmp/CRAN"
![image](https://user-images.githubusercontent.com/21193866/191078227-1fcbd05f-a03d-4699-9dcb-02d7e0031863.png)

:heavy_check_mark: it works on Ubuntu 20.04 LTS as is

## Regular checks

- Regular checks seems to be run regularly.
- Question is when ? when the devel version of R change, dependencies, nightly, .... ?
- These checks seem to update the check result page of each package
    + e.g. https://cran.r-project.org/web/checks/check_results_gitlabr.html
![image](https://user-images.githubusercontent.com/21193866/191074944-9a6a54b6-c1fa-44f6-910c-b55be3004c1b.png)

Scripts are:

- sh script: https://github.com/r-devel/r-dev-web/blob/master/CRAN/QA/Kurt/bin/check-R-ng

=> This builds the R-devel version

- It runs a R script: https://github.com/r-devel/r-dev-web/blob/master/CRAN/QA/Kurt/lib/R/Scripts/check_CRAN_regular.R
     

- Which itself uses this list of env. variables: https://github.com/r-devel/r-dev-web/blob/master/CRAN/QA/Kurt/.R/check.Renviron

=>  This builds all R base packages

### Tests on Ubuntu 22.04 LTS

- Extra steps needed on local computer:  
- 
```sh
mkdir ~/tmp/
mkdir ~/tmp/R.check
```

- Define these two directories inside file "check-R-ng"

- R scripts directory :
```
R_scripts_dir=~/lib/R/Scripts
```

- Shell scripts directory.
```
sh_scripts_dir=~/lib/bash
```

- Error to be explored....
```
creating NEWS.2.pdf
/bin/bash: line 1: html: command not found
make: [Makefile:120: R-FAQ.epub] Error 127 (ignored)
/usr/bin/sed: can't read R-FAQ.epub.tmp: No such file or directory
make: *** [Makefile:121: R-FAQ.epub] Error 2
Fatal error: cannot open file '/home/srochett/lib/R/Scripts/check_CRAN_regular.R': No such file or directory
```

=> Need to be tested inside a Docker container
