#' Filesystem Cache
#'
#' Use a cache on the local filesystem that will persist between R sessions.
#'
#' @param path Directory in which to store cached items.
#' @param compress Argument passed to \code{saveRDS} or \code{qs::qsave}. One of FALSE, "gzip",
#' "bzip2", "xz", "qs_fast" or "qs_balanced". Default: FALSE.
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
cache_filesystem <- function(path, algo = "xxhash64", compress = FALSE) {

  if(compress %in% c("qs_fast", "qs_balanced")){
    if (!(requireNamespace("qs"))) { stop("Package `qs` must be installed for \"qs_fast\" or \"qs_balanced\" compression options") } #nocov
  }

  if (!dir.exists(path)) {
    dir.create(path, showWarnings = FALSE)
  }

  # convert to absolute path so it will work with user working directory changes
  path <- normalizePath(path)

  cache_reset <- function() {
    cache_files <- list.files(path, full.names = TRUE)
    file.remove(cache_files)
  }

  cache_set <- function(key, value) {
    cache_set_fs(value, path, key, compress)
  }

  cache_get <- function(key) {
    cache_get_fs(path, key, compress)
  }

  cache_has_key <- function(key) {
    file.exists(file.path(path, key))
  }

  cache_drop_key <- function(key) {
    file.remove(file.path(path, key))
  }

  list(
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    drop_key = cache_drop_key,
    keys = function() list.files(path)
  )
}
