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

* I ran R CMD check on all 21 downstream dependencies of memoise
  Summary at: https://github.com/hadley/memoise/blob/master/revdep/README.md

* There were 3 ERRORs:

  * gWidgets2RGtk2, gWidgets2tcltk these are installation errors due to failure
    to install RGtk2 and are unrelated to memoise.
  * biolink: This error is a false positive, related to the method used to
    checking reverse dependencies and is unrelated to changes in memoise.

* There was 1 WARNINGS:
  * regioneR: these NOTES and warnings are due to differences in Bioconductor
    and CRAN check procedures and are not due to changes in memoise.
