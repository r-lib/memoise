context("memoise")

test_that("memoisation works", {
  fn <- function() { i <<- i + 1; i }
  i <- 0

  expect_that(fnm <- memoise(fn), not(gives_warning()))
  expect_equal(fn(), 1)
  expect_equal(fn(), 2)
  expect_equal(fnm(), 3)
  expect_equal(fnm(), 3)
  expect_equal(fn(), 4)
  expect_equal(fnm(), 3)

  expect_false(forget(fn))
  expect_true(forget(fnm))
  expect_equal(fnm(), 5)

  expect_true(is.memoised(fnm))
  expect_false(is.memoised(fn))
})

test_that("memoisation depends on argument", {
  fn <- function(j) { i <<- i + 1; i }
  i <- 0

  expect_that(fnm <- memoise(fn), not(gives_warning()))
  expect_equal(fn(1), 1)
  expect_equal(fn(1), 2)
  expect_equal(fnm(1), 3)
  expect_equal(fnm(1), 3)
  expect_equal(fn(1), 4)
  expect_equal(fnm(1), 3)
  expect_equal(fnm(2), 5)
  expect_equal(fnm(2), 5)
  expect_equal(fnm(1), 3)
  expect_equal(fn(2), 6)
})

test_that("interface of wrapper matches interface of memoised function", {
  fn <- function(j) { i <<- i + 1; i }
  i <- 0

  expect_equal(formals(fn), formals(memoise(fn)))
  expect_equal(formals(runif), formals(memoise(runif)))
  expect_equal(formals(paste), formals(memoise(paste)))
})

test_that("dot arguments are used for hash", {
  fn <- function(...) { i <<- i + 1; i }
  i <- 0

  expect_that(fnm <- memoise(fn), not(gives_warning()))
  expect_equal(fn(1), 1)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(1, 2), 3)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(), 4)

  expect_true(forget(fnm))

  expect_equal(fnm(1), 5)
  expect_equal(fnm(1, 2), 6)
  expect_equal(fnm(), 7)
})

test_that("default arguments are used for hash", {
  fn <- function(j = 1) { i <<- i + 1; i }
  i <- 0

  expect_that(fnm <- memoise(fn), not(gives_warning()))
  expect_equal(fn(1), 1)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(), 2)
  expect_equal(fnm(2), 3)
  expect_equal(fnm(), 2)
})

test_that("default arguments are evaluated correctly", {
  expect_false(exists("g"))
  g <- function() 1
  fn <- function(j = g()) { i <<- i + 1; i }
  i <- 0

  expect_that(fnm <- memoise(fn), not(gives_warning()))
  expect_equal(fn(1), 1)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(), 2)
  expect_equal(fnm(2), 3)
  expect_equal(fnm(), 2)
})

test_that("symbol collision", {
  cache <- function(j = 1) { i <<- i + 1; i }
  i <- 0
  cachem <- memoise(cache)

  expect_equal(cache(), 1)
  expect_equal(cache(), 2)
  expect_equal(cachem(), 3)
  expect_equal(cachem(), 3)
  expect_equal(cache(), 4)
  expect_equal(cachem(), 3)

  expect_true(forget(cachem))
  expect_equal(cachem(), 5)
})

test_that("visibility", {
  vis <- function() NULL
  invis <- function() invisible()

  expect_true(withVisible(memoise(vis)())$visible)
  expect_false(withVisible(memoise(invis)())$visible)
})

test_that("is.memoised", {
  i <- 0
  expect_false(is.memoised(i))
  expect_false(is.memoised(is.memoised))
  expect_true(is.memoised(memoise(identical)))
})

test_that("visibility", {
  vis <- function() NULL
  invis <- function() invisible()

  expect_true(withVisible(memoise(vis)())$visible)
  expect_false(withVisible(memoise(invis)())$visible)
})

test_that("can memoise anonymous function", {
  expect_that(fm <- memoise(function(a = 1) a), not(gives_warning()))
  expect_equal(names(formals(fm))[[1]], "a")
  expect_equal(fm(1), 1)
  expect_equal(fm(2), 2)
  expect_equal(fm(1), 1)
})

test_that("can memoise primitive", {
  expect_that(fm <- memoise(`+`), not(gives_warning()))
  expect_equal(names(formals(fm)), names(formals(args(`+`))))
  expect_equal(fm(1, 2), 1 + 2)
  expect_equal(fm(2, 3), 2 + 3)
  expect_equal(fm(1, 2), 1 + 2)
})

test_that("printing a memoised function prints the original definition", {

  fn <- function(j) { i <<- i + 1; i }

  fnm <- memoise(fn)

  fn_output <- capture.output(fn)
  fnm_output <- capture.output(fnm)

  expect_equal(fnm_output[1], "Memoised Function:")

  expect_equal(fnm_output[-1], fn_output)
})

test_that("memoisation can depend on non-arguments", {
  fn <- function(x) { i <<- i + 1; i }
  i <- 0
  j <- 2

  fn2 <- function(y, ...) {
    fnm <- memoise(fn, ~y)
    fnm(...)
  }
  expect_error(memoise(fn, j), "`j` must be a formula\\.")

  expect_error(memoise(fn, ~j, k), "`k` must be a formula\\.")

  expect_error(memoise(fn, j ~ 1), "`x` must be a one sided formula \\[not j ~ 1\\]\\.")

  fnm <- memoise(fn, ~j)
  expect_equal(fn(1), 1)
  expect_equal(fn(1), 2)
  expect_equal(fnm(1), 3)
  expect_equal(fnm(1), 3)
  j <- 1
  expect_equal(fnm(1), 4)
  expect_equal(fnm(1), 4)
  j <- 2
  expect_equal(fnm(1), 3)
  expect_equal(fnm(1), 3)
  j <- 3
  expect_equal(fnm(1), 5)
  expect_equal(fnm(1), 5)
})

test_that("it fails if already memoised", {
  mem_sum <- memoise(sum)
  expect_error(memoise(mem_sum), "`f` must not be memoised.")
})

test_that("it evaluates arguments in proper environment", {
  e <- new.env(parent = baseenv())
  e$a <- 5
  fun <- function(x, y = a) { x + y }
  environment(fun) <- e
  fun_mem <- memoise(fun)
  expect_equal(fun(1), fun_mem(1))
  expect_equal(fun(10), fun_mem(10))
})

test_that("it does have namespace clashes with internal memoise symbols", {
  e <- new.env(parent = baseenv())
  e$f <- 5
  fun <- function(x, y = f) { x + y }
  environment(fun) <- e
  fun_mem <- memoise(fun)
  expect_equal(fun(1), fun_mem(1))
  expect_equal(fun(10), fun_mem(10))
})

context("has_cache")
test_that("it works as expected with memoised functions", {
  mem_sum <- memoise(sum)
  expect_false(has_cache(mem_sum)(1, 2, 3))

  mem_sum(1, 2, 3)

  expect_true(has_cache(mem_sum)(1, 2, 3))

  mem_sum <- memoise(sum)
  expect_false(has_cache(mem_sum)(1, 2, 3))
})

test_that("it errors with an un-memoised function", {
  expect_error(has_cache(sum)(1, 2, 3), "`f` is not a memoised function.")
})

context("timeout")
test_that("it stays the same if not enough time has passed", {
  duration <- 10
  first <- timeout(duration, 0)

  expect_equal(first, timeout(duration, 1))
  expect_equal(first, timeout(duration, 5))
  expect_equal(first, timeout(duration, 7))
  expect_equal(first, timeout(duration, 9))

  expect_that(first, not(equals(timeout(duration, 10))))


  duration <- 100
  first <- timeout(duration, 0)

  expect_equal(first, timeout(duration, 10))
  expect_equal(first, timeout(duration, 50))
  expect_equal(first, timeout(duration, 70))
  expect_equal(first, timeout(duration, 99))

  expect_that(first, not(equals(timeout(duration, 100))))
})
