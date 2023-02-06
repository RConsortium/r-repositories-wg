# CRAN discussion 2023-01-16

Notes by Hadley Wickham

Present

* Gabor Csardi
* Kurt Hornik
* Uwe Ligges
* Jeroen Ooms
* Lluis Revilla
* Hadley Wickham, 
* Simon Urbanek

KH: MRAN going way. 
HW: Posit will host historical archive. Point people to Posit public package manager. 

SU: can we match CRAN, R-hub, and r-lib so that folks get the same results in every situation.

HW: we all seem to agree that’s a good idea; what do we need to make them match?

GH: need practical approach of thinks that need to match exactly and things that don’t. Two reasons not to match: technical and too much work. One example: Can’t use the same macOS versions as CRAN because GHA doesn’t have the same versions.

SU: not really a problem, because newer macOS tool chains can build for older macOS versions. Instead, CRAN could build on newer OS version and test on older versions. Happy to change on  CRAN - the goal is to support users with old macOS versions, but trun-time tests can be done on newer versions..

GC: another example: on linux, CRAN uses debian, but on actions we use ubuntu because GHA give us ubuntu out of the box and we Posit package manager creates ubuntu binaries. Which makes things much much faster.  Building binaries works for a one off check, but not a good experience for CI.

SU: depends on what the goals are. r-lib actions and r-hub have slightly different goals; like CRAN submission and full rebuild checks. For actions and r-hub individual re-builds are ok (possibly modulo packages with large rev deps).

GC: for mac and windows, GHA and r-hub are very similar (although not using the latest build tools for windows by default). Main differences are linux builds. And not generally a big deal. 
extra-check stuff is much harder; technically possible but much harder. Updating the r-hub containers to 

SU: this is why we need to talk. KH + UL + SU + TK scripts are open source and documented. But other scripts are harder. 

GC: current plan is to take a pragmatic approach; in the past have tried to replicate exactly which is really hard because it’s one system that’s mostly undocumented. Instead focus on (e.g.) gcc-13 check.

SU: would be great to get those things documented enough so that folks can fix themselves.

HW: two classes of problems: sophisticated C uses + extra checks; and env var variants for new users. 

KH: would be great to have a bit more documentation on r-hub. Compare and contrast cran extra checks (e.g https://cran.r-project.org/web/checks/check_issue_kinds.html) with r-hub images.

gcc 13 & clang 16 are mostly well meaning because these problems will surface when gcc/clang released. Others are less useful (e.g. numeric FP MKO/OpenBlas/ATLAS). 

SU: are r-lib actions are in anyway related to r-hub images?

GC: no, mostly just scripts to set up on default GH images

HW: primary goal of r-lib of performance; secondary is fidelity. Opposite is true for r-hub.

SU: could take advantage of binary builds of R.  Would like to be assured that R binaries/tool chains are exactly the same as on CRAN.

GC: Considering whether or not to use debian-unstable. Potentially a lot of extra work; more binaries & more changes.

SU: could there be funding from R-foundation/posit for sys admin type task for fixing breakages in system requirements.

GC: actions are in pretty good place with reliability; lot of packages + lot of developers + lot of builds. 

HW: hard to find that person with the right skills.

SU: in general agree; happy to improve fidelity. But might be more efficient to focus on other areas (e.g. extra check). Hard to do it 5 years ago.

HW: working with other people is hard

KU: solaris is gone for good. Originally was to have set of compilers that strictly adhered to C++. But pragmatically everything needs to compile of gcc anyway.

UL: Big-endian vs little-endian also lost

KU: solaris is gone, but worried about fedora-clang, clang sanitizer, because they’re custom fedora builds. 

SU: at least one person reproduces in docker, easy for anyone else.

GC: at least fedora is up to date, and no longer needs self-built compilers.

KU: problem is also needs to recompile some libraries with C++ ABI. Could never fully reproduce same problems on debian.

GC: fairly easy to get ubuntu containers with nightly clang + libc++ etc. Easier than trying to get custom fedora build. (e.g. https://hub.docker.com/u/tuxmake).

KH: fedora is BDR. And has fairly custom set up. Can reproduce compiler stuff, but hard to reproduce sanitizer stuff. Could use clang on debian, but doesn’t test full toolchain for building system packages.

GC: have compilers + libc++, but don’t recompile whole system. Even on fedora, today, don’t think much recompiling is necessary. Have managed to reproduce most issues with that setup.

JO: from https://www.stats.ox.ac.uk/pub/bdr/Rconfig/r-devel-linux-x86_64-fedora-clang, You need to rebuild only: JAGS ImageMagick boost_program_options gdal poppler protobuf.

KH: might be worth revisiting; but requires time + energy from some one.

GC: if we used tuxmake, could always recompile those packages. 

KH: would be very useful

JO: but there’s also a large stoplist. Having been trying to rebuild v8 and hitting many problems. A docker container would be great, but would need specifics from BDR. e.g ImageMagick has >100 flags.

SU: what would be the aim? both maintaining the list of checks and documentation/images. e.g. could we prune/collapse them?

HW: Idea: if you can’t easily reproduce a check off CRAN, then it shouldn’t lead to your package being pulled off CRAN.

JO: would be create to containerise more checks — both safer and more reproducible.

KH: would like to containerize, but haven’t found time/energy. And it’s now hard to learn. Would really like to move forward. Would like “reasonable” reproducible. Worried about things that BDR flags that I can’t reproduce (e.g. sanitizers, MKO).

JO: very happy to help.

**Action items:**

* JO + KH to talk more about containerizing CRAN checks. 
* GC + SU to talk about opportunities for to share more code for mac
* Meet again in 2-3 months
