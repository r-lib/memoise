# Wrap an old-style cache so that the external API is consistent with that from
# the cache package.

#' @importFrom cachem key_missing
wrap_old_cache <- function(x) {
  if (!is_old_cache(x)) {
    stop("`x` must be an old-style cache.", call. = FALSE)
  }

  list(
    digest = x$digest,
    reset = x$reset,
    set = x$set,
    get = function(key) {
      if (!x$has_key(key)) {
        return(key_missing())
      }
      x$get(key)
    },
    exists = x$has_key,
    remove = x$drop_key,
    keys = x$keys
  )
}

# Returns TRUE if it's an old-style cache.
is_old_cache <- function(x) {
  is.function(x$digest) &&
    is.function(x$set) &&
    is.function(x$get) &&
    is.function(x$has_key)
}
