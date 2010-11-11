\name{forget}
\alias{forget}
\title{Forget past results.}
\usage{forget(f)}
\description{Forget past results.
Resets the cache of a memoised function.}
\seealso{\code{\link{memoise}}, \code{\link{is.memoised}}}
\arguments{\item{f}{memoised function}}
\examples{memX <- memoise(function() { Sys.sleep(1); runif(1) })
# The forget() function
system.time(print(memX()))
system.time(print(memX()))
forget(memX)
system.time(print(memX()))}
