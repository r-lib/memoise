#' \code{mf <- memoise(f)} creates \code{mf}, a memoised copy of
#' \code{f}. A memoised copy is basically a
#' lazier version of the same function: it saves the answers of
#' new invocations, and re-uses the answers of old ones. Under the right
#' circumstances, this can provide a very nice speedup indeed.
#'
#' There are two main ways to use the \code{memoise} function. Say that
#' you wish to memoise \code{glm}, which is in the \code{stats}
#' package; then you could use \cr
#'   \code{  mem_glm <- memoise(glm)}, or you could use\cr
#'   \code{  glm <- memoise(stats::glm)}. \cr
#' The first form has the advantage that you still have easy access to
#' both the memoised and the original function. The latter is especially
#' useful to bring the benefits of memoisation to an existing block
#' of R code.
#'
#' Two example situations where \code{memoise} could be of use:
#' \itemize{
#'   \item You're evaluating a function repeatedly over the rows (or
#'     larger chunks) of a dataset, and expect to regularly get the same
#'     input.
#'   \item You're debugging or developing something, which involves
#'     a lot of re-running the code.  If there are a few expensive calls
#'     in there, memoising them can make life a lot more pleasant.
#'     If the code is in a script file that you're \code{source()}ing,
#'     take care that you don't just put \cr
#'       \code{  glm <- memoise(stats::glm)} \cr
#'     at the top of your file: that would reinitialise the memoised
#'     function every time the file was sourced. Wrap it in \cr
#'       \code{  if (!is.memoised(glm)) }, or do the memoisation call
#'     once at the R prompt, or put it somewhere else where it won't get
#'     repeated.
#' }
#'
#' @name memoise
#' @title Memoise a function.
#' @param f     Function of which to create a memoised copy.
#' @param envir Environment of the returned function.
#' @seealso \code{\link{forget}}, \code{\link{is.memoised}},
#'     \url{http://en.wikipedia.org/wiki/Memoization}
#' @aliases memoise memoize
#' @export memoise memoize
#' @importFrom digest digest
#' @examples
#' # a() is evaluated anew each time. memA() is only re-evaluated
#' # when you call it with a new set of parameters.
#' a <- function(n) { runif(n) }
#' memA <- memoise(a)
#' replicate(5, a(2))
#' replicate(5, memA(2))
#'
#' # Caching is done based on parameters' value, so same-name-but-
#' # changed-value correctly produces two different outcomes...
#' N <- 4; memA(N)
#' N <- 5; memA(N)
#' # ... and same-value-but-different-name correctly produces
#' #     the same cached outcome.
#' N <- 4; memA(N)
#' N2 <- 4; memA(N2)
#'
#' # memoise() knows about default parameters.
#' b <- function(n, dummy="a") { runif(n) }
#' memB <- memoise(b)
#' memB(2)
#' memB(2, dummy="a")
#' # This works, because the interface of the memoised function is the same as
#' # that of the original function.
#' formals(b)
#' formals(memB)
#' # However, it doesn't know about parameter relevance.
#' # Different call means different cacheing, no matter
#' # that the outcome is the same.
#' memB(2, dummy="b")
#'
#' # You can create multiple memoisations of the same function,
#' # and they'll be independent.
#' memA(2)
#' memA2 <- memoise(a)
#' memA(2)  # Still the same outcome
#' memA2(2) # Different cache, different outcome
#'
#' # Don't do the same memoisation assignment twice: a brand-new
#' # memoised function also means a brand-new cache, and *that*
#' # you could as easily and more legibly achieve using forget().
#' # (If you're not sure whether you already memoised something,
#' #  use is.memoised() to check.)
#' memA(2)
#' memA <- memoise(a)
#' memA(2)
memoise <- memoize <- function(f, envir = parent.frame()) {
  # We must not even try evaluating f -- once we start, there's no way back
  if (inherits(try(eval.parent(substitute(f)), silent = TRUE), "try-error")) {
    warning("Can't access f -- using old-style memoisation with dots interface. ",
            "Define the memoised function before memoising to avoid this warning.")
    memoise_old(f)
  } else {
    memoise_new(f, envir)
  }
}

#' @importFrom stats setNames
memoise_new <- function(f, envir) {
  f_formals <- formals(args(f))
  f_formal_names <- names(f_formals)
  f_formal_name_list <- lapply(f_formal_names, as.name)

  # list(...)
  list_call <- make_call(quote(list), f_formal_name_list)

  # memoised_function(...)
  init_call_args <- setNames(f_formal_name_list, f_formal_names)
  init_call <- make_call(quote(memoised_function), init_call_args)

  cache <- new_cache()

  memo_f <- eval(
    bquote(function(...) {
      hash <- digest(.(list_call))

      if (cache$has_key(hash)) {
        res <- cache$get(hash)
      } else {
        res <- withVisible(.(init_call))
        cache$set(hash, res)
      }

      if (res$visible) {
        res$value
      } else {
        invisible(res$value)
      }
    },
    as.environment(list(list_call = list_call, init_call = init_call)))
  )
  formals(memo_f) <- f_formals
  attr(memo_f, "memoised") <- TRUE

  cache_env <- new.env(parent = envir)
  cache_env$cache <- cache
  cache_env$memoised_function <- f
  cache_env$digest <- digest
  environment(memo_f) <- cache_env

  return(memo_f)
}

make_call <- function(name, args) {
  stopifnot(is.name(name), is.list(args))
  as.call(c(list(name), args))
}

memoise_old <- function(f) {
  cache <- new_cache()

  memo_f <- function(...) {
    hash <- digest(list(...))

    if (cache$has_key(hash)) {
      res <- cache$get(hash)
    } else {
      res <- withVisible(f(...))
      cache$set(hash, res)
    }

    if (res$visible) {
      res$value
    } else {
      invisible(res$value)
    }
  }
  attr(memo_f, "memoised") <- TRUE
  return(memo_f)
}

#' Forget past results.
#' Resets the cache of a memoised function.
#'
#' @param f memoised function
#' @export
#' @seealso \code{\link{memoise}}, \code{\link{is.memoised}}
#' @examples
#' memX <- memoise(function() { Sys.sleep(1); runif(1) })
#' # The forget() function
#' system.time(print(memX()))
#' system.time(print(memX()))
#' forget(memX)
#' system.time(print(memX()))
forget <- function(f) {
  if (!is.memoised(f)) {
    return(FALSE)
  }

  env <- environment(f)
  if (!exists("cache", env, inherits = FALSE)) return(FALSE)

  cache <- get("cache", env)
  cache$reset()

  TRUE
}

#' Test whether a function is a memoised copy.
#' Memoised copies of functions carry an attribute
#' \code{memoised = TRUE}, which is.memoised() tests for.
#' @param f Function to test.
#' @seealso \code{\link{memoise}}, \code{\link{forget}}
#' @export is.memoised is.memoized
#' @aliases is.memoised is.memoized
#' @examples
#' mem_lm <- memoise(lm)
#' is.memoised(lm) # FALSE
#' is.memoised(mem_lm) # TRUE
is.memoised <- is.memoized <- function(f) {
  is.function(f) && identical(attr(f, "memoised"), TRUE)
}
