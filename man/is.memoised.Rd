\name{is.memoised}
\title{Test whether a function is a memoised copy.}
\description{Test whether a function is a memoised copy.
is.memoised(\kbd{f}) returns \code{TRUE} if \kbd{f} is a memoised
function. It looks for an attribute \code{memoised} set to \code{TRUE}.}
\seealso{\code{\link{memoise}}, \code{\link{forget}}}
\alias{is.memoised}
\alias{is.memoized}
\arguments{\item{f}{Function to test.}}
\examples{mem_lm <- memoise(lm)
is.memoised(lm) # FALSE
is.memoised(mem_lm) # TRUE}
