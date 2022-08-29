
## Proposal to CRAN

### Proposal Letter
Prposal sent via email to cran@r-project.org on April 12, 2022


Dear CRAN maintainers,

The R Consortium Repositories working group
(https://github.com/RConsortium/r-repositories-wg) was formed to
investigate ways to build, maintain, and operate new package
repositories for specialized purposes. For example, we are cooperating
with the R Validation Hub (https://www.pharmar.org) to consider a
repository designed specifically around the needs of regulatory
submissions by the Pharma community.

The underlying philosophy of the Repositories working group is that
anything we do should be in harmony with CRAN, not make additional
work for CRAN maintainers, and if possible ease the burden on CRAN
maintainers. Along these lines, we’d like to put forward a proposal
that would help us, help the community, and we believe reduce a little
of your workload.

Currently, many people use R-hub (https://builder.r-hub.io) prior to
CRAN submission as a way to check their package in a standardized
environment. R-hub does its best to mimic CRAN as closely as possible,
but one challenge is matching the extra _R_CHECK_ environment
variables used by the different CRAN machines. We’d like to work with
you to figure out some convenient way to share those envvars. We
understand that this will generate some work for you but we hope it
should be small, we’re willing to do anything we can to help, and we
believe it will pay off by reducing the number of submissions with
known problems.

Sincerely,

Joe

Joseph B. Rickert
Chair: R Consortium Board of Directors

### Response from Kurt Hornik
August 18, 2022

Dear Joe,

Thanks for reaching out.

In principle, all code used for the CRAN checks should be available via

  https://svn.r-project.org/R-dev-web/trunk/CRAN/QA/

with

  https://cran.r-project.org/web/checks/check_flavors.html

providing details for the fedora checks and

  https://cran.r-project.org/web/checks/check_issue_kinds.html

providing details for all additional checks.

At least in my case, this could use an additional README: for the
regular checks, the basic (shell) script is

  https://svn.r-project.org/R-dev-web/trunk/CRAN/QA/Kurt/bin/check-R-ng

which in turn uses

  https://svn.r-project.org/R-dev-web/trunk/CRAN/QA/Kurt/.R/check.Renviron
  https://svn.r-project.org/R-dev-web/trunk/CRAN/QA/Kurt/lib/R/Scripts/check_CRAN_regular.R

for setting env vars; for my incoming checks, Rscript calls

  https://svn.r-project.org/R-dev-web/trunk/CRAN/QA/Kurt/lib/R/Scripts/check_CRAN_incoming.R

which again uses

  https://svn.r-project.org/R-dev-web/trunk/CRAN/QA/Kurt/.R/check.Renviron

for env vars.

Hope this helps for moving things forward.

Best
-k

### Response from Simon Urbanek
August 18, 2022

FWIW the actually used macOS scripts are still in https://svn.r-project.org/R-dev-web/trunk/QA/ since I apparently missed the move into the CRAN directory.

Cheers,
Simon

### Response from Tomas Kalibera

My Windows checks ("ucrt3", not used for incoming/regular checks, only
used for testing packages with updates of Rtools and hence also testing
Rtools) are sourced at:

https://svn.r-project.org/R-dev-web/trunk/WindowsBuilds/winutf8/ucrt3

described here:

https://svn.r-project.org/R-dev-web/trunk/WindowsBuilds/winutf8/ucrt3/howto.html

---

I think that setting the environment variables the same way as CRAN
check machines is only a small part of getting the same results. What
matters particularly on Windows is which external software is installed.
It is also not unusual to see crashes only with certain versions of
other packages. All of that is a moving target, particularly the last
bit - you can't possibly match exactly the same versions of all CRAN
packages (sometimes not in strong revdeps...).

There is also inevitable non-determinism in check results due to
external sites used during package checks going offline and online
again. And there are other potential sources sometimes seen, including
race conditions, compiler version, etc.

So I think matching the results exactly is not realistic. Neither it
would be much useful: packages should "work", not just "happen to work
on CRAN check systems". If you set up your own checks and find out
different problems, and they get fixed, it's great.

However, you may find out useful variables to set to aid automating the
checks, as well as other tricks, particularly in the scripts linked by
Kurt which have been used in operation for years.

Best
Tomas

