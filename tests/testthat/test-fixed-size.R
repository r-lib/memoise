context("fixed_size")

test_that("using a fixed size cache works (FIFO)", {

  i <- 0
  fn <- function(j) { i <<- i + 1; i + j }

  fnm <- memoise(fn, cache = cache_fixed_size(2))

  expect_equal(fnm(0), 1)
  expect_equal(fnm(0), 1)
  expect_equal(fnm(1), 3)
  expect_equal(fnm(1), 3)
  expect_equal(fnm(0), 1)
  expect_equal(fnm(2), 5)  # Evicts 0
  expect_equal(fnm(0), 4)

  forget(fnm)
  expect_equal(fnm(0), 5)

  expect_true(drop_cache(fnm)(0))
  expect_equal(fnm(0), 6)
})

test_that("using a fixed size cache works (LRU)", {

  i <- 0
  fn <- function(j) { i <<- i + 1; i + j }

  fnm <- memoise(fn, cache = cache_fixed_size(2, eviction = evict_lru()))

  expect_equal(fnm(0), 1)
  expect_equal(fnm(0), 1)
  expect_equal(fnm(1), 3)
  expect_equal(fnm(1), 3)
  expect_equal(fnm(0), 1)
  expect_equal(fnm(2), 5)  # Evicts 1
  expect_equal(fnm(0), 1)
  expect_equal(fnm(1), 5)

  forget(fnm)
  expect_equal(fnm(0), 5)

  expect_true(drop_cache(fnm)(0))
  expect_equal(fnm(0), 6)
})
