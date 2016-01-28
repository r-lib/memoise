I (Jim Hester) and taking over maintenance of the memoise package from Hadley
Wickham.

## Test environments
* local OS X install, R 3.2.3
* ubuntu 12.04 (on travis-ci), R 3.2.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs, WARNINGs

There was 1 NOTES:

Possibly mis-spelled words in DESCRIPTION:
  Memoisation (2:8)
  pre (9:50)

Both of these cases seem to be appropriate and correct spellings.

## Downstream dependencies

* I ran R CMD check on all 11 downstream dependencies of memoise
  Summary at: https://github.com/hadley/memoise/blob/master/revdep/summary.md

* There were 2 ERRORs:

  * gWidgets2RGtk2: this is an error on OSX builds independent of memoise, it is
    currently failing in CRANs nightly builds with the same error.
    (https://www.r-project.org/nosvn/R.check/r-devel-osx-x86_64-clang/gWidgets2RGtk2-00check.html)

  * surveillance: This looks like a error in the parallel code of surveillance
    which I believe is unrelated to it's use of memoise. I have notified the authors of
    the issue.
