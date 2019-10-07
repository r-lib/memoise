#' In Memory Cache
#'
#' A cache in memory, that lasts only in the current R session.
#' @param algo The hashing algorithm used for the cache, see
#' \code{\link[digest]{digest}} for available algorithms.
#' @param compress Default FALSE, otherwise "qs_fast" or
#' "qs_balanced" will be passed to \code{qs::qserialise}.
#' Compression will always be slower than none, but it can
#' substantially reduce the memory usage, and hence allow
#' a effectively larger cache size.
#' @export
cache_memory <- function(algo = "sha512", compress = FALSE) {

  if(compress %in% c("qs_fast", "qs_balanced")){
    if (!(requireNamespace("qs"))) { stop("Package `qs` must be installed for \"qs_fast\" or \"qs_balanced\" compression options") } #nocov
  }

  cache <- NULL
  cache_reset <- function() {
    cache <<- new.env(TRUE, emptyenv())
  }

  cache_set <- function(key, value) {
    if(compress %in% c("qs_fast", "qs_balanced")){
      assign(key, qs::qserialize(value, preset = c("qs_fast" = "fast", "qs_balanced" = "balanced")[compress]), envir = cache)
    }else{
      assign(key, value, envir = cache)
    }

  }

  cache_get <- function(key) {
    if(compress %in% c("qs_fast", "qs_balanced")){
      qs::qdeserialize(get(key, envir = cache, inherits = FALSE), strict = TRUE)
    }else{
      get(key, envir = cache, inherits = FALSE)
    }
  }

  cache_has_key <- function(key) {
    exists(key, envir = cache, inherits = FALSE)
  }

  cache_drop_key <- function(key) {
    rm(list = key, envir = cache, inherits = FALSE)
  }

  cache_reset()
  list(
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    drop_key = cache_drop_key,
    keys = function() ls(cache)
  )
}
