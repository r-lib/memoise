#' datastore_cache
#'
#' Use google datastore to store and retrieve cache items. Requires authentication.
#'
#' @seealso \url{https://cloud.google.com/}
#' @seealso \url{https://cloud.google.com/datastore/docs/concepts/overview}
#' @seealso \url{https://developers.google.com/identity/protocols/OAuth2#basicsteps}
#'
#' @export

datastore_cache <- function(project, cache_name = "rcache") {

  options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/datastore",
                                            "https://www.googleapis.com/auth/userinfo.email"))

  googleAuthR::gar_auth()

  base_url <- paste0("https://datastore.googleapis.com/v1beta3/projects/", project)

  transaction <- googleAuthR::gar_api_generator(paste0(base_url, ":beginTransaction"),
                    "POST",
                    data_parse_function = function(x) x$transaction)

  commit_ds <- googleAuthR::gar_api_generator(paste0(base_url, ":commit"),
                                            "POST",
                                            data_parse_function = function(x) x)

  load_ds <- googleAuthR::gar_api_generator(paste0(base_url, ":lookup"),
                                            "POST",
                                            data_parse_function = function(resp) {
                                              # Unserialize and return
                                              if ("found" %in% names(resp)) {
                                                resp <- resp$found
                                                value <- resp$entity$properties$object$blobValue
                                                response <- unserialize(memDecompress(base64enc::base64decode(value), type = "gzip"))
                                              } else if ("missing" %in% names(resp)) {
                                                "!cache-not-found"
                                              } else {
                                                stop("Error")
                                              }
                                            })

  query_ds <- googleAuthR::gar_api_generator(paste0(base_url, ":runQuery"),
                                             "POST",
                                             data_parse_function = function(resp) resp)


  cache_reset <- function() {
    query_results <- query_ds(the_body = list(gqlQuery = list(queryString = paste0("SELECT * FROM ", cache_name))))
    while((query_results$batch$moreResults != "NO_MORE_RESULTS") | is.null(query_results$batch$entityResults) == FALSE) {
        ids <- (query_results$batch$entityResults$entity$key$path %>% dplyr::bind_rows())$name

        item_groups <- split(ids, (1:length(ids)) %/% 25)
        sapply(item_groups, function(idset) {
          mutations <- lapply(idset, function(x) {
            c(list("delete" = list(path = list(kind = cache_name, name = x))))
          })
          body <- list(mutations = mutations, transaction = transaction())
          resp <- try(commit_ds(the_body = body), silent = T)
          message("Clearing Cache")
        })
        query_results <- query_ds(the_body = list(gqlQuery = list(queryString = paste0("SELECT * FROM ", cache_name))))
    }
  }


  cache_set <- function(key, value) {
    # Serialize value
    svalue <- base64enc::base64encode(memCompress(serialize(value, NULL, ascii=T), type = "gzip"))
    path_item <- list(
      kind = cache_name,
      name = key
    )
    prop = list(
      object = list(blobValue = svalue, excludeFromIndexes = T)
    )

    transaction_id <- transaction()

    key_obj <- c(list(key = list(path = path_item),
                      properties = prop))
    mutation = list()
    mutation[["upsert"]] =  key_obj
    body <- list(mutations = mutation,
                 transaction = transaction_id
    )

    resp <- try(commit_ds(the_body = body), silent = T)
    if (class(resp) == "try-error") {
      warning(attr(resp, "condition"))
    }
  }

  cache_get <- function(key) {
    path_item <- list(
      kind = cache_name,
      name = key
    )

    resp <- load_ds(the_body = list(keys = list(path = path_item)))
    suppressWarnings( if(resp == "!cache-not-found") {
      stop("Cache Not Found")
    })
    resp
  }

  cache_has_key <- function(key) {
    res <- try(suppressWarnings(cache_get(key)), silent = TRUE)
    if (class(res) != "try-error") {
      message("Using Cached Version")
    }
    class(res) != "try-error"
  }

  list(
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    keys = function() message("Keys can't be listed with the google datastore cache.")
  )
}



