
<!-- README.md is generated from README.Rmd. Please edit that file -->

# memoise

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/memoise)](https://CRAN.R-project.org/package=memoise)
[![R build
status](https://github.com/r-lib/memoise/workflows/R-CMD-check/badge.svg)](https://github.com/r-lib/memoise/actions)
[![Codecov test
coverage](https://codecov.io/gh/hadley/memoise/branch/master/graph/badge.svg)](https://codecov.io/gh/hadley/memoise?branch=master)
<!-- badges: end -->

The memoise package makes it easy to memoise R functions.
**Memoisation** (<https://en.wikipedia.org/wiki/Memoization>) caches
function calls so that if a previously seen set of inputs is seen, it
can return the previously computed output.

# Installation

Install from CRAN with

``` r
install.packages("memoise")
```

## Usage

To memoise a function, use `memoise()`:

``` r
library(memoise)
f <- function(x) {
  Sys.sleep(1)
  mean(x)
}
mf <- memoise(f)
```

``` r
system.time(mf(1:10))
#>    user  system elapsed
#>   0.002   0.000   1.003
system.time(mf(1:10))
#>    user  system elapsed
#>   0.000   0.000   0.001
```

You can clear `mf`’s cache with:

``` r
forget(mf)
```

And you can test whether a function is memoised with `is.memoised()`.

## Caches

By default, memoise uses an in-memory cache, using `cache_mem()` from
the [cachem](https://cachem.r-lib.org/) package. `cachem::cache_disk()`
allows caching using files on a local filesystem.

Both `cachem::cache_mem()` and `cachem::cache_disk()` support automatic
pruning by default; this means that they will not keep growing past a
certain size, and eventually older items will be removed from the cache.
The default size `cache_mem()` is 512 MB, and the default size for a
`cache_disk()` is 1 GB, but this can be customized by specifying
`max_size`:

``` r
# 100 MB limit
cm <- cachem::cache_mem(max_size = 100 * 1024^2)

mf <- memoise(f, cache = cm)
```

You can also change the maximum age of items in the cache with
`max_age`:

``` r
# Expire items in cache after 15 minutes
cm <- cachem::cache_mem(max_age = 15 * 60)

mf <- memoise(f, cache = cm)
```

By default, a `cache_disk()` uses a subdirectory the R process’s temp
directory, but it is possible to specify the directory. This is useful
for persisting a cache across R sessions, sharing a cache among
different processes, or even for synchronizing across the network.

``` r
# Store in "R-myapp" directory inside of user-level cache directory
cd <- cachem::cache_disk(rappdirs::user_cache_dir("R-myapp"))

# Store in Dropbox
cdb <- cachem::cache_disk("~/Dropbox/.rcache")
```

A single cache object can be shared among multiple memoised functions.
By default, the cache key includes not only the arguments to the
function, but also the body of the function. This essentially eliminates
the possibility of a cache collision, even if two memoised functions are
called with the same arguments.

``` r
m <- cachem::cache_mem()

times2 <- memoise(function(x) { x * 2 }, cache = m)
times4 <- memoise(function(x) { x * 4 }, cache = m)

times2(10)
#> [1] 20
times4(10)
#> [1] 40
```

### Cache API

It is possible to use other caching backends with memoise. These caching
objects must be key-value stores which use the same API as those from
the [cachem](https://cachem.r-lib.org/) package. The following methods
are required for full compatibiltiy with memoise:

-   `$set(key, value)`: Sets a `key` to `value` in the cache.
-   `$get(key)`: Gets the value associated with `key`. If the key is not
    in the cache, this returns an object with class `"key_missing"`.
-   `$exists(key)`: Checks for the existence of `key` in the cache.
-   `$remove(key)`: Removes the value for `key` from the cache.
-   `$reset()`: Resets the cache, clearing all key/value pairs.

Note that the sentinel value for missing keys can be created by calling
`cachem::key_missing()`, or `structure(list(), class = "key_missing")`.

### Old-style cache objects

Before version 2.0, memoise used different caching objects, which did
not have automatic pruning and had a slightly different API. These
caching objects can still be used, but we recommend using the caching
objects from cachem when possible. The following cache objects do not
currently have an equivalent in cachem.

-   `cache_s3()` allows caching on [Amazon
    S3](https://aws.amazon.com/s3/) Requires you to specify a bucket
    using `cache_name`. When creating buckets, they must be unique among
    all s3 users when created.

    ``` r
    Sys.setenv(
      "AWS_ACCESS_KEY_ID" = "<access key>",
      "AWS_SECRET_ACCESS_KEY" = "<access secret>"
    )
    cache <- cache_s3("<unique bucket name>")
    ```

-   `cache_gcs()` saves the cache to Google Cloud Storage. It requires
    you to authenticate by downloading a JSON authentication file, and
    specifying a pre-made bucket:

    ``` r
    Sys.setenv(
      "GCS_AUTH_FILE" = "<google-service-json>",
      "GCS_DEFAULT_BUCKET" = "unique-bucket-name"
    )
    gcs <- cache_gcs()
    ```
