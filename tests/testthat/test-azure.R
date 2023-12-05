context("azure storage")

skip_on_cran()
skip_on_travis_pr()
skip_without_azure_credentials()

storage_url <- Sys.getenv("AZ_TEST_STORAGE_MEMOISE_URL")
storage_key <- Sys.getenv("AZ_TEST_STORAGE_MEMOISE_KEY")

bl_endp <- AzureStor::storage_endpoint(storage_url, key=storage_key)
cache_name <- paste0(sample(letters, 20, TRUE), collapse = "")

test_that("using an Azure storage cache works", {

  azcache <- cache_azure(cache_name, bl_endp)
  i <- 0
  fn <- function() { i <<- i + 1; i }
  fnm <- memoise(fn, cache = azcache)
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
})

teardown({
    AzureStor::delete_blob_container(bl_endp, cache_name, confirm = FALSE)
})
