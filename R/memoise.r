#' Memoise a function.
#'
#' @param f function to memoise
#' @seealso \url{http://en.wikipedia.org/wiki/Memoization}
#' @aliases memoise memoize
#' @export memoise memoize
#' @importFrom digest digest
#' @examples
#' a <- function(x) runif(1)
#' replicate(10, a())
#' b <- memoise(a)
#' replicate(10, b())
#'
#' c <- memoise(function(x) { Sys.sleep(1); runif(1) })
#' system.time(print(c()))
#' system.time(print(c()))
#' forget(c)
#' system.time(print(c()))
memoize <- memoise <- function(f) {
  cache <- new_cache()
  
  function(...) {
    hash <- digest(list(...))
    
    if (cache$has_key(hash)) {
      cache$get(hash)
    } else {
      res <- f(...)
      cache$set(hash, res)
      res
    }
  }
}

#' Forget past results.
#' Resets the cache of a memoised function.
#'
#' @param f memoised function
#' @export
forget <- function(f) {
  if (!is.function(f)) return(FALSE)
  
  env <- environment(f)
  if (!exists("cache", env, inherits = FALSE)) return(FALSE)
  
  cache <- get("cache", env)
  cache$reset()
  
  TRUE
}