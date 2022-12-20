### CRAN Discussion 2022-12-19
R Repositories Working Group

Minutes by Hadley Wickham

### Attendees

* Gabe Becker
* Kurt Hornik
* Michael Lawrence
* Martin Mächler
* Lluís Revilla
* Joseph Rickert
* Simon Urbanek
* Hadley Wickham

The meeting was recorded and the [video](https://positpbc.zoom.us/rec/share/-akNiLDeojiiFAwlH4rrlWOu5ASfQdE4RgvA82LJ2dvMlE_5d7txlMYymSV0SpU.wIluZcAvxqSjObVM?startTime=1671473061000) is available.

KH: put exactly Kurt’s set up in a docker container. 

GB: If the docker containers did exist, could CRAN use them? 

KH: would need to experiment. But getting increasing concerned with running code on their own systems.

SU: have a fully automated setup. Checks out svn & then run scripts. As self-contained as possible. Not even setting a long set of flags.

HW: surprised that –as-cran not used

SU: can’t actually use it if you’re CRAN.  Tried once and it broke a bunch of stuff. Maybe possible to have a new flag.

KH: regular checks, part of submission (needs to be a extra strict). Can not be fixed by adding more flags? –as-cran doesn’t use it because of subjectivity. UL and KH generally don’t show NOTEs that they won’t act upon, e.g. lacking native routine registration code. In principal, everything should be checked in. Would be happy to liaise with someone to work on, and make more maintainable for the long run. Good place to start is incoming checks; just Kurt and Uwe. In principle, should be fully aligned on env vars. (A few small differences, but likely to be resolvable.)

GB: what does flavour does –as-cran suggest? incoming or regular.

KH: BDR introduced –as-cran; documented as approximation as CRAN submission checks. But he never actually did checks. Better to hard wire in more sets of flags.

ML: can we refactor QA scripts to put all env vars in one file?

KH: In principle, incoming checks are the strictest. Revdep and regular checks turn some checks off to improve performance or because they’re not applicable (e.g. is a version new? how many days since last update?)

GB: Are they a strict subset?

KH: Yes, but there are some details. When you submit, it’s checked on a Kurt machine + an Uwe machine. And then if there are revdeps, Kurt’s machine does them. For a few months, Kurt’s machine uses clang, and revdepchecks use gcc. A version of package may have additional issues (e.g. BDR’s checks, or Tomas’ additional check) which are queued for manually inspection (e.g. m1mac). So have to email to BDR. KH pushing for full automation for many years. 

Can fully reproduce some additional checks and others can’t (e.g. fedora clang checks, openBLAS, altas). R-core needs to figure out how to handle –run-dont-test.

Probably can’t attend physical R developer sprint. So no reason not to start earlier. Happy to do it online. But if someone did come, Tomas would probably come from Prague. Needs to be someone expert in docker.

ML: Are there any other ways this committee can help?

SU: happy that there’s a line of communication between CRAN and r-hub. Happy to work with anyone. Now is a good time to collaborate for Simon since it’s summer.

Working system for checking in transient vms. Works for individual packages (e.g. mac check) and incoming, but not for revdeps. Happy to align env vars with Kurt/Uwe.

KH: One comment on technical side. For windows + mac, SU + UL build binaries and use for own checks. For linux, don’t build binaries. Dirk keeps talking about using linux binaries. Could massively speed things up by using binaries. Kurt currently works with library of 1,500 packages that are other used by many packages or take a long to time to respond.

Might be worth writing a bit of user level documentation. What should you really do when you get an email from CRAN saying there’s an ASAN issue and you’ve got two weeks to fix it. So here’s is what to do next.

ML: does that fit in google season of documentation?

LR: haven’t done it yet, but potential collaboration.

SU: want to be careful about increasing the amount of docs. R-pkg-devel seems pretty useful. Organising it well is really important. Worth mentioning that (e.g.) Tomas will usually fix rchk issues.

GB: when one of your dependencies is archived, is there some options for a CRAN unsafe repo? So they could still act as dependencies for other packages.

SU: sounds like a bad idea. If maintainer not response, and no problems, it’s fine. 

KH: one of the design principle is that active packages has active maintainers. Want to have a maintainer that’s committed to responding. Emailing maintainers of reverse dependencies is a way to increase the pressure. Some time it’s effective and other times no one responds, even those affected.

MM: would like to change how things work because it might be the only source. And suddenly it disappears. And practically it disappears for 99% of users. And sometimes the reasons is that the Rd parser has changed, and code that was fine before is no longer fine. 

HW: maybe worth having a new level that means should be fixed on next submission.

ML: two concrete takeaways:

1. refactor CRAN scripts to extract env vars. Maybe with Gabor?
2. There is a need for CRAN documentation.

KH: if we schedule another meeting, would be great to discuss R-hub more. Need to get Gabor on the call.

SU: would like to talk about r-lib/actions. Would like to align efforts. Find some time mid January.

**Action** JR to schedule a meeting in mid January with Gábor.
