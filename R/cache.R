#' @export
cache <- function(code, ..., envir = parent.frame(), cache = cache_memory()) {
  expr <- substitute(code)
  key <- cache$digest(c(expr, lapply(list(...), function(x) eval(x[[2L]], environment(x)))))
  if (cache$has_key(key)) {
    res <- cache$get(key)
    if (res$visible) {
      res$value
    } else {
      invisible(res$value)
    }
  } else {
    f <- function() NULL
    body(f) <- expr
    environment(f) <- envir
    cache$set(key, f())
  }
}
