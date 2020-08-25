#' Redis Cache
#'
#' Use a Redis based cache to persist memoisation between R sessions.
#'
#' @param ... arguments passed along to the `hiredis()` function in the **redux** package.
#' @inheritParams cache_memory
#' @author Carson Sievert
#' @export
#' @examples
#'
#' \dontrun{
#' my_function <- memoise::memoise(
#'   function(input) {
#'     Sys.sleep(5)
#'     paste('Input was', input)
#'   },
#'   cache = cache_redis()
#' )
#' my_function("a")
#' my_function("a")
#'
#' }
cache_redis <- function(..., algo = "md5") {

  if (!requireNamespace("redux")) {
    stop("Package `redux` must be installed for `cache_redis()`. Please install and try again.")
  } # nocov

  r <- redux::hiredis(...)

  cache_reset <- function() {
    r$FLUSHALL()
  }

  cache_set <- function(key, value) {
    r$SET(key, redux::object_to_bin(value))
  }

  cache_get <- function(key) {
    redux::bin_to_object(r$GET(key))
  }

  cache_has_key <- function(key) {
    length(r$KEYS(key)) == 1
  }

  list(
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    keys = function() r$KEYS("*")
  )
}
