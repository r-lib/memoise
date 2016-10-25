#' In Memory Cache
#'
#' A cache in memory, that lasts only in the current R session.
#' @param algo The hashing algorithm used for the cache, see
#' \code{\link[digest]{digest}} for available algorithms.
#' @export
cache_memory <- function(algo = "sha512") {

  cache <- NULL
  cache_reset <- function() {
    cache <<- new.env(TRUE, emptyenv())
  }

  cache_set <- function(key, value) {
    assign(key, value, envir = cache)
  }

  cache_get <- function(key) {
    get(key, envir = cache, inherits = FALSE)
  }

  cache_has_key <- function(key) {
    exists(key, envir = cache, inherits = FALSE)
  }

  cache_reset()
  list(
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    keys = function() ls(cache)
  )
}
