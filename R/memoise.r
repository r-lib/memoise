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
#' @param ... optional variables specified as formulas with no RHS to use as
#' additional restrictions on caching. See Examples for usage.
#' @param envir Environment of the returned function.
#' @seealso \code{\link{forget}}, \code{\link{is.memoised}},
#'   \code{\link{timeout}}, \url{http://en.wikipedia.org/wiki/Memoization}
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
#' # Making a memoized automatically time out after 10 seconds.
#' memA3 <- memoise(a, ~{current <- as.numeric(Sys.time()); (current - current %% 10) %/% 10 })
#' memA3(2)
#'
#' # The timeout function is any easy way to do the above.
#' memA4 <- memoise(a, ~timeout(10))
#' memA4(2)
#' @importFrom stats setNames
memoise <- memoize <- function(f, ..., envir = environment(f)) {
  f_formals <- formals(args(f))
  if(is.memoised(f)) {
    stop("`f` must not be memoised.", call. = FALSE)
  }

  f_formal_names <- names(f_formals)
  f_formal_name_list <- lapply(f_formal_names, as.name)

  # list(...)
  list_call <- make_call(quote(list), f_formal_name_list)

  # memoised_function(...)
  init_call_args <- setNames(f_formal_name_list, f_formal_names)
  init_call <- make_call(quote(`_f`), init_call_args)

  cache <- new_cache()

  validate_formulas(...)
  additional <- list(...)

  memo_f <- eval(
    bquote(function(...) {
      hash <- `_digest`(c(.(list_call),
          lapply(`_additional`, function(x) eval(x[[2L]], environment(x)))),
        algo = "sha512")

      if (`_cache`$has_key(hash)) {
        res <- `_cache`$get(hash)
      } else {
        res <- withVisible(.(init_call))
        `_cache`$set(hash, res)
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

  # This should only happen for primitive functions
  if (is.null(envir)) {
     envir <- baseenv()
  }

  memo_f_env <- new.env(parent = envir)
  memo_f_env$`_cache` <- cache
  memo_f_env$`_f` <- f
  memo_f_env$`_digest` <- digest
  memo_f_env$`_additional` <- additional
  environment(memo_f) <- memo_f_env

  class(memo_f) <- c("memoised", "function")

  memo_f
}

make_call <- function(name, args) {
  stopifnot(is.name(name), is.list(args))
  as.call(c(list(name), args))
}

#' Return a new number after a given number of seconds
#'
#' This function will return a number corresponding to the system time and
#' remain stable until a given number of seconds have elapsed, after which it
#' will update to the current time. This makes it useful as a way to timeout
#' and invalidate a memoised cache after a certain period of time.
#' @param seconds Number of seconds after which to timeout.
#' @param current The current time as a numeric.
#' @return A numeric that will remain constant until the seconds have elapsed.
#' @seealso \code{\link{memoise}}
#' @export
#' @examples
#' a <- function(n) { runif(n) }
#' memA <- memoise(a, ~timeout(10))
#' memA(2)
timeout <- function(seconds, current = as.numeric(Sys.time())) {
  (current - current %% seconds) %/% seconds
}

validate_formulas <- function(...) {
  format.name <- function(x, ...) format(as.character(x), ...)
  is_formula <- function(x) {
    if (is.call(x) && identical(x[[1]], as.name("~"))) {
      if (length(x) > 2L) {
        stop("`x` must be a one sided formula [not ", format(x), "].", call. = FALSE)
      }
    } else {
      stop("`", format(x), "` must be a formula.", call. = FALSE)
    }
  }

  dots <- eval(substitute(alist(...)))
  lapply(dots, is_formula)
}

#' @export
print.memoised <- function(x, ...) {
  cat("Memoised Function:\n")
  tryCatch(print(environment(x)$`_f`), error = function(e) stop("No function defined!", call. = FALSE))
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
  if (!exists("_cache", env, inherits = FALSE)) return(FALSE)

  cache <- get("_cache", env)
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
  is.function(f) && inherits(f, "memoised")
}

#' Test whether a memoised function has been cached for particular arguments.
#' @param f Function to test.
#' @param ... arguments to function.
#' @seealso \code{\link{is.memoised}}, \code{\link{memoise}}
#' @export
#' @examples
#' mem_sum <- memoise(sum)
#' has_cache(mem_sum)(1, 2, 3) # FALSE
#' mem_sum(1, 2, 3)
#' has_cache(mem_sum)(1, 2, 3) # TRUE
has_cache <- function(f, ...) {
  if(!is.memoised(f)) stop("`f` is not a memoised function!", call. = FALSE)

  # Modify the function body of the function to simply return TRUE and FALSE
  # rather than get or set the results of the cache
  body <- body(f)
  body[[3]] <- quote(if (`_cache`$has_key(hash)) return(TRUE) else return(FALSE))
  body(f) <- body

  f
}
