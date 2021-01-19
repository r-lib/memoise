#' Azure Storage Cache
#' Azure Storage backed cache, for remote caching. You can use either file, blob or ADLSgen2 storage.
#'
#' @examples
#'
#' \dontrun{
#' library(AzureStor)
#'
#' stor <- storage_container("https://blob.{accountname}.core.windows.net",
#'                           key="{storage-key}")
#'
#' azcache <- cache_azure("cache_container", stor)
#' mem_runif <- memoise(runif, cache = azcache)
#'
#'
#' # alternative way of specifying the account
#' azcache <- cache_azure("cache_container", "https://blob.{accountname}.core.windows.net",
#'                        key="{storage_key}")
#' }
#'
#'
#' @param cache_name Name of the storage container for storing cache files.
#' @param account The storage account for the cache. This should be an object of class \code{\link[AzureStor::storage_endpoint]{AzureStor::storage_endpoint}}, or inheriting from it. Alternatively, you can provide the storage endpoint URL, along with one of the authentication arguments \code{key}, \code{token} or \code{sas}.
#' @param key The access key for the storage account.
#' @param token An Azure Active Directory (AAD) authentication token. This can be either a string, or an object of class \code{AzureToken} created by \code{\link[AzureAuth::get_azure_token]{AzureAuth::get_azure_token}}. The latter is the recommended way of doing it, as it allows for automatic refreshing of expired tokens.
#' @param sas A shared access signature (SAS) for the account.
#' @param compress Argument passed to \code{saveRDS}. One of FALSE, "gzip",
#' "bzip2" or "xz". Default: FALSE.
#' @inheritParams cache_memory
#' @export
cache_azure <- function(cache_name, account, key = NULL, token = NULL, sas = NULL,
                        algo = "sha512", compress = FALSE) {
  if(!requireNamespace("AzureStor")) { stop("Package `AzureStor` must be installed for `cache_azure()`.") } # nocov

  if(is.character(account)) {
    storage_account <- AzureStor::storage_endpoint(account, key, sas, token)
  } else if(!inherits(account, "storage_endpoint")) {
    stop("Must provide either the URL of a storage account endpoint, or a `storage_endpoint` object")
  }

  path <- tempfile("memoise-")
  dir.create(path)

  # create container if it doesn't exist
  try(AzureStor::create_storage_container(account, cache_name), silent = TRUE)
  cache <- AzureStor::storage_container(account, cache_name)

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
    AzureStor::storage_download(cache, key, rds, overwrite = TRUE)
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
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    drop_key = cache_drop_key,
    keys = cache_keys
  )
}
