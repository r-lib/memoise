#' PostgreSQL Cache
#' PostgreSQL-backed cache, for remote caching.
#'
#' Create a table with key and val columns.
#' CREATE TABLE r_cache (
#'   key VARCHAR(128) PRIMARY KEY,
#'   val TEXT
#' )
#'
#' @examples
#'
#' \dontrun{
#' pg <- cache_postgresql(pg_con, "r_cache")
#' mem_runif <- memoise(runif, cache = pg)
#' }
#'
#'
#' @param pg_con An RPostgreSQL connection object
#' @param table_name A postgres table name with val and key fields. May include a schema.
#' @param compress Argument passed to \code{saveRDS}. One of FALSE, "gzip",
#' "bzip2" or "xz". Default: FALSE.
#' @inheritParams cache_memory
#' @export
cache_postgresql <- function(pg_con, table_name, algo = "sha512", compress = FALSE) {

  path <- tempfile("memoise-")
  dir.create(path)

  if (!(requireNamespace("RPostgreSQL"))) { stop("Package `RPostgreSQL` must be installed for `cache_postgresql()`.") } # nocov
  if (!(requireNamespace("DBI"))) { stop("Package `DBI` must be installed for `cache_postgresql()`.") } # nocov
  if (!(requireNamespace("readr"))) { stop("Package `readr` must be installed for `cache_postgresql()`.") } # nocov

  cache_reset <- function() {
    DBI::dbSendQuery(
      pg_con,
      paste0("DELETE FROM ", table_name)
    )
  }

  cache_set <- function(key, value) {
    temp_file <- file.path(path, key)
    on.exit(unlink(temp_file))
    saveRDS(value, file = temp_file, compress = compress, ascii = TRUE)
    encoded <- readr::read_file(temp_file)
    DBI::dbSendQuery(
      pg_con,
      DBI::sqlInterpolate(
        pg_con,
        paste0(
          "INSERT INTO ", table_name,
          " VALUES (?key, ?encoded)"
        ),
        key = key,
        encoded = encoded
      )
    )
  }

  cache_get <- function(key) {
    temp_file <- file.path(path, key)
    on.exit(unlink(temp_file))
    rs <- DBI::dbGetQuery(
      pg_con,
      DBI::sqlInterpolate(
        pg_con,
        paste0(
          "SELECT val FROM ", table_name,
          " WHERE key = ?key"
        ),
        key = key
      )
    )
    readr::write_file(rs[1][[1]], temp_file)

    readRDS(temp_file)
  }

  cache_has_key <- function(key) {
    rs <- DBI::dbGetQuery(
      pg_con,
      DBI::sqlInterpolate(
        pg_con,
        paste0(
          "SELECT 1 FROM ", table_name,
          " WHERE key = ?key"
        ),
        key = key
      )
    )
    is_here <- nrow(rs) == 1
    # if not result is logical(0)
    if(identical(is_here, logical(0))){
      is_here <- FALSE
    }

    is_here
  }

  cache_drop_key <- function(key) {
    DBI::dbSendQuery(
      pg_con,
      DBI::sqlInterpolate(
        pg_con,
        paste0(
          "DELETE FROM ", table_name,
          " WHERE key = ?key"
        ),
        key = key
      )
    )
  }

  cache_keys <- function() {
    items <- DBI::dbGetQuery(
      pg_con,
      DBI::sqlInterpolate(
        pg_con,
        paste0(
          "SELECT key FROM ", table_name
        )
      )
    )
    items$key
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
