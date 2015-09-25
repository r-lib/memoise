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

test_that("old-style interface", {
  expect_warning(fm <- memoise(f), "old-style")
  f <- function(a = 1) a

  expect_equal(formals(fm), formals(function(...) NULL))

  expect_equal(fm(), 1)
  expect_equal(fm(3), 3)
  expect_true(withVisible(fm())$visible)
})

test_that("old-style interface with invisible result", {
  expect_warning(fm <- memoise(f), "old-style")
  f <- function(a = 1) invisible(a)

  expect_false(withVisible(fm())$visible)
})
