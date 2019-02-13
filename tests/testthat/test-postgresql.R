context("postgresql")

setup_cache <- function() {
  pg_con <- DBI::dbConnect(
    RPostgreSQL::PostgreSQL(),
    user = Sys.getenv("MEMOISE_PG_USER"),
    password = Sys.getenv("MEMOISE_PG_PASSWORD"),
    dbname = Sys.getenv("MEMOISE_PG_DBNAME"),
    host = Sys.getenv("MEMOISE_PG_HOST")
  )

  cache_postgresql(pg_con, Sys.getenv("MEMOISE_PG_TABLE"))
}

test_that("using a postgresql cache works", {
  skip_without_postgres_credentials()

  pg <- setup_cache()

  i <- 0
  fn <- function() { i <<- i + 1; i }
  fnm <- memoise(fn, cache = pg)
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

  expect_true(drop_cache(fnm)())
  expect_equal(fnm(), 6)

  expect_true(is.memoised(fnm))
  expect_false(is.memoised(fn))
  drop_cache(fnm)()
})

test_that("two functions with the same arguments produce different caches", {
  skip_without_postgres_credentials()

  pg <- setup_cache()

  f1 <- memoise(function() 1, cache = pg)
  f2 <- memoise(function() 2, cache = pg)

  expect_equal(f1(), 1)
  expect_equal(f2(), 2)
  drop_cache(f1)()
})
