# R Repos for Regulatory Use Wishlist

> **Document Purpose:**  
> A brainstorming document for features that might benefit public repository use
> within regulated industries. This is most certainly not a set of requirements.

## Build/Check System Reproducibility

* Clarity on the configuration of systems used for running R CMD check / other
  tests (ideally, base images with full exec logs)
* Verifiable binary builds to safeguard against malicious build injection
* `revdepcheck` more formally integrated with build logs

## Package Stats

* Test execution status and/or logs
* Coverage stats (expression/line coverage)
* Traceability logs (matching test to executed lines/functions/objects, see
  [genentech/covtracer](https://github.com/Genentech/covtracer))
* [ROpenSci `srr`](https://docs.ropensci.org/srr/) integration for statistical
  methods implementations
* Improved display of package references/citations to make it easier to see at a
  glance if a package is widely used in peer-reviewed publications
* Transparent downloads statistics, ideally with ability to distinguish human
  users from automated downloads (for things like CI/CD)
* Open-source underlying tooling for checks/testing, enabling components to be
  run and reproduced in controlled environments. Components are also modular
  enough to fit into company specific tooling like existing cran-like setups, or
  where packages are installed by admins as system libraries in network
  restricted environments.  

## Quality Filter Flags

* Framework allowing the addition of specific flags, and mechanism to
  collectively and openly define those flags across companies (e.g.
  covr/covtracer thresholds, package inactive and maintainers email bounces,
  development repo not listed, etc).  

## Package Maintenance

* Confirmed active maintainers. Perhaps something like a yearly confirmation
  email when a package hasn’t received updates to safeguard against abandoned
  packages.  

## Repo Endpoint Behaviors

* Historical snapshots that remain human interpretable when more than one update
  in a calendar day

    `https://fake-repo.org/snapshot/2022-01-01` (by calendar date)  
    `https://fake-repo.org/snapshot/2022-01-01T01:01.00+000` (by timestamp)  
    `https://fake-repo.org/snapshot/12345`  (by change increment)  

* Perhaps the ability to specify filters via repo url query params and/or set
  alias for applied filters. For example, filtering on coverage threshold:

    `https://fake-repo.org?maintainer=active`

  Which would serve a repo endpoint of packages who themselves and all
  dependencies have an active maintainer
