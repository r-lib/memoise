context("memoise")

test_that("memoisation works", {
  fn <- function() { i <<- i + 1; i }
  i <- 0
  fnm <- memoise(fn)
  expect_equal(fn(), 1)
  expect_equal(fn(), 2)
  expect_equal(fnm(), 3)
  expect_equal(fnm(), 3)
  expect_equal(fn(), 4)
  expect_equal(fnm(), 3)

  forget(fnm)
  expect_equal(fnm(), 5)

  expect_true(is.memoised(fnm))
  expect_false(is.memoised(fn))
})

test_that("memoisation depends on argument", {
  fn <- function(j) { i <<- i + 1; i }
  i <- 0
  fnm <- memoise(fn)
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
