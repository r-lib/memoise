#' Filesystem Cache
#'
#' Use a cache on the local filesystem that will persist between R sessions.
#'
#' @param path Directory in which to store cached items.
#'
#' @examples
#'
#' \dontrun{
#' # Use with Dropbox
#'
#' db <- cache_filesystem("~/Dropbox/.rcache")
#'
#' mem_runif <- memoise(runif, cache = db)
#'
#' # Use with Google Drive
#'
#' gd <- cache_filesystem("~/Google Drive/.rcache")
#'
#' mem_runif <- memoise(runif, cache = gd)
#'
#' }
#'
#' @export
#' @inheritParams cache_memory
cache_filesystem <- function(path, algo = "xxhash64") {

  if (!dir.exists(path)) {
    dir.create(path, showWarnings = FALSE)
  }

  cache_reset <- function() {
    cache_files <- list.files(path, full.names = TRUE)
    file.remove(cache_files)
  }

  cache_set <- function(key, value) {
    saveRDS(value, file = file.path(path, key))
  }

  cache_get <- function(key) {
    readRDS(file = file.path(path, key))
  }

  cache_has_key <- function(key) {
    file.exists(file.path(path, key))
  }

  list(
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    keys = function() list.files(path)
  )
}
