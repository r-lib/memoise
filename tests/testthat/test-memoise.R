context("memoise")

test_that("memoisation works", {
  fn <- function() { i <<- i + 1; i }
  i <- 0

  expect_warning(fnm <- memoise(fn), NA)
  expect_equal(fn(), 1)
  expect_equal(fn(), 2)
  expect_equal(fnm(), 3)
  expect_equal(fnm(), 3)
  expect_equal(fn(), 4)
  expect_equal(fnm(), 3)

  expect_false(forget(fn))
  expect_true(forget(fnm))
  expect_true(forget(fnm))
  expect_equal(fnm(), 5)

  expect_true(is.memoised(fnm))
  expect_false(is.memoised(fn))
})

test_that("memoisation depends on argument", {
  fn <- function(j) { i <<- i + 1; i }
  i <- 0

  expect_warning(fnm <- memoise(fn), NA)
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

  expect_warning(fnm <- memoise(fn), NA)
  expect_equal(fn(1), 1)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(1, 2), 3)
  expect_equal(fnm(1), 2)
  expect_equal(fnm(1, 2), 3)
  expect_equal(fnm(), 4)

  expect_true(forget(fnm))

  expect_equal(fnm(1), 5)
  expect_equal(fnm(1, 2), 6)
  expect_equal(fnm(), 7)
})

test_that("default arguments are used for hash", {
  fn <- function(j = 1) { i <<- i + 1; i }
  i <- 0

  expect_warning(fnm <- memoise(fn), NA)
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

  expect_warning(fnm <- memoise(fn), NA)
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

test_that("different body avoids collisions", {
  # Same args, different body
  m <- cachem::cache_mem()
  times2 <- memoise(function(x) { x * 2 }, cache = m)
  times4 <- memoise(function(x) { x * 4 }, cache = m)

  expect_identical(times2(10), 20)
  expect_equal(m$size(), 1)
  expect_identical(times4(10), 40)
  expect_equal(m$size(), 2)
})

test_that("different formals avoids collisions", {
  # Different formals (even if not used) avoid collisions, because formals
  # are used in key.
  m <- cachem::cache_mem()
  f <- function(x, y) { x * 2 }
  times2  <- memoise(function(x, y) { x * 2 }, cache = m)
  times2a <- memoise(function(x, y = 1) { x * 2 }, cache = m)

  expect_identical(times2(10),  20)
  expect_equal(m$size(), 1)
  expect_identical(times2a(10), 20)
  expect_equal(m$size(), 2)
})

test_that("same body results in collisions", {
  # Two identical memoised functions should result in cache hits so that cache
  # can be shared more easily.
  # https://github.com/r-lib/memoise/issues/58
  m <- cachem::cache_mem()
  times2  <- memoise(function(x, y) { x * 2 }, cache = m)
  times2a <- memoise(function(x, y) { x * 2 }, cache = m)

  expect_identical(times2(10),  20)
  expect_identical(times2a(10), 20)
  expect_equal(m$size(), 1)
})

test_that("same body results in collisions", {
  # Even though t2 and t4 produce different results, the memoised versions,
  # times2 and times4, have cache collisions because the functions have the same
  # body and formals. It would be nice if we could somehow avoid this.
  m <- cachem::cache_mem()

  t2 <- local({
    n <- 2
    function(x) x * n
  })
  t4 <- local({
    n <- 4
    function(x) x * n
  })

  times2 <- memoise(t2, cache = m)
  times4 <- memoise(t4, cache = m)

  expect_identical(times2(10),  20)
  expect_identical(times4(10), 20)  # Bad (but expected) cache collision!
  expect_equal(m$size(), 1)
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
  expect_warning(fm <- memoise(function(a = 1) a), NA)
  expect_equal(names(formals(fm))[[1]], "a")
  expect_equal(fm(1), 1)
  expect_equal(fm(2), 2)
  expect_equal(fm(1), 1)
})

test_that("can memoise primitive", {
  expect_warning(fm <- memoise(`+`), NA)
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

test_that("arguments are evaluated before hashing", {
  i <- 1

  f <- memoise(function(x, y, z = 3) { x + y + z})
  f2 <- function(x, y) f(x, y)

  expect_equal(f2(1, 1), 5)

  expect_equal(f2(1, 1), 5)

  expect_equal(f2(2, 2), 7)
})

test_that("argument names don't clash with names in memoised function body", {
  f <- function(
    # Names in enclosing environment of memoising function
    `_f`, `_cache`, `_additional`,
    # Names in body of memoising function
    mc, encl, called_args, default_args, args, hash, res
  ) list(`_f`, `_cache`, `_additional`, mc, encl, called_args, default_args, args, hash, res)
  f_mem <- memoise(f)

  expect_error(f_mem(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), NA)
  expect_identical(f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), f_mem(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
})

test_that("omit_args respected", {
  # If no arguments ignored, these 2 rnorm() calls should have different results
  mem_rnorm <- memoise(rnorm, omit_args = c())

  res1 <- mem_rnorm(10, mean = -100)
  res2 <- mem_rnorm(10, mean = +100)

  expect_false(identical(res1, res2))


  # If 'mean' ignored when hashing, these 2 rnorm() calls will have identical results
  mem_rnorm <- memoise(rnorm, omit_args = c('mean'))

  res1 <- mem_rnorm(10, mean = -100)
  res2 <- mem_rnorm(10, mean = +100)

  expect_true(identical(res1, res2))

  # Also works for default arguments
  a <- 0
  f <- function(x = a) {
    a <<- a + 1
    a
  }

  # everytime `f()` is called its value increases by 1
  expect_equal(f(), 1)
  expect_equal(f(), 2)

  # it still increases by one when memoised as the argument `x` changes
  a <- 0
  mem_f <- memoise::memoise(f)
  expect_equal(mem_f(), 1)
  expect_equal(mem_f(), 2)

  # but `x` can be ignored via `omit_args`
  a <- 0
  mem_f2 <- memoise(f, omit_args = "x")
  expect_equal(mem_f2(), 1)
  expect_equal(mem_f2(), 1)
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

context("drop_cache")
test_that("it works as expected with memoised functions", {
  mem_sum <- memoise(sum)
  expect_false(drop_cache(mem_sum)(1, 2, 3))

  mem_sum(1, 2, 3)
  mem_sum(2, 3, 4)

  expect_true(has_cache(mem_sum)(1, 2, 3))
  expect_true(has_cache(mem_sum)(2, 3, 4))

  expect_true(drop_cache(mem_sum)(1, 2, 3))

  expect_false(has_cache(mem_sum)(1, 2, 3))
  expect_true(has_cache(mem_sum)(2, 3, 4))

  mem_sum <- memoise(sum)
  expect_false(drop_cache(mem_sum)(1, 2, 3))
})

test_that("it errors with an un-memoised function", {
  expect_error(drop_cache(sum)(1, 2, 3), "`f` is not a memoised function.")
})

context("timeout")
test_that("it stays the same if not enough time has passed", {
  duration <- 10
  first <- timeout(duration, 0)

  expect_equal(first, timeout(duration, 1))
  expect_equal(first, timeout(duration, 5))
  expect_equal(first, timeout(duration, 7))
  expect_equal(first, timeout(duration, 9))

  expect_true(first != timeout(duration, 10))


  duration <- 100
  first <- timeout(duration, 0)

  expect_equal(first, timeout(duration, 10))
  expect_equal(first, timeout(duration, 50))
  expect_equal(first, timeout(duration, 70))
  expect_equal(first, timeout(duration, 99))

  expect_true(first != timeout(duration, 100))
})

context("missing")
test_that("it works with missing arguments", {
  fn <- function(x, y) {
    i <<- i + 1
    if (missing(y)) {
      y <- 1
    }
    x + y
  }
  fnm <- memoise(fn)
  i <- 0

  expect_equal(fn(1), fnm(1))
  expect_equal(fn(1, 2), fnm(1, 2))
  expect_equal(i, 4)
  fnm(1)
  expect_equal(i, 4)
  fnm(1, 2)
  expect_equal(i, 4)
})
