#' MongoDB Cache
#' MongoDB cache, for remote caching.
#'
#' @examples
#'
#' \dontrun{
#' # Creates a GridFS connection
#'
#' mongo_grid <- mongolite::gridfs(
#'   db = "memoize",
#'   prefix = "memoize"
#' )
#'
#' # Set mongo as a caching backend
#' mong <- cache_mongo(mongo_grid)
#' mem_runif <- memoise(runif, cache = mong)
#'
#' # Try the cache
#' mem_runif(2)
#' mem_runif(2)
#'
#' # Forget the cached fun
#' forget(mem_runif)
#' mem_runif(2)
#' mem_runif(2)
#'
#' # Remove the cache
#' mong$reset()
#' mem_runif(2)
#' mem_runif(2)
#'
#' # Adding some keys
#' mem_runif(3)
#' mem_runif(4)
#' mem_runif(5)

#' # List the keys
#' mong$keys()
#' # Drop one key
#' one <- mong$keys()[1]
#' two <- mong$keys()[2]
#' mong$drop_key(one)
#' mong$keys()
#'
#' # Test if has key
#' mong$has_key(one)
#' mong$has_key(two)
#'
#' }
#'
#'
#' @param mongo_grid A MongoDB GridFS connection object
#' @param compress Argument passed to \code{saveRDS}. One of FALSE, "gzip",
#' "bzip2" or "xz". Default: FALSE.
#' @inheritParams cache_memory
#' @export

cache_mongo <- function(
  mongo_grid,
  algo = "sha512",
  compress = FALSE
) {

  if (!(requireNamespace("mongolite"))) {
    stop("Package `mongolite` must be installed for `cache_mongo()`.")
  } # nocov

  if (!(inherits(mongo_grid, "gridfs"))){
    stop("Please use a gridfs object.")
  }

  path <- tempfile("memoise-")
  dir.create(path)

  cache_reset <- function() {
    mongo_grid$drop()
  }

  cache_set <- function(key, value) {
    temp_file <- file.path(path, key)
    on.exit(unlink(temp_file))
    saveRDS(value, file = temp_file, compress = compress)
    mongo_grid$write(
      temp_file,
      key,
      progress = FALSE,
      metadata = sprintf(
        '{"key": "%s"}',
        key
      )
    )
  }

  cache_get <- function(key) {
    temp_file <- file.path(path, key)
    mongo_grid$read(key, temp_file, progress = FALSE)
    readRDS(temp_file)
  }

  cache_has_key <- function(key) {
    nrow(
      mongo_grid$find(
        sprintf(
          '{"metadata.key": "%s"}',
          key
        )
      )
    )  > 0
  }

  cache_drop_key <- function(key) {
    mongo_grid$remove(
      sprintf(
        '{"metadata.key": "%s"}',
        key
      )
    )
  }

  cache_keys <- function() {
    mongo_grid$find()$name
  }

  list(
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    drop_key = cache_drop_key,
    keys = cache_keys
  )
}
