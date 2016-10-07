context("filesystem")

test_that("using a filesystem cache works", {

  fs <- cache_filesystem(tempfile())
  i <- 0
  fn <- function() { i <<- i + 1; i }
  fnm <- memoise(fn, cache = fs)
  on.exit(forget(fnm))

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
