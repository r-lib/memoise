#' gs_cache
#'
#' Use google storage as a cache. Requires authentication.
#'
#' @export

cache_gs <- function(project, cache_name = "rcache") {


  options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/devstorage.full_control",
                                          "https://www.googleapis.com/auth/devstorage.read_write"))

  googleAuthR::gar_auth()

  base_url <- paste0("https://www.googleapis.com/storage/v1/b?project=andersen-lab")

  transaction <- googleAuthR::gar_api_generator(base_url,
                                                "GET",
                                                data_parse_function = function(x) x)
  transaction()


  cache <- NULL
  cache_reset <- function() {
    cache <<- new.env(TRUE, emptyenv())
  }

  cache_set <- function(key, value) {
    assign(key, value, envir = cache)
  }

  cache_get <- function(key) {
    get(key, envir = cache, inherits = FALSE)
  }

  cache_has_key <- function(key) {
    exists(key, envir = cache, inherits = FALSE)
  }

  cache_reset()
  list(
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    keys = function() ls(cache)
  )
}
