\name{memoize}
\title{Memoise a function.}
\usage{memoize(f)}

\description{
  Memoise a function.
}
\seealso{\url{http://en.wikipedia.org/wiki/Memoization}}
\alias{memoise}
\alias{memoize}
\arguments{
  \item{f}{function to memoise}
}
\examples{a <- function(x) runif(1)
replicate(10, a())
b <- memoise(a)
replicate(10, b())

c <- memoise(function(x) { Sys.sleep(1); runif(1) })
system.time(print(c()))
system.time(print(c()))
forget(c)
system.time(print(c()))}
