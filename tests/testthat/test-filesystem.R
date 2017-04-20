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

test_that("two functions with the same arguments produce different caches (#38)", {

  temp <- tempfile()
  fs <- cache_filesystem(temp)

  f1 <- memoise(function() 1, cache = fs)
  f2 <- memoise(function() 2, cache = fs)

  expect_equal(f1(), 1)
  expect_equal(f2(), 2)

  expect_equal(length(list.files(temp)), 2)
})
