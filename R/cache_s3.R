#' Amazon Web Services S3 Cache
#' Amazon Web Services S3 backed cache, for remote caching.
#'
#' @examples
#'
#' \dontrun{
#' # Set AWS credentials.
#' Sys.setenv("AWS_ACCESS_KEY_ID" = "<access key>",
#'            "AWS_SECRET_ACCESS_KEY" = "<access secret>")
#'
#' # Set up a unique bucket name.
#' s3 <- cache_s3("unique-bucket-name")
#' mem_runif <- memoise(runif, cache = s3)
#' }
#'
#'
#' @param cache_name Bucket name for storing cache files.
#' @param compress Argument passed to \code{saveRDS}. One of FALSE, "gzip",
#' "bzip2" or "xz". Default: FALSE.
#' @inheritParams cache_memory
#' @export

cache_s3 <- function(cache_name, algo = "sha512", compress = FALSE) {

  if (!(requireNamespace("digest"))) { stop("Package `digest` must be installed for `cache_s3()`.") } # nocov
  if (!(requireNamespace("aws.s3"))) { stop("Package `aws.s3` must be installed for `cache_s3()`.") } # nocov

  if (!(aws.s3::bucket_exists(cache_name))) {
    aws.s3::put_bucket(cache_name) # nocov
  }

  path <- tempfile("memoise-")
  dir.create(path)

  cache_reset <- function() {
    keys <- cache_keys()
    lapply(keys, aws.s3::delete_bucket, bucket = cache_name)
  }

  cache_set <- function(key, value) {
    temp_file <- file.path(path, key)
    on.exit(unlink(temp_file))
    saveRDS(value, file = temp_file, compress = compress)
    aws.s3::put_object(temp_file, object = key, bucket = cache_name)
  }

  cache_get <- function(key) {
    temp_file <- file.path(path, key)
    httr::with_config(httr::write_disk(temp_file, overwrite = TRUE), {
      aws.s3::get_object(object = key, bucket = cache_name)
    })
    readRDS(temp_file)
  }

  cache_has_key <- function(key) {
    suppressMessages(aws.s3::head_object(object = key, bucket = cache_name))
  }

  cache_drop_key <- function(key) {
    aws.s3::delete_bucket(key, bucket = cache_name)
  }

  cache_keys <- function() {
    items <- lapply(aws.s3::get_bucket(bucket = cache_name), `[[`, "Key")
    as.character(unlist(Filter(Negate(is.null), items)))
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
