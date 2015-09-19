# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.2.2 (2015-08-14) |
|system   |x86_64, linux-gnu            |
|ui       |X11                          |
|language |en_US:en                     |
|collate  |en_US.UTF-8                  |
|tz       |NA                           |
|date     |2015-09-19                   |

## Packages

|package  |*  |version |date       |source         |
|:--------|:--|:-------|:----------|:--------------|
|digest   |   |0.6.8   |2014-12-31 |CRAN (R 3.2.0) |
|testthat |   |0.10.0  |2015-05-22 |CRAN (R 3.2.1) |

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

## icd9 (1.2.2)
Maintainer: Jack O. Wasey <jack@jackwasey.com>  
Bug reports: https://github.com/jackwasey/icd9/issues

```
checking installed package size ... NOTE
  installed size is  6.0Mb
  sub-directories of 1Mb or more:
    libs   3.6Mb
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

## lubridate (1.3.3)
Maintainer: Garrett Grolemund <garrett@rstudio.com>  
Bug reports: https://github.com/hadley/lubridate/issues

```
checking dependencies in R code ... NOTE
Missing or unexported object: ‘fts::dates.fts’
```
```
checking S3 generic/method consistency ... NOTE
Found the following apparent S3 methods exported but not registered:
  pretty.day pretty.hour pretty.min pretty.month pretty.point
  pretty.sec pretty.unit pretty.year
See section ‘Registering S3 methods’ in the ‘Writing R Extensions’
manual.
```
```
checking examples ... ERROR
Running examples in ‘lubridate-Ex.R’ failed
The error most likely occurred in:

> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
> ### Name: stamp
> ### Title: Format dates and times based on human-friendly templates.
> ### Aliases: stamp stamp_date stamp_time
> 
> ### ** Examples
> 
> D <- ymd("2010-04-05") - days(1:5)
> stamp("March 1, 1999")(D)
Using: "March %m, %Y"
[1] "March 04, 2010" "March 04, 2010" "March 04, 2010" "March 04, 2010"
[5] "March 03, 2010"
> sf <- stamp("Created on Sunday, Jan 1, 1999 3:34 pm")
Using: "Created on Sunday, %b %d, %Y %H:%M pm"
> sf(D)
[1] "Created on Sunday, Apr 04, 2010 00:00 pm"
[2] "Created on Sunday, Apr 03, 2010 00:00 pm"
[3] "Created on Sunday, Apr 02, 2010 00:00 pm"
[4] "Created on Sunday, Apr 01, 2010 00:00 pm"
[5] "Created on Sunday, Mär 31, 2010 00:00 pm"
> stamp("Jan 01")(D)
Multiple formats matched: "%b %y"(0), "%b %d"(1), "Jan %H"(1), "Jan %m"(1), "Jan %y"(1)
Using: "%b %y"
[1] "Apr 10" "Apr 10" "Apr 10" "Apr 10" "Mär 10"
> stamp("Sunday, May 1, 2000")(D)
Using: "Sunday, May %m, %Y"
[1] "Sunday, May 04, 2010" "Sunday, May 04, 2010" "Sunday, May 04, 2010"
[4] "Sunday, May 04, 2010" "Sunday, May 03, 2010"
> stamp("Sun Aug 5")(D) #=> "Sun Aug 04" "Sat Aug 04" "Fri Aug 04" "Thu Aug 04" "Wed Aug 03"
Multiple formats matched: "Sun %b %d"(1), "Sun Aug %m"(1)
Using: "Sun %b %d"
[1] "Sun Apr 04" "Sun Apr 03" "Sun Apr 02" "Sun Apr 01" "Sun Mär 31"
> stamp("12/31/99")(D)              #=> "06/09/11"
Using: "%m/%d/%y"
[1] "04/04/10" "04/03/10" "04/02/10" "04/01/10" "03/31/10"
> stamp("Sunday, May 1, 2000 22:10")(D)
Error in stamp("Sunday, May 1, 2000 22:10") : 
  Couldn't quess formats of: Sunday, May 1, 2000 22:10
Execution halted
```
```
checking tests ... ERROR
Running the tests in ‘tests/test-all.R’ failed.
Last 13 lines of output:
  1: withCallingHandlers(eval(code, new_test_environment), error = capture_calls, message = function(c) invokeRestart("muffleMessage"), 
         warning = function(c) invokeRestart("muffleWarning"))
  2: eval(code, new_test_environment)
  3: eval(expr, envir, enclos)
  4: test_that(stamp(test_dates[[i, "date"]])(D), equals(test_dates[[i, "expected"]])) at test-stamp.R:43
  5: test_code(desc, substitute(code), env = parent.frame())
  6: get_reporter()$start_test(description)
  7: .oapply(reporters, "start_test", desc)
  8: eval(substitute(o$FUN(...), list(FUN = method, ...)))
  9: stamp(test_dates[[i, "date"]])
  10: stop("Couldn't quess formats of: ", x)
  Error: Test failures
  Execution halted
```
```
DONE
Status: 2 ERRORs, 2 NOTEs
```

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

## surveillance (1.9-1)
Maintainer: Michael Höhle <hoehle@math.su.se>  
Bug reports: https://r-forge.r-project.org/tracker/?group_id=45

```
checking R code for possible problems ... NOTE
plot,stsNC-missing : .local : nowcastPlotHook: no visible binding for
  global variable ‘lwd’
plot,stsNC-missing : .local : nowcastPlotHook: no visible binding for
  global variable ‘lty’
plot,stsNC-missing : .local : nowcastPlotHook: no visible binding for
  global variable ‘legend.opts’
plot,stsNC-missing : .local: no visible binding for global variable ‘y’
```
```
DONE
Status: 1 NOTE
```

