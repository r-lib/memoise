#' Azure Storage Cache
#'
#' Azure Storage backed cache, for remote caching. File, blob and ADLSgen2 storage are all supported.
#'
#' @examples
#'
#' \dontrun{
#' library(AzureStor)
#'
#' # use Azure blob storage for the cache
#' stor <- storage_endpoint("https://blob.accountname.core.windows.net", key="storage-key")
#' azcache <- cache_azure("cache_container", stor)
#' mem_runif <- memoise(runif, cache = azcache)
#'
#'
#' # you can also pass the endpoint URL and key to cache_azure:
#' azcache <- cache_azure("cache_container", "https://blob.accountname.core.windows.net",
#'                        key = "storage-key")
#'
#' # a better alternative to a master key: OAuth 2.0 authentication via AAD
#' token <- AzureAuth::get_azure_token(
#'   "https://storage.azure.com",
#'   tenant = "mytenant",
#'   app = "app_id"
#' )
#' azcache <- cache_azure("cache_container", "https://blob.accountname.core.windows.net",
#'                        token = token)
#' }
#'
#' @param cache_name Name of the storage container for storing cache files.
#' @param endpoint The storage account endpoint for the cache. This should be an object of class \code{AzureStor::storage_endpoint}, or inheriting from it. Alternatively, you can provide the endpoint URL as a string, and pass any authentication arguments in `...`.
#' @param compress Argument passed to \code{saveRDS}. One of FALSE, "gzip",
#' "bzip2" or "xz". Default: FALSE.
#' @param ... Further arguments that will be passed to \code{AzureStor::storage_endpoint}, if \code{endpoint} is a URL.
#' @export
cache_azure <- function(cache_name, endpoint, compress = FALSE, ...) {
  if(!requireNamespace("AzureStor")) { stop("Package `AzureStor` must be installed for `cache_azure()`.") } # nocov

  if(is.character(endpoint)) {
    endpoint <- AzureStor::storage_endpoint(endpoint, ...)
  } else if(!inherits(endpoint, "storage_endpoint")) {
    stop("Must provide either the URL of a storage account endpoint, or a `storage_endpoint` object")
  }

  path <- tempfile("memoise-")
  dir.create(path)

  # create container if it doesn't exist
  try(AzureStor::create_storage_container(endpoint, cache_name), silent = TRUE)
  cache <- AzureStor::storage_container(endpoint, cache_name)

  cache_reset <- function() {
    keys <- cache_keys()
    lapply(keys, function(key) {
       AzureStor::delete_storage_file(cache, key, confirm = FALSE)
    })
  }

  cache_set <- function(key, value) {
    rds <- file.path(path, key)
    saveRDS(value, rds, compress = compress)
    opts <- options(azure_storage_progress_bar = FALSE)
    on.exit({
      unlink(rds)
      options(opts)
    })
    AzureStor::storage_upload(cache, rds, key)
  }

  cache_get <- function(key) {
    rds <- file.path(path, key)
    opts <- options(azure_storage_progress_bar = FALSE)
    on.exit({
      unlink(rds)
      options(opts)
    })
    res <- try(AzureStor::storage_download(cache, key, rds, overwrite = TRUE), silent = TRUE)
    if(inherits(res, "try-error")) {
      return(cachem::key_missing())
    }
    readRDS(rds)
  }

  cache_has_key <- function(key) {
    key %in% cache_keys()
  }

  cache_drop_key <- function(key) {
    AzureStor::delete_storage_file(cache, key, confirm = FALSE)
  }

  cache_keys <- function() {
    AzureStor::list_storage_files(cache, info = "name")
  }

  list(
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    exists = cache_has_key,
    remove = cache_drop_key,
    keys = cache_keys
  )
}
