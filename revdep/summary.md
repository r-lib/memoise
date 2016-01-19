# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.2.3 (2015-12-10) |
|system   |x86_64, linux-gnu            |
|ui       |X11                          |
|language |en_US:en                     |
|collate  |en_US.UTF-8                  |
|tz       |NA                           |
|date     |2016-01-13                   |

## Packages

|package  |*  |version |date       |source         |
|:--------|:--|:-------|:----------|:--------------|
|digest   |   |0.6.9   |2016-01-08 |CRAN (R 3.2.3) |
|testthat |   |0.11.0  |2015-10-14 |CRAN (R 3.2.2) |

# Check results
10 checked out of 10 dependencies 

## crayon (1.3.1)
Maintainer: Gabor Csardi <csardi.gabor@gmail.com>  
Bug reports: https://github.com/gaborcsardi/crayon/issues

__OK__

## devtools (1.9.1)
Maintainer: Hadley Wickham <hadley@rstudio.com>  
Bug reports: https://github.com/hadley/devtools/issues

```
checking foreign function calls ... NOTE
Registration problem:
  Evaluating ‘dll$foo’ during check gives error
‘object 'dll' not found’:
   .C(dll$foo, 0L)
See chapter ‘System and foreign language interfaces’ in the ‘Writing R
Extensions’ manual.
```
```
checking R code for possible problems ... NOTE
Found the following calls to attach():
File ‘devtools/R/package-env.r’:
  attach(NULL, name = pkg_env_name(pkg))
File ‘devtools/R/shims.r’:
  attach(e, name = "devtools_shims", warn.conflicts = FALSE)
See section ‘Good practice’ in ‘?attach’.
```
```
DONE
Status: 2 NOTEs
```

## functools (0.2.0)
Maintainer: Paul Hendricks <paul.hendricks.2013@owu.edu>  
Bug reports: https://github.com/paulhendricks/functools/issues

__OK__

## gWidgets2RGtk2 (1.0-3)
Maintainer: John Verzani <jverzani@gmail.com>

__OK__

## gWidgets2tcltk (1.0-4)
Maintainer: John Verzani <jverzani@gmail.com>

__OK__

## icd9 (1.3)
Maintainer: Jack O. Wasey <jack@jackwasey.com>  
Bug reports: https://github.com/jackwasey/icd9/issues

```
checking installed package size ... NOTE
  installed size is  6.4Mb
  sub-directories of 1Mb or more:
    libs   3.9Mb
```
```
checking data for non-ASCII characters ... NOTE
  Note: found 14 marked Latin-1 strings
  Note: found 39 marked UTF-8 strings
```
```
DONE
Status: 2 NOTEs
```

## ltmle (0.9-6)
Maintainer: Joshua Schwab <joshuaschwab@yahoo.com>  
Bug reports: https://github.com/joshuaschwab/ltmle/issues

__OK__

## regioneR (1.0.3)
Maintainer: Bernat Gel <bgel@imppc.org>

```
checking DESCRIPTION meta-information ... NOTE
Packages listed in more than one of Depends, Imports, Suggests, Enhances:
  ‘memoise’ ‘GenomicRanges’ ‘BSgenome’ ‘rtracklayer’ ‘parallel’
A package should be listed in only one of these fields.
```
```
checking S3 generic/method consistency ... NOTE
Found the following apparent S3 methods exported but not registered:
  print.permTestResults
See section ‘Registering S3 methods’ in the ‘Writing R Extensions’
manual.
```
```
checking R code for possible problems ... NOTE
createRandomRegions: no visible global function definition for
  ‘seqlevels’
filterChromosomes: no visible global function definition for
  ‘keepSeqlevels’
randomizeRegions: no visible global function definition for
  ‘seqlevels<-’
randomizeRegions: no visible global function definition for ‘seqlevels’
resampleRegions: no visible global function definition for ‘seqlevels’
toGRanges: no visible global function definition for ‘IRanges’
```
```
checking Rd line widths ... NOTE
Rd file 'circularRandomizeRegions.Rd':
  \usage lines wider than 90 characters:
     circularRandomizeRegions(A, genome="hg19", mask=NULL, max.mask.overlap=NULL, max.retries=10, verbose=TRUE, ...)

Rd file 'commonRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, B, commons), chromosome="chr1", regions.labels=c("A", "B", "common"), regions.colors=3:1)

Rd file 'createRandomRegions.Rd':
  \usage lines wider than 90 characters:
     createRandomRegions(nregions=100, length.mean=250, length.sd=20, genome="hg19", mask=NULL, non.overlapping=TRUE)

Rd file 'extendRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, extend1, extend2, extend3), chromosome="chr1", regions.labels=c("A", "extend1", "extend2", "extend3"), regions.colo ... [TRUNCATED]

Rd file 'joinRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, join1, join2, join3), chromosome="chr1", regions.labels=c("A", "join1", "join2", "join3"), regions.colors=4:1)

Rd file 'localZScore.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))

Rd file 'mergeRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, B, merges), chromosome="chr1", regions.labels=c("A", "B", "merges"), regions.colors=3:1)

Rd file 'numOverlaps.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))

Rd file 'overlapGraphicalSummary.Rd':
  \usage lines wider than 90 characters:
     overlapGraphicalSummary(A, B, regions.labels=c("A","B"), regions.colors=c("black","forestgreen","darkred"), ...)

Rd file 'overlapPermTest.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))

Rd file 'overlapRegions.Rd':
  \usage lines wider than 90 characters:
     overlapRegions(A, B, colA=NULL, colB=NULL, type="any", min.bases=1, min.pctA=NULL, min.pctB=NULL, get.pctA=FALSE, get.pctB=FALSE, get.b ... [TRUNCATED]

Rd file 'permTest.Rd':
  \usage lines wider than 90 characters:
     permTest(A, ntimes=100, randomize.function, evaluate.function, alternative="auto", min.parallel=1000, force.parallel=NULL, randomize.fu ... [TRUNCATED]
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))
     pt2 <- permTest(A=A, B=B, ntimes=10, alternative="auto", verbose=TRUE, genome=genome, evaluate.function=meanDistance, randomize.functio ... [TRUNCATED]

Rd file 'plot.localZScoreResults.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=100000, length.sd=20000, genome=genome, non.overlapping=FALSE))

Rd file 'plot.permTestResults.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))
     pt2 <- permTest(A=A, B=B, ntimes=10, alternative="auto", genome=genome, evaluate.function=meanDistance, randomize.function=randomizeReg ... [TRUNCATED]

Rd file 'plotRegions.Rd':
  \usage lines wider than 90 characters:
     plotRegions(x, chromosome, start=NULL, end=NULL, regions.labels=NULL, regions.colors=NULL, ...)

Rd file 'print.permTestResults.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))
     pt <- permTest(A=A, B=B, ntimes=10, alternative="auto", verbose=TRUE, genome=genome, evaluate.function=meanDistance, randomize.function ... [TRUNCATED]

Rd file 'randomizeRegions.Rd':
  \usage lines wider than 90 characters:
     randomizeRegions(A, genome="hg19", mask=NULL, non.overlapping=TRUE, per.chromosome=FALSE, ...)

Rd file 'recomputePermTest.Rd':
  \examples lines wider than 100 characters:
     resPerm <- permTest(A=A, B=B, ntimes=5, alternative="less", genome="hg19", evaluate.function=meanDistance, randomize.function=randomize ... [TRUNCATED]

Rd file 'splitRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, B, splits), chromosome=1, regions.labels=c("A", "B", "splits"), regions.colors=3:1)

Rd file 'subtractRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, B, subtract), chromosome=1, regions.labels=c("A", "B", "subtract"), regions.colors=3:1)

Rd file 'uniqueRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, B, uniques), chromosome="chr1", regions.labels=c("A", "B", "uniques"), regions.colors=3:1)

These lines will be truncated in the PDF manual.
```
```
checking files in ‘vignettes’ ... NOTE
The following directory looks like a leftover from 'knitr':
  ‘figure’
Please remove from your package.
```
```
DONE
Status: 5 NOTEs
```

## surveillance (1.10-0)
Maintainer: Sebastian Meyer <Sebastian.Meyer@ifspm.uzh.ch>  
Bug reports: https://r-forge.r-project.org/tracker/?group_id=45

```
checking package dependencies ... NOTE
Package suggested but not available for checking: ‘gsl’
```
```
checking tests ... ERROR
Running the tests in ‘tests/testthat.R’ failed.
Last 13 lines of output:
  'Fcircle' vs. cubature using method = "midpoint" ... TRUE 
  'deriv' vs. numerical derivative ... TRUE 
  'Deriv' vs. cubature using method = "midpoint" ... 
  	siaf parameter 1: TRUE 
  	siaf parameter 2: TRUE 
  	siaf parameter 3: TRUE 
  testthat results ================================================================
  OK: 196 SKIPPED: 0 FAILED: 2
  1. Failure (at test-calibration.R#25): still the same z-statistics with rps 
  2. Failure (at test-calibration.R#28): still the same z-statistics with rps 
  
  Error: testthat unit tests failed
  Execution halted
```
```
DONE
Status: 1 ERROR, 1 NOTE
```

## toaster (0.4.1)
Maintainer: Gregory Kanevsky <gregory.kanevsky@teradata.com>  
Bug reports: https://github.com/teradata-aster-field/toaster/issues

__OK__

