
<!-- README.md is generated from README.Rmd. Please edit that file -->

# memoise

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/memoise)](https://CRAN.R-project.org/package=memoise)
[![R build
status](https://github.com/r-lib/memoise/workflows/R-CMD-check/badge.svg)](https://github.com/r-lib/memoise/actions)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/memoise/branch/master/graph/badge.svg)](https://codecov.io/gh/r-lib/memoise?branch=master)
<!-- badges: end -->

The memoise package makes it easy to memoise R functions.
**Memoisation** (<http://en.wikipedia.org/wiki/Memoization>) caches
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

system.time(mf(1:10))
#>    user  system elapsed 
#>   0.000   0.000   1.003
system.time(mf(1:10))
#>    user  system elapsed 
#>   0.031   0.001   0.032
```

You can clear `mf`’s cache with:

``` r
forget(mf)
#> [1] TRUE
```

And you can test whether a function is memoised with `is.memoised()`.

## Caches

By default, memoise uses an in-memory cache. But you can customise this
with the `cache` arugment and another built-in cache:

  - `cache_filesystem()` allows caching using files on a local
    filesystem. This is useful for preserving the cache between R
    sessions as well as sharing between systems when using a shared or
    synced files system such as Dropbox or Google Drive.
    
    ``` r
    fc <- cache_filesystem("~/.cache")
    
    # Store in Dropbox
    dbc <- cache_filesystem("~/Dropbox/.rcache")
    ```

  - `cache_s3()` allows caching on [Amazon
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

  - `cache_gcs()` saves the cache to Google Cloud Storage. It requires
    you to authenticate by downloading a JSON authentication file, and
    specifying a pre-made bucket:
    
    ``` r
    Sys.setenv(
      "GCS_AUTH_FILE" = "<google-service-json>",
      "GCS_DEFAULT_BUCKET" = "unique-bucket-name"
    )
    gcs <- cache_gcs()
    ```
