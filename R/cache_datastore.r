rdatastore_env <- new.env()
datastore_url <- "https://www.googleapis.com/auth/datastore"


#' Authenticate Datastore using a service account
#'
#' Set credentials to the name of an environmental variable
#' or the location of your service account json key file.
#'
#' @param credentials Environmental variable or service account.
#' @param project Google cloud platform project id/name.
#'
#' @seealso \url{https://cloud.google.com/}
#' @seealso \url{https://cloud.google.com/datastore/docs/concepts/overview}
#' @seealso \url{https://developers.google.com/identity/protocols/OAuth2#basicsteps}
#'
#' @export


authenticate_datastore_service <- function(credentials, project) {
  # Locate Credentials
  if (file.exists(as.character(credentials))) {
    credentials <- jsonlite::fromJSON(credentials)
  } else if (Sys.getenv(credentials) != "") {
    credentials <- jsonlite::fromJSON(Sys.getenv(credentials))
  } else {
    stop("Could not find credentials")
  }

  google_token <- httr::oauth_service_token(httr::oauth_endpoints("google"),
                                            credentials,
                                            scope = datastore_url)

  url <- paste0("https://datastore.googleapis.com/v1beta3/projects/", project)
  # Create global variable for project id
  assign("project_id", project, envir=rdatastore_env)
  assign("token", google_token, envir=rdatastore_env)
  assign("url", url, envir=rdatastore_env)
}

#' Authenticate Datastore
#'
#' Authenticate datastore using OAuth 2.0. Create an application on the
#' \strong{google cloud platform}
#' and generate
#'
#' @param key OAuth 2.0 credential key
#' @param secret OAuth credential secret key
#' @param project Google cloud platform project id/name.
#'
#' @seealso \url{https://cloud.google.com/}
#' @seealso \url{https://cloud.google.com/datastore/docs/concepts/overview}
#' @seealso \url{https://developers.google.com/identity/protocols/OAuth2#basicsteps}
#'
#' @export

authenticate_datastore <- function(key, secret, project) {
  # Authorize app
  app <- httr::oauth_app("google",
                         key = key,
                         secret = secret)

  # Fetch token
  google_token <- httr::oauth2.0_token(httr::oauth_endpoints("google"),
                                       app,
                                       scope = datastore_url)
  url <- paste0("https://datastore.googleapis.com/v1beta3/projects/", project)
  # Create global variable for project id
  assign("project_id", project, envir=rdatastore_env)
  assign("token", google_token, envir=rdatastore_env)
  assign("url", url, envir=rdatastore_env)
}


#' datastore_cache
#'
#' Use google datastore to store and retrieve cache items. Requires authentication.
#'
#' @seealso \url{https://cloud.google.com/}
#' @seealso \url{https://cloud.google.com/datastore/docs/concepts/overview}
#' @seealso \url{https://developers.google.com/identity/protocols/OAuth2#basicsteps}
#'
#' @export

datastore_cache <- function(cache_name = "rcache") {

  transaction <- function() {
    req <- httr::POST(paste0(rdatastore_env$url, ":beginTransaction"),
                      httr::config(token = rdatastore_env$token),
                      encode = "json")
    if (req$status_code != 200) {
      stop(httr::content(req)$error$message)
    }
    httr::content(req)$transaction
  }

  cache <- NULL
  cache_reset <- function() {

  }

  cache_set <- function(key, value) {
    # Serialize value
    svalue <- base64enc::base64encode(serialize(value, NULL, ascii=T))
    path_item <- list(
      kind = cache_name,
      name = key
    )
    prop = list(
      object = list(blobValue = svalue)
    )

    transaction_id <- transaction()

    key_obj <- c(list(key = list(path = path_item),
                      properties = prop))
    mutation = list()
    mutation[["insert"]] =  key_obj
    body <- list(mutations = mutation,
                 transaction = transaction_id
    )

    req <- httr::POST(paste0(rdatastore_env$url, ":commit"),
                      httr::config(token = rdatastore_env$token),
                      body =  body,
                      encode = "json")

  }

  cache_get <- function(key) {
    path_item <- list(
      kind = cache_name,
      name = key
    )

    req <- httr::POST(paste0(rdatastore_env$url, ":lookup"),
                      httr::config(token = rdatastore_env$token),
                      body = list(keys = list(path = path_item)),
                      encode = "json")

    # Unserialize and return
    resp <- jsonlite::fromJSON(httr::content(req, as = "text"))$found
    value <- resp$entity$properties$object$blobValue
    unserialize(base64enc::base64decode(value))
  }

  cache_has_key <- function(key) {
    res <- try(cache_get(key), silent = TRUE)
    class(res) != "try-error"
  }

  cache_reset()
  list(
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    keys = function() message("Keys can't be listed with google datastore.")
  )
}



