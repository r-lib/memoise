# memoise
[![Travis-CI Build Status](https://travis-ci.org/r-lib/memoise.svg?branch=master)](https://travis-ci.org/r-lib/memoise)
[![Coverage Status](https://img.shields.io/codecov/c/github/r-lib/memoise/master.svg)](https://codecov.io/github/r-lib/memoise?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/memoise)](https://cran.r-project.org/package=memoise)

# Memoization

If a function is called multiple times with the same input, you can
often speed things up by keeping a cache of known answers that it can
retrieve. This is called memoisation <http://en.wikipedia.org/wiki/Memoization>.
The `memoise` package provides a simple syntax

```r
mf <- memoise(f)
```

to create `mf()`, a memoised wrapper around `f()`. You can clear `mf`'s
cache with

```r
forget(mf)
```

and you can test whether a function is memoised with

```r
is.memoised(mf) # TRUE
is.memoised(f)  # FALSE
```

# Installation

```
devtools::install_github("r-lib/memoise")
```

# External Caches

`memoise` also supports external caching in addition to the default in-memory caches.

* `cache_filesystem()` allows caching using files on a local filesystem. You
  can point this to a shared file such as dropbox or google drive to share
  caches between systems.
* `cache_s3()` allows caching on [Amazon S3](https://aws.amazon.com/s3/)


## AWS S3

Use `cache_s3()` to cache objects using s3 storage. Requires you to specify
a bucket using `cache_name`. When creating buckets, they must be unique among
all s3 users when created.

```r
Sys.setenv("AWS_ACCESS_KEY_ID" = "<access key>",
           "AWS_SECRET_ACCESS_KEY" = "<access secret>")

mrunif <- memoise(runif, cache = cache_s3("<unique bucket name>"))

mrunif(10) # First run, saves cache
mrunif(10) # Loads cache, results should be identical

```

## Filesystem

`cache_filesystem` can be used for a file system cache. This is useful for
preserving the cache between R sessions as well as sharing between systems
when using a shared or synced files system such as Dropbox or Google Drive.

```r
fc <- cache_filesystem("~/.cache")
mrunif <- memoise(runif, cache = fc)
mrunif(20) # Results stored in local file

dbc <- cache_filesystem("~/Dropbox/.rcache")
mrunif <- memoise(runif, cache = dbc)
mrunif(20) # Results stored in Dropbox .rcache folder which will be synced between computers.

gdc <- cache_filesystem("~/Google Drive/.rcache")
mrunif <- memoise(runif, cache = gdc)
mrunif(20) # Results stored in Google Drive .rcache folder which will be synced between computers.
```

## Google Cloud Storage

`cache_gcs` saves the cache to Google Cloud Storage.  It requires you to authenticate by downloading a JSON authentication file, and specifying a pre-made bucket:

```r
library(googleCloudStorageR)
# Set GCS credentials.
Sys.setenv("GCS_AUTH_FILE"="<google-service-json>",
           "GCS_DEFAULT_BUCKET"="unique-bucket-name")

gcs <- cache_gcs()
mrunif <- memoise(runif, cache = gcs)
mrunif(10) # First run, saves cache
mrunif(10) # Loads cache, results should be identical
```
