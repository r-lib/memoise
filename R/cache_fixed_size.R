#' @describeIn cache_fixed_size First-in, first-out (FIFO) eviction strategy.
#' @export
evict_fifo <- function() {

  keys <- NULL

  reset <- function() {
    keys <<- NULL
  }

  add_key <- function(key) {
    keys <<- c(keys, key)
  }

  hit_key <- function(key) {
    NULL
  }

  drop_key <- function(key) {
    keys <<- keys[keys != key]
  }

  key_to_evict <- function() {
    if (is.null(keys)) NULL
    else keys[[1]]
  }

  reset()
  list(
    reset = reset,
    add_key = add_key,
    hit_key = hit_key,
    drop_key = drop_key,
    key_to_evict = key_to_evict
  )
}

#' @describeIn cache_fixed_size Least-recently-used (LRU) eviction strategy.
#' @export
evict_lru <- function() {

  keys <- NULL

  reset <- function() {
    keys <<- NULL
  }

  add_key <- function(key) {
    keys <<- c(keys, key)
  }

  hit_key <- function(key) {
    keys <<- c(keys[keys != key], key)
  }

  drop_key <- function(key) {
    keys <<- keys[keys != key]
  }

  key_to_evict <- function() {
    if (length(keys) == 0) NULL
    else keys[[1]]
  }

  reset()
  list(
    reset = reset,
    add_key = add_key,
    hit_key = hit_key,
    drop_key = drop_key,
    key_to_evict = key_to_evict
  )
}

#' Fixed Size Cache
#'
#' A fixed cache which drops key/values when it gets too large. Uses any
#' underlying cache (by default, \code{\link{cache_memory}}), and evicts
#' according to a specified rule (by default, first-in, first-out).
#'
#' You can define your own eviction strategy by creating a list with function
#' entries of \code{reset}, \code{add_key}, \code{hit_key}, \code{drop_key},
#' and \code{key_to_evict}; see the package source for examples.
#'
#' @param base_cache The base cache, by default \code{\link{cache_memory}}.
#' @param size The maximum number of key/values to keep in the cache.
#' @param eviction Eviction strategy; see below.
#' @examples
#' # Cache which remembers only the last function call
#' mem_runif <- memoise(runif, cache = cache_fixed_size(size = 1))
#' print(mem_runif(1))
#' print(mem_runif(1))  # Remembered
#' print(mem_runif(2))
#' print(mem_runif(1))  # Changed from last time
#' @export
cache_fixed_size <- function(size = 100, base_cache = cache_memory(),
                             eviction = evict_fifo()) {

  cache_reset <- function() {
    base_cache$reset()
    eviction$reset()
  }

  cache_set <- function(key, value) {
    base_cache$set(key, value)
    eviction$add_key(key)
    if (length(base_cache$keys()) > size) {
      cache_drop_key(eviction$key_to_evict())
    }
  }

  cache_get <- function(key) {
    eviction$hit_key(key)
    base_cache$get(key)
  }

  cache_drop_key <- function(key) {
    base_cache$drop_key(key)
    eviction$drop_key(key)
  }

  cache_reset()
  list(
    digest = base_cache$digest,
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = base_cache$has_key,
    drop_key = cache_drop_key,
    keys = base_cache$keys
  )
}
