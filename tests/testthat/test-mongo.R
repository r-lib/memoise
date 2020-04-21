test_that("using a mongodb cache works", {
  skip_on_cran()
  skip_on_travis_pr()
  skip_without_mongodb()

  # Setting a gridFS connection
  mongo_grid <- mongolite::gridfs(
    db = "memoize",
    prefix = "memoize"
  )

  # Creating a cache object and function
  mong <- cache_mongo(mongo_grid)
  mem_runif <- memoise(runif, cache = mong)
  expect_is(mem_runif, "memoised")
  # Try
  res1 <- mem_runif(200)
  expect_equal(
    res1,
    mem_runif(200)
  )

  forget(mem_runif)

  expect_false(all(res1 == mem_runif(200)))

  # Remove the cache
  mong$reset()
  expect_false(all(res1 == mem_runif(200)))

  # Adding some keys
  mem_runif(3)
  mem_runif(4)
  mem_runif(5)

  # List the keys
  expect_length(mong$keys(),4)

  # Drop one
  one <- mong$keys()[1]
  two <- mong$keys()[2]
  mong$drop_key(one)
  expect_length(mong$keys(),3)

  # Test if has key
  expect_false( mong$has_key(one) )
  expect_true( mong$has_key(two) )

})
