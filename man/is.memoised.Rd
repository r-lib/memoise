\name{is.memoised}
\title{Test whether a function is a memoised copy.}
\description{Test whether a function is a memoised copy.
Memoised copies of functions carry an attribute 
\code{memoised = TRUE}, which is.memoised() tests for.}
\seealso{\code{\link{memoise}}, \code{\link{forget}}}
\alias{is.memoised}
\alias{is.memoized}
\arguments{\item{f}{Function to test.}}
\examples{mem_lm <- memoise(lm)
is.memoised(lm) # FALSE
is.memoised(mem_lm) # TRUE}
