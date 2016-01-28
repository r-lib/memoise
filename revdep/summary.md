# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.2.3 (2015-12-10) |
|system   |x86_64, darwin15.2.0         |
|ui       |unknown                      |
|language |(EN)                         |
|collate  |en_US.UTF-8                  |
|tz       |America/New_York             |
|date     |2016-01-28                   |

## Packages

|package | * |version |date |source | * |
|:-------|:--|:-------|:----|:------|:--|

# Check results
11 checked out of 11 dependencies 

## crayon (1.3.1)
Maintainer: Gabor Csardi <csardi.gabor@gmail.com>  
Bug reports: https://github.com/gaborcsardi/crayon/issues

__OK__

## devtools (1.10.0)
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

```
checking tests ... ERROR
Running the tests in ‘tests/run-tests.R’ failed.
Last 13 lines of output:
   7: methods::new(def, ...)
   8: GSlider$new(toolkit, from, to, by, value, horizontal, handler,     action, container, ...)
   9: .gslider.guiWidgetsToolkitRGtk2(toolkit, from, to, by, value,     horizontal, handler, action, container = container, ...)
  10: .gslider(toolkit, from, to, by, value, horizontal, handler, action,     container = container, ...)
  11: gslider(from = 0, to = 100, by = 1, cont = g)
  12: eval(expr, envir, enclos)
  13: eval(ei, envir)
  14: withVisible(eval(ei, envir))
  15: source(i)
  16: FUN(X[[i]], ...)
  17: lapply(X = X, FUN = FUN, ...)
  18: sapply(f, function(i) {    message("testing ", i)    source(i)})
  aborting ...
```
```
DONE
Status: 1 ERROR
```

## gWidgets2tcltk (1.0-4)
Maintainer: John Verzani <jverzani@gmail.com>

__OK__

## icd9 (1.3)
Maintainer: Jack O. Wasey <jack@jackwasey.com>  
Bug reports: https://github.com/jackwasey/icd9/issues

```
checking data for non-ASCII characters ... NOTE
  Note: found 14 marked Latin-1 strings
  Note: found 39 marked UTF-8 strings
```
```
DONE
Status: 1 NOTE
```

## ltmle (0.9-6)
Maintainer: Joshua Schwab <joshuaschwab@yahoo.com>  
Bug reports: https://github.com/joshuaschwab/ltmle/issues

__OK__

## regioneR (1.2.0)
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
copySeqLevels: no visible global function definition for ‘seqlevels<-’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/randomizeRegions.R:350)
copySeqLevels: no visible global function definition for ‘seqlevels’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/randomizeRegions.R:350)
copySeqLevels: no visible global function definition for ‘seqlevels’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/randomizeRegions.R:351)
createRandomRegions: no visible global function definition for
  ‘seqlevels’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/createRandomRegions.R:50)
filterChromosomes: no visible global function definition for
  ‘keepSeqlevels’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/filterChromosomes.R:53)
randomizeRegions: no visible global function definition for ‘seqlevels’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/randomizeRegions.R:75-83)
randomizeRegions: no visible global function definition for ‘IRanges’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/randomizeRegions.R:113)
resampleRegions: no visible global function definition for ‘seqlevels’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/resampleRegions.R:49)
toGRanges: no visible global function definition for ‘IRanges’
  (/private/var/folders/dt/r5s12t392tb5sk181j3gs4zw0000gn/T/RtmprZ8p6a/check_cran12ff25dce9dcf/regioneR.Rcheck/00_pkg_src/regioneR/R/toGRanges.R:128)
```
```
checking Rd line widths ... NOTE
Rd file 'circularRandomizeRegions.Rd':
  \usage lines wider than 90 characters:
     circularRandomizeRegions(A, genome="hg19", mask=NULL, max.mask.overlap=NULL, max.retries=10, verbose=TRUE, ...)

Rd file 'commonRegions.Rd':
  \examples lines wider than 100 characters:
     plotRegions(list(A, B, commons), chromosome="chr1", regions.labels=c("A", "B", "common"), regions.colors=3:1)

Rd file 'createFunctionsList.Rd':
  \examples lines wider than 100 characters:
     funcs <- createFunctionsList(FUN=f, param.name="b", values=c(1,2,3), func.names=c("plusone", "plustwo", "plusthree"))

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
     pt2 <- permTest(A=A, B=B, ntimes=10, randomize.function=randomizeRegions, evaluate.function=list(overlap=numOverlaps, distance=meanDist ... [TRUNCATED]

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

Rd file 'plot.localZScoreResultsList.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=100000, length.sd=20000, genome=genome, non.overlapping=FALSE))
     pt2 <- permTest(A=A, B=B, ntimes=10, randomize.function=randomizeRegions, evaluate.function=list(overlap=numOverlaps, distance=meanDist ... [TRUNCATED]

Rd file 'plot.permTestResults.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))
     pt2 <- permTest(A=A, B=B, ntimes=10, alternative="auto", genome=genome, evaluate.function=meanDistance, randomize.function=randomizeReg ... [TRUNCATED]

Rd file 'plot.permTestResultsList.Rd':
  \examples lines wider than 100 characters:
     A <- createRandomRegions(nregions=20, length.mean=10000000, length.sd=20000, genome=genome, non.overlapping=FALSE)
     B <- c(A, createRandomRegions(nregions=10, length.mean=10000, length.sd=20000, genome=genome, non.overlapping=FALSE))
     pt2 <- permTest(A=A, B=B, ntimes=10, alternative="auto", genome=genome, evaluate.function=list(distance=meanDistance, numberOfOverlaps= ... [TRUNCATED]

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
     randomizeRegions(A, genome="hg19", mask=NULL, allow.overlaps=TRUE, per.chromosome=FALSE, ...)

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
DONE
Status: 4 NOTEs
```

## SamplingStrata (1.1)
Maintainer: Giulio Barcaroli <barcarol@istat.it>

__OK__

## surveillance (1.10-0)
Maintainer: Sebastian Meyer <Sebastian.Meyer@ifspm.uzh.ch>  
Bug reports: https://r-forge.r-project.org/tracker/?group_id=45

```
checking package dependencies ... NOTE
Package suggested but not available for checking: ‘INLA’
```
```
checking installed package size ... NOTE
  installed size is  7.8Mb
  sub-directories of 1Mb or more:
    R   4.3Mb
```
```
checking Rd cross-references ... NOTE
Packages unavailable to check Rd xrefs: ‘coin’, ‘VGAM’
```
```
checking examples ... ERROR
Running examples in ‘surveillance-Ex.R’ failed
The error most likely occurred in:

> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
> ### Name: twinstim_epitest
> ### Title: Permutation Test for Space-Time Interaction in '"twinstim"'
> ### Aliases: epitest coef.epitest plot.epitest
> ### Keywords: htest
> 
> ### ** Examples
> 
> data("imdepi")
> data("imdepifit")
> 
> ## test for space-time interaction of the B-cases
> ## assuming spatial interaction to be constant within 50 km
> imdepiB50 <- update(subset(imdepi, type == "B"), eps.s = 50)
Note: dropped type(s) "C"
> imdfitB50 <- update(imdepifit, data = imdepiB50,
+                     epidemic = ~1, epilink = "identity",
+                     siaf = NULL, control.siaf = NULL,
+                     start = c("e.(Intercept)" = 1e-6))
updating list of potential sources ...
assuming constant spatial interaction 'siaf.constant()'
assuming constant temporal interaction 'tiaf.constant()'

minimizing the negative log-likelihood using 'nlminb()' ...
initial parameters:
            h.(Intercept)      h.I(start/365 - 3.5) h.sin(2 * pi * start/365) 
             -20.53057516               -0.04567343                0.21693842 
h.cos(2 * pi * start/365)             e.(Intercept) 
               0.31764884                0.00000100 
negative log-likelihood and parameters in each iteration:
  0:     4927.5404: -20.5306 -0.0456734 0.216938 0.317649 1.00000e-06
  1:     4926.2928: -20.5603 -0.0230546 0.157162 0.404814 1.12303e-06
  2:     4926.2858: -20.5566 -0.0221811 0.165123 0.402575 1.13028e-06
  3:     4926.2858: -20.5567 -0.0222681 0.164822 0.403248 1.13028e-06

MLE:
            h.(Intercept)      h.I(start/365 - 3.5) h.sin(2 * pi * start/365) 
            -2.055673e+01             -2.226812e-02              1.648220e-01 
h.cos(2 * pi * start/365)             e.(Intercept) 
             4.032484e-01              1.130280e-06 
loglik(MLE) = -4926.286 

Done.
> 
> ## simple likelihood ratio test
> epitest(imdfitB50, imdepiB50, method = "LRT")

	Likelihood Ratio Test for Space-Time Interaction

data:  imdepiB50
twinstim:  imdfitB50
D = 105.76, df = 1, p-value < 2.2e-16

> 
> ## permutation test (only few permutations for speed, in parallel)
> et <- epitest(imdfitB50, imdepiB50, B = 4 + 25*surveillance.options("allExamples"),
+               verbose = 2 * (.Platform$OS.type == "unix"),
+               .seed = 1, .parallel = 2)
Endemic/Epidemic log-likelihoods, LRT statistic, and simple R0:
l0 = -4979 | l1 = -4926 | D = 105.8 | simpleR0 = 0.27

Results from B=4 permutations of time:

 *** caught segfault ***
address 0x110, cause 'memory not mapped'

Traceback:
 1: drop(mmhGrid %*% beta)
 2: .hIntTW(beta, uppert = uppert)
 3: heIntTWK(beta0, beta, gammapred, siafpars, tiafpars)
 4: objective(.par, ...)
 5: nlminb(start = optimArgs$par, objective = negll, gradient = negsc,     hessian = if (doHessian) neghess else NULL, control = nlminbControl,     lower = optimArgs$lower, upper = optimArgs$upper)
 6: twinstim(endemic = ~offset(log(popdensity)) + I(start/365 - 3.5) +     sin(2 * pi * start/365) + cos(2 * pi * start/365), epidemic = ~1,     data = .permdata, subset = !is.na(agegrp), start = c(-20.55672518676,     -0.0222681194425509, 0.164822014646932, 0.403248413226967,     1.13028012099544e-06), epilink = "identity", optim.args = list(        control = list(trace = FALSE)), model = FALSE, cumCIF = FALSE,     control.siaf = list(siafInt = NULL), cores = 1, verbose = FALSE)
 7: eval(expr, envir, enclos)
 8: eval(call, parent.frame())
 9: update.twinstim(model, data = .permdata, control.siaf = list(siafInt = .siafInt),     model = FALSE, cumCIF = FALSE, cores = 1, verbose = FALSE,     optim.args = list(fixed = fixed, control = list(trace = is.numeric(verbose) &&         verbose >= 3)))
10: FUN(X[[i]], ...)
11: lapply(X = S, FUN = FUN, ...)
12: doTryCatch(return(expr), name, parentenv, handler)
13: tryCatchOne(expr, names, parentenv, handlers[[1L]])
14: tryCatchList(expr, classes, parentenv, handlers)
15: tryCatch(expr, error = function(e) {    call <- conditionCall(e)    if (!is.null(call)) {        if (identical(call[[1L]], quote(doTryCatch)))             call <- sys.call(-4L)        dcall <- deparse(call)[1L]        prefix <- paste("Error in", dcall, ": ")        LONG <- 75L        msg <- conditionMessage(e)        sm <- strsplit(msg, "\n")[[1L]]        w <- 14L + nchar(dcall, type = "w") + nchar(sm[1L], type = "w")        if (is.na(w))             w <- 14L + nchar(dcall, type = "b") + nchar(sm[1L],                 type = "b")        if (w > LONG)             prefix <- paste0(prefix, "\n  ")    }    else prefix <- "Error : "    msg <- paste0(prefix, conditionMessage(e), "\n")    .Internal(seterrmessage(msg[1L]))    if (!silent && identical(getOption("show.error.messages"),         TRUE)) {        cat(msg, file = stderr())        .Internal(printDeferredWarnings())    }    invisible(structure(msg, class = "try-error", condition = e))})
 *** caught segfault ***

address 0x110, cause 'memory not mapped'
16: try(lapply(X = S, FUN = FUN, ...), silent = TRUE)
17: sendMaster(try(lapply(X = S, FUN = FUN, ...), silent = TRUE))
18: FUN(X[[i]], ...)
19: lapply(seq_len(cores), inner.do)
20: parallel::mclapply(X = X, FUN = .FUN, ..., mc.preschedule = TRUE,     mc.set.seed = TRUE, mc.silent = FALSE, mc.cores = .parallel)
21: plapply(X = integer(B), FUN = permfits1, .verbose = .verbose,     ...)
22: epitest(imdfitB50, imdepiB50, B = 4 + 25 * surveillance.options("allExamples"),     verbose = 2 * (.Platform$OS.type == "unix"), .seed = 1, .parallel = 2)
aborting ...

Traceback:
 1: drop(mmhGrid %*% beta)
 2: .hIntTW(beta, uppert = uppert)
 3: heIntTWK(beta0, beta, gammapred, siafpars, tiafpars)
 4: objective(.par, ...)
 5: nlminb(start = optimArgs$par, objective = negll, gradient = negsc,     hessian = if (doHessian) neghess else NULL, control = nlminbControl,     lower = optimArgs$lower, upper = optimArgs$upper)
 6: twinstim(endemic = ~offset(log(popdensity)) + I(start/365 - 3.5) +     sin(2 * pi * start/365) + cos(2 * pi * start/365), epidemic = ~1,     data = .permdata, subset = !is.na(agegrp), start = c(-20.55672518676,     -0.0222681194425509, 0.164822014646932, 0.403248413226967,     1.13028012099544e-06), epilink = "identity", optim.args = list(        control = list(trace = FALSE)), model = FALSE, cumCIF = FALSE,     control.siaf = list(siafInt = NULL), cores = 1, verbose = FALSE)
 7: eval(expr, envir, enclos)
 8: eval(call, parent.frame())
 9: update.twinstim(model, data = .permdata, control.siaf = list(siafInt = .siafInt),     model = FALSE, cumCIF = FALSE, cores = 1, verbose = FALSE,     optim.args = list(fixed = fixed, control = list(trace = is.numeric(verbose) &&         verbose >= 3)))
10: FUN(X[[i]], ...)
11: lapply(X = S, FUN = FUN, ...)
12: doTryCatch(return(expr), name, parentenv, handler)
13: tryCatchOne(expr, names, parentenv, handlers[[1L]])
14: tryCatchList(expr, classes, parentenv, handlers)
15: tryCatch(expr, error = function(e) {    call <- conditionCall(e)    if (!is.null(call)) {        if (identical(call[[1L]], quote(doTryCatch)))             call <- sys.call(-4L)        dcall <- deparse(call)[1L]        prefix <- paste("Error in", dcall, ": ")        LONG <- 75L        msg <- conditionMessage(e)        sm <- strsplit(msg, "\n")[[1L]]        w <- 14L + nchar(dcall, type = "w") + nchar(sm[1L], type = "w")        if (is.na(w))             w <- 14L + nchar(dcall, type = "b") + nchar(sm[1L],                 type = "b")        if (w > LONG)             prefix <- paste0(prefix, "\n  ")    }    else prefix <- "Error : "    msg <- paste0(prefix, conditionMessage(e), "\n")    .Internal(seterrmessage(msg[1L]))    if (!silent && identical(getOption("show.error.messages"),         TRUE)) {        cat(msg, file = stderr())        .Internal(printDeferredWarnings())    }    invisible(structure(msg, class = "try-error", condition = e))})
16: try(lapply(X = S, FUN = FUN, ...), silent = TRUE)
17: sendMaster(try(lapply(X = S, FUN = FUN, ...), silent = TRUE))
18: FUN(X[[i]], ...)
19: lapply(seq_len(cores), inner.do)
20: parallel::mclapply(X = X, FUN = .FUN, ..., mc.preschedule = TRUE,     mc.set.seed = TRUE, mc.silent = FALSE, mc.cores = .parallel)
21: plapply(X = integer(B), FUN = permfits1, .verbose = .verbose,     ...)
22: epitest(imdfitB50, imdepiB50, B = 4 + 25 * surveillance.options("allExamples"),     verbose = 2 * (.Platform$OS.type == "unix"), .seed = 1, .parallel = 2)
aborting ...
Error in as.data.frame(t(vapply(X = permfits, FUN = "[[", "stats", FUN.VALUE = numeric(5L),  : 
  error in evaluating the argument 'x' in selecting a method for function 'as.data.frame': Error in vapply(X = permfits, FUN = "[[", "stats", FUN.VALUE = numeric(5L),  : 
  values must be length 5,
 but FUN(X[[1]]) result is length 0
Calls: t -> vapply
Calls: epitest -> as.data.frame
Execution halted
```
```
DONE
Status: 1 ERROR, 3 NOTEs
```

## toaster (0.4.2)
Maintainer: Gregory Kanevsky <gregory.kanevsky@teradata.com>  
Bug reports: https://github.com/teradata-aster-field/toaster/issues

__OK__

